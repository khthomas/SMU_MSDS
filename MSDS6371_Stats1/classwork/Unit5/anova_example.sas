filename ref "/folders/myshortcuts/SMU/MSDS6371 - Stats/Unit 5/leniency.csv";

proc import file=ref dbms=csv
	out = work.smiledata;
	getnames= yes; 
run;

data smile;
	set work.smiledata;
	if smile = 1 then smiletype = "Genuine";
	if smile = 2 then smiletype = "False";
	if smile = 3 then smiletype = "Neutral";
	if smile = 4 then smiletype = "Miserable";
run;

/*there are two procs that will run anova
proc anova and proc glm*/
proc anova data=work.smile;
	class smiletype; /*which is the factor for the study*/
	model  leniency = smiletype;
run;

proc sort data=work.smile out=sortedSmile;
	by smiletype;
run;

proc means data = work.sortedSmile 
	N
	mean 
	stddev 
	min q1 median q3 max;
	by smiletype;
	var leniency;
run;
	



/* Random Effects */

/*the @@ symbol in SAS allows SAS to keep reading on one line*/
Data Ferment;
  input Batch Process $ Response @@;
  title1 'Mason, Gunst, & Hess: Exercise 10.17';
Datalines;
1  F1  84 2  F1  79 3  F1  76 4  F1  82 5  F1  74
1  F2  83 2  F2  72 3  F2  82 4  F2  97 5  F2  76
1  F3  92 2  F3  87 3  F3  82 4  F3  84 5  F3  75
1  F4  89 2  F4  74 3  F4  80 4  F4  79 5  F4  83
;
run;


/*notes for glm shown below
The standard error is usllay in the denomitor of a test
stat, thus getting it wrong is bad. */

proc glm data=ferment;
	*Illustrate that GLM standard errors are incorrect;
	class batch process;
	model response = batch process;
	random batch /test;
	lsmeans process / stderr pdiff;
run;

/*notes for proc mixed below
random batch effects are captured*/

proc mixed data=ferment CL covtest;
*mixed has correct standard errors;
	class batch process;
	model response = process;
	random batch;
	lsmeans process / adjust=tukey pdiff;
run;














