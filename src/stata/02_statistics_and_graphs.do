*****************************************************
* 02_statistics_and_graphs.do

* - Loading the clean dataset
* - Computation of descriptive statistics
* - Creation of a table that summarize statistics by group (cut)
* - Computation of the correlation
* - Plotting graphs

*****************************************************
version 16.0
clear
set more off

*****************************************************
* Loading the clean dataset

capture confirm file "$clean/diamonds_clean_dataset.dta"
use "$clean/diamonds_clean_dataset.dta", clear

*****************************************************
* Computation of summary descriptive statistics

summarize price carat log_price price_per_carat

* Creation of the table with the summary statistics for the varibale price, carat, log_price, price_per_carat

tabstat price carat log_price price_per_carat, statistics(n mean sd min p25 p50 p75 max) columns(statistics) save

* Creation of a temporary file name and save it in the local macro

tempfile summarylog

* Creation of a temporary log to create the table that will be saved in the temporary macro

capture log close summary
log using "`summarylog'", name(summary) text replace
	tabstat price carat log_price price_per_carat, statistics(n mean sd min p25 p50 p75 max) columns(statistics)
log close summary
copy "`summarylog'" "$tables\summary_statistics_tabstat.txt", replace

* The table has been saved in the tables directory

*****************************************************
* Creation of a table that summarize statistics by group (cut)

* By preserving the current dataset, creation of new variables for the mean and the sd of price and carat, grouping them by cut

preserve
    bysort cut: egen mean_price_cut = mean(price)
    bysort cut: egen sd_price_cut   = sd(price)
    bysort cut: egen mean_carat_cut = mean(carat)
    bysort cut: egen sd_carat_cut   = sd(carat)

* Creation of a single line for each cut and mantaining the columns that are needed for the table and sorting all by cut	

    egen tag_cut = tag(cut)                  
    keep if tag_cut==1
    keep cut mean_price_cut sd_price_cut mean_carat_cut sd_carat_cut
    sort cut

 * Check if the variable is a string, if so, it will copy the variable cut in a new string variable called group
 
    capture confirm string variable cut
    if !_rc {
        gen str20 group = cut
    }

	* In other case if cut is numerical it will create a new variable called group and convert the labels in strings	

    else {
        decode cut, gen(group)
    }
    drop cut
    order group mean_price_cut sd_price_cut mean_carat_cut sd_carat_cut

* Creation of a temporary local file and save the table in it, then restore the initial dataset
	
    tempfile bycut
    save "`bycut'", replace
restore

* 2) Creation of a new row for the table that will compute the complessive mean and standard deviation for each variable previusly defined for the table

preserve
    egen _mean_price_total = mean(price)
    egen _sd_price_total   = sd(price)
    egen _mean_carat_total = mean(carat)
    egen _sd_carat_total   = sd(carat)

* Creation of the variable group with fixed value as "TOTAL", keeping only the columns of the total values and renaming the temporary columns to align them to the columns of the table, and keeping only the first row

    gen str20 group = "TOTAL"
    keep group _mean_price_total _sd_price_total _mean_carat_total _sd_carat_total
    rename (_mean_price_total _sd_price_total _mean_carat_total _sd_carat_total) ///
           (mean_price_cut sd_price_cut mean_carat_cut sd_carat_cut)
    keep in 1

* Saving the new row TOTAL in a new temporary local file
    tempfile overall
    save "`overall'", replace
restore

* Merging the two template by uploading the first table and by appending the TOTAL row, saving then the file in the table directory
preserve
    use "`bycut'", clear
    append using "`overall'"
    order group mean_price_cut sd_price_cut mean_carat_cut sd_carat_cut
    export delimited using "$tables/summary_statistics_by_cut.csv", replace
restore

*****************************************************
* Correlation matrix including the p-value and the p-value stars to have the significance

pwcorr price carat log_price price_per_carat, sig star(0.05)

* Creation of a temporary file where to store the correlation table

tempfile corrlog
capture log cloase corr

* Creation of a log temporary file to recreate the table and store it not in the command line but in the table directory

log using "`corrlog'", name(corr) text replace 
	pwcorr price carat log_price price_per_carat, sig star(0.05)
log close corr
copy "`corrlog'" "$tables/correlation_matrix.txt", replace

*****************************************************
* Plotting graphs

* Kernel density graph for the variables: price, carat log_price, price_per_carat through a loop cycle to create more graphs ina single code

* Creation of a local list of variable to use it in the loop cycle

local graph_var price carat log_price price_per_carat
foreach p of local graph_var {
	kdensity `p', title("Kernel Density of `p'") xtitle("`p'")
	graph export "$figures/kernel_density_graph_`p'.png", replace
}

* Creation of a 2 scatterplots combined

twoway (scatter price carat, mcolor(red)) (scatter price_per_carat log_price, mcolor(blue)), title("Scatterplots") subtitle("Red: Price vs Carat  |  Blue:  Price per carat vs Log of price") xtitle("Carat (red)  |  Log of price (blue)") legend(order(1 "Price vs Carat" 2 "Price per carat vs ln(price)") ring(0) pos(6) col(1))

graph export "$figures/combined_scatterplots.png", replace

*****************************************************
* Saving the new dataset created
save "$clean/diamonds_clean_02.dta", replace


*****************************************************