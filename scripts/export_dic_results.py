"""Export the DIC Lab 1/2 HSPICE pilot results to CSV and metrics.json.

Usage:
    python scripts/export_dic_results.py batch_STAGING_DIRECTORY OUTPUT_DIRECTORY

Requires NumPy. The input may contain the DIC_Lab01_/DIC_Lab02_ prefixes
created by stage_batch.py, or the original unprefixed result names. Only
the ten DIC pilot decks are read; AIC files in a shared staging directory
are ignored. Existing exports require --overwrite.

The exports reproduce the report's original calculations: printed DC data,
native .ms/.mt measurements, and a semilog least-squares fit over 0.15--0.25 V.
This script neither runs HSPICE nor modifies netlists or input results.
"""

from pathlib import Path
import argparse
import csv
import json
import re

import numpy as np


NUMBER = re.compile(r"^[+-]?(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][+-]?\d+)?[a-zA-Z]?$")
SCALES = dict(t=1e12, g=1e9, x=1e6, k=1e3, m=1e-3, u=1e-6,
              n=1e-9, p=1e-12, f=1e-15, a=1e-18)
DECKS = {
    1: ("01_diode_n", "01_diode_p", "02_output_n", "02_output_p",
        "03_length", "04_subthreshold", "05_equal_geometry"),
    2: ("01_chain", "02_fanout3", "03_size3"),
}


def numeric_value(token):
    """Read HSPICE scientific notation and engineering suffixes."""
    if token[-1].isalpha():
        suffix = token[-1].lower()
        if suffix not in SCALES:
            raise ValueError(f"Unknown HSPICE numeric suffix: {token!r}")
        return float(token[:-1]) * SCALES[suffix]
    return float(token)


def printed_tables(path, columns, expected_blocks):
    """Extract complete numeric DC print blocks, excluding log statistics."""
    blocks = []
    current = []
    for line in path.read_text(errors="replace").splitlines():
        tokens = line.split()
        if len(tokens) == columns and all(NUMBER.fullmatch(t) for t in tokens):
            current.append([numeric_value(t) for t in tokens])
        else:
            if len(current) > 100:
                blocks.append(np.array(current))
            current = []
    if len(current) > 100:
        blocks.append(np.array(current))
    if len(blocks) != expected_blocks:
        raise ValueError(
            f"{path}: expected {expected_blocks} DC blocks with {columns} columns, "
            f"found {len(blocks)}. Use the unchanged pilot decks and complete .lis files."
        )
    return blocks


def measurement_rows(path):
    """Read native HSPICE .ms/.mt tables, including wrapped rows."""
    fields = []
    data = []
    started = False
    for line in path.read_text().splitlines():
        if not line.strip() or line.lstrip().startswith(("$", ".")):
            continue
        tokens = line.split()
        if all(NUMBER.fullmatch(t) for t in tokens):
            started = True
        (data if started else fields).extend(tokens)
    if not fields or not data or len(data) % len(fields):
        raise ValueError(f"Incomplete or malformed measurement table: {path}")
    return [
        dict(zip(fields, map(numeric_value, data[i:i + len(fields)])))
        for i in range(0, len(data), len(fields))
    ]


def collect_results(input_directory):
    stems = {}
    for lab, names in DECKS.items():
        for name in names:
            candidates = [input_directory / f"DIC_Lab{lab:02d}_{name}",
                          input_directory / name]
            stems[name] = next((p for p in candidates if p.with_suffix(".lis").is_file()), None)
            if stems[name] is None:
                raise FileNotFoundError(
                    f"Missing result: DIC_Lab{lab:02d}_{name}.lis (or {name}.lis) "
                    f"in {input_directory}"
                )

    def source(name, extension):
        path = stems[name].with_suffix(extension)
        if not path.is_file():
            raise FileNotFoundError(f"Required HSPICE result is missing: {path}")
        return path

    metrics = {}
    exports = {}
    validation = {}
    for name in stems:
        text = source(name, ".lis").read_text(errors="replace").lower()
        validation[name] = dict(error_count=text.count("**error**"),
                                failed_count=text.count("failed"),
                                job_concluded=text.count("job concluded"))
        if validation[name]["error_count"] or validation[name]["failed_count"]:
            raise ValueError(f"{source(name, '.lis')}: contains an error or failed measurement.")
        expected = 3 if name.startswith("01_diode_") or name == "04_subthreshold" or name in DECKS[2] else 1
        if validation[name]["job_concluded"] != expected:
            raise ValueError(f"{source(name, '.lis')}: expected {expected} completed analyses.")

    diodes = []
    for polarity in "np":
        name = f"01_diode_{polarity}"
        for alter, block in enumerate(printed_tables(source(name, ".lis"), 3, 3)):
            for row in block:
                diodes.append(dict(polarity=polarity, width_factor=2**alter,
                                   VGS_magnitude_V=abs(row[0]), IDS_magnitude_A=abs(row[2])))
        metrics[f"diode_{polarity}_at_1V_uA"] = [
            abs(measurement_rows(source(name, f".ms{a}"))[0]["source_current_at_limit"]) * 1e6
            for a in range(3)
        ]
    exports["dic01_diode.csv"] = diodes

    output = []
    for polarity in "np":
        for block in printed_tables(source(f"02_output_{polarity}", ".lis"), 4, 6):
            for row in block:
                output.append(dict(polarity=polarity, VDS_magnitude_V=abs(row[0]),
                                   VGS_magnitude_V=abs(row[2]), IDS_magnitude_A=abs(row[3])))
    exports["dic01_output.csv"] = output

    length = []
    blocks = printed_tables(source("03_length", ".lis"), 4, 4)
    for channel_length, block in zip([.25, .5, .75, 1.0], blocks):
        for row in block:
            length.append(dict(L_um=channel_length, VDS_magnitude_V=row[0],
                               IDS_n_A=abs(row[2]), IDS_p_A=abs(row[3])))
    exports["dic01_length.csv"] = length
    metrics["length"] = measurement_rows(source("03_length", ".ms0"))
    exports["dic01_length_measurements.csv"] = metrics["length"]

    subthreshold = []
    fits = []
    for drain, block in zip([1, .6, .3], printed_tables(source("04_subthreshold", ".lis"), 4, 3)):
        for row in block:
            subthreshold.append(dict(VDS_magnitude_V=drain, VGS_magnitude_V=row[0],
                                     IDS_n_A=abs(row[2]), IDS_p_A=abs(row[3])))
        fit = block[(block[:, 0] >= .15) & (block[:, 0] <= .25)]
        if len(fit) < 3:
            raise ValueError("Not enough points in the 0.15--0.25 V fitting interval.")
        for polarity, column in [("n", 2), ("p", 3)]:
            x = fit[:, 0]
            current = np.abs(fit[:, column])
            if np.any(current <= 0):
                raise ValueError("Cannot take log10 of a zero current in the fitting interval.")
            y = np.log10(current)
            slope, intercept = np.polyfit(x, y, 1)
            predicted = slope*x + intercept
            r_squared = 1 - float(sum((y - predicted)**2) / sum((y - y.mean())**2))
            local = np.gradient(y, x)
            fits.append(dict(polarity=polarity, VDS_magnitude_V=drain,
                             fit_min_V=.15, fit_max_V=.25, SS_fit_mV_dec=1000/slope,
                             R_squared=r_squared, SS_local_min_mV_dec=float(1000/max(local)),
                             SS_local_max_mV_dec=float(1000/min(local))))
    exports["dic01_subthreshold.csv"] = subthreshold
    exports["dic01_subthreshold_fits.csv"] = fits
    metrics["subthreshold_fits"] = fits

    block = printed_tables(source("05_equal_geometry", ".lis"), 4, 1)[0]
    exports["dic01_equal_geometry.csv"] = [
        dict(VGS_magnitude_V=row[0], IDS_n_A=abs(row[2]), IDS_p_A=abs(row[3])) for row in block
    ]
    metrics["equal_geometry"] = measurement_rows(source("05_equal_geometry", ".ms0"))[0]

    summary = []
    stages = []
    for name in DECKS[2]:
        for alter, case in enumerate(["0.2 ns", "1 ps near-step", "2 us"]):
            row = measurement_rows(source(name, f".mt{alter}"))[0]
            summary.append(dict(deck=name, input_edge=case, tr8_ps=row["tr8"]*1e12,
                                tf8_ps=row["tf8"]*1e12,
                                rise_change_78_percent=row["rise_change_78"]*100,
                                fall_change_78_percent=row["fall_change_78"]*100,
                                pavg_W=row["pavg"]))
            for stage in range(1, 9):
                stages.append(dict(deck=name, input_edge=case, stage=stage,
                                   rise_10_90_ps=row[f"tr{stage}"]*1e12,
                                   fall_90_10_ps=row[f"tf{stage}"]*1e12))
    exports["dic02_summary.csv"] = summary
    exports["dic02_stages.csv"] = stages
    metrics["lab2_summary"] = summary
    metrics["validation"] = validation
    return exports, metrics


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("input_directory", type=Path, help="batch staging/results directory")
    parser.add_argument("output_directory", type=Path, help="Directory for nine CSV exports and metrics.json")
    parser.add_argument("--overwrite", action="store_true", help="Replace existing named CSV/metrics exports")
    args = parser.parse_args()
    input_directory = args.input_directory.resolve()
    output_directory = args.output_directory.resolve()
    if not input_directory.is_dir():
        parser.error(f"Input directory does not exist: {input_directory}")
    try:
        exports, metrics = collect_results(input_directory)
        targets = [output_directory / name for name in [*exports, "metrics.json"]]
        existing = [p.name for p in targets if p.exists()]
        if existing and not args.overwrite:
            parser.error("Output files already exist; use a new directory or --overwrite: " + ", ".join(existing))
        output_directory.mkdir(parents=True, exist_ok=True)
        for name, rows in exports.items():
            with (output_directory / name).open("w", newline="", encoding="utf-8-sig") as stream:
                writer = csv.DictWriter(stream, fieldnames=list(rows[0]))
                writer.writeheader()
                writer.writerows(rows)
        (output_directory / "metrics.json").write_text(json.dumps(metrics, indent=2), encoding="utf-8")
    except (OSError, ValueError, KeyError) as error:
        parser.exit(1, f"Export failed: {error}\n")
    print(f"Exported {len(exports)} CSV files and metrics.json to {output_directory}")
    print("Read only DIC Lab 1/2 results; input files and netlists were not modified.")


if __name__ == "__main__":
    main()
