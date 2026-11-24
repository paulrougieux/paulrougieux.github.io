---
name: html-workbench-papers
description: Build a single self-contained, offline HTML workbench that compares results reported in published papers (values transcribed from their tables and figures), with SVG charts and on-page controls. Use when asked to compare paper results, literature estimates or published model outputs side by side in an interactive HTML page. For model scenario runs against a reference dataset, use html-workbench-scenarios instead.
---

# HTML workbench for papers

A one-file interactive page that puts results from several publications side by side.
No server, no CDN, no network: the self contained html file can be emailed or opened
from disk.

Read the `html-workbench` skill first: it holds the shared pattern (page shell, inlined
payload, shared chart kit, numbered sections with a lede, top bar, controls, "Show
table" and "Download SVG"). This skill only lists what is specific to papers.


## Data

- **One long table** with one row per reported value and these columns: `source` (a
  short citation key, e.g. `Smith2021`), the variable, the region or stratum, the year
  or period, the value and the unit.
- **Provenance** on every row: where the value was taken from in the paper (table or
  figure number, page). Values read off a figure are marked as approximate.
- **Bibliography table** in the payload: citation key, full reference, DOI link and a
  one-line note on the method or scope of each paper.


## Comparison

- **No reference by default.** All papers are peers; a reference (one paper, an
  inventory, or own model results) is optional and drawn first when present.
- **Harmonise units** before plotting, and keep the value and unit as reported in the
  table view.
- **Do not interpolate.** Papers report single years or periods: draw points, or bars
  spanning the period, rather than lines through missing years.
- **Caveats** in each section for differences in definitions, scope or system
  boundaries between papers.


## Page

- The metadata block under the top bar shows the bibliography table.
- One checkbox per paper to show or hide its values.


## Checklist

1. List the papers and give each a citation key.
2. Transcribe the values into the long table, with provenance and the unit as reported.
3. Harmonise units; note every conversion.
4. Write one section per variable compared, with a lede and a caveat.
5. Open the file from disk in both themes and check that every paper appears in the
   legend and in the table view.
