libname mydata "/courses/u_coursera.org1/i_1006328/c_5333" access=readonly;


/* INTELLIGENCE FOR WOMEN */
DATA new; set mydata.addhealth_pds;

LABEL 	h1se4 = "Intelligence distribution among women";

/* ignore: */
/* unknown sex (6) and male (1) */
IF BIO_SEX EQ 2;
/* intelligence refused (96) and unknown (98) data */
IF h1se4 EQ 98 OR h1se4 EQ 96 THEN h1se4=.;


/* sort by intelligence */
PROC SORT; by h1se4;


/* show intelligence quantiles */
PROC FREQ; TABLES h1se4;

run;


/* INTELLIGENCE FOR MEN */
DATA new; set mydata.addhealth_pds;

LABEL 	h1se4 = "Intelligence distribution among men";

/* ignore: */
/* unknown sex (6) and female (2) */
IF BIO_SEX EQ 1;
/* intelligence refused (96) and unknown (98) data */
IF h1se4 EQ 98 OR h1se4 EQ 96 THEN h1se4=.;


/* sort by intelligence */
PROC SORT; by h1se4;


/* show intelligence quantiles */
PROC FREQ; TABLES h1se4;

run;

