from pathlib import Path
import json,csv,re,sys
exec(Path('work/dic_high_next/extract.py').read_text().split('all_data={}')[0])
labs=[int(x) for x in sys.argv[1:]] or [15,24,26]
all_data={}
for lab in labs:
    folder=ROOT/f'Lab{lab:02d}'/'results';folder.mkdir(exist_ok=True)
    summary=[]
    for p in sorted((ROOT/f'Lab{lab:02d}').glob('*.sp')):
        stem=f'Lab{lab:02d}_'+p.stem
        status=json.loads((RUN/(stem+'_status.json')).read_text())
        if not status['completed'] or status['errors'] or status['failed']:raise RuntimeError(status)
        d=cases(stem);all_data[stem]=d
        for c in d:
            fields=list(c['rows'][0])
            with (folder/f'{p.stem}_case{c["index"]}.csv').open('w',newline='') as f:
                writer=csv.DictWriter(f,fieldnames=fields);writer.writeheader();writer.writerows(c['rows'])
            summary.append(dict(deck=p.name,case_index=c['index'],measurements=c['measurements'],completed=True,warning_status='No warnings reported.' if not status['warnings'] else 'Encrypted-block warning details suppressed by simulator.'))
    (folder/'measurements.json').write_text(json.dumps(summary,indent=2))
    print(lab,len(summary),'cases')
    # Save separate files; never overwrite prior labs' extracted data.
    (Path('work/dic_high_next')/f'data_{lab}.json').write_text(json.dumps({k:v for k,v in all_data.items() if k.startswith(f'Lab{lab:02d}_')}))
