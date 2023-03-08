###### Input parameters
sink('runlog.txt')
  # Specify input directory

inputDir <- "~/Projects/r-projects/capital-stock-forecasts/inputs"

# Specify location of R scripts

scriptsPath <- "~/Projects/r-projects/capital-stock-forecasts"

# Specify library path

libraryPath <- ""

###### End of input parameters

# Ensure wd in correct format

if (substr(scriptsPath,nchar(scriptsPath),nchar(scriptsPath))!="/"){

  scriptsPath <- paste0(scriptsPath,"/")

}

setwd(scriptsPath)

# Set library path if specified

if (libraryPath!=""){

  .libPaths(libraryPath)

}

# Read in libraries

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

# Timestamp

runTime <- format(Sys.time(), "%Y-%m-%d_%H%M") # Used in various file out names

if (!(dir.exists('./save-points'))) {
  dir.create(sprintf('./save-points/%s',runTime), recursive = TRUE)
} else{
  dir.create(sprintf('./save-points/%s',runTime), recursive = FALSE)
}

save_point_dir <- sprintf('./save-points/%s',runTime)

# Run sequential R scripts

  # Read in PIM inputs

source("./PIM_inputs.R")

  # Run PIM

source("./Run_pim.R")
save.image(file = paste0(runTime,'/1_aft_Run_pim.R'))

  # Write out selected data (before post-processing)

source("./Write_PIM_outputs.R")
save.image(file = paste0(runTime,'/2_aft_Write_pim.R'))
  # Unchain results and perform reclassifications

source("./Unchain.R")
save.image(file = paste0(runTime,'/3_aft_unchain.R'))
  # Aggregate

source("./Aggregate.R")
save.image(file = paste0(runTime,'/4_aft_aggregate.R'))
# Chain & ANNUALISATION

source("./Chain.R")
save.image(file = paste0(runTime,'/5_aft_chain.R'))

sink()