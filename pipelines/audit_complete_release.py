"""Verify public sources, completed private runs, report builds and publication hygiene."""
from pathlib import Path
import argparse,hashlib,json,re,subprocess
from pypdf import PdfReader
from PIL import Image

p=argparse.ArgumentParser();p.add_argument('--partial',action='store_true');a=p.parse_args()
base=Path(__file__).resolve().parents[1]
root=base/'outputs'/'Circuit_Labs_Release'
expected_dic=[1,2,4,5,6,7,8,9,10,11,12,13,14,15,16,17,19,20,21,22,23,24,25,26,27,28]
expected={f'DIC{i:02d}' for i in expected_dic}|{f'AIC{i:02d}' for i in range(1,6)}
issues=[];decks=[];reports=[]
qa_path=base/'work'/'visual_qa.json'
visual_qa=json.loads(qa_path.read_text('utf8')) if qa_path.exists() else {}
def digest(path):return hashlib.sha256(path.read_bytes()).hexdigest()
def electrical(path):
    return [line.strip() for line in path.read_text('utf-8-sig').splitlines()[1:]
            if line.strip() and not line.lstrip().startswith('*')
            and not re.match(r'^\s*\.(include|inc|lib)\b',line,re.I)]
def staged_path(source):
    group,lab,name=source.relative_to(root).parts
    prefixed=f'{group}_{lab}_{name}'
    n=int(lab[3:])
    if (group=='AIC' and n==1) or (group=='DIC' and n in (1,2)):
        return base/'work'/'hspui_final'/prefixed
    if group=='AIC' or n in (5,6,8,9,12,14):
        return base/'work'/'gui_batch_02'/prefixed
    if n==15:return base/'work'/'corner_final'/prefixed
    if n in (16,17,21,25,27,28):return base/'work'/'gui_batch_03'/prefixed
    if n in (4,7,10,11,13):return base/'work'/'dic_missing'/'sim'/prefixed
    if n in (19,20,22,23):return base/'work'/'dic_missing_highA'/'staging'/prefixed
    if n in (24,26):return base/'work'/'dic_high_next'/'runs'/f'{lab}_{name}'
    raise ValueError(source)

for source in sorted(root.glob('*/*/*.sp')):
    rel=source.relative_to(root).as_posix();text=source.read_text('utf8')
    staged=staged_path(source);listing=staged.with_suffix('.lis')
    if not listing.exists():issues.append([rel,'missing final listing']);continue
    content=listing.read_text(errors='replace')
    expected_cases=1+len(re.findall(r'^\s*\.alter\b',text,re.I|re.M))
    record={'source':rel,'source_sha256':digest(source),
        'model_paths_omitted':not bool(re.search(r'^\s*\.(include|inc|lib)\b',text,re.I|re.M)),
        'model_setup_markers':len(re.findall(r'^\* MODEL_SETUP_REQUIRED\b',text,re.M)),
        'electrical_statements_match_executed_source':electrical(source)==electrical(staged),
        'expected_cases':expected_cases,'concluded_cases':content.lower().count('job concluded'),
        'visible_error_count':len(re.findall(r'\*\*\s*error\s*\*\*',content,re.I)),
        'failed_measurement_count':len(re.findall(r'(?im)^.*(?:=\s*failed|measure.*fail|job aborted).*$',content)),
        'visible_warning_count':len(re.findall(r'\*\*\s*warning\s*\*\*',content,re.I))}
    record['execution_complete']=(record['electrical_statements_match_executed_source'] and
        record['concluded_cases']==expected_cases and not record['visible_error_count'] and not record['failed_measurement_count'])
    if not record['execution_complete'] or not record['model_paths_omitted'] or not record['model_setup_markers']:
        issues.append([rel,'execution or source validation',record])
    decks.append(record)

for identifier in sorted(expected):
    for language in ['zh','en']:
        d=root/'reports'/identifier/language;pdf=d/'main.pdf'
        if not all((d/name).exists() for name in ['main.tex','body.tex','schematic.tex','main.pdf','main.log']):
            issues.append([f'{identifier}/{language}','incomplete report']);continue
        inputs=[q for q in d.rglob('*') if q.is_file() and (q.suffix=='.tex' or q.parent.name=='figures')]
        log=(d/'main.log').read_text('utf8',errors='replace')
        reader=PdfReader(pdf)
        schematic=(d/'schematic.tex').read_text('utf8')
        main=(d/'main.tex').read_text('utf8')
        record={'report':pdf.relative_to(root).as_posix(),'pages':len(reader.pages),'sha256':digest(pdf),
            'schematic_source':(d/'schematic.tex').relative_to(root).as_posix(),
            'schematic_sha256':digest(d/'schematic.tex'),
            'editable_mos_schematic_included':r'\input{schematic.tex}' in main and 'circuitikz' in schematic and bool(re.search(r'\b(?:nmos|pmos)\b',schematic)),
            'current_build':all(q.stat().st_mtime<=pdf.stat().st_mtime for q in inputs),
            'compiler_success':'Output written on main.pdf' in log,
            'overfull_boxes':bool(re.search('Overfull',log)),
            'missing_characters':bool(re.search('Missing character',log))}
        record['visual_review_current']=visual_qa.get(identifier+'/'+language,{}).get('pdf_sha256')==record['sha256']
        if not record['current_build'] or not record['compiler_success'] or record['overfull_boxes'] or record['missing_characters'] or not record['editable_mos_schematic_included']:
            issues.append([f'{identifier}/{language}','report build',record])
        reports.append(record)
        if not record['visual_review_current']:issues.append([f'{identifier}/{language}','visual review not current'])

files=subprocess.check_output(['git','ls-files','--cached','--others','--exclude-standard','-z'],cwd=root).decode('utf8').split('\0')
files=sorted(set(n for n in files if n and (root/n).is_file()))
# Private terms (model, names, local folders) are supplied at run time and not published.
import os
private=re.compile(r'hspui|[CD]:[\\/]|'+os.environ.get('PRIVATE_TERMS_REGEX','(?!)'),re.I)
scan=[]
for name in files:
    f=root/name;suffix=f.suffix.lower()
    if private.search(name):scan.append([name,'file name'])
    if f.stat().st_size>=100*1024**2:scan.append([name,'file at least 100 MiB'])
    if suffix in ['.model','.lib','.lis','.l'] or re.match(r'\.(?:tr|sw|mt|ms|ma|ac|ic|st)\d+$',suffix):
        scan.append([name,'private simulator artifact'])
    if suffix=='.pdf':
        reader=PdfReader(f)
        content=str(reader.metadata)+'\n'+'\n'.join(page.extract_text() or '' for page in reader.pages)
    elif suffix=='.png':
        with Image.open(f) as im:content=str(im.info)
    elif suffix in ['.jpg','.jpeg','.zip']:continue
    else:
        content=f.read_text('utf8',errors='replace')
    if private.search(content):scan.append([name,'identifier or personal path'])
issues.extend(scan)
present={q.parent.parent.name+q.parent.name[3:] for q in root.glob('*/*/*.sp')}
if present!=expected:issues.append(['lab coverage',{'missing':sorted(expected-present),'extra':sorted(present-expected)}])
summary={'labs':len(present),'decks':len(decks),'cases':sum(d['concluded_cases'] for d in decks),
    'reports':len(reports),'reports_with_mos_schematics':sum(r['editable_mos_schematic_included'] for r in reports),'pages':sum(r['pages'] for r in reports),'publication_files':len(files),'issues':len(issues)}
print(json.dumps({'summary':summary,'issues':issues},ensure_ascii=False,indent=2))
(base/'work'/'release_audit_latest.json').write_text(json.dumps({'summary':summary,'issues':issues},ensure_ascii=False,indent=2)+'\n',encoding='utf8')
if issues:
    if not a.partial:raise SystemExit(1)
elif not a.partial:
    (root/'validation'/'report_build.json').write_text(json.dumps(reports,indent=2)+'\n',encoding='utf8')
    (root/'validation'/'release_checks.json').write_text(json.dumps({
        'report_date':'2026-10-17','summary':summary,'decks':decks,
        'scope':'All circuit-only labs in the supplied handouts; layout and PDK-rule dependent labs excluded.',
        'excluded':['DIC03','DIC29','DIC30'],'absent_from_handout':['DIC18'],
        'model_dependency':'Supplied separately; public decks contain no model loading paths.',
        'execution_method':'Installed HSPICE; background command-line execution for the later batches.',
        'specification_compliance':'Execution completion is separate from meeting design targets; results and limitations are documented in each report.',
        'publication_scan':{'files':len(files),'matches':0,'coverage':['file names','source text and data','PDF text and metadata','PNG metadata']}
    },ensure_ascii=False,indent=2)+'\n',encoding='utf8')
