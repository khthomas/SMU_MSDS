/*Homework 11 Code*/


/*Import data*/

filename ref1 "/folders/myshortcuts/SMU/MSDS6371 - Stats/Unit11/Metabolism_Data_Prob_26.csv";

proc import datafile=ref1 dbms=csv out=work.meta;
	getnames=yes;
run;


filename ref2 "/folders/myshortcuts/SMU/MSDS6371 - Stats/Unit11/Autism_Data_Prob_29.csv";

proc import datafile=ref2 dbms=csv out=work.autism;
	getnames=yes;
run;

/*Question 1 -- Metabolism Data*/

proc reg data=work.meta;
	model metab = mass / cli clm r;
run;

/*based on the above it seems like the data needs to be transformed*/

data work.meta_trans;
	set work.meta;
	logmass = log(Mass);
	logmetab = log(Metab);
run;

/*First run the same regression with only the x transformed. If it is still bad
run the regression with both transformations. Will need to look at Async notes to determine 
how to interprete the data*/

proc reg data=work.meta_trans;
	model logmetab = mass / cli clm r;
run;


/*now run with log mass and no transformation on metabolism*/

proc reg data=work.meta_trans;
	model metab = logmass / cli clm r;
run;

/*finally run a log log model (gross)*/
title "Regression of Log Metabolism vs Log Mass";
proc reg data=work.meta_trans;
	model logmetab = logmass / cli clm r;
run;

/*the log log model has the best residual plot and meets the requirements of the linear
regression model. I will have to use this to make accurate predicitons... interpretation is
difficult*/



/*Question 2 -- Autism data */
data work.logAutism;
	set work.autism;
	logYear = log(year);
	logPrev = log(Prevalence);
run;

title "Autism Rate vs Year No Logs";
proc reg data=work.autism;
	model prevalence = year / cli clm r;
run;

title "Autism Rate vs Year Log Rates Only";
proc reg data=work.logAutism;
	model logPrev = year / cli clm r;
run;

title "Autism Rate vs Year Log Year Only";
proc reg data=work.logAutism;
	model prevalence = logYear / cli clm r;
run;

title "Autism Rate vs Year Log Both";
proc reg data=work.logAutism;
	model logPrev = logYear / cli clm r;
run;





