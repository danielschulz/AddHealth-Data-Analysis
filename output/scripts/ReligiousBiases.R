# clean
rm(list=ls())

setWD = tryCatch({
  # set working directory
  setwd(paste(getwd(), "/output", sep=""))
}, error = function(e) {})

# load data
relativeAddHealthPath = "../input/data/addhealth_pds3.RData"
load(relativeAddHealthPath)
