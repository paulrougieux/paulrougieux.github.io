This repository contains useful tools and data related to my work on forest products.

Content is listed in a menu generated from [_site.yml](_site.yml).

The site is built with [rmarkdown websites](http://rmarkdown.rstudio.com/rmarkdown_websites.html), using the R command:

    rmarkdown::render_site()
    
Use `CTRL+SHIFT+B` to build the site in RStudio.

This shell command can also be used:

    cd ~/rp/paulrougieux.github.io && Rscript -e "rmarkdown::render_site()"

Or simply use the `makefile`

    make

To build the site on gitlab CI's pages, I specify the build instructions in
`gitlab-ci.yml`. The site then becomes visible at 
https://paulrougieux.gitlab.io/paulrougieux/

For the gitub version, I build the site locally on my laptop and simply use git to
upload all html files to github. The site then becomes visible at paulrougieux.github.io/
