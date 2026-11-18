"""Parse HSPICE ASCII (.option post=2) waveforms and measure each practice deck.

    python analyze.py RUN_DIRECTORY

RUN_DIRECTORY is the folder written by run_practice.py (RUN_DIRECTORY/<deck>.tr0, .mt0).
Writes ../results/summary.json and ../results/figures/*.png.
"""
import json
import os
import re
import sys

import numpy as np
import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt

HERE = os.path.dirname(os.path.abspath(__file__))
RUN = os.path.abspath(sys.argv[1])
OUT = os.path.join(HERE, "..", "results", "figures")
SUMMARY = os.path.join(HERE, "..", "results", "summary.json")
os.makedirs(OUT, exist_ok=True)


def read_tr(path):
    """Return list of sweeps; each sweep is dict name -> np.array."""
    with open(path, "r", errors="replace") as f:
        lines = f.read().split("\n")
    hdr, i = [], 0
    while "$&%#" not in lines[i]:
        hdr.append(lines[i])
        i += 1
    hdr.append(lines[i])
    tokens = "".join(hdr).split("$&%#")[0].split()
    t0 = tokens.index("TIME")
    names = [n if not n.startswith(("v(", "i(")) or n.endswith(")") else n + ")" for n in tokens[t0:]]
    names[0] = "time"
    # a sweep file has a trailing parameter token row; keep only signal names
    data = "".join(l for l in lines[i + 1:])
    fields = [data[k:k + 13] for k in range(0, len(data) - 12, 13)]
    vals = []
    for s in fields:
        s = s.strip()
        if not s:
            continue
        vals.append(float(s))
    ncol = len(names)
    sweeps, cur = [], []
    for v in vals:
        if v > 0.9e30:  # end-of-sweep marker
            sweeps.append(cur)
            cur = []
        else:
            cur.append(v)
    if cur:
        sweeps.append(cur)
    out = []
    for sw in sweeps:
        # swept files start each block with the sweep parameter value
        extra = len(sw) % ncol
        arr = np.array(sw[extra:]).reshape(-1, ncol)
        d = {n: arr[:, k] for k, n in enumerate(names)}
        if extra:
            d["_param"] = sw[:extra]
        out.append(d)
    return out


def read_mt(path):
    with open(path) as f:
        txt = f.read().split("\n")
    body = [l for l in txt if l and not l.startswith(("$", ".TITLE"))]
    toks = " ".join(body).split()
    # header names are non-numeric tokens before the first number
    names = []
    for t in toks:
        try:
            float(t)
            break
        except ValueError:
            names.append(t)
    nums = []
    for t in toks[len(names):]:
        try:
            nums.append(float(t))
        except ValueError:
            nums.append(float("nan"))
    rows = np.array(nums).reshape(-1, len(names))
    return {n: rows[:, k] for k, n in enumerate(names)}


def cross(t, y, level, edge="rise", after=0.0):
    """Interpolated crossing times."""
    s = y - level
    idx = np.where((s[:-1] < 0) & (s[1:] >= 0))[0] if edge == "rise" else np.where((s[:-1] > 0) & (s[1:] <= 0))[0]
    tc = t[idx] - s[idx] * (t[idx + 1] - t[idx]) / (s[idx + 1] - s[idx])
    return tc[tc >= after]


def at(t, y, tq):
    return float(np.interp(tq, t, y))


def win(t, y, a, b):
    m = (t >= a) & (t <= b)
    return y[m]


S = {}

# ---------------------------------------------------------------- 20260902
w = read_tr(os.path.join(RUN, "and_glitch_4versions.tr0"))[0]
t = w["time"]
r = {}
for k in ["base", "sol1", "sol2", "sol3"]:
    y = w[f"v(and_out_{k})"]
    fast = k == "sol3"
    ref_rise = 40.0e-9 + (0.005e-9 if fast else 0.05e-9)   # b 50 % rising at 40 ns
    ref_fall = 10.0e-9 + (0.015e-9 if fast else 0.15e-9)   # b 50 % falling at 10 ns
    # AND is ideally 0 from 10 ns to 40 ns; b rises at 20 ns while a falls 20.0x ns
    seg_t, seg_y = t[(t >= 19.5e-9) & (t <= 25e-9)], y[(t >= 19.5e-9) & (t <= 25e-9)]
    up = cross(seg_t, seg_y, 0.5, "rise")
    dn = cross(seg_t, seg_y, 0.5, "fall")
    width = float(dn[0] - up[0]) if len(up) and len(dn) and dn[0] > up[0] else 0.0
    r[k] = {
        "glitch_peak_V_near_20ns": round(float(seg_y.max()), 4),
        "glitch_peak_V_near_60ns": round(float(win(t, y, 59.5e-9, 65e-9).max()), 4),
        "glitch_width_ps_at_50pct": round(width * 1e12, 1),
        "rise_delay_ps_b_to_out": round((cross(t, y, 0.5, "rise", after=39e-9)[0] - ref_rise) * 1e12, 1),
        "fall_delay_ps_b_to_out": round((cross(t, y, 0.5, "fall", after=9e-9)[0] - ref_fall) * 1e12, 1),
    }
S["01_and_gate_glitch"] = r
fig, ax = plt.subplots(5, 1, figsize=(8, 8), sharex=True)
ax[0].plot(t * 1e9, w["v(a)"], label="a")
ax[0].plot(t * 1e9, w["v(b)"], label="b")
ax[0].legend(loc="right")
for j, k in enumerate(["base", "sol1", "sol2", "sol3"]):
    ax[j + 1].plot(t * 1e9, w[f"v(and_out_{k})"])
    ax[j + 1].set_ylabel(k)
ax[-1].set_xlabel("time (ns)")
fig.suptitle("AND gate glitch, 4 versions")
fig.tight_layout()
fig.savefig(os.path.join(OUT, "01_and_glitch.png"), dpi=110)
plt.close(fig)

# ---------------------------------------------------------------- 20260903
m = read_mt(os.path.join(RUN, "fo4_wp_sweep_L0p25.mt0"))
k = int(np.nanargmin(m["t_fo4"]))
S["02_fo4_wp_sweep_L0p25"] = {
    "sweep_points": int(len(m["wp_val"])),
    "wn_um": 0.6,
    "L_um": 0.25,
    "best_wp_um": round(float(m["wp_val"][k]) * 1e6, 3),
    "best_wp_over_wn": round(float(m["wp_val"][k]) / 0.6e-6, 3),
    "min_t_fo4_ps": round(float(m["t_fo4"][k]) * 1e12, 3),
    "tpHL_ps_at_best": round(float(m["tphl"][k]) * 1e12, 3),
    "tpLH_ps_at_best": round(float(m["tplh"][k]) * 1e12, 3),
    "t_fo4_ps_at_wp_0p6": round(float(m["t_fo4"][0]) * 1e12, 3),
    "t_fo4_ps_at_wp_4p0": round(float(m["t_fo4"][-1]) * 1e12, 3),
}
fig, ax = plt.subplots(figsize=(7, 4))
ax.plot(m["wp_val"] * 1e6, m["t_fo4"] * 1e12, label="t_avg")
ax.plot(m["wp_val"] * 1e6, m["tphl"] * 1e12, "--", label="tpHL")
ax.plot(m["wp_val"] * 1e6, m["tplh"] * 1e12, "--", label="tpLH")
ax.axvline(m["wp_val"][k] * 1e6, color="gray", lw=0.8)
ax.set_xlabel("Wp (um), Wn = 0.6 um")
ax.set_ylabel("delay (ps)")
ax.legend()
ax.set_title("FO4 delay vs PMOS width (L = 0.25 um)")
fig.tight_layout()
fig.savefig(os.path.join(OUT, "02_fo4_wp_sweep.png"), dpi=110)
plt.close(fig)

# ---------------------------------------------------------------- PFD x4
pfd = {}
fig, axs = plt.subplots(4, 1, figsize=(9, 9), sharex=True)
for j, n in enumerate(["pfd_v0_tg_dff", "pfd_v1_or_reset_dff", "pfd_v2_tg_latch_dff", "pfd_v3_6nand_dff"]):
    w = read_tr(os.path.join(RUN, n + ".tr0"))[0]
    t = w["time"]
    up, dn, rst = w["v(up)"], w["v(dn)"], w["v(rst)"]
    rr = cross(t, rst, 0.5, "rise")
    rf = cross(t, rst, 0.5, "fall")
    widths = [float(f - r0) for r0 in rr for f in rf[rf > r0][:1]]
    upr = cross(t, up, 0.5, "rise")
    dnr = cross(t, dn, 0.5, "rise")
    pfd[n] = {
        # ideal: UP=1 from 5 ns until DN rises at 25 ns -> reset; at 45 ns UP=1, 47 ns DN -> reset
        "UP_at_15ns": round(at(t, up, 15e-9), 3),
        "DN_at_15ns": round(at(t, dn, 15e-9), 3),
        "UP_at_35ns": round(at(t, up, 35e-9), 3),
        "DN_at_35ns": round(at(t, dn, 35e-9), 3),
        "UP_at_46ns": round(at(t, up, 46e-9), 3),
        "UP_at_55ns": round(at(t, up, 55e-9), 3),
        "DN_at_55ns": round(at(t, dn, 55e-9), 3),
        "UP_rising_edges": int(len(upr)),
        "DN_rising_edges": int(len(dnr)),
        "RST_pulses": int(len(rr)),
        "RST_pulse_width_ps": [round(x * 1e12, 1) for x in widths[:6]],
        "UP_first_rise_ns": round(float(upr[0]) * 1e9, 3) if len(upr) else None,
    }
    a = axs[j]
    a.plot(t * 1e9, up + 2.4, label="UP")
    a.plot(t * 1e9, dn + 1.2, label="DN")
    a.plot(t * 1e9, rst, label="RST")
    a.set_ylabel(n.split("_")[1])
    a.set_yticks([])
axs[0].legend(loc="upper right", ncol=3)
axs[-1].set_xlabel("time (ns)")
fig.suptitle("PFD versions (offset traces: UP, DN, RST)")
fig.tight_layout()
fig.savefig(os.path.join(OUT, "04_pfd_versions.png"), dpi=110)
plt.close(fig)
S["04_pfd"] = pfd

# ---------------------------------------------------------------- RC wire + buffer
buf = {}
fig, axs = plt.subplots(2, 1, figsize=(8, 6), sharex=True)
for j, (n, L) in enumerate([("rc_buffer_L0p1", 0.1), ("rc_buffer_L0p25", 0.25)]):
    w = read_tr(os.path.join(RUN, n + ".tr0"))[0]
    t = w["time"]
    di, o1, o = w["v(in_degraded)"], w["v(out1)"], w["v(out)"]
    ss = t >= 20e-9
    ic = cross(t, w["v(in)"], 0.6, "rise", after=19e-9)
    oc = cross(t, o, 0.6, "rise", after=19e-9)
    buf[n] = {
        "L_um": L,
        "rc_tau_ns": 10.0,
        "in_degraded_min_V_ss": round(float(di[ss].min()), 4),
        "in_degraded_max_V_ss": round(float(di[ss].max()), 4),
        "out_min_V_ss": round(float(o[ss].min()), 4),
        "out_max_V_ss": round(float(o[ss].max()), 4),
        "out_rise_delay_ns_in_to_out_50pct": round(float((oc[0] - ic[0]) * 1e9), 4),
    }
    a = axs[j]
    a.plot(t * 1e9, w["v(in)"], lw=0.8, label="in")
    a.plot(t * 1e9, di, label="in_degraded")
    a.plot(t * 1e9, o, label="out")
    a.set_ylabel(f"{n} (L={L}u)")
axs[0].legend(loc="upper right", ncol=3)
axs[-1].set_xlabel("time (ns)")
fig.suptitle("RC-degraded input regenerated by 2-stage buffer")
fig.tight_layout()
fig.savefig(os.path.join(OUT, "03_rc_buffer.png"), dpi=110)
plt.close(fig)
S["03_rc_wire_buffer"] = buf

# ---------------------------------------------------------------- 2026091702 FO4
m = read_mt(os.path.join(RUN, "fo4_tpd_L0p1.mt0"))
S["02_fo4_tpd_L0p1"] = {
    "L_um": 0.1,
    "wp_um": 1.2,
    "wn_um": 0.6,
    "t_pHL_ps": round(float(m["t_phl"][0]) * 1e12, 3),
    "t_pLH_ps": round(float(m["t_plh"][0]) * 1e12, 3),
    "tpd_ps": round(float(m["tpd"][0]) * 1e12, 3),
}

# ---------------------------------------------------------------- 20261020 RC oscillator
w = read_tr(os.path.join(RUN, "rc_phase_shift_osc.tr0"))[0]
t, o = w["time"], w["v(out)"]
early = win(t, o, 0.0, 0.5e-3)
late = win(t, o, 2.5e-3, 3e-3)
S["05_rc_phase_shift_osc"] = {
    "out_pp_mV_0_to_0p5ms": round(float(np.ptp(early)) * 1e3, 4),
    "out_pp_mV_2p5_to_3ms": round(float(np.ptp(late)) * 1e3, 4),
    "out_mean_V_end": round(float(late.mean()), 4),
    "oscillates": bool(np.ptp(late) > 0.05),
}
fig, ax = plt.subplots(figsize=(8, 3.5))
ax.plot(t * 1e3, o, label="out")
ax.plot(t * 1e3, w["v(gate)"], label="gate")
ax.set_xlabel("time (ms)")
ax.legend()
ax.set_title("NMOS RC phase-shift oscillator")
fig.tight_layout()
fig.savefig(os.path.join(OUT, "05_rc_phase_shift_osc.png"), dpi=110)
plt.close(fig)

# ---------------------------------------------------------------- 202610201 CS amp
w = read_tr(os.path.join(RUN, "cs_amp.tr0"))[0]
t, g, o = w["time"], w["v(gate)"], w["v(out)"]
ss = t >= 0.5e-3
S["05_cs_amp"] = {
    "vin_pp_mV": round(float(np.ptp(g[ss])) * 1e3, 4),
    "vout_pp_mV": round(float(np.ptp(o[ss])) * 1e3, 4),
    "gain_VV": round(float(np.ptp(o[ss]) / np.ptp(g[ss])), 5),
    "vout_mean_V": round(float(o[ss].mean()), 5),
}
fig, ax = plt.subplots(2, 1, figsize=(8, 4.5), sharex=True)
ax[0].plot(t * 1e3, g)
ax[0].set_ylabel("v(gate)")
ax[1].plot(t * 1e3, o)
ax[1].set_ylabel("v(out)")
ax[1].set_xlabel("time (ms)")
fig.suptitle("NMOS common-source amplifier")
fig.tight_layout()
fig.savefig(os.path.join(OUT, "05_cs_amp.png"), dpi=110)
plt.close(fig)

with open(SUMMARY, "w") as f:
    json.dump(S, f, indent=2)
print(json.dumps(S, indent=2))
