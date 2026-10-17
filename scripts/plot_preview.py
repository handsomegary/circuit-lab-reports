"""Regenerate report figures from exported HSPICE measurements (no synthetic data)."""
from pathlib import Path
import csv
import shutil
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "validation" / "dic_pilot"
FIG = ROOT / "figures"
FIG.mkdir(exist_ok=True)
plt.rcParams.update({"font.family": "DejaVu Sans", "font.size": 10,
    "axes.spines.top": False, "axes.spines.right": False,
    "axes.grid": True, "grid.alpha": .2, "axes.titleweight": "bold",
    "figure.constrained_layout.use": True, "legend.frameon": False})
COLORS = ["#17628A", "#D17B25", "#38836D"]

def rows(name):
    with (DATA / name).open(encoding="utf-8-sig", newline="") as stream:
        return list(csv.DictReader(stream))

def save(fig, name, lab):
    for ext in ("pdf", "png"):
        fig.savefig(FIG / f"{name}.{ext}", dpi=220)
    for lang in ("zh", "en"):
        target = ROOT / "reports" / lab / lang / "figures"
        target.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(FIG / f"{name}.pdf", target / f"{name}.pdf")
    plt.close(fig)

diode = rows("dic01_diode.csv")
weak = rows("dic01_subthreshold.csv")
fig, axes = plt.subplots(1, 2, figsize=(7.0, 3.35))
for polarity, linestyle in [("n", "-"), ("p", "--")]:
    for factor, color in zip(sorted({float(d["width_factor"]) for d in diode}), COLORS):
        r = [d for d in diode if d["polarity"] == polarity and float(d["width_factor"]) == factor]
        if r:
            axes[0].plot([float(d["VGS_magnitude_V"]) for d in r],
                         [1e6*float(d["IDS_magnitude_A"]) for d in r],
                         linestyle, color=color, label=f"{polarity.upper()}MOS, {factor:g}x W")
    for drain, color in zip(sorted({float(d["VDS_magnitude_V"]) for d in weak}), COLORS):
        r = [d for d in weak if float(d["VDS_magnitude_V"]) == drain]
        axes[1].semilogy([float(d["VGS_magnitude_V"]) for d in r],
                        [abs(float(d[f"IDS_{polarity}_A"])) for d in r],
                        linestyle, color=color, label=f"{polarity.upper()}MOS, |VDS|={drain:g} V")
axes[0].set(xlabel="Gate-voltage magnitude (V)", ylabel="Drain-current magnitude (uA)", title="Diode-connected transfer")
axes[0].legend(fontsize=7)
axes[1].axvspan(.15, .25, color=COLORS[2], alpha=.12, label="Fit interval")
axes[1].set(xlabel="Gate-voltage magnitude (V)", ylabel="Drain-current magnitude (A)", title="Weak-inversion transfer")
axes[1].legend(fontsize=6.5)
save(fig, "dic01_characteristics", "DIC01")

length = rows("dic01_length.csv")
fig, axes = plt.subplots(1, 2, figsize=(7.0, 3.2), sharex=True)
for ax, polarity in zip(axes, ("n", "p")):
    for ch in sorted({float(d["L_um"]) for d in length}):
        r = [d for d in length if float(d["L_um"]) == ch]
        ax.plot([float(d["VDS_magnitude_V"]) for d in r], [1e6*abs(float(d[f"IDS_{polarity}_A"])) for d in r], label=f"L = {ch:g} um")
    ax.set(xlabel="Drain-voltage magnitude (V)", ylabel="Drain-current magnitude (uA)", title=f"{polarity.upper()}MOS length sweep")
    ax.legend(fontsize=8)
save(fig, "dic01_length", "DIC01")

output = rows("dic01_output.csv")
fig, axes = plt.subplots(1, 2, figsize=(7.0, 3.2), sharex=True)
for ax, polarity in zip(axes, ("n", "p")):
    p = [d for d in output if d["polarity"] == polarity]
    for gate in sorted({float(d["VGS_magnitude_V"]) for d in p}):
        r = [d for d in p if float(d["VGS_magnitude_V"]) == gate]
        ax.plot([float(d["VDS_magnitude_V"]) for d in r],
                [1e6*abs(float(d["IDS_magnitude_A"])) for d in r], label=f"|VGS| = {gate:g} V")
    ax.set(xlabel="Drain-voltage magnitude (V)", ylabel="Drain-current magnitude (uA)", title=f"{polarity.upper()}MOS output family")
    ax.legend(fontsize=7)
save(fig, "dic01_output", "DIC01")

stages = rows("dic02_stages.csv")
names = {"01_chain": "Baseline / FO1", "02_fanout3": "Fanout 3", "03_size3": "3x device size"}
fig, axes = plt.subplots(1, 2, figsize=(7.0, 3.3), sharex=True)
for deck, color in zip(names, COLORS):
    r = [d for d in stages if d["deck"] == deck and d["input_edge"] == "2 us"]
    for ax, key in zip(axes, ("rise_10_90_ps", "fall_90_10_ps")):
        ax.semilogy([int(d["stage"]) for d in r], [float(d[key]) for d in r], "o-", color=color, ms=4, label=names[deck])
for ax, title in zip(axes, ("10-90% rise time", "90-10% fall time")):
    ax.set(xlabel="Loaded output stage", ylabel="Transition time (ps)", title=title, xticks=range(1, 9))
    ax.legend(fontsize=7)
save(fig, "dic02_stage_evolution", "DIC02")

summary = rows("dic02_summary.csv")
fig, axes = plt.subplots(1, 2, figsize=(7.0, 3.3))
edges = ["1 ps near-step", "0.2 ns", "2 us"]
x = np.arange(3)
for ax, key, title in zip(axes, ("tr8_ps", "tf8_ps"), ("Stage 8 rise time", "Stage 8 fall time")):
    for j, deck in enumerate(names):
        vals = [float(next(d for d in summary if d["deck"] == deck and d["input_edge"] == edge)[key]) for edge in edges]
        ax.bar(x + (j-1)*.25, vals, width=.23, color=COLORS[j], label=names[deck])
    ax.set(xticks=x, xticklabels=["1 ps approx.", "0.2 ns", "2 us"], ylabel="Transition time (ps)", xlabel="Input transition time", title=title)
    ax.legend(fontsize=7)
save(fig, "dic02_stage8", "DIC02")
print("Generated five figure pairs from actual DIC CSV exports.")
