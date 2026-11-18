This repository contains useful tools and data related to my work on forest products.

It is visible as a website in two places:

- https://paulrougieux.gitlab.io/paulrougieux/

- https://paulrougieux.github.io/

The site is built with [rmarkdown websites](http://rmarkdown.rstudio.com/rmarkdown_websites.html), using the R command:

    rmarkdown::render_site()

This shell command can also be used:

    cd ~/rp/paulrougieux.github.io && Rscript -e "rmarkdown::render_site()"

Or use the `makefile`

    make

The website menu is generated from [_site.yml](_site.yml).

The file [.gitlab-ci.yml](.gitlab-ci.yml) specifies how Gitlab's continuous integration
system should build the pages. The gitlab site is visible at:
https://paulrougieux.gitlab.io/paulrougieux/

To create the gitub version, I build the static site locally on my laptop and simply push all
html files to github. The github site is visible at: https://paulrougieux.github.io/

## Formatting rules for pasted terminal output

Pasted output often contains characters that markdown treats as markup. An unmatched
one opens a region that runs until the next matching character, swallowing every
heading in between.

- Wrap globs, tags and dollar amounts in backticks: `` `*.md` ``, `` `<json>` ``,
  `` `$5-$25` ``. A bare `*` opens emphasis, `<tag>` is dropped as raw HTML, and a
  `$` opens inline math (pandoc will not close it on a `$` followed by a digit).
- Do not use bare ```` ``` ```` fences in `.Rmd`. The vim `rmd` syntax only knows
  knitr chunks (```` ```{r} ````); a plain fence, even with an info string like
  ```` ```text ````, is parsed as an inline code span and leaks into the rest of the
  file. Use a knitr chunk or a 4-space indented block instead.
- Inside a 4-space indented block nothing needs escaping, and backslash escapes such
  as `\$` would be printed literally.

To find leaks, check whether every heading still highlights as a heading:

    vim -c 'syntax on' -c 'set ft=rmd' file.Rmd
    " then on a heading line:
    :echo synIDattr(synID(line('.'), 3, 1), 'name')

Anything other than `pandocAtxStart` / `pandocAtxHeader` means a region above is still
open.
