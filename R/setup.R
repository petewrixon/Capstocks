# RUNME.R -------------------------------------------------------------------
# The script to source when producing a model run. 

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

uncommitted_r_files <- gert::git_status %>% 
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

for (url in unlist(meta$config$input$urls)) {
  download.file(url, destfile = file.path(inputDir,basename(file.path(url))))
}
curl::curl(url = url)
