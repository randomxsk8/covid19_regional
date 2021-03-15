#!/bin/bash
### For Running that script you need
### R 
### Python 3.7
### R Module tidyverse
printf "Running first Rscript... \n Loading African Countries \n\n"
Rscript 'Africa/Africa.r'
printf "\n#################################################\n"
printf "OK DONE! \n\n"

printf "Running Second Rscript... \n Loading Asian Countries \n\n"
Rscript 'Asia/Asia.r'
printf "\n#################################################\n"
printf "OK DONE! \n\n"

printf "Running Third Rscript... \n Loading Oceanina Countries \n\n"
Rscript 'Oceania/Oceania.r'
printf "\n#################################################\n"
printf "OK DONE! \n\n"

printf "Running Fourth Rscript... \n Loading Southern America Countries \n\n"
Rscript 'South America/South_America.R'
printf "\n#################################################\n"
printf "OK DONE! \n\n"

printf "Running Fifth Rscript... \n Loading Middle East Countries \n\n"
Rscript 'Middle East/Middle_east.r'
printf "\n################################################# \n
OK DONE! \n

Running sixth Rscript... \n Loading European Countries \n\n"
Rscript 'Europe/Europe.r'
printf "\n#################################################\n"
printf "OK DONE! \n

Running seventh Rscript... \n Loading North American Countries \n\n"
Rscript 'North America/North_America.r'
printf "\n#################################################\n"
printf "OK DONE! \n

\n################################################# \n"

printf "\n Preparing csv files...\n"

mv 'Africa/africa.csv'  'csv_final/pre_build/Africa.csv'
printf " Africa... Ok \n"

mv 'Asia/Asia.csv'  'csv_final/pre_build/Asia.csv' 
printf " Asia... Ok \n"

mv 'Europe/Europe.csv'  'csv_final/pre_build/Europe.csv'
printf " Europe... Ok \n"

mv 'North America/na.csv'  'csv_final/pre_build/na.csv'
printf " North America... Ok \n"

mv 'Middle East/mes.csv'  'csv_final/pre_build/mes.csv'
printf " Middle East... Ok \n"

mv 'Oceania/Oceania.csv'  'csv_final/pre_build/Oceania.csv' 
printf " Oceania... Ok \n"

mv 'South America/south_america.csv'  'csv_final/pre_build/south_america.csv'
printf " South America... Ok \n
\n#################################################\n

DONE! \n All csv_files are located under csv_final folder \n"

ls -l 'Asia/csv/' |  awk '{print $6 "-" $7 " " $8 " " $9}' > log_extract.txt;ls -l 'Africa/csv/' |  awk '{print $6 "-" $7 " " $8 " " $9}' >> log_extract.txt;ls -l 'South America/csv/' |  awk '{print $6 "-" $7 " " $8 " " $9}' >> log_extract.txt;ls -l 'Europe/csv/' |  awk '{print $6 "-" $7 " " $8 " " $9}' >> log_extract.txt;ls -l 'Oceania/csv/' |  awk '{print $6 "-" $7 " " $8 " " $9}' >> log_extract.txt;ls -l 'North America/csv/' |  awk '{print $6 "-" $7 " " $8 " " $9}' >> log_extract.txt;ls -l 'Middle East/csv/' |  awk '{print $6 "-" $7 " " $8 " " $9}' >> log_extract.txt

printf "
####################################################
#                                                  #
#                                                  #
# For more information check log file generated on #
#               log_extract.txt                    #
#                                                  #
#                                                  #
####################################################

\n

Tidying up...

"

python site_alignment.py

printf "
####################################################
#                                                  #
#                                                  #
#             DATASET BUILD COMPLETE!              #
#                                                  #
#                                                  #
####################################################

\n
"
