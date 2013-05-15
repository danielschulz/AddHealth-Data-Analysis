libname mydata "/courses/u_coursera.org1/i_1006328/c_5333" access=readonly;


/* ethnics */
DATA new; set mydata.addhealth_pds;

LABEL 	h1gi6b = "African Americans"
		h1gi6c = "Native Americans"
		h1gi6d = "Asian people";


/* ignore: */
/* unknown refused (6) and unknown (8) */
IF h1gi6b NE 6 and h1gi6b NE 8;
IF h1gi6c NE 6 and h1gi6c NE 8;
IF h1gi6d NE 6 and h1gi6d NE 8;

/* refused (6), no religion (7) and unknown (8) */
IF h1re2 LT 6; /* word of God */
IF h1re3 LT 6; /* attended services */

/* only iff disagrees to sacred scriptures
IF h1re2 EQ 2;*/
/* only for African Americans */
/* African American in favor of the idea of sacrificed symbols 
IF h1gi6b EQ 1 AND h1re2 LT 3;*/

/* whole population against 
IF h1re2 LT 3;*/

/* sort by intelligence */
PROC SORT; by aid;


PROC FREQ; TABLES h1re2*h1re3 /CHISQ;

run;
