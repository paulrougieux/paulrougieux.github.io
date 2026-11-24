---
name: html-workbench
description: Base pattern for a single self-contained, offline HTML workbench that compares two or more datasets with SVG charts driven by sliders, toggles and checkboxes. Use when asked to create, extend or restyle an interactive HTML comparison page. Read the specialised skill as well when it applies: html-workbench-scenarios for model scenario runs against a reference, html-workbench-papers for results reported in published papers.
---

# HTML workbench

A pattern for one-file interactive workbenches that compares two or more datasets. It
lets the reader move through time, variables and units with on-page controls. No server,
no CDN, no network: the self contained html file can be emailed or opened from disk.

This skill holds the parts every workbench shares. The specialised skills add what
depends on the kind of sources:

- `html-workbench-scenarios`: model scenario runs compared with a reference dataset.
- `html-workbench-papers`: results transcribed from published papers.


## Architecture

1. **Page shell**: one HTML template with a header, a numbered table of
   contents, a theme toggle (system / light / dark) and an empty figures host.
2. **Payload**: the data the charts need, as tidy tables plus a `meta` block
   (years, labels, source names). It is inlined in the page (for example as
   JSON, gzipped and base64-encoded, decoded in the browser).
3. **Shared chart kit** (`kit.js`): payload loading, SVG drawing helpers,
   axes, tooltip, legend, controls, figure mounting. Plain SVG keeps the page
   small; a plotting library would be larger than the data.
4. **One figure file per page**: registers
   numbered sections with `figure({id, num, title, lede, caveat, state,
   controls, render})`.
5. **Generator** (optional, any language): exports the tables, builds the
   payload and writes the template, kit and figure file into one file. Any tool
   that can write the payload and concatenate the assets would do.

Data sources are a project choice. The page only needs tables in long format
with a `source` column (see below); where they come from (model output on
disk, a database, CSV exports, values transcribed from papers) is outside the
pattern.


## Principles every page follows

1. **Top floating header bar** with the page title, the numbered section links and the
   theme button.
2. **Metadata section** under the bar that describes the sources being compared. What
   it holds depends on the kind of sources (see the specialised skills).
3. **Fixed section order** shared by all pages of a project, then page-specific extras.
   Skip a section a page has no data for.

A shared page shell gives every page the bar and the metadata block; a page only fills
its metadata.


## Shared components: reuse before writing

- **One stylesheet** with the colour tokens for light and dark. Add page-specific rules
  to it or as extra CSS passed to the page writer, never a new palette.
- **One page shell** (template) with the top bar and the metadata block, used by every
  page.
- **The kit** (`kit.js`): payload loading, colour roles, chart helpers, controls,
  `figure`, `boot`, the source model (source colours, legend) and aggregation by
  source. Put any helper a second page needs here, not in a page file.
- **Section modules**: one file per standard section. Each section function takes an
  adapter (`num`, `sources()`, `rows()` in long format), so several pages with
  different data can register the same section.
- **One page writer** on the generator side: takes the output path, payload, scripts,
  title, subtitle and intro, and inlines everything into one file.


## Top menu bar and sections

A **section** is one numbered block of the page that answers one question,
about one page in size: a single plot, or a collection of panels when the plot
is faceted. Each section has the same parts, top to bottom:

- a number and title
- a lede: what is compared, and what each control does; optionally a caveat on known
  differences in definitions; A lede is the short introductory paragraph under the title
  (a newspaper term for the opening lines of a story).
- a control row (sliders, button rows, dropdowns, checkboxes);
- the legend and the chart, or a table when the content is tabular (e.g. indicators);
- a footer with "Show table" (the data behind the chart) and "Download SVG".

A section may hold more than one view of the same subject behind a "View"
switch. A closely related follow-up can be a sub-section, numbered
"3b", with no link of its own in the top bar.

Every page opens with the single top bar of the shared page shell, `<header
class="top">`:

- **Title** on the left: the page title, optionally preceded by a short tag (see the
  specialised skills).
- **Section links** in the middle: one numbered pill per section. The links are not
  written in the template: `boot()` in `kit.js` builds them from the `nav` field of
  each registered figure, so adding a figure adds its link.
- **Theme button** on the right: cycles system, light and dark. The choice is
  kept in `localStorage`, and every figure is redrawn so the chart colours
  follow the theme.

The bar stays at the top of the window while scrolling (`position: sticky`)
and wraps onto several lines on narrow screens. Every page uses the same shell, so
every page has the same bar.


## Data comparison

The core idea: **every table is long format with a `source` column**, so the
page loops over sources instead of hard-coding one column per source. Adding a
source is adding rows, not code.

- **Colours.** Sources get the colours of a bounded categorical palette, in a stable
  order (hence a maximum number of sources).
- **Align before comparing.** Years, periods and units must be matched so the page plots
  like with like.
- **Common keys.** Restrict to the intersection of years or strata present in
  every source; show "No data for this selection" rather than a misleading
  zero.
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

1. Decide the sources to compare (see the specialised skill for the kind of sources).
2. Export each as a long table with a `source` column; align years and units.
3. Write one figure file that registers numbered sections, reusing the section modules
   where the tables fit and the kit's controls otherwise; add a lede (and caveat) per
   section. Register the sections in the fixed order, then the extras.
4. Fill the metadata so the header and the metadata block are filled.
5. Write the page with the shared page writer, which inlines the payload and assets
   into one HTML file; check the size.
6. Open the file from disk in both themes and drag each slider end to end.
