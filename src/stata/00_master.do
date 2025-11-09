/********************************************************************
  00_master.do  —  Portable master for the Diamonds project
  
********************************************************************/

version 18
clear all
set more off

* -----------------------------
* 1) Locate project directories
* -----------------------------
* Full path of this master file while it runs
local _me = c(filename)

* Folder of this master (remove the filename)
local _dofolder = subinstr("`_me'","00_master.do","",.)
cd "`_dofolder'"

* Project root = one level above /src/stata  (handle / and \)
local _root = subinstr("`_dofolder'","/src/stata","",.)
local _root = subinstr("`_root'","\src\stata","",.)
global root "`_root'"

* Global paths (ONLY $macros, as requested)
global raw      "$root/data/raw"
global clean    "$root/data/clean"
global output   "$root/output"
global figures  "$root/output/figures"
global tables   "$root/output/tables"
global stata    "$root/src/stata"

* --------------------------------
* 2) Create folders if they exist
* --------------------------------
cap mkdir "$raw"
cap mkdir "$clean"
cap mkdir "$output"
cap mkdir "$figures"
cap mkdir "$tables"

* -------------------------
* 3) Optional: start a log
* -------------------------
cap log close _all
log using "$output/master_log.smcl", replace

* --------------------------------------
* 4) Run the project sub do-files
*    (they are in the same folder)
* --------------------------------------
do "$stata/01_import_and_clean_data.do"
do "$stata/02_statistics_and_graphs.do"
do "$stata/03_normal_distribution.do"

* -------------
* 5) All done!
* -------------
di as result "✓ Pipeline completed successfully."
log close
