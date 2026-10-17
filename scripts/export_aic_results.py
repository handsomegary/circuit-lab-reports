#!/usr/bin/env python3
"""Export the supplied AIC Lab 1 HSPICE runs to reproducible CSV/JSON.

Usage (Python 3.9+, standard library only):
    python scripts/export_aic_results.py STAGING_DIRECTORY OUTPUT_DIRECTORY

Inputs are the seven final Lab01 .lis files and their .msN/.maN files.
Both plain names (02_simple_mirror.lis) and batch staging names
(AIC_Lab01_02_simple_mirror.lis) are recognized. Output names are canonical,
without the staging prefix. Use --prefix to explicitly select a naming set
if both exist. No simulation is run and no model or deck is modified.

This exporter implements the definitions in the Lab01 report. In particular,
the 5% current/rail criterion is a declared comparison criterion, not a PDK
guarantee. Vmin does not certify saturation over the entire sweep; the MOS
VDS/VDSAT check is made only at the declared 0.8 V operating point.
"""

import argparse
import csv
import hashlib
import json
import re
import shutil
from pathlib import Path


DECKS = (
    '01_device_iv',
    '02_simple_mirror',
    '03_cascode_mirror',
    '04_high_swing_cascode',
    '05_wilson_comparison',
    '06_regulated_comparison',
    '07_feedback_boost_experiment',
)
EXPECTED_CASES = (4, 4, 4, 6, 4, 5, 3)
NUMBER = re.compile(r'^[+-]?(?:\d+\.?\d*|\.\d+)(?:[eE][+-]?\d+)?$')

# name, canonical deck, sensed current, DC measurement, AC measurement,
# checked bias nodes, checked MOS devices, number of ideal reference branches.
TOPOLOGIES = (
    ('Simple', '02_simple_mirror', 'vs', 'iout', 'rout',
     ['ref'], ['m0', 'ms'], 1),
    ('Cascode', '03_cascode_mirror', 'vs', 'iout', 'rout',
     ['ref', 'bias', 'mid'], ['m0', 'm1', 'm2', 'm3'], 1),
    ('High-swing', '04_high_swing_cascode', 'vs', 'iout', 'rout',
     ['ref', 'bias', 'mid', 'rtop'], ['m0', 'm1', 'm2', 'm3', 'm4'], 2),
    ('Wilson', '05_wilson_comparison', 'vsw', 'iwout', 'rwout',
     ['rw', 'mw'], ['mw0', 'mw1', 'mw2'], 1),
    ('Modified Wilson', '05_wilson_comparison', 'vsm', 'imout', 'rmout',
     ['rm', 'mm', 'lm'], ['mm0', 'mm1', 'mm2', 'mm3'], 1),
    ('Swapped diodes', '05_wilson_comparison', 'vsq', 'iqout', 'rqout',
     ['rq', 'mq', 'lq'], ['mq0', 'mq1', 'mq2', 'mq3'], 1),
    ('Regulated', '06_regulated_comparison', 'vsr', 'irout', 'rrout',
     ['rr', 'br', 'mr'], ['mr0', 'mr1', 'mr2', 'mr3'], 2),
    ('Complete regulated', '06_regulated_comparison', 'vsc', 'icout', 'rcout',
     ['rc', 'pc', 'bc', 'mc'],
     ['mc0', 'mc1', 'mc2', 'mc3', 'mc4', 'mc5', 'mc6'], None),
)


def select_input(staging, stem, prefix):
    """Resolve a complete naming set; never silently pick an ambiguous log."""
    prefixes = ('', 'AIC_Lab01_') if prefix == 'auto' else (prefix,)
    matches = [staging / (p + stem + '.lis') for p in prefixes
               if (staging / (p + stem + '.lis')).is_file()]
    if len(matches) != 1:
        candidates = ', '.join(p + stem + '.lis' for p in prefixes)
        raise ValueError(
            f'{stem}: expected exactly one input ({candidates}); found '
            f'{len(matches)}. Check the staging directory or select --prefix.')
    return matches[0]


def read_measurement(path):
    """Read the default wrapped HSPICE .msN/.maN header and single data row."""
    if not path.is_file():
        raise ValueError(f'Missing measurement file: {path}')
    tokens = ' '.join(
        line for line in path.read_text(errors='replace').splitlines()
        if line.strip() and not line.lstrip().startswith(('$', '.'))
    ).split()
    if any(token.lower() == 'failed' for token in tokens):
        raise ValueError(f'Failed HSPICE measurement in {path}')
    first = next((i for i, value in enumerate(tokens)
                  if NUMBER.fullmatch(value)), None)
    if first is None or len(tokens) != first * 2:
        raise ValueError(f'Unexpected measurement header/data layout: {path}')
    keys, values = tokens[:first], tokens[first:]
    if not all(NUMBER.fullmatch(value) for value in values):
        raise ValueError(f'Non-numeric measurement value in {path}')
    return {key: float(value) for key, value in zip(keys, values)}


def parse_dc_tables(text, stem, index):
    """Merge HSPICE's four-column print-table blocks by sweep coordinate."""
    rows = {}
    dc = text.split('****** operating point information')[0]
    for match in re.finditer(r'\nx\s*\n(.*?)\ny(?=\s*\n|$)', dc, re.S):
        lines = [line.strip() for line in match.group(1).splitlines()
                 if line.strip()]
        first = next((j for j, line in enumerate(lines)
                      if all(NUMBER.fullmatch(v) for v in line.split())), None)
        if first is None:
            continue
        if first == 0:
            raise ValueError(f'{stem} case {index}: print-table header absent')
        columns = lines[first - 1].split()
        count = len(lines[first].split()) - 1
        if len(columns) == count + 1 and columns[0] in ('volt', 'freq', 'time'):
            columns = columns[1:]
        if len(columns) != count:
            raise ValueError(
                f'{stem} case {index}: {columns} do not match {count} columns')
        parameters = re.findall(
            r'\*\*\* parameter\s+0:vg\s*=\s*(\S+)', dc[:match.start()])
        vg = float(parameters[-1]) if parameters else None
        for line in lines[first:]:
            tokens = line.split()
            if not all(NUMBER.fullmatch(v) for v in tokens):
                continue
            values = list(map(float, tokens))
            if len(values) != count + 1:
                raise ValueError(f'{stem} case {index}: incomplete data row')
            row = rows.setdefault((vg, values[0]), {'sweep_v': values[0]})
            if vg is not None:
                row['vg_v'] = vg
            row.update(dict(zip(columns, values[1:])))
    return list(rows.values())


def parse_operating_point(text):
    """Retain HSPICE region labels and numerical MOS operating-point fields."""
    # VTEST is explicitly 0.8 V in the nominal OP; this is not the DC sweep end.
    op = text.split('****** operating point information')[-1]
    op = op.split('****** ac analysis')[0]
    devices = {}
    pattern = (r'\n element\s+([^\n]+)\n model\s+([^\n]+)'
               r'\n region\s+([^\n]+)\n(.*?)(?=\n\s*\n|$)')
    for match in re.finditer(pattern, op, re.S):
        names = [name.split(':')[-1] for name in match.group(1).split()]
        for name, region in zip(names, match.group(3).split()):
            devices[name] = {'region': region}
        for line in match.group(4).splitlines():
            tokens = line.split()
            if (len(tokens) == len(names) + 1
                    and all(NUMBER.fullmatch(v) for v in tokens[1:])):
                for name, value in zip(names, tokens[1:]):
                    devices[name][tokens[0]] = float(value)
    return devices


def parse_deck(path, stem, expected_cases):
    text = path.read_text(errors='replace')
    if '**error**' in text.lower() or 'job concluded' not in text.lower():
        raise ValueError(f'HSPICE did not conclude successfully: {path}')
    starts = [match.start() for match in
              re.finditer(r' \*{6} dc transfer curves', text)]
    chunks = [text[a:b] for a, b in
              zip(starts, starts[1:] + [len(text)])]
    result = []
    for index, chunk in enumerate(chunks):
        result.append({'index': index,
                       'dc': parse_dc_tables(chunk, stem, index),
                       'op': parse_operating_point(chunk),
                       'dc_meas': {}, 'ac_meas': {}})
    if stem == '01_device_iv':
        # Nested VG sweeps repeat the heading eleven times per length case.
        if len(result) != 44:
            raise ValueError(f'{path}: expected 44 nested VG sections; '
                             f'found {len(result)}')
        result = [
            {'index': j,
             'dc': [row for case in result[j * 11:(j + 1) * 11]
                    for row in case['dc']],
             'op': result[j * 11 + 10]['op'], 'dc_meas': {}, 'ac_meas': {}}
            for j in range(4)
        ]
    else:
        for case in result:
            index = case['index']
            case['dc_meas'] = read_measurement(path.with_suffix(f'.ms{index}'))
            case['ac_meas'] = read_measurement(path.with_suffix(f'.ma{index}'))
    if len(result) != expected_cases:
        raise ValueError(f'{path}: expected {expected_cases} cases; '
                         f'found {len(result)}')
    expected_rows = 1111 if stem == '01_device_iv' else 1001
    for case in result:
        if len(case['dc']) != expected_rows:
            raise ValueError(f'{path} case {case["index"]}: expected '
                             f'{expected_rows} DC rows, got {len(case["dc"])}')
    return result


def build_comparison(all_data):
    comparison = []
    for name, stem, column, ikey, rkey, bias, devices, nref in TOPOLOGIES:
        for case in all_data[stem]:
            index = case['index']
            iref = [50e-6, 10e-6, 1e-6, 50e-6, 1e-6, 1e-6][index]
            width = [3, 3, 3, 30, 3, 3][index]
            if stem == '06_regulated_comparison' and index == 4:
                iref, width = 50e-6, 30
            op, rows = case['op'], case['dc']
            snap = min(rows, key=lambda row: abs(row['sweep_v'] - .8))
            current = case['dc_meas'][ikey]
            expected = 2 * iref
            error = 100 * (current / expected - 1)
            low = min(rows, key=lambda row: abs(row['sweep_v'] - .799))
            high = min(rows, key=lambda row: abs(row['sweep_v'] - .801))
            slope = ((high[column] - low[column])
                     / (high['sweep_v'] - low['sweep_v']))
            resistance_dc = 1 / slope if slope else None
            maximum = max(snap[node] for node in bias)
            minimum = min(snap[node] for node in bias)
            rails = minimum >= -1e-6 and maximum <= 1 + 1e-6
            regions = '; '.join(f'{device}:{op[device]["region"]}'
                                for device in devices)
            saturated = all(abs(op[device]['vds']) + 1e-6
                            >= abs(op[device]['vdsat']) for device in devices)
            valid = [abs(row[column] / expected - 1) <= .05
                     and all(-1e-6 <= row[node] <= 1 + 1e-6 for node in bias)
                     for row in rows]
            last_bad = max((i for i, ok in enumerate(valid) if not ok),
                           default=-1)
            vmin = (rows[last_bad + 1]['sweep_v']
                    if last_bad + 1 < len(rows) else None)
            # VDD=1 V. This is bias power only, not total circuit power.
            bias_power = (iref + abs(op['mc5']['id']) + abs(op['mc6']['id'])
                          if nref is None else nref * iref)
            comparison.append({
                'topology': name, 'case_index': index,
                'iref_uA': iref * 1e6, 'wunit_um': width, 'vout_V': .8,
                'iout_uA': current * 1e6, 'ratio_error_pct': error,
                'rout_ac_ohm': case['ac_meas'][rkey],
                'rout_dc_ohm': resistance_dc,
                'rout_current_phase_deg': case['ac_meas'].get('phase_' + column),
                'vmin_5pct_rail_V': vmin, 'max_bias_V': maximum,
                'bias_rail_ok': rails,
                'all_abs_vds_ge_abs_vdsat': saturated, 'regions': regions,
                'bias_power_uW': bias_power * 1e6,
                'output_port_power_uW': .8 * current * 1e6,
                'current_and_rail_at_08V': rails and abs(error) <= 5,
                'complete_operating_check_at_08V':
                    rails and abs(error) <= 5 and saturated,
            })
    return comparison


def write_csv(path, rows):
    if not rows:
        raise ValueError(f'Cannot export empty table: {path}')
    fields = list(dict.fromkeys(key for row in rows for key in row))
    with path.open('w', newline='', encoding='utf-8') as handle:
        writer = csv.DictWriter(handle, fieldnames=fields)
        writer.writeheader()
        writer.writerows(rows)


def export(staging, output, prefix):
    if not staging.is_dir():
        raise ValueError(f'Staging directory does not exist: {staging}')
    if staging.resolve() == output.resolve():
        raise ValueError('Choose an output directory different from staging.')
    inputs, all_data = {}, {}
    for stem, count in zip(DECKS, EXPECTED_CASES):
        path = select_input(staging, stem, prefix)
        inputs[stem] = path
        all_data[stem] = parse_deck(path, stem, count)
    comparison = build_comparison(all_data)
    # Parse and validate everything before writing any output.
    output.mkdir(parents=True, exist_ok=True)
    operating_points = []
    status = []
    for stem, cases in all_data.items():
        for case in cases:
            write_csv(output / f'{stem}_case{case["index"]}.csv', case['dc'])
            for device, values in case['op'].items():
                operating_points.append({'deck': stem, 'case': case['index'],
                                         'device': device, **values})
        source = inputs[stem]
        status.append({'deck': stem + '.sp', 'source_lis': source.name,
                       'sha256_lis': hashlib.sha256(source.read_bytes()).hexdigest(),
                       'case_count': len(cases), 'concluded': True,
                       'errors': []})
        # Copy only this deck's original numeric measurement files; normalize
        # the staging prefix. Never copy the model, deck or license metadata.
        pattern = re.compile(re.escape(source.stem) + r'(\.m[ast]\d+)$', re.I)
        for file in staging.iterdir():
            match = pattern.fullmatch(file.name)
            if file.is_file() and match:
                shutil.copy2(file, output / (stem + match.group(1).lower()))
    write_csv(output / 'comparison.csv', comparison)
    write_csv(output / 'operating_points.csv', operating_points)
    for name, value in (('simulation_data.json', all_data),
                        ('comparison.json', comparison),
                        ('run_status.json', status)):
        (output / name).write_text(json.dumps(value, indent=2), encoding='utf-8')
    return sum(len(cases) for cases in all_data.values()), len(comparison)


def main():
    parser = argparse.ArgumentParser(description=__doc__,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument('staging_directory', type=Path,
                        help='Directory containing the completed HSPICE/batch outputs')
    parser.add_argument('output_directory', type=Path,
                        help='Destination for canonical CSV/JSON and copied measurements')
    parser.add_argument('--prefix', default='auto',
                        help='Input filename prefix: auto (default), AIC_Lab01_, or an empty string')
    args = parser.parse_args()
    try:
        cases, rows = export(args.staging_directory, args.output_directory, args.prefix)
    except (ValueError, KeyError, OSError) as error:
        parser.exit(1, f'Export failed: {error}\n')
    print(f'Exported 7 decks / {cases} cases / {rows} comparison rows to '
          f'{args.output_directory.resolve()}')


if __name__ == '__main__':
    main()
