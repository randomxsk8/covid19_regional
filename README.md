# covid19_regional
Dailycases of COVID-19 pandemic at regional level

There are stored dailycases by region for country since COVID-19 spread.

Link to sources: https://docs.google.com/spreadsheets/d/1JdDV2l1alA0twOyZlSWiZHCd4IXfaM51Vy3CVV8lRYU/edit?usp=sharing

There is an automated script that allowed you to download updated dailycases aligned to GADM administrative areas and NUTS_2 administrative areas for European countries.
If you would running this you must:
1. clone the repo into your home
2. Then cd to covid_19 dir
3. run extract.sh

You need last version of R and Python installed and some modules are needed to run the script.

For R:
- tidyverse
- plyr
- readr
- reticulate

For Python:
- Pandas
- Numpy
- streamlit
- json
- fuzzymatcher
