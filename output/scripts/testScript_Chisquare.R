# clean
rm(list=ls())

library(MASS)       # load the MASS package 
tbl = table(survey$Smoke, survey$Exer) 
tbl                 # the contingency table 

# chisquare
chisq.test(tbl)

ctbl = cbind(tbl[,"Freq"], tbl[,"None"] + tbl[,"Some"]) 
ctbl

chisq.test(ctbl) 