sink()

if (exists("outputDir")) {
  file.copy(run.log.tmp.path, file.path(outputDir,"pim-run.log"))
} else {
  file.copy(run.log.tmp.path, file.path(getwd(),"pim-run.log"), overwrite = TRUE)
}

file.remove(run.log.tmp.path)