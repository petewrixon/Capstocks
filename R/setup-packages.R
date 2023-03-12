renv_status <- renv::status()

if (!(renv_status$synchronized)) {
  renv::restore()
}

# CRAN packages
# iii
library(dplyr)
library(readr)
library(readxl)
library(testthat)
library(tibble)
library(tidyr)
library(tempdisagg)
# Capstock packages
library(capstock)
library(pimIO)
library(prepim)
# Packages for Forecasting
library(forecast)
library(stringr)
# SQL
library(sqldf)
library(cellranger)
library(RSQLite)
##
library(writexl)
library(futile.logger)
library(doSNOW)
library(assertr)
library(tempdisagg)
library(purrrlyr)
library(data.table)
library(forcats)
# Data Export packages
library(arrow)

library(capstock, pimir)









