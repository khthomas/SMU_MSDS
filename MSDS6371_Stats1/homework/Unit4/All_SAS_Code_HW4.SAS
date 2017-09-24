/*HW4 Problem 2A*/
/* Get the data into SAS */
FILENAME REFFILE '/folders/myshortcuts/SMU/MSDS6371 - Stats/Unit 4/Logging.csv';
PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.IMPORT;
	GETNAMES=YES;
RUN;
/*make the data an easy name*/
data work.logging;
	set work.import;
run;

/*check assumptions of the data*/
proc univariate data=work.logging;
	class action;
	histogram PercentLost;
	qqplot  PercentLost;
run;

/*Analysis of logging data using a rank sum test*/
proc npar1way data=work.logging wilcoxon hl alpha=0.05 ;
	var PercentLost;
	class Action;
	exact wilcoxon hl /mc;
run;


/* Welch's two sample t test on Education Data from HW3 */
/*get the data*/
filename EduData '/folders/myshortcuts/SMU/MSDS6371 - Stats/Unit 3/Homework/EducationData.csv';

proc import datafile=EduData
	DBMS = CSV
	OUT = work.EduData;
	GETNAMES = Yes;
run;

proc sort data=work.edudata;
	by descending Educ;
run;

proc univariate data=work.edudata;
	class Educ;
	var income2005;
	histogram income2005;
	QQplot income2005;
run;

/* conduct the t-test */
proc ttest data=work.edudata sides=2 order=data;
	class Educ;
	var income2005;
run;

/*HW 4 Question 4B */
data work.trauma;
	input tram $ meta;
datalines;
N 20.1
N 22.9
N 18.8
N 20.9
N 20.9
N 22.7
N 21.4
N 20.0
Y 38.5
Y 25.8
Y 22.0
Y 23.0
Y 37.6
Y 30.0
Y 24.5
;
run;

proc npar1way data = work.trauma wilcoxon hl;
	var meta;
	class tram;
	exact wilcoxon hl /mc;
run;

data crit;
	critValue = quantile("T", 0.95, 14);
run;
	 

proc univariate data=work.trauma;
	class tram;
	var meta;
	histogram meta;
	QQPLOT meta;
run;

/*HW 5B */
data work.yoga;
	input child before after;
datalines;
1 85 75
2 70 50
3 40 50
4 65 40
5 80 20
6 75 65
7 55 40
8 20 25
9 70 30
run;

data work.yoga2;
	set work.yoga;
	diff = before - after;
run;

proc univariate data=work.yoga2;
	*var diff;
	histogram  Before After;
	QQPLOT  Before After;
run;

data crit;
	critValue = quantile("T", 0.95, 8);
run;

/*5D same but now with paird t test */
proc ttest data=work.yoga2;
	paired before*after;
run;



