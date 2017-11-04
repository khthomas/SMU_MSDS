/*Unit 10 Homework*/

/*Question 1*/

filename ref1 "/folders/myshortcuts/SMU/MSDS6371 - Stats/Unit10/Male_Display_Data_Set.csv";

proc import datafile=ref1 dbms=csv out=work.birds;
	getnames=yes;
run;

title "Black-eared Wheater T-cell Count vs Mass";
proc reg data=work.birds;
	model tcell = mass / r cli clm;
run;
title;

proc print data=work.birds; run;

/*Find Critical Value*/
data work.critvalue;
	critVal = quantile("T", 0.975, 19); /*distribution, area, degree of freedom*/
run;

/*Get confidnece intervals at 95% confidence*/

proc glm data=work.birds;
	model tcell = mass / solution clm;
run;

data work.birds2;
	set work.birds end=eof;
	output;
	if eof then do;
		mass = 4.5;
		tcell = .;
		output;
	end;
run;

proc reg data=work.birds2;
	model tcell = mass / clm;
run;

proc reg data=work.birds2;
	model tcell = mass / cli;
run;

/*Residual Plot*/
proc reg data=work.birds2;
	model tcell = mass;
	plot residual.;
	plot quantile.;
run;








