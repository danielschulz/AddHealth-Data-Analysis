libname mydata "/courses/u_coursera.org1/i_1006328/c_5333" access=readonly;


/* INTELLIGENCE FOR WOMEN */
DATA new; set mydata.addhealth_pds;

LABEL 	h1se4 = "Intelligence distribution among women";

/* ignore: */
/* unknown sex (6) and male (1) */
IF BIO_SEX EQ 2;
/* intelligence refused (96) and unknown (98) data */
IF h1se4 EQ 98 OR h1se4 EQ 96 THEN h1se4=.;


/* make relative intelligence -1 (below), 0 (about average), +1 (high) */
relativeIntelligence = 0;
IF h1se4 LT 3 THEN relativeIntelligence = -1;
ELSE IF h1se4 GT 4 THEN relativeIntelligence = +1;
ELSE relativeIntelligence = 0;


/* sort by intelligence */
PROC SORT; by h1se4;


/* show intelligence quantiles */
PROC FREQ; TABLES h1se4 relativeIntelligence;

run;


/* INTELLIGENCE FOR MEN */
DATA new; set mydata.addhealth_pds;

LABEL 	h1se4 = "Intelligence distribution among men";

/* ignore: */
/* unknown sex (6) and female (2) */
IF BIO_SEX EQ 1;
/* intelligence refused (96) and unknown (98) data */
IF h1se4 EQ 98 OR h1se4 EQ 96 THEN h1se4=.;


/* make relative intelligence -1 (below), 0 (about average), +1 (high) */
relativeIntelligence = 0;
IF h1se4 LT 3 THEN relativeIntelligence = -1;
ELSE IF h1se4 GT 4 THEN relativeIntelligence = +1;
ELSE relativeIntelligence = 0;


/* sort by intelligence */
PROC SORT; by h1se4;


/* show intelligence quantiles */
PROC FREQ; TABLES h1se4 relativeIntelligence;

run;

