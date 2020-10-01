setwd("~/covid19_regional/Europe/")
library('tidyverse')
library("anytime")

############## ITALY ##############À
df = read_csv('https://raw.githubusercontent.com/pcm-dpc/COVID-19/master/dati-regioni/dpc-covid19-ita-regioni.csv')
df$date <- as.Date(as.character(df$data),format="%Y-%m-%d")
df$state<-rep("Italy", nrow=df) 
head(df)

df2 <- df %>%
  group_by(state, date, denominazione_regione) %>%
  arrange(date) %>%
  select(state, date,denominazione_regione, nuovi_positivi) %>%
  rename(site=denominazione_regione, dailycases=nuovi_positivi)

head(df2)

df2$note<-rep("NA", nrow=df2) 
head(df2)
write.csv(df2,'csv/Italy.csv')


################# Spain ################
df = read_csv('https://raw.githubusercontent.com/IFCA/covid-19-spain/master/dataset/by-province.csv')
df$date <- as.Date(as.character(df$date),format="%Y-%m-%d")
df$state<-rep("Spain", nrow=df) 
head(df)

df2 <- df %>%
  group_by(province) %>%
  arrange(province, date)%>%
  select(state, date, province, "cases new") %>%
  rename(site=province, dailycases="cases new")
df2$note<-rep("NA", nrow=df2) 
df2 <- df2[!is.na(df2$dailycases), ]
head(df2)
write.csv(df2,'csv/Spain.csv')


############### Deutschland ##############à
df = read_csv2('https://raw.githubusercontent.com/averissimo/covid19.de.data/master/data/rki.covid19.csv')
df$date <- as.Date(as.character(df$date),format="%Y-%m-%d")
df$state<-rep("Deutschland", nrow=df) 
head(df)

df2 <- df %>%
  group_by(state,district,date ,NUTS_3.code) %>%
  summarise(totale_casi=sum(cases)) %>%
  arrange(date, district)%>%
  mutate(dailycases=totale_casi-lag(totale_casi))%>%
  mutate(dailycases=case_when(is.na(dailycases)~totale_casi, TRUE ~ dailycases )) %>%
  select(state, date,district, dailycases, NUTS_3.code) %>%
  rename(site=district, note=NUTS_3.code)
#df2 <- df2[!is.na(df2$cases), ]
sum(df2$dailycases)
write.csv(df2,'csv/Deutschland.csv')



############### ROMANIA ##############à

# df = read_csv('https://raw.githubusercontent.com/gabrielpreda/covid_19_ro/master/ro_covid_19_time_series/ro_covid_19_time_series.csv')
# df$date <- as.Date(df$Date,format="%Y-%m-%d")
# df$state<-rep("Romania", nrow=df) 
# 
# df2 <- df %>%
#   group_by(County) %>%
#   arrange(date) %>%
#   mutate(dailycases=Confirmed-lag(Confirmed))%>%
#   mutate(dailycases=case_when(is.na(dailycases)~Confirmed, TRUE ~ dailycases )) %>%
#   select(state, date, County, dailycases) %>%
#   rename(site=County)
# df2$note<-rep("NA", nrow=df2) 
# df2 <- df2[!is.na(df2$site), ]
# sum(df2$dailycases)
# write.csv(df2,'csv/Romania.csv')

############### Belgium ##############

df = read_csv('belgium_raw.csv')
df$date <- as.Date(as.character(df$DATE),format="%Y-%m-%d")
df$state<-rep("Belgium", nrow=df) 
df <- df[!is.na(df$date), ]
df2 <- df %>%
  group_by(state, PROVINCE, date) %>%
  arrange(PROVINCE, date) %>%
  summarise(confirmed=sum(CASES)) %>%
  select(state, date, PROVINCE, confirmed) %>%
  rename(site=PROVINCE, dailycases=confirmed)
df2$note<-rep("NA", nrow=df2) 
df2 <- df2[!is.na(df2$site), ]
write.csv(df2,'csv/Belgium.csv')

############### Austria ##############

df = read_csv('https://raw.githubusercontent.com/at062084/COVID-19-Austria/master/bmsgpk/data/COVID-19-austria.sanitized.region.csv')
df$date <- as.Date(as.character(df$Stamp),format="%Y-%m-%d")
df$state<-rep("Austria", nrow=df) 
df <- df[df$Status !=  "Tested", ]
df <- df[df$Status != "Recovered", ]
df <- df[df$Status != "Deaths", ]
df <- df[df$Status != "Hospitalisierung", ]
df <- df[df$Status != "Intensivstation", ]
df2 <- df %>%
  gather(key='Region', value= 'total_count', `B`:`W`)%>% 
  group_by(Region) %>%
  arrange(Region, date)%>%
  mutate(dailycases=total_count-lag(total_count))%>%
  mutate(dailycases=case_when(is.na(dailycases)~total_count, TRUE ~ dailycases )) %>%
  select(state, date,Region, dailycases) %>%
  rename(site=Region)
df3 <- df2 %>%
            group_by(state, site, date) %>%
            summarise(dailycases = sum(dailycases)) %>%
            arrange(site)
df3$note<-rep("NA", nrow=df2) 
write.csv(df3,'csv/Austria.csv')


############### UK ##############

df = read_csv('https://raw.githubusercontent.com/tomwhite/covid-19-uk-data/master/data/covid-19-cases-uk.csv')
df$date <- as.Date(as.character(df$Date),format="%Y-%m-%d")
df$state<-rep("United Kingdom", nrow=df) 
head(df)

df2 <- df %>%
  group_by(Area) %>%
  arrange(Area, date)%>%
  mutate(dailycases=TotalCases-lag(TotalCases))%>%
  mutate(dailycases=case_when(is.na(dailycases)~TotalCases, TRUE ~ dailycases )) %>%
  select(state, date, Area, dailycases, AreaCode) %>%
  rename(site=Area, note=AreaCode)
#df2$note<-rep("NA", nrow=df2) 
#df2 <- df2[!is.na(df2$cases), ]
head(df2)
write.csv(df2,'csv/UK.csv')



############### Netherlands ##############à

df = read_csv('https://raw.githubusercontent.com/J535D165/CoronaWatchNL/master/data-geo/data-municipal/RIVM_NL_municipal.csv')
df$date <- as.Date(as.character(df$Datum),format="%Y-%m-%d")
df$state<-rep("Netherlands", nrow=df) 
head(df)
df = filter(df, !(Type %in% c("Ziekenhuisopname", "Overleden")))

df2 <- df %>%
  group_by(Gemeentenaam) %>%
  arrange(Gemeentenaam, date)%>%
  select(state, date,Gemeentenaam, Aantal) %>%
  rename(site=Gemeentenaam, dailycases=Aantal)
df2$note<-rep("NA", nrow=df2) 
df2 <- df2[!is.na(df2$site), ]
df2 <- df2[!is.na(df2$dailycases), ]
head(df2)
write.csv(df2,'csv/Netherlands.csv')

############### Norway ##############à

df = read_csv('https://raw.githubusercontent.com/thohan88/covid19-nor-data/master/data/01_infected/msis/municipality_and_district.csv')
df$date <- as.Date(as.character(df$date),format="%Y-%m-%d")
df$state<-rep("Norway", nrow=df) 

df2 <- df %>%
  group_by(state,fylke_name, date) %>%
  arrange(date)%>%
  summarise(confirmed=sum(cases)) %>%
  mutate(dailycases=confirmed-lag(confirmed))%>%
  mutate(dailycases=case_when(is.na(dailycases)~confirmed, TRUE ~ dailycases )) %>%
  select(state, date,fylke_name, dailycases) %>%
  rename(site=fylke_name)
head(df2)

write.csv(df2,'csv/Norway.csv')

############### Sweden ##############à

df = read_csv('https://raw.githubusercontent.com/jannesgg/swe-covid-19/master/time_series_confimed-confirmed.csv')
df$state<-rep("Sweden", nrow=df) 
head(df)

df2 <- df %>%
  gather(key='date', value= 'dailycases', `2020-02-25`:`Today`)%>% 
  group_by(Display_Name) %>%
  arrange(Display_Name, date)%>%
  select(state, date,Display_Name, dailycases) %>%
  rename(site=Display_Name)
df2$note<-rep("NA", nrow=df2) 
df2$date <- as.Date(as.character(df2$date),format="%Y-%m-%d")
#df2 <- df2[!is.na(df2$cases), ]
head(df2)
write.csv(df2,'csv/Sweden.csv')

############### Ireland ##############à

irlanda= read_csv('Ireland_raw.csv')
irlanda$date<-irlanda$TimeStamp/1000
irlanda$date<-anydate(irlanda$date)
irlanda$state<-rep("Ireland", nrow=df) 
df2 <- irlanda %>%
  group_by(state, CountyName, date) %>%
  arrange(CountyName, date) %>% 
  summarise(confirmed=sum(ConfirmedCovidCases)) %>%
  mutate(dailycases=confirmed-lag(confirmed))%>%
  mutate(dailycases=case_when(is.na(dailycases)~confirmed, TRUE ~ dailycases )) %>%
  select(state, CountyName,date,dailycases) %>%
  rename(site=CountyName)
df2$note<-rep("NA", nrow=df2) 
#df2 <- df2[!is.na(df2$site), ]
write.csv(df2,'csv/Ireland.csv')

############### Czech ##############à


df = read_csv('https://onemocneni-aktualne.mzcr.cz/api/v1/covid-19/osoby.csv')
df$date <- as.Date(as.character(df$datum_hlaseni),format="%Y-%m-%d")
df$state<-rep("Czech Republic", nrow=df) 
head(df)

df2 <- df %>%
  group_by(state, kraj, date) %>%
  summarise(dailycases=sum(state=="Czech Republic"))%>%
  select(state, date,kraj, dailycases) %>%
  rename(site=kraj)
df2$note<-rep("NA", nrow=df2) 
head(df2)
write.csv(df2,'csv/czech.csv')


############### POLAND ##############à

df = read_csv('https://raw.githubusercontent.com/dtandev/coronavirus/master/data/CoronavirusPL%20-%20Timeseries.csv')
df$date <- as.Date(df$Timestamp,format="%d-%m-%Y")
df$state<-rep("Poland", nrow=df) 
head(df)

df2 <- df %>%
  group_by(state, City, date) %>%
  summarise(dailycases=sum(state=="Poland"))%>%
  select(state, date,City, dailycases) %>%
  rename(site=City)
df2$note<-rep("NA", nrow=df2) 
#df2 <- df2[!is.na(df2$cases), ]
head(df2)

write.csv(df2,'csv/Poland.csv')

############### Luxembourg ##############à

df = read_csv('https://raw.githubusercontent.com/thlaegler/covid-19-monitor/456bcb1bd4a08963a8acc31529cad64899c52586/data/by_country/Luxembourg.csv')
df$date <- as.Date(as.character(df$dateId),format="%Y-%m-%d")
df$state<-rep("Luxembourg", nrow=df) 
head(df)

df2 <- df %>%
  group_by(country) %>%
  arrange(country, date)%>%
  mutate(dailycases=confirmed-lag(confirmed))%>%
  mutate(dailycases=case_when(is.na(dailycases)~confirmed, TRUE ~ dailycases )) %>%
  select(state, date,country, dailycases) %>%
  rename(site=country)
df2$note<-rep("NA", nrow=df2) 
head(df2)

write.csv(df2,'csv/Luxembourg.csv')

#### MERGE

library(plyr)
library(readr)
csv_dir = "csv/"
csv_files = list.files(path=csv_dir, pattern="*.csv", full.names=TRUE)

eu = ldply(csv_files, read_csv)
eu <- eu[,-1]

write.csv(eu,'Europe.csv')

names(eu)
