# Local model library

Place a locally authorized, flat model library here as `process.lib`. It must define the `nmos` and `pmos` model names used by the lab netlists. Model files are excluded from version control and are not supplied with these reports.

The 17 lab netlists use `.include '../../models/process.lib'` relative to their own lab directories. Run from the directory containing the netlist, or use `scripts/stage_batch.py` to resolve paths before running elsewhere.

The `.lib` filename extension alone does not select the SPICE command. Use `.include 'path/process.lib'` for a flat file; use `.lib 'path/corners.lib' SECTION` only if the library actually defines that named section with `.LIB SECTION` and `.ENDL SECTION`.

See `examples/include_path.sp` and `examples/library_section.sp`. The section name `TT` in the second example is a placeholder, not a statement about an available or verified corner. Check model names, operating limits and library documentation before using a different library. The supplied report data are from the original local simulations; another library can produce different results.
