"""Plot actual AIC Lab 1 .print DC exports. No interpolation or invented data."""
from pathlib import Path
import csv
import shutil
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "AIC" / "Lab01" / "results"
OUT = ROOT / "figures"
OUT.mkdir(exist_ok=True)
plt.rcParams.update({"font.family":"DejaVu Sans", "font.size":10,
    "axes.spines.top":False,"axes.spines.right":False,"axes.grid":True,
    "grid.alpha":.2,"axes.titleweight":"bold","legend.frameon":False,
    "figure.constrained_layout.use":True})
colors=["#17628A", "#D17B25", "#38836D"]

def load(filename):
    with (DATA / filename).open(encoding="utf-8-sig", newline="") as stream:
        return list(csv.DictReader(stream))

def save(fig,name):
    for ext in ("pdf","png"):
        fig.savefig(OUT / f"{name}.{ext}",dpi=220)
    for lang in ("zh","en"):
        dest=ROOT/"reports"/"AIC01"/lang/"figures"
        dest.mkdir(parents=True,exist_ok=True)
        shutil.copyfile(OUT/f"{name}.pdf",dest/f"{name}.pdf")
    plt.close(fig)

groups=[
    ("aic01_mirrors", [("02_simple_mirror","vs","Simple"),
        ("03_cascode_mirror","vs","Cascode"),
        ("04_high_swing_cascode","vs","High-swing")]),
    ("aic01_feedback", [("05_wilson_comparison","vsw","Wilson"),
        ("05_wilson_comparison","vsm","Modified Wilson"),
        ("06_regulated_comparison","vsc","Complete regulated")])]
checks=load("comparison.csv")
for name,circuits in groups:
    fig,axes=plt.subplots(1,2,figsize=(7.0,3.6),sharex=True)
    for ax,case,title in zip(axes,(0,3),("Original sizing: W = 3 um","Resized: W = 30 um")):
        for (filename,column,label),color in zip(circuits,colors):
            selected_case = 4 if label == "Complete regulated" and case == 3 else case
            rows=load(f"{filename}_case{selected_case}.csv")
            check=next((c for c in checks if c['topology']==label and int(c['case_index'])==selected_case),None)
            suffix=" *" if check and check['bias_rail_ok'].lower()=='false' else ""
            if selected_case == 4:
                suffix += " (bias resized)"
            ax.plot([float(d['sweep_v']) for d in rows],
                    [1e6*float(d[column]) for d in rows],label=label+suffix,color=color,lw=1.6)
        ax.axhline(100,color="#7B8791",lw=.8,ls=":",label="Ideal 1:2 ratio")
        ax.set(xlabel="Output voltage (V)",ylabel="Output current (uA)",title=title)
        ax.legend(fontsize=7,loc="lower right")
    note="Iref = 50 uA, L = 1.4 um, VDD = 1 V.  * Bias exceeds the supply rail."
    if name == "aic01_feedback":
        note += "\nComplete regulated (right): gain NMOS W=120 um; bias PMOS W=300 um."
    fig.supxlabel(note,fontsize=7.5)
    save(fig,name)
print("Generated two AIC comparison figures from measured DC exports.")
