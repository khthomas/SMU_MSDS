/*Unit 6 Async Example */

filename ref "/folders/myshortcuts/SMU/MSDS6371 - Stats/Unit 5/leniency.csv";

proc import file=ref dbms=csv
	out = work.smiledata;
	getnames= yes; 
run;

data smile;
	set work.smiledata;
	if smile = 1 then smiletype = "Genuine";
	if smile = 2 then smiletype = "False";
	if smile = 3 then smiletype = "Miserable";
	if smile = 4 then smiletype = "Neutral";
run;

/*EDA*/

proc univariate data=smile;
	var leniency;
	class smiletype;
	histogram leniency;
	qqplot leniency;
run;

proc glm data=smile;
	class smiletype;
	model leniency=smiletype;
run;

/*Which group is different? */
/*post hoc tests*/
proc glm data=smile;
	class smiletype;
	model leniency=smiletype;
	means smiletype / bon tukey regwq; /*these are the post hoc tests*/
run;