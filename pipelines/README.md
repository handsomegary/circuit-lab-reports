# Archived analysis pipelines

`scripts/` 的公開匯出與繪圖腳本只涵蓋 AIC01、DIC01、DIC02。其餘 28 個 lab 的量測抽取、分析與繪圖程式，當初是在私人工作區執行的，這裡保存它們、它們需要的小型輸入，以及原生量測檔。這份資料記錄報告數值與圖表的產生方式，**不是可以直接執行的公開流程**。

## 涵蓋範圍

| 資料夾 | Labs | 腳本 | 小型輸入 |
| --- | --- | --- | --- |
| [`aic_next/`](aic_next) | AIC02–05 | `extract_next.py`、`analyze_next.py`、`plot_next.py` | `deck_index.json`、`calibrated_bias.json`、`frozen_sources.json` |
| [`dic_missing/`](dic_missing) | DIC04、07、10、11、13 | `analyze.py`、`figures.py` | `deck_manifest.json`、`final_audit.json` |
| [`dic_next/`](dic_next) | DIC05、06、08、09、12、14 | `analyze.py`、`figures.py` | `final_audit.json`、原生量測檔 |
| [`dic_missing_highA/`](dic_missing_highA) | DIC19、20、22、23 | `analyze.py`、`plot.py`（import `aic_next/extract_next.py`） | `deck_index.json`、`final_audit.json` |
| [`dic_high_next/`](dic_high_next) | DIC15、16、17、21、24–28 | `extract.py`、`extract_new.py`、`analyze.py`、`analyze24.py`、`plots.py`、`report15.py`、`report24.py`、`report26.py` | `deck_manifest.json`、`derived.json`、`validation_15_24_26.json` |
| [`dic_missing_highB/`](dic_missing_highB) | DIC24 | （由 `dic_high_next/analyze24.py` 寫入） | `derived.json` |
| 根目錄 | 全部 | `audit_complete_release.py`、`compile_release.py`、`render_release.py` | `visual_qa.json` |

[`measurements/`](measurements) 收錄 1,439 個 HSPICE 原生量測檔（`.mt*`、`.ms*`、`.ma*`，共 2.7 MB），依原本的工作資料夾分類。除了上表各組，還包含 HSPUI GUI 對照批次（`gui_batch_02`、`gui_batch_03`、`hspui_final`）與 CIC 角落檢查（`corner_final`、`library_corner_check`）。

## 原始目錄對照

這些腳本使用相對於原工作區根目錄的路徑：

| 腳本中的路徑 | 對應 |
| --- | --- |
| `outputs/Circuit_Labs_Release/` | 本 repo 根目錄 |
| `work/<group>/` | 本資料夾的 `pipelines/<group>/` |
| `work/<group>/sim`、`staging`、`runs` | 用 `scripts/stage_batch.py` 與 `scripts/run_batch.py` 重新產生的執行目錄 |
| `WORKSPACE/`（JSON 內） | 原工作區根目錄（已去除本機路徑） |

要重跑，請先在 repo 外建立同樣的目錄結構，或改寫路徑。部分腳本會覆寫已定稿的 CSV、圖表或報告原始碼，執行前請先檢查。

## 未收錄的內容

| 內容 | 原因 | 重新產生 |
| --- | --- | --- |
| RAW 波形（`.tr*`、`.sw*`、`.ac*`，3.5 GB）與 `.lis` listing（1.1 GB） | 模擬暫存輸出；listing 也含模型與 license 路徑 | 重跑 HSPICE |
| `dic_high_next/data.json`、`data_15.json`、`data_24.json`、`data_26.json`（347 MB） | 從 listing 抽出的完整波形 | 重跑後執行 `extract.py`／`extract_new.py` |
| 模型庫 | 不重新散布 | 另行提供（見根目錄 README） |
| 原始講義與私人原始檔清單 | 不重新散布 | — |

刪除前的檔名、大小與 SHA-256 記錄在 [`receipts/deleted_outputs_2026-11-18.json`](receipts/deleted_outputs_2026-11-18.json)。

## 去識別化

公開版本只換掉以下內容，量測與分析邏輯都沒有改：

- JSON 中的本機工作區路徑改為 `WORKSPACE/`。
- `compile_release.py`、`render_release.py` 的執行檔路徑改讀環境變數 `XELATEX`、`PDFTOPPM`。
- `audit_complete_release.py` 的私人用語檢查清單改讀環境變數 `PRIVATE_TERMS_REGEX`。
- `report15.py`、`report24.py`、`report26.py` 洩漏檢查中的模型名稱，改為 `private_model_tag`。
