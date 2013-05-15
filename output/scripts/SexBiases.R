# libraries
library(MASS)

# clean
rm(list= ls()[!(ls() %in% PERSISTENT_CONSTANTS)])


# constants
WD = getwd()
PERSISTENT_CONSTANTS = c("WD", "PERSISTENT_CONSTANTS")

yNames = c("below average", "about average", "above average")
yLimit = c(0, 0.7)




setWD = tryCatch({
  # set working directory
  setwd(paste(WD, "/output", sep=""))
}, error = function(e) {})

# load data
relativeAddHealthPath = "../input/data/addhealth_pds3.RData"
load(relativeAddHealthPath)


# make subsets
rawData = addhealth_pds[c("aid", "bio_sex", "h1se4")]
names(rawData) = c("id", "sex", "relIQ")

rawData$id = as.numeric(rawData$id)
rawData$relIQ = as.numeric(rawData$relIQ)
rawData$sex = as.numeric(rawData$sex)
rawData$sexgr = as.factor(NA)
rawData$sexgr = ifelse (rawData$sex == 2, "female", rawData$sexgr)
rawData$sexgr = ifelse (rawData$sex == 1, "male", rawData$sexgr)



# filter out
filterConstraint = (rawData$relIQ <= 6 & rawData$relIQ > 0) & (rawData$sex == 1 | rawData$sex == 2)
filteredOutRawData = subset(rawData, !filterConstraint)
data = subset(rawData, filterConstraint)
women = subset(data, data$sex == 2)
men = subset(data, data$sex == 1)

# intelligence groups
data$igr = "avg"
data$igr = ifelse (data$relIQ > 3, "above", data$igr)
data$igr = ifelse (data$relIQ < 3, "below", data$igr)
data$igr = as.factor(data$igr)

women$igr = 0
women$igr = ifelse (women$relIQ > 3, +1, women$igr)
women$igr = ifelse (women$relIQ < 3, -1, women$igr)

men$igr = 0
men$igr = ifelse (men$relIQ > 3, +1, men$igr)
men$igr = ifelse (men$relIQ < 3, -1, men$igr)


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


# table = table(aboveAvgIntelligentMen, aboveAvgIntelligentWomen)
# table = table(subset, women$igr)
# head(table)
# chisq.test(table)
# w_b = dim(women[women$igr==-1,])[1]
# w_a = dim(women[women$igr!=-1,])[1] - w_b
# m_b = dim(men[men$igr==-1,])[1]
# m_a = dim(men[men$igr!=-1,])[1] - m_b
# table(x = c(1, 2, 3, 4, 5, 6), y = c(10:15))


table = table(data$igr, data$sexgr)
chisq.test(table)
# barplot(aboveAvgIntelligentPop, xlab="Opinion on oneself", ylab="Y",main="Title", sub="sub", names.arg=c("a", "B", "c"), ylim=c(0, 0.7))
# meanRelIQ = majority(data$relIQ)
#


# make plots
makePlots = function () {
  barplot(aboveAvgIntelligentPop, 
          xlab="Opinion on oneself", ylab="frequency derived from population", 
          main="Population's opinion on theirselve's intelligence", 
          sub="The population's opinion on theirselve's IQ is the weighted average between the women's and men's measurements. Theirfore these bars are about 'inbetween' the two.", 
          names.arg=yNames, ylim=yLimit, border=NA)
  
  boxplot(women$relIQ, men$relIQ, 
          main = "Female vs. male self-assessment of their own intelligence", 
          names=c("Women", "Men"), 
          xlab = "", ylab ="Their own intelligence rating: one to six", 
          sub = "The difference is hardly visible. The scale is [1, 6] with 3 meaning about average. So 1 and 2 is below and 4 thru 6 is above the average. Women and men seem not to differ when it comes to their own intelligence compared to others.")
  boxplot(women$igr, men$igr, 
          main = "Female vs. male self-assessment of their own intelligence", 
          names=c("Women", "Men"), 
          xlab = "", ylab ="Their own intelligence rating: minus one to plus one", 
          sub = "The difference is hardly visible. The scale is [-1, +1] with zero meaning about average. So minus one is below and plus one is above the average. Women and men seem not to differ when it comes to their own intelligence compared to others.")
  
}


# makePlots()
# process