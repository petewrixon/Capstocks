
# RUNME-saves-external-run-log.R ------------------------------------------

RUNME.R <- parse("./R/RUNME.R")

###### Input parameters
run.log.tmp.path <- file.path(tempdir(), 'pim-run-tmp.log')

log.init.time <- Sys.time()

elapse_time <- function(ti = log.init.time) format(x = Sys.time(),"%H:%M:%S")

log.start <- sprintf("%s: SOURCE RUNME.R SAVING EXTERNAl LOG\n%s: %s\n WD: %s", elapse_time(),elapse_time(),elapse_time(), renv::project())

writeLines(log.start, con = run.log.tmp.path)

sink(file = run.log.tmp.path, append = FALSE)

end.of.log.code <- "./R/sink-end-of-code.R"

tryCatch(
  source('./R/RUNME.R', echo = TRUE),
  finally = source(end.of.log.code, echo = TRUE)
)
