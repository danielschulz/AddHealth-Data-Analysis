libname mydata "/courses/u_coursera.org1/i_1006328/c_5333" access=readonly;

/* INTELLIGENCE FOR MEN */
DATA new; set mydata.addhealth_pds;

LABEL 	h1se4 = "Intelligence distribution";

/* ignore: */
/* unknown sex */
IF BIO_SEX NE 6;
/* intelligence refused (96) and unknown (98) data */
IF h1se4 EQ 98 OR h1se4 EQ 96 THEN h1se4=.;


/* sort by intelligence */
PROC SORT; by h1se4;

PROC ANOVA; CLASS BIO_SEX;
MODEL h1se4=BIO_SEX;
MEANS BIO_SEX;


/* show intelligence quantiles */
PROC FREQ; TABLES h1se4 BIO_SEX;

run;

