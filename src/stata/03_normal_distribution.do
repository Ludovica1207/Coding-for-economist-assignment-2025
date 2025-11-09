*****************************************************
* 03_normal_distribution.do

* - Check of the statistics of the variables
* - Statistics by group
* - Check of the distribution of the variables
* - Computation of the z-score
* - Normal distribution

*****************************************************

version 16.0
clear all
set more off


import delimited "$clean/diamonds_clean_dataset.csv", clear varnames(1)

*****************************************************
* Check of the statistics of the variables

inspect price carat
codebook price carat cut
summarize price carat, detail

*****************************************************
* Statistics by group (cut)

tabstat price carat, by(cut) statistics(n mean sd min p25 p50 p75 max) columns(statistics)

*****************************************************
* Check of the distribution of the varibales 

histogram price, normal title ("Price normal distribution") xtitle("Price") ytitle ("Frequency")

graph export "$figures/normal_price_graph.png", replace

histogram carat, normal title ("Carat normal distribution") xtitle("Carat") ytitle ("Frequency")

graph export "$figures/normal_carat_graph.png", replace

kdensity price, title("Price kernel density") xtitle("Price") ytitle("Density")

graph export "$figures/kdensity_price_graph.png", replace

kdensity carat, title("Carat kernel density") xtitle("Carat") ytitle("Density")

graph export "$figures/kdensity_carat_graph.png", replace

***************************************************
* Computation of the z-score

summarize price if !missing(price)
local price_mean `r(mean)'
local sd_price `r(sd)'
generate z_score_price = (price- r(mean))/r(sd)
label var z_score_price "Z-score of price"

* Comparing the mean of the price in each cut category with the mean of the entire sample. The absolute value of z will declare how much distance (in standard deviation terms) there is form the sample. So, the bigger the z the greater the distance from the sample

foreach category in Fair Ideal Good Very Good Premium{
	summarize price if cut == "`category'"
	display (`r(mean)'- `price_mean')/`sd_price'
}

summarize carat if !missing(carat)
generate z_score_carat = (carat- r(mean))/r(sd)
label var z_score_carat "Z-score of carat"

* creation of a table with estout for the z_score of price and carat and saving it in the table directory
capture which estpost
if _rc ssc install estout, replace
estpost summarize z_score_price z_score_carat
esttab using "$tables/zscore_table.txt", replace cells("count mean sd min max") label title("Z_score")

***************************************************
* Normal distribution

* Cumulated standard probability for the varible price of how many observation are below the value of z_price

summarize price if !missing(price)
local z_price (10000 - `r(mean)')/`r(sd)'
display `z_price'
display round(normal (`z_price')*100, 0.01)

* Calculation of the normal density in Z=0 (the height of the normal curve in Z=0)
display normalden(0)

***************************************************
