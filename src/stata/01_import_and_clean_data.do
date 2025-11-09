*****************************************************
* 01_import_and_clean_data.do

* This .do file imports the dataset diamonds.csv and creates a filtered and clean dataset*

* - Remove unnamed columns
* - Conversion of the strings into numeric variables
* - Cleaning the dataset from potential unreasonable values
* - Data manipulation and transformation
* - Filtering data
* - Changing names of the variables
* - Check of the variables after the commands to clean the dataset
* - Saving the new dataset

*****************************************************
version 16.0
clear
set more off

* Import CSV file in the directory of the project


import delimited "$raw/diamonds.csv", clear varnames(1) stringcols(_all)

*****************************************************

* Removing unnamed columns

* Recolling all the names of the variables without displaying them
quietly ds

* Creation of a local macro that contains all the variables
local allvariables `r(varlist)'

* creation of a cycle to browse in the local macro the different varibales, creates a local macro in with all the varibale names are transformed in lower case letters to mitigate case sensitive problems, reports a text to specify with variable is going to drop
foreach v of local allvariables{
	local lv = lower("`v'")
	if strpos("`lv'", "v1") {
		display as txt "Removing unneccessary column: `v'"
		drop `v'
	}
	
}

*****************************************************

* Conversion of the string imported values into numeric ones

* Previously, the datased was imported with the conversion of all the values into string to mitigate potential errors, now with the function destring we transform the string values into numeric values. Ingore() was used to mitigate problems with potential missing values

capture destring price carat depth table x y z, replace ignore("")

*****************************************************

* Cleaning the dataset from potential unreasonable values

* Creation of missing values for the numeric values in the variable price, carat and x,y,z (the dimensions) that are negative and so non reasonable, through a cycle

foreach c in price carat x y z {
	capture confirm varibale `c'
	if !_rc {
		replace `c' = . if `c' <=0
	}
}

* Check for missing values

misstable summarize

*****************************************************
* Data manipulation and transformation

* creation of two new variables the log of the price and the price per carat

gen log_price = ln(price)

gen price_per_carat = price/carat

*****************************************************
* Filtering data

* Creation of a dataset that contains only the diamonds with a carat that is bigger than 0.4 and smaller than 3

keep if inrange(carat, 0.4, 3)

* Sorting the dataset by carat

sort carat

*****************************************************
* Changing the name of some variables

* Change of the name of the variable depth, x, y, z, that are the dimension of the diamond to make the dataset more readable

rename depth depth_percentage
rename x length
rename y width
rename z depth

*****************************************************
* Check of the variable after the commands to clean the dataset

summarize
browse

*****************************************************
* Saving the new dataset in the directory processed in data directory

export delimited using "$clean/diamonds_clean_dataset.csv", replace
save "$clean/diamonds_clean_dataset.dta", replace