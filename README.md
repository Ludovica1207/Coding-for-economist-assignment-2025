
# Coding for Economists 2025 — Diamonds Project 

This project has been created to demonstrate differnt flows of analysis using VS and Stata for the diamonds.csv dataset   

Author: Ludovica Capelli
University: Central European University
Date: 2025-11-09

# Structure of the project

Coding-for-economist-assignment-2025/
│
├── data/
│ ├── raw/ 
│ └── clean/ 
│
├── output/
│ ├── figures/ 
│ └── tables/ 
│
├── src/
│ ├── stata/ 
│ │ ├── 00_master.do
│ │ ├── 01_import_and_clean_data.do
│ │ ├── 02_statistics_and_graphs.do
│ │ └── 03_normal_distribution.do
│ └── python/ 

├── README.md  
└── .gitignore 

# How to execute the project

Python: Run the file integrated in the project Coding_for_economist_python.ipynb in VS code. The project is in src-python directory

Stata: Open Stata on the desktop and write in the command line: 
cd "C:\Users\yourname\Desktop\Coding-for-economist-assignment-2025-main\src\stata"
do 00_master.do

After the execution you will find the output of the project in the correspondent directories
