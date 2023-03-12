###### Input parameters
sink('runlog.txt', append = FALSE)
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
#pete
library(arrow)

# Timestamp

runTime <- format(Sys.time(), "%Y-%m-%d_%H%M") # Used in various file out names

save_point_dir <- sprintf('./save-points/%s',runTime)

outputs_dir <- sprintf('./outputs/%s',runTime)

outputDir = outputs_dir

if (!(dir.exists(outputs_dir))) {
  dir.create(outputs_dir, recursive = TRUE)}

if(!(dir.exists(save_point_dir))){
  dir.create(save_point_dir, recursive = TRUE)}

# Run sequential R scripts

  # Read in PIM inputs

source("./PIM_inputs.R")

  # Run PIM

source("./Run_pim.R")
save.image(file = file.path('./save-points',runTime,'1_aft_Run_pim.Rdata'))

  # Write out selected data (before post-processing)

source("./Write_PIM_outputs.R")
save.image(file = file.path('./save-points',runTime,'/2_aft_Write_pim.Rdata'))
  # Unchain results and perform reclassifications

source("./Unchain.R")
save.image(file = file.path('./save-points',runTime,'/3_aft_unchain.Rdata'))
  # Aggregate

source("./Aggregate.R")
save.image(file = file.path('./save-points',runTime,'/4_aft_aggregate.Rdata'))
# Chain & ANNUALISATION

source("./Chain.R")
save.image(file = file.path('./save-points',runTime,'/5_aft_chain.Rdata'))

sink()