*****************************************************
* 00_master.do  — Master script 

*****************************************************

version 18.0
capture log close _all
log using "../../output/master_log.smcl", replace
set more off

* Root of the project
cd "../.."

global raw      "data/raw"
global clean    "data/clean"
global figures  "output/figures"
global tables   "output/tables"
global stata    "src/stata"

# Creates the directories if missing
cap mkdir "$raw"
cap mkdir "$clean"
cap mkdir "$output" 
cap mkdir "$figures"
cap mkdir "$tables"


* Setting the other modules that the project should report
do "stata/01_import_and_clean_data.do"
do "stata/02_statistics_and_graphs.do"
do "stata/03_normal_distribution.do"

log close
