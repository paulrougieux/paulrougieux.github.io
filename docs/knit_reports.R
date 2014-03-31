#
# Generate Reports for the different forest products
# 
# Inspired by 
# http://botthoughts.wordpress.com/2012/05/17/generating-reports-for-different-data-sets-using-brew-and-knitr/
# I first used brew + knitr, but then used knitr only

library(knitr)
library(markdown)
opts_knit$set(base.dir = './docs/all_products/') # Change the base dir where to save figures

#############
# Load data #
#############
load("enddata/EU28 paper products.rdata")
load("enddata/EU28 sawnwood.rdata")
load("enddata/EU28 roundwood.rdata")
load("enddata//world Bank GDP defl pop")

##################
# Create reports #
##################
# A function that create reports based on the template and product endata
create.report <- function(product.data, path="./docs/all_products/"){
    knit2html(paste0(path,"template.Rmd"),
              paste0(path, product.data$metadata$title, ".html"), 
              options = c(markdownHTMLOptions(defaults=TRUE), "toc"))
}

create.report(roundwood)
create.report(sawnwood)
create.report(paperproducts)                 


##############################################
# Combined report for roundwood and sawnwood #
##############################################
# Hack! This should rather be done in the load or clean script.
rwd_swd <- list(entity = rbind(roundwood$entity,
                               sawnwood$entity),
                eu_aggregates = rbind(roundwood$eu_aggregates,
                                      sawnwood$eu_aggregates),
                
                trade = rbind(roundwood$trade, 
                              sawnwood$trade),
                metadata = list(unit = "M3", title = "Roundwood and Sawnwood"))

# Keep only total values
rwd_swd$entity <- rwd_swd$entity[grep("Total",rwd_swd$entity$Item),]
rwd_swd$eu_aggregates <- rwd_swd$eu_aggregates[grep("Total",rwd_swd$eu_aggregates$Item),]
rwd_swd$trade <- rwd_swd$trade[grep("Total",rwd_swd$trade$Item),]

create.report(rwd_swd)



##############################################################
# Combined report for roundwood, sawnwood and paper products #
##############################################################
# Volumes have to be converted in volume equivalent roundwood

