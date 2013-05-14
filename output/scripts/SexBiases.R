# libraries
library(MASS)

# clean
rm(list=ls())

setWD = tryCatch({
  # set working directory
  setwd(paste(getwd(), "/output", sep=""))
}, error = function(e) {})

# load data
relativeAddHealthPath = "../input/data/addhealth_pds3.RData"
load(relativeAddHealthPath)


# get 95% ranges
majority = function (list)
  c(1, 6)


# make subsets
rawData = addhealth_pds[c("aid", "bio_sex", "h1se4")]
names(rawData) = c("id", "sex", "relIQ")

rawData$id <- as.numeric(rawData$id)
rawData$relIQ <- as.numeric(rawData$relIQ)
rawData$sex <- as.numeric(rawData$sex)



# filter out
filterConstraint = (rawData$relIQ <= 6 & rawData$relIQ > 0) & (rawData$sex == 1 | rawData$sex == 2)
filteredOutRawData = subset(rawData, !filterConstraint)
data = subset(rawData, filterConstraint)
women = subset(data, data$sex == 2)
men = subset(data, data$sex == 1)


hist(data$relIQ)
hist(women$relIQ)
hist(men$relIQ)
summary(aov(data$relIQ ~ data$sex))
mean = mean(data$relIQ)
sd = sd(data$relIQ)

# rel. dist. intelligence in population
aboveAvgIntelligentPop =   c(length(subset(data$relIQ, data$relIQ < 3)), 
                             length(subset(data$relIQ, data$relIQ == 3)),
                             length(subset(data$relIQ, data$relIQ > 3)))
aboveAvgIntelligentPop = aboveAvgIntelligentPop / sum(aboveAvgIntelligentPop)

# rel. dist. intelligence among women
aboveAvgIntelligentWomen = c(length(subset(women$relIQ, women$relIQ < 3)), 
                             length(subset(women$relIQ, women$relIQ == 3)),
                             length(subset(women$relIQ, women$relIQ > 3)))
aboveAvgIntelligentWomen = aboveAvgIntelligentWomen / sum(aboveAvgIntelligentWomen)

# rel. dist. intelligence among men
aboveAvgIntelligentMen =   c(length(subset(men$relIQ, men$relIQ < 3)), 
                             length(subset(men$relIQ, men$relIQ == 3)),
                             length(subset(men$relIQ, men$relIQ > 3)))
aboveAvgIntelligentMen = aboveAvgIntelligentMen / sum(aboveAvgIntelligentMen)




# meanRelIQ = majority(data$relIQ)
#

# process