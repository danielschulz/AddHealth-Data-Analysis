# rm(list=ls())
# load("D:\\My Documents\\Downloads\\addhealth_pds3.RData")
intelligence <- addhealth_pds$h1se4
sex <- addhealth_pds$bio_sex

# religion
religion <- addhealth_pds$h1re1
sacredScriptures <- addhealth_pds$h1re2
attendedServices <- addhealth_pds$h1re3
importanceOfReligion <- addhealth_pds$h1re4
bornAgainChrist <- addhealth_pds$h1re5
freqPraying <- addhealth_pds$h1re6
attendedExtraServices <- addhealth_pds$h1re7

# ethnic
africanAmerican <- addhealth_pds$h1gi6b
nativeAmerican <- addhealth_pds$h1gi6c
asianOrIslander <- addhealth_pds$h1gi6d


# process
unique(africanAmerican)
unique(nativeAmerican)
unique(asianOrIslander)

formula <- attendedServices ~ religion + sacredScriptures + importanceOfReligion + freqPraying + attendedExtraServices
lm <- lm(formula, data = addhealth_pds)
aov <- aov(formula)
summary(aov)
