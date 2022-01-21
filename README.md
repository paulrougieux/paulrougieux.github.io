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
