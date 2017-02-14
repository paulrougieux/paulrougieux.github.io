#
# Generate Reports for the different forest products using brew
# 
# Inspired by 
# http://botthoughts.wordpress.com/2012/05/17/generating-reports-for-different-data-sets-using-brew-and-knitr/
# I first used brew, but then used knitr only

library(knitr)
opts_knit$set(base.dir = './docs/all_products/') # Change the base dir where to save figures

#############
# Load data #
#############
load("enddata/EU27 sawnwood demand.rdata")
load("enddata/EU27 paper products demand.rdata")
load("enddata/EU27 roundwood demand.rdata")

# A function that create aggregate reports based on the agg dataframe and template
create.report <- function(dtf, dtfagg, report.name, path="./docs/all_products/"){
    dtf <- dtf
    dtfagg <- dtfagg
    knit2html(paste0(path,"template.Rmd"),
              paste0(path, report.name, ".html"), 
              options = c(markdownHTMLOptions(defaults=TRUE), "toc")
}

create.report(roundwood, rwdagg, "rwd")
create.report(sawnwood, swdagg, "swd")
create.report(paperProducts, ppagg, "pp")                 


### Content lost, 
# See maybe in git history february 2014 or before