# Local model library

Model libraries and their loading paths are supplied privately at execution time and are not included in the uploaded netlists. Ordinary decks expect `nmos` and `pmos`; the corner lab uses `n_18` and `p_18` from a separately supplied sectioned library.

Each public deck contains a `MODEL_SETUP_REQUIRED` comment. The staging script replaces this comment only in the local execution copy, using the model selected at run time. A section name following the comment selects that named section in the corner library.

Do not upload staged execution copies or model libraries. The extension of a model file does not establish the existence of selectable process corners. Section names must actually exist in the selected library.

The examples also omit loading paths. Check device names, operating limits and library documentation before using a different library; another model can produce different results.
