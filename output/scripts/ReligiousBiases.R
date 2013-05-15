# clean
rm(list= ls()[!(ls() %in% PERSISTENT_CONSTANTS)])


# constants
PERSISTENT_CONSTANTS = c("WD", "PERSISTENT_CONSTANTS")
WD = getwd()



setWD = tryCatch({
  # set working directory
  setwd(paste(WD, "/output", sep=""))
}, error = function(e) {})

# load data
relativeAddHealthPath = "../input/data/addhealth_pds3.RData"
load(relativeAddHealthPath)



# filter out
rawData = addhealth_pds[c("h1re1", "h1re2", "h1re3", "h1re4", "h1re5", "h1re6", "h1re7", "h1gi6a", "h1gi6b", "h1gi6c", "h1gi6d")]
names(rawData) = c("religion", "figuresAreSacre", "attendedServices", "impOfReligion", "bornAgain", "prayingFreq", 
                   "attendedYouthActivities", "white", "african", "native", "pacific")
rm(list=c("addhealth_pds", "relativeAddHealthPath", "WD", "setWD"))

# dont-know-count
rawData$dontknowing = 0
rawData$dontknowing = ifelse (8 == rawData$figuresAreSacre, rawData$dontknowing + 1, rawData$dontknowing)
rawData$dontknowing = ifelse (8 == rawData$attendedServices, rawData$dontknowing + 1, rawData$dontknowing)
rawData$dontknowing = ifelse (8 == rawData$impOfReligion, rawData$dontknowing + 1, rawData$dontknowing)
rawData$dontknowing = ifelse (8 == rawData$prayingFreq, rawData$dontknowing + 1, rawData$dontknowing)
rawData$dontknowing = ifelse (8 == rawData$attendedYouthActivities, rawData$dontknowing + 1, rawData$dontknowing)


# replace dummy values
RELIGIONS_KEEPER = rawData$religion %in% c(0:28)
FIGURES_ARE_SACRE_KEEPER = rawData$figuresAreSacre %in% c(1:3, 7)
ATTENDED_SERVICES_KEEPER = 6 != rawData$attendedServices & 8 != rawData$attendedServices
IMP_OF_RELIGION_KEEPER = 6 != rawData$impOfReligion & 8 != rawData$impOfReligion
BORN_AGAIN_KEEPER = rawData$bornAgain %in% c(0:1, 7, 9)
PRAYING_FREQ_KEEPER = rawData$prayingFreq %in% c(1:5, 7)
ATTENDED_YOUTH_ACTIVITIES_KEEPER = rawData$attendedYouthActivities %in% c(1:4, 7)


data = subset(rawData, RELIGIONS_KEEPER & FIGURES_ARE_SACRE_KEEPER & ATTENDED_SERVICES_KEEPER & IMP_OF_RELIGION_KEEPER & 
                BORN_AGAIN_KEEPER & PRAYING_FREQ_KEEPER & ATTENDED_YOUTH_ACTIVITIES_KEEPER)



# religious groups
NO_RELIGION_KEEPER = function (dataset) {
  dataset$religion == 0
}
CHRISTIAN_RELIGION_KEEPER = function (dataset) {
  dataset$religion == 4 | dataset$religion == 5  | dataset$religion == 22
}
OTHER_RELIGION_KEEPER = function (dataset) {
  !NO_RELIGION_KEEPER(dataset) & !CHRISTIAN_RELIGION_KEEPER(dataset)
}

no = subset(data, NO_RELIGION_KEEPER(data))
christ = subset(data, CHRISTIAN_RELIGION_KEEPER(data))
other = subset(data, OTHER_RELIGION_KEEPER(data))




# eval
# lm = lm(data$attendedServices ~ data$religion + data$attendedYouthActivities + data$prayingFreq + data$figuresAreSacre)
# summary(lm)
aov = aov(data$attendedServices ~ data$attendedYouthActivities + data$prayingFreq + data$impOfReligion + data$figuresAreSacre + data$bornAgain)
summary(aov)




dontknows = subset(rawData, rawData$dontknowing > 0 & RELIGIONS_KEEPER)
rm(list=c("rawData"))

dontknows$MORE_THAN_ONE_UNCLEAR = FALSE
dontknows$MORE_THAN_ONE_UNCLEAR = ifelse (dontknows$dontknowing > 1, TRUE, dontknows$MORE_THAN_ONE_UNCLEAR)

dontknows$CHRISTIAN = "other"
dontknows$CHRISTIAN = ifelse (CHRISTIAN_RELIGION_KEEPER(dontknows), "christians", dontknows$CHRISTIAN)
dontknows$CHRISTIAN = factor(dontknows$CHRISTIAN)

table = table("didn´t knew 40%+"=dontknows$MORE_THAN_ONE_UNCLEAR, "religious Group"=dontknows$CHRISTIAN)
table

chisq.test(table)


dontknows$impOfReligionGroup = NA
dontknows$impOfReligionGroup = ifelse (1 == dontknows$impOfReligion, "1-very", dontknows$impOfReligionGroup)
dontknows$impOfReligionGroup = ifelse (2 == dontknows$impOfReligion, "2-fairly", dontknows$impOfReligionGroup)
dontknows$impOfReligionGroup = ifelse (3 == dontknows$impOfReligion | 4 == dontknows$impOfReligion, "3-not", dontknows$impOfReligionGroup)
dontknows$impOfReligionGroup = factor(dontknows$impOfReligionGroup)

table = table(dontknows$MORE_THAN_ONE_UNCLEAR, dontknows$impOfReligionGroup)
table

chisq.test(table)

# pairwise.t.test(dontknows$MORE_THAN_ONE_UNCLEAR, dontknows$impOfReligionGroup, p.adjust.method="holm")
dontknows$impOfReligionGroup = factor(dontknows$impOfReligionGroup)
taov = aov(dontknows$MORE_THAN_ONE_UNCLEAR ~ dontknows$impOfReligionGroup)
tukey = TukeyHSD(taov)
tukey

rm(list=c("taov", "table"))
#




# MULTI_RACE_FORMULA = rawData$white + rawData$african + rawData$native + rawData$pacific > 1

# multiRaces = subset(rawData, MULTI_RACE_FORMULA)
# singleRaces = subset(rawData, !MULTI_RACE_FORMULA)

