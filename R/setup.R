# RUNME.R -------------------------------------------------------------------
# The script to source when producing a model run. 


# Package Loading ---------------------------------------------------------

source('./R/setup-packages.R')

# Generate runtime and retrieve configuration metadata -------------------

meta <- list()
meta$run_id <- format(Sys.time(), '%y%m%d%H%S')
meta$runtime <- Sys.time()
meta$user <- Sys.getenv('user')
meta$config <- yaml::read_yaml('config.yaml')
meta$git.info <- gert::git_info()

# Check that wd is the same as the renv project path ---------------------
# Ensures that R scripts being ran are contained within the same subdir as 
# renv (and that essentially that the correct .Rproj and git project are open)

renv.project.path = renv::project()

if (file.path(renv.project.path)!=file.path(getwd())) {
  sprintf('The renv project path (%s) does not match the current working directory (%s). Have you opened the project correctly?',renv.project.path, getwd())
  stop()
}


# Check git for reproducible analytical pipelines (RAPs) ------------------

# Check to ensure there are no tracked modifications in the .R files recorded. 
# For a good RAP pipeline, all run files should be saved in a git commit so that
# they can easily be retrieved later.

uncommitted_r_files <- gert::git_status() %>% 
  filter(grepl('^.*.R$',file))

if (nrow(uncommitted_r_files)>0) {
  if (!(meta$config$inputs$run.params$override.git.restriction)) {
  stop("There are uncommited changes to the project's R files.
       For the sake of reproducibility, please either commit or stash these files.")
  } else {
  warning("There are uncommitted changes to the project's R files. 
However, the 'git.override.restriction' parameter has been provided.
Details of the deviations can be found in the output config file and the end of the model run.")
    
    meta$git.info$commit.deviations = as.list(gert::git_info())
} }


# Set up model-run subdirectory -------------------------------------------

# Both run_id as well as human-friendly title used under ./model-runs/
run.name = paste0(meta$run_id,'-',
                  stringr::str_replace_all(stringr::str_to_lower(meta$config$title),' ','-'))

run_path_root = file.path('model-runs',run.name)

dir.create(run_path_root, recursive = T)

#set up ./model-runs/{run.name}/ subdirectories: /inputs, /outputs and /save-point
meta$run$subdirs <- purrr::map(run_path_root,file.path,list('inputs','outputs','save-points'))[[1]]

names(meta$run$subdirs) <- c('input','output','save.point')

meta$run$subdirs <- as.list(meta$run$subdirs)

for (x in meta$run$subdirs) {
if (!dir.exists(x)) {
  dir.create(x)
}
    
}

# Original ons code, uses below variables, so for easier backward compatability
# they have been kept, should tidy up in future.

inputDir = meta$run$subdirs$input
outputDir = meta$run$subdirs$output
saveDir = meta$run$subdirs$save.point

# Retrieve inputs file paths/urls from config.yaml.
# Keep basename the same but store them under /inputs

input_files <- rrapply::rrapply(meta$config$input$urls, how = "melt") %>%
  rename(file_type = L1) %>%
  tidyr::pivot_wider(names_from = L2, values_from = value) %>%
  mutate(basename = basename(file.path(src_url))) %>%
  mutate(destfile = file.path(inputDir,basename))

# Loop and download the input files. Note: for Windows systems the mode 'wb' 
# (write binary) must be specified for xlsx files.

for (i in 1:nrow(input_files)) {
  
  download.file(url = input_files$src_url[[i]], 
                destfile = input_files$destfile[[i]],
                mode = "wb")
  }

# Keep for reference later, generally clearer to refer to file paths as a list
# Rather than a data.frame so swap it back.

input_files <- setNames(split(input_files, seq(nrow(input_files))),
                        input_files$file_type)


