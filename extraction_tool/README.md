# covid19_regional
## Dailycases of COVID-19 pandemic at regional level


Update of Covid-19 cases
This is the Linux bash script for downloading updated Covid-19 data.

You can download them separate for country,continent, or the entire csv.
You can find COVID-19 dailycases data under 'csv_final' folder (most of the countries are updated to 10-01-2020).

Link to sources: https://github.com/randomxsk8/covid19_regional/blob/master/extraction_tool/COVID-19_regional_sources.csv

---------------------------------

There is also an automated script that allow you to download updated dailycases and align them to GADM administrative areas codes and NUTS_2 administrative areas codes (for European countries).
If you would running this you must:
1. clone the repo into your home
2. extract all files into a new folder and rename it as covid19_regional or simply rename covid19_regional-master into covid19_regional
3. Then open the shell and cd to covid19_regional dir
4. Make executable the extract.sh script with chmod ugo+x extract.sh
5. Make executable the site_alignment.py script with chmod ugo+x site_alignment.py
5. run ./extract.sh

You need last version of R and Python installed and some modules are needed to run the script.

**R requirements**:
- tidyverse
- plyr
- readr
- reticulate

**Python requirements**:
- Pandas
- Numpy
- streamlit
- json
- fuzzymatcher

---------------------------

There are also some notebooks that describe data with geopandas under notebook folder!
