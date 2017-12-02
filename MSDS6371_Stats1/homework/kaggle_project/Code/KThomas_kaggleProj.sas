/*basic setup*/
filename ref1 "/folders/myshortcuts/SMU/SMU_MSDS/MSDS6371_Stats1/homework/kaggle_project/Data/train.csv";
filename ref2 "/folders/myshortcuts/SMU/SMU_MSDS/MSDS6371_Stats1/homework/kaggle_project/Data/test.csv";

proc import datafile=ref1 dbms=csv out=work.train;
	getnames=yes;
run;

proc import datafile=ref2 dbms=csv out=work.test;
	getnames=yes;
run;

/*set up from Bivin's Video*/ 
data work.test;
	set work.test;
	SalePrice = .;
run;

data work.train2;
	set train test;
run;


/*#############################################example model#########################################################*/
/*Note that SAS will make a prediction if there is no data*/
proc glm data = train2 plots = all;
class RoofStyle RoofMatl  Exterior1st Exterior2nd MasVnrType;
model SalePrice = RoofStyle RoofMatl Exterior1st Exterior2nd MasVnrType LotArea  BedroomAbvGr YearBuilt /cli solution;
output out = results p = predict;
run;

/*set up the data that should be exported for Kaggle*/
data work.results2;
	set work.results;
	if predict > 0 then SalePrice = Predict;
	if predict < 0 then SalePrice = 10000;
	keep id SalePrice;
	where id > 1460;
run;


/*#################################################Actual Analysis##########################################################*/

/*Question 1*/
data work.quest1;
	set work.train;
	if Neighborhood in ("NAmes", "BrkSide", "Edwards");
	sqft100 = GrLivArea/100;
run;

/*build a model based off of sqft100 and Neighborhood variables*/
proc glm data=work.quest1 plots=all;
	class Neighborhood;
	model SalePrice = sqft100 Neighborhood / cli clm solution;
run;

/*Based on this analysis it seems as if the neighborhood matters. There are some variables that are outliers
that had a very high sale price and have a lot of leverage on the model. Most of the other assumptions seem fine. */



/*Question 2 -- Kaggle Model*/

/*Goal is to make the most predictive model (i.e. explaniation does not matter). Need to have
1. Forward Selection Model
2. Backward Selection Model
3. Stepwise Selection Model
4. And a custom build

Genreate adjust R2, CV Press and Kaggle Score for each model and define which model is best and why
*/

/*Macro Variables to reference in the model*/
%let allvars =  
_1stFlrSF _2ndFlrSF _3SsnPorch Alley BedroomAbvGr BldgType BsmtCond BsmtExposure BsmtFinSF1 
BsmtFinSF2 BsmtFinType1 BsmtFinType2 BsmtFullBath BsmtHalfBath BsmtQual BsmtUnfSF CentralAir 
Condition1 Condition2 Electrical EnclosedPorch ExterCond Exterior1st Exterior2nd ExterQual 
Fence FireplaceQu Fireplaces Foundation FullBath Functional GarageArea GarageCars GarageCond 
GarageFinish GarageQual GarageType GarageYrBlt GrLivArea HalfBath Heating HeatingQC HouseStyle 
KitchenAbvGr KitchenQual LandContour LandSlope LotArea LotConfig LotFrontage 
LotShape LowQualFinSF MasVnrArea MasVnrType MiscFeature MiscVal MoSold MSSubClass 
MSZoning Neighborhood OpenPorchSF OverallCond OverallQual PavedDrive PoolArea PoolQC 
RoofMatl RoofStyle SaleCondition SaleType ScreenPorch Street TotalBsmtSF TotRmsAbvGrd 
Utilities WoodDeckSF YearBuilt YearRemodAdd YrSold;

%let classvars = 
Alley BldgType BsmtCond BsmtExposure BsmtFinType1 BsmtFinType2 BsmtQual CentralAir Condition1 
Condition2 Electrical ExterCond Exterior1st Exterior2nd ExterQual Fence FireplaceQu Foundation 
Functional GarageCond GarageFinish GarageQual GarageType Heating HeatingQC HouseStyle KitchenQual 
LandContour LandSlope LotConfig LotShape MasVnrType MiscFeature MSZoning Neighborhood 
PavedDrive PoolQC RoofMatl RoofStyle SaleCondition SaleType Street Utilities;

/*Notes on selection process


*/


/*######################Forward Selection Model####################*/
proc glmselect data=work.train2;
	class &classvars;
	model SalePrice = &allvars / selection=Forward(stop=CV) cvmethod=random(5) stats= adjrsq;
	output out=work.forwardselect p = predict;
run;

/*Run the model created by the forward selection process*/
proc glm plots=all;
	Class BsmtQual Neighborhood;
	model SalePrice = OverallQual GrLivArea Neighborhood BsmtQual / cli clm solution;
run;

/*###################Backward Selection########################*/
proc glmselect data=work.train3;
	class &classvars;
	model SalePrice = &allvars / selection=Backward(stop=CV) cvmethod=random(5) stats= adjrsq;
	output out=work.backwardselect p = predictf;
run;

/*Run the selected model created by the backward selection process*/

/*lot frontage has NA data... these need to be replaced*/
data train3;
	set work.train2;
	select (LotFrontage);
		when ("NA") LotFrontage = .;
	otherwise;
	end;
	new = input(LotFrontage, 2.);
	drop LotFrontage;
	rename new=LotFrontage;
run;

/*run the model*/
proc glm data=work.train3 plots=all;
	class Utilities Exterior2nd Exterior1st HouseStyle GarageType;
	model SalePrice = Utilities TotalBsmtSF LowQualFinSF Exterior2nd Exterior1st HouseStyle GarageType / cli clm solution;
	output out=work.backwardselect p=predictb;
run;

/*##########################Stepwise Selection##################*/
proc glmselect data=work.train2;
	class &classvars;
	model SalePrice = &allvars / selection=Stepwise(stop=CV) cvmethod=random(5) stats= adjrsq;
	output out=work.stepwise p = predict;
run;


/*Make a model off what I think is important in a house (4. Custom Build)*/
proc glm data= work.train2 plots=all;
	class  BldgType CentralAir Foundation GarageType HouseStyle KitchenQual Neighborhood;
	model SalePrice = BldgType Foundation GarageType HouseStyle KitchenQual Neighborhood
					   GarageCars LotArea OverallCond OverallQual OverallCond OverallQual
					    _1stFlrSF _2ndFlrSF GrLivArea/ cli solution;
	output out = results p = predict;
run;

proc glm data=work.train3 plots=all;
	class BldgType Utilities HouseStyle Neighborhood BsmtQual;
	model SalePrice = OverallQual GrLivArea Neighborhood BsmtQual Utilities HouseStyle OverallQual GarageCars GrLivArea / CLI CLM solution;
run;

proc means data=work.results;
	where SalePrice > 0;
run;

data work.my_first_sub;
	set work.results;
	if predict > 0 then SalePrice = Predict;
	if predict < 0 then SalePrice = 180921.20;
	keep id SalePrice;
	where id > 1460;
run;

/*Make datasets to submit to Kaggle*/
data work.forwardStep;
	set work.forwardselect;
	if predict > 0 then SalePrice = Predict;
	if predict < 0 then SalePrice = 180921.20;
	keep id SalePrice;
	where id > 1460;
run;

data work.backward;
	set work.backwardselect;
	if predict > 0 then SalePrice = Predict;
	if predict < 0 then SalePrice = 180921.20;
	keep id SalePrice;
	where id > 1460;
run;

data work.custom;
	set work.





















