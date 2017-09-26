/*STATS HW5*/

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

proc boxplot data=work.education;
	by eduNum;
	plot Income2005*eduNum;
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

/*Set up and run the ANOVA */

proc anova data=work.logEdu;
	class educ;
	model logIncome = educ;
run;

/*now run it as glm to get confidence intervals and other needed data */
proc glm data=ferment;
	*Illustrate that GLM standard errors are incorrect;
	class batch process;
	model response = batch process;
	random batch /test;
	lsmeans process / stderr pdiff;
run;

proc glm data=work.logedu;
	class educ;
	model logIncome = educ;	
	lsmeans educ / stderr pdiff cl;
run;
/*CONCLUSION: At least one of the means is different based on the logged income data */


