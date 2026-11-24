---
name: html-workbench-scenarios
description: Build a single self-contained, offline HTML workbench that compares a reference dataset with one or more model scenario runs, using small-multiple SVG charts driven by sliders, toggles and checkboxes. Use when asked to create, extend or restyle an interactive HTML report, a scenario comparison page, or a "model vs reference" workbench. For comparing results reported in published papers, use html-workbench-papers instead.
---

# HTML workbench for scenarios

Model scenario runs compared with a reference dataset, in a one-file interactive page.

Read the `html-workbench` skill first: it holds the shared pattern (architecture,
principles, shared components, top bar and sections, data comparison, controls and the
base checklist). This skill only lists what is specific to scenarios.


## Generator

The generator is typically called from the code that runs the model, so a page can be
rebuilt after each run.


## Principles, scenario specifics

1. **Reference tag** at the start of the top bar: a short tag that names the reference
   dataset, before the page title.
2. **Metadata section** under the bar: the names of the input configuration files, the
   configuration as a table hidden by default (one column per run, differing values in
   bold), and a short explanation of the reference data.
3. **Page-specific extras** after the fixed sections, e.g. a ratio scatter or an
   indicator table.

A page only sets the reference label, the reference text and the configuration tables
in its metadata.


## Data comparison, scenario specifics

- **Reference vs runs.** One source is the reference, drawn first with a fixed colour;
  the runs get the next colours of the categorical palette (hence a maximum number of
  runs). Adding a run is adding rows, not code.
- **External sources** are separate small tables drawn as extra lines, each behind its
  own checkbox.
- **Section adapters** may expose `runs()` instead of `sources()` when the reference is
  handled apart.
- **Comparison forms used:**
  - side-by-side bars per category (one bar per source in each category);
  - lines through time, one per source, with the gap to the reference shaded;
  - ratio scatter (run / reference for one variable on x, another on y);
  - summary tables (totals per source, indicator tables).


## Checklist additions

On top of the base checklist in `html-workbench`:

1. Decide the reference, the runs and any external sources.
2. Fill the metadata with the reference label, the reference text, and the
   configuration file names and tables.
