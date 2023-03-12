###### Input parameters
sink('runlog.txt', append = FALSE)
  # Specify input directory

# Run sequential R scripts

  # Read in PIM inputs

source("./R/PIM_inputs.R")

  # Run PIM
save.point.q = meta$config$run.params$save.points

source("./R/Run_pim.R")
if(save.point.q) save.image(file = file.path('./save-points',runTime,'1_aft_Run_pim.Rdata'))

  # Write out selected data (before post-processing)

source("./R/Write_PIM_outputs.R")
if(save.point.q) save.image(file = file.path('./save-points',runTime,'/2_aft_Write_pim.Rdata'))
  # Unchain results and perform reclassifications

source("./R/Unchain.R")
if(save.point.q) save.image(file = file.path('./save-points',runTime,'/3_aft_unchain.Rdata'))
  # Aggregate

source("./R/Aggregate.R")
if(save.point.q) save.image(file = file.path('./save-points',runTime,'/4_aft_aggregate.Rdata'))
# Chain & ANNUALISATION

source("./R/Chain.R")
if(save.point.q) save.image(file = file.path('./save-points',runTime,'/5_aft_chain.Rdata'))

sink()