###### Input parameters
#sink(file = 'run.log', append = FALSE)

source('./R/setup.R')

  # Read in PIM inputs

source("./R/PIM_inputs.R")

  # Run PIM
save.point.q = meta$config$run.params$save.points

source("./R/Run_pim.R")
if(save.point.q) save.image(file = file.path(saveDir,'1_post_Run_pim.Rdata'))

  # Write out selected data (before post-processing)

source("./R/Write_PIM_outputs.R")
if(save.point.q) save.image(file = file.path(saveDir,'2_post_Write_pim.Rdata'))
  # Unchain results and perform reclassifications

source("./R/Unchain.R")
if(save.point.q) save.image(file = file.path(saveDir,'3_post_unchain.Rdata'))
  # Aggregate

source("./R/Aggregate.R")
if(save.point.q) save.image(file = file.path(saveDir,'4_post_aggregate.Rdata'))
# Chain & ANNUALISATION

source("./R/Chain.R")
if(save.point.q) save.image(file = file.path(saveDir,'5_post_chain.Rdata'))

sink()
file.copy('run.log',file.path(outputDir,'run.log'))
file.remove('run.log')