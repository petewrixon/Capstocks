# RUNME.R -------------------------------------------------------------------
# The script to source when producing a model run. 


# Package Loading ---------------------------------------------------------

source('./R/setup-packages.R')

meta <- list()
meta$run_id <- format(Sys.time(), '%y%m%d%H%S')
meta$runtime <- Sys.time()
meta$user <- Sys.getenv('user')
meta$config <- yaml::read_yaml('config.yaml')
meta$git.info <- gert::git_info()

renv.project.path = renv::project()

if (file.path(renv.project.path)!=file.path(getwd())) {
  sprintf('The renv project path (%s) does not match the current working directory (%s). Have you opened the project correctly?',renv.project.path, getwd())
  stop()
}

uncommitted_r_files <- gert::git_status() %>% 
  filter(grepl('^.*.R$',file))

if (nrow(uncommitted_r_files)>0) {
  stop("There are uncommited changes to the project's R files.
       For the sake of reproducibility, please either commit or stash these files.")
}

run.name = paste0(meta$run_id,'-',
                  stringr::str_replace_all(stringr::str_to_lower(meta$config$title),' ','-'))

run_path_root = file.path('model-runs',run.name)

dir_create(run_path_root, recursive = T)

meta$run$subdirs <- purrr::map(run_path_root,file.path,list('inputs','outputs','save-points'))[[1]]

names(meta$run$subdirs) <- c('input','output','save.point')

meta$run$subdirs <- as.list(meta$run$subdirs)

for (x in meta$run$subdirs) {
if (!dir.exists(x)) {
  dir.create(x)
}
    
}


inputDir = meta$run$subdirs$input
outputDir = meta$run$subdirs$output
saveDir = meta$run$subdirs$save.point

meta$config$input$urls$pim.inputs$basename <- basename(file.path)

input_files <- rrapply::rrapply(meta$config$input$urls, how = "melt") %>%
  rename(file_type = L1) %>%
  tidyr::pivot_wider(names_from = L2, values_from = value) %>%
  mutate(basename = basename(file.path(src_url))) %>%
  mutate(destfile = file.path(inputDir,basename))

input_files <- setNames(split(input_files, seq(nrow(input_files))),
         input_files$file_type)

for (i in 1:nrow(input_files)) {
  
  download.file(url = input_files$src_url[[i]], 
                destfile = input_files$destfile[[i]])
  }

