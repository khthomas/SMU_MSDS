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
	

	
