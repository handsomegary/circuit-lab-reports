from pathlib import Path
import subprocess, concurrent.futures, sys
from PIL import Image, ImageOps, ImageDraw
root=Path('outputs/Circuit_Labs_Release/reports')
out=Path('work/release_render');out.mkdir(exist_ok=True)
import os
exe=os.environ.get('PDFTOPPM','pdftoppm')
def render(pdf):
 key=pdf.parent.parent.name+'_'+pdf.parent.name
 d=out/key;d.mkdir(exist_ok=True)
 contact=out/(key+'_contact.png')
 if contact.exists() and contact.stat().st_mtime>=pdf.stat().st_mtime:
  return (key,'already_current')
 for stale in d.glob('page-*.png'):
  assert stale.resolve().is_relative_to(out.resolve())
  stale.unlink()
 subprocess.run([exe,'-r','100','-png',str(pdf),str(d/'page')],check=True,capture_output=True)
 pages=sorted(d.glob('page-*.png'))
 thumbs=[]
 for p in pages:
  im=Image.open(p).convert('RGB');im.thumbnail((450,636))
  t=Image.new('RGB',(470,670),'#dfe5ec');t.paste(im,((470-im.width)//2,24))
  ImageDraw.Draw(t).text((15,7),key+' / '+p.stem,fill='black')
  thumbs.append(t)
 sheet=Image.new('RGB',(470*3,670*((len(thumbs)+2)//3)),'#bcc4cc')
 for i,t in enumerate(thumbs):sheet.paste(t,((i%3)*470,(i//3)*670))
 sheet.save(out/(key+'_contact.png'))
 return (key,len(pages))
pdfs=sorted(root.glob('*/*/main.pdf'))
if len(sys.argv)>1:pdfs=[p for p in pdfs if p.parent.parent.name in sys.argv[1:]]
with concurrent.futures.ThreadPoolExecutor(max_workers=3) as pool:
 for r in pool.map(render,pdfs):print(r,flush=True)
