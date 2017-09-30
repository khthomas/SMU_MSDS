/*STATS HW5*/
/*I used the data from the Sleuth3 R library and exported the data*/
filename ref "/folders/myshortcuts/SMU/MSDS6371 - Stats/Unit 5/ex0525.csv";

proc import file=ref dbms=csv out=work.hw5;
	getnames=yes;
run;

/*set up data, both numerical and categorical labels*/
data work.education;
	set work.hw5;
	if educ = "<<12" then eduYears = "less than twelve";
	if educ = "<12" then eduYears = "tweleve";
	if educ = "13-15" then  eduYears = "13 to 15";
	if educ = "16" then eduYears = "sixteen";
	if educ = ">16" then eduYears = "more than 16";
	if educ = "<<12" then eduNum = 1;
	if educ = "<12" then eduNum = 2;
	if educ = "13-15" then  eduNum = 3;
	if educ = "16" then eduNum = 4;
	if educ = ">16" then eduNum = 5;
run;

/*log transform the data*/
data work.logEdu;
	set work.education;
	logIncome = log(Income2005);
run;

/*Exploritory data analysis on original data*/

/*Notes:
Data is very unnormal and heavily skewed at times*/
proc univariate data=work.education;
	class educ;
	var  Income2005;
	histogram Income2005;
	QQPLOT Income2005;
run;

proc sort data=work.education; by eduNum Income2005; run;

/* proc boxplot data=work.education; */
/* 	by eduNum; */
/* 	plot Income2005*eduNum; */
/* run; */

proc sgplot data=work.education;
	title "Disribution of Income by Educational Attainment";
	vbox Income2005 / group=Educ;
	yaxis label="Income ($)";
	format Income2005 dollar6.0;
run;




/*Exploritory data analysis on transformed data data*/
/*Notes:
	The transformation helps the normality assumption quite a deal*/
proc univariate data=work.logEdu;
	class educ;
	var  logIncome;
	histogram logIncome;
	QQPLOT logIncome;
run;

proc sort data=work.logEdu; by eduNum logIncome; run;

proc boxplot data=work.logEdu;
	by eduNum;
	plot logIncome*eduNum;
run;

proc sgplot data=work.logedu;
	title "Disribution of Log Income by Educational Attainment";
	vbox logIncome / group=Educ;
	yaxis label="Log Income ($)";
	*format logIncome dollar6.0;
run;


/*Set up and run the ANOVA and GLM */

proc anova data=work.logEdu;
	class educ;
	model logIncome = educ;
run;


proc glm data=work.logedu;
	class educ;
	model logIncome = educ;	
	lsmeans educ / stderr pdiff cl;
run;
/*CONCLUSION: At least one of the means is different based on the logged income data */

/* ~~~~~~~~~~~~~ BYOA -- Build Your Own Anova -- HW Question 2 ~~~~~~~~~~~~~~~~~~~~~~*/
/* data work.byoa; */
/* 	set work.logedu; */
/* 	if educ = "16" or educ = ">16"; */
/* run; */
/*  */
/* data work.byoa2; */
/* 	set work.logEdu; */
/* 	if(educ ne "16") & (educ ne ">16") then delete; */
/* run; */

proc sort data=work.logedu out=logSort; by educ; run;

data critVAl;
	crit = quantile("T", 0.975, 2579);
run;

proc ttest data=work.logsort;
	class educ;
	var logIncome;
run;

proc glm data=work.logsort order=data;
	class educ;
	model logIncome = educ;	
	estimate 'Estimate of BYOA' educ 0 0 1 0 -1;
run; 




/*~~~~~Question 3 - Kruskal Wallace test - non parametric ANOVA ~~~~~~~~~~~~*/
/*Is non-equal standard deviation messing things up? Lets find out.*/

/* first lets do a regular anova and see what happens */
proc glm data=work.logedu;
	class educ;
	model logincome = educ;
	means educ / hovtest=bf;
run;

/* Now run a non parametric test and see what happens */
proc npar1way data=work.logedu wilcoxon;
	class educ;
	var logincome;
run;

proc anova data=work.logedu;
	class educ;
	model logincome = educ;
	means educ / welch;
run;



/* Conclusion: */
/* There is no difference in the p-value between the normal ANOVA and the non-parametric test.  */
/* The conclusion remains the same. */
/* This is rather unsurprsing as the data passed earlier when the assumptions were met with the */
/* transformed data */













