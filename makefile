# Usage:
# make        # Generate all pages in the website 

all: install_tidyverse install_reticulate render

install_tidyverse:
	Rscript -e "if (!require('tidyverse')) {install.packages('tidyverse')}"

install_reticulate:
	Rscript -e "if (!require('reticulate')) {install.packages('reticulate')}"

render:
	Rscript -e "rmarkdown::render_site()"
