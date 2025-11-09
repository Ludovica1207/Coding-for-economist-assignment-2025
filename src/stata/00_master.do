/********************************************************************
  00_master.do  —  Portable master file for the Diamonds Project
 
********************************************************************/

version 18
clear all
set more off

* --------------------------------------------------------------
* 1) Locate the folder of this master file and compute root path
* --------------------------------------------------------------
* If run with a full path, c(filename) contains the location
local ME = c(filename)

if "`ME'" != "" {
    * Remove the filename from the path
    local DOFOLDER = subinstr("`ME'","00_master.do","",.)
}
else {
    * Fallback: if opened manually, use current working directory
    local DOFOLDER = c(pwd)
}

* Normalize backslashes to forward slashes (Windows safe)
local DOFOLDER = subinstr("`DOFOLDER'","\","/",.)

* Project root = remove "/src/stata" from the path
local ROOT = subinstr("`DOFOLDER'","/src/stata","",.)

* --------------------------------------------------------------
* 2) Define global paths (ONLY $macros)
* --------------------------------------------------------------
global root "`ROOT'"
global stata "$root/src/stata"
global raw "$root/data/raw"
global clean "$root/data/clean"
global output "$root/output"
global figures "$root/output/figures"
global tables "$root/output/tables"

* --------------------------------------------------------------
* 3) Create folders if they don’t exist
* --------------------------------------------------------------
cap mkdir "$raw"
cap mkdir "$clean"
cap mkdir "$output"
cap mkdir "$figures"
cap mkdir "$tables"

* --------------------------------------------------------------
* 4) (Optional) Start a log file
* --------------------------------------------------------------
cap log close _all
log using "$output/master_log.smcl", replace

* --------------------------------------------------------------
* 5) Run all the sub .do files (same folder as this master)
* --------------------------------------------------------------
do "$stata/01_import_and_clean_data.do"
do "$stata/02_statistics_and_graphs.do"
do "$stata/03_normal_distribution.do"

* --------------------------------------------------------------
* 6) Finish
* --------------------------------------------------------------
di as result "✓ All Stata scripts executed successfully."
log close
