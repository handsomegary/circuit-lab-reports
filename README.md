# Circuit Lab Reports

本版包含 **DIC Lab 1、DIC Lab 2、AIC Lab 1**，每個 lab 各有中文及英文 LaTeX / PDF 報告。報告依講義列出規格對照、電路分析、模擬設定、真實結果、討論與結論；移植差異、量測限制與未解項目皆予保留。

## Reports

| Lab | 中文 | English | LaTeX |
| --- | --- | --- | --- |
| DIC 1: MOS characteristics | [PDF](reports/DIC01/zh/main.pdf) | [PDF](reports/DIC01/en/main.pdf) | [ZH](reports/DIC01/zh/main.tex) / [EN](reports/DIC01/en/main.tex) |
| DIC 2: Inverter chain | [PDF](reports/DIC02/zh/main.pdf) | [PDF](reports/DIC02/en/main.pdf) | [ZH](reports/DIC02/zh/main.tex) / [EN](reports/DIC02/en/main.tex) |
| AIC 1: Current mirrors | [PDF](reports/AIC01/zh/main.pdf) | [PDF](reports/AIC01/en/main.pdf) | [ZH](reports/AIC01/zh/main.tex) / [EN](reports/AIC01/en/main.tex) |

## Model-library paths and SPICE examples

模型庫由使用者在本機另行提供，不隨 repo 上傳。17 個 lab 程式使用下列路徑，從各 lab 的目錄執行：

```spice
.include '../../models/process.lib'
```

將適用且有使用權限的平面模型庫放在 `models/process.lib`，並確認包含 `nmos`、`pmos` 名稱。若需要絕對路徑，可替換為：

```spice
.include 'D:/models/process.lib'
```

如果模型庫本身含有具名 `.LIB` / `.ENDL` 區段，改用以下語法；`TT` 必須改成該庫實際存在的 section：

```spice
.lib 'D:/models/corners.lib' TT
```

完整 `.sp` 範例：[平面庫 include](examples/include_path.sp)、[具名區段 library](examples/library_section.sp)。`.lib` 副檔名不代表一定要用 `.lib` 指令。更多說明見 [models/README.md](models/README.md)。

The report data come from completed local simulations with the supplied model. The public paths are portable dependency placeholders; the model itself is not included. Changing the library may change the results. The 1 V setup is a declared teaching condition, not a verified foundry voltage rating. Original lecture PDFs are also not redistributed.

## Run and export

The 17 lab decks are under `DIC/Lab01`, `DIC/Lab02` and `AIC/Lab01`. Use a licensed HSPICE installation. To resolve relative include paths for running the files from a different working directory:

```text
python scripts/stage_batch.py C:\path\to\fresh_batch
```

The staging command requires the local model file to exist. Run the resulting decks with the simulator, then export and plot the actual data:

```text
python scripts/inspect_run.py C:\path\to\fresh_batch --output validation/simulation_execution.json
python scripts/export_dic_results.py C:\path\to\fresh_batch validation/dic_pilot --overwrite
python scripts/export_aic_results.py C:\path\to\fresh_batch AIC/Lab01/results
python scripts/plot_preview.py
python scripts/plot_aic_preview.py
```

The export commands replace generated result files. NumPy is required for DIC export; Matplotlib is required for plots. The AIC exporter uses the Python standard library. Exports use `.lis` tables and `.ms`/`.mt`/`.ma` measurements. Re-exporting figures does not rewrite numerical prose in `body.tex`; review the tables and discussion after changing simulation conditions.

The recorded local batch completed all 17 decks with no visible errors or failed measurements. Encrypted-block warning details remain suppressed even after a representative WARNLIMIT=100 diagnostic; matching measured values do not prove these warnings harmless. See `validation/model_warning_diagnostic.json`. Execution success is distinct from satisfying every lab specification.

This release changes descriptions and external include paths while retaining the simulated circuit statements and numeric data. `validation/release_checks.json` records those checks. Original private paths and model fingerprints are omitted. Raw simulator listings and waveforms remain local and are ignored by Git.

## Rebuild reports

Use XeLaTeX with `fontspec`, `xeCJK`, and Microsoft JhengHei (Windows), or Noto Serif CJK TC / Noto Sans CJK TC. Run twice in each report's language directory:

```text
xelatex -no-shell-escape -interaction=nonstopmode -halt-on-error main.tex
xelatex -no-shell-escape -interaction=nonstopmode -halt-on-error main.tex
```

Each project includes editable text and vector figures. All figures are plotted from actual exported data.
