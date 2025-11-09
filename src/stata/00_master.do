version 18
clear all
set more off

* ==========================================================
* MASTER DO-FILE for the Diamonds Project
* ==========================================================

* --- Find this master file’s folder and the project root ---
local this = c(filename)
local dofolder = subinstr("`this'","00_master.do","",.)
cd "`dofolder'"

* The project root is one level above src/stata
local root = subinstr("`dofolder'","/src/stata","",.)
local root = subinstr("`root'","\src\stata","",.)
global root "`root'"

* --- Define global paths using $ (no braces) ---
global raw      "$root/data/raw"
global clean    "$root/data/clean"
global output   "$root/output"
global figures  "$root/output/figures"
global tables   "$root/output/tables"
global stata    "$root/src/stata"

* --- Create folders if they do not exist ---
cap mkdir "$raw"
cap mkdir "$clean"
cap mkdir "$output"
cap mkdir "$figures"
cap mkdir "$tables"

* --- Optional log ---
cap log close _all
log using "$output/master_log.smcl", replace

* --- Run all sub do-files (located in the same folder) ---
do "$stata/01_import_and_clean_data.do"
do "$stata/02_statistics_and_graphs.do"
do "$stata/03_normal_distribution.do"

* --- End ---
di as text "✓ All Stata scripts executed successfully."
log close

