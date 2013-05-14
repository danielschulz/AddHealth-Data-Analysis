# clean
rm(list= ls()[!(ls() %in% PERSISTENT_CONSTANTS)])


# constants
WD = getwd()
PERSISTENT_CONSTANTS = c("WD", "PERSISTENT_CONSTANTS")


setWD = tryCatch({
  # set working directory
  setwd(paste(WD, "/output", sep=""))
}, error = function(e) {})

# load data
relativeAddHealthPath = "../input/data/addhealth_pds3.RData"
load(relativeAddHealthPath)
