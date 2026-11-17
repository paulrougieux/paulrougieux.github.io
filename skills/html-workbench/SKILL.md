---
name: html-comparison-workbench
description: Build a single self-contained, offline HTML workbench that compares a reference dataset with one or more model runs, using small-multiple SVG charts driven by sliders, toggles and checkboxes. Use when asked to create, extend or restyle an interactive HTML report, a scenario comparison page, or a "model vs reference" workbench.
---

# HTML comparison workbench

A pattern for one-file interactive workbenches that compares two or more datasets. It
lets the reader move through time, variables and units with on-page controls. No server,
no CDN, no network: the self contained html file can be emailed or opened from disk.

## Architecture

1. **Page shell**: one HTML template with a header, a numbered table of
   contents, a theme toggle (system / light / dark) and an empty figures host.
2. **Payload**: the data the charts need, as tidy tables plus a `meta` block
   (years, labels, run names). It is inlined in the page (in the current
   instances: JSON, gzipped and base64-encoded, decoded in the browser).
3. **Shared chart kit** (`kit.js`): payload loading, SVG drawing helpers,
   axes, tooltip, legend, controls, figure mounting. Plain SVG keeps the page
   small; a plotting library would be larger than the data.
4. **One figure file per page** (`report.js`, `comparison.js`, ...): registers
   numbered sections with `figure({id, num, title, lede, caveat, state,
   controls, render})`.
5. **Generator** (optional, any language): exports the tables, builds the
   payload and writes the template, kit and figure file into one file. In this
   project it is Python, called from a runner, e.g.
   `runner.plot.html_report()`. Any tool that can write the payload and
   concatenate the assets would do.

Data sources are a project choice. The page only needs tables in long format
with a `source` column (see below); where they come from (model output on
disk, a database, CSV exports) is outside the pattern.


## Top menu bar and sections

A **section** is one numbered block of the page that answers one question,
about one page in size: a single plot, or a collection of panels when the plot
is faceted. Each section has the same parts, top to bottom:

- a number and title
- a lede: what is compared, and what each control does; optionally a caveat on known
  differences in definitions; A lede is the short introductory paragraph under the title
  (a newspaper term for the opening lines of a story).
- a control row (sliders, button rows, dropdowns, checkboxes);
- the legend and the chart, or a table when the content is tabular
  (indicators, the KB translation);
- a footer with "Show table" (the data behind the chart) and "Download SVG".

A section may hold more than one view of the same subject behind a "View"
switch. A closely related follow-up can be a sub-section, numbered
"3b", with no link of its own in the top bar.

A single top bar, `<header class="top">`

- **Title** on the left: the page title
- **Section links** in the middle: one numbered pill per section. The links are not written
  in the template: `boot()` in `kit.js` builds them from the `nav` field of
  each registered figure, so adding a figure adds its link.
- **Theme button** on the right: cycles system, light and dark. The choice is
  kept in `localStorage`, and every figure is redrawn so the chart colours
  follow the theme.

The bar stays at the top of the window while scrolling (`position: sticky`)
and wraps onto several lines on narrow screens. The scenario comparison page
has the same bar. In the scenario report, the generation date sits where the
section links are, and those links appear lower on the page instead.

## Data comparison

The core idea: **every table is long format with a `source` column**, so the
page loops over sources instead of hard-coding "reference" and "model"
columns. Adding a run is adding rows, not code.

- **Reference vs runs.** One source is the reference, drawn first with a fixed colour;
  the runs get the next colours of a bounded categorical palette (hence a maximum number
  of runs).
- **External sources** are separate small tables drawn as extra lines, each behind its
  own checkbox.
- **Align before comparing.** Years, periods and units must be matched so the page plots
  like with like.
- **Common keys.** Restrict to the intersection of years or strata present in
  every source; show "No data for this selection" rather than a misleading
  zero.
- **Comparison forms used:**
  - side-by-side bars per category (one bar per source in each age class);
  - lines through time, one per source, with shortfall or gap shaded;
  - ratio scatter (run / reference for area on x, volume on y);
  - summary tables (totals per source, indicator or score tables).
- **Caveats in the page.** Each section has an optional caveat for known differences in
  definitions.


## Plot options and controls

Each figure keeps its own `state` object. Controls change the state, then call
either `redraw` (chart only) or `rerender` (controls and chart). Sliders call
`redraw` so the slider is not rebuilt under the pointer while dragging.

Control types
- slider
- Mutually exclusive choices
- select list
- Checkbox

Every figure also gets, from the kit: hover tooltip and crosshair, a legend,
a "Download SVG" button and a toggle to show the underlying data table.


## Checklist for a new workbench

1. Decide the reference, the runs and any external sources.
2. Export each as a long table with a `source` column; align years and units.
3. Write one figure file that registers numbered sections, reusing the kit's
   controls; add a lede (and caveat) per section.
4. Inline the payload and assets into one HTML file; check the size.
5. Open the file from disk in both themes and drag each slider end to end.

