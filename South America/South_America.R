setwd("~/covid19_regional/South America/")

library("tidyverse")

## Reminder: update links Mexico and Costa Rica

########### MEXICO ###########
#### CSV CHE CAMBIA CON DATA 
dfmexico = read_csv("https://raw.githubusercontent.com/bialikover/covid-mexico/master/data/confirmados/confirmados-2020-04-10.csv")
dfmexico$data<-dfmexico$"Fecha de Inicio de síntomas"
dfmexico$data <- as.Date(dfmexico$data, format = "%d/%m/%y")
dfmexico$casi<-as.factor(dfmexico$"Identificación de COVID-19 por RT-PCR en tiempo real")
dfmexico1<-dfmexico%>%
  group_by(Estado, data)%>% 
  summarize(dailycasi=sum(casi=="Confirmado"))%>%
  mutate(casicum=cumsum(dailycasi))
dfmexico1$state<-rep("Mexico", nrow=dfmexico)
dfmexico1$note<-rep("NA", nrow=dfmexico)
dfmexico2<-dfmexico1 %>%
  rename(site=Estado, date=data, dailycases=dailycasi)%>%
  select(state, date, site, dailycases, note)
dfmexico2 <- dfmexico2[!is.na(dfmexico2$dailycases), ]
head(dfmexico2)
write.csv(dfmexico2,'csv/Mexico.csv')

########### PARAGUAY ###########

df = read_csv2('raw_paraguay.csv')
df$date <- as.Date(df$"Fecha Confirmacion", format = "%d/%m/%y")
df$state <- rep("Paraguay", nrow=df)
df$note <- rep(("NA"), nrow=df)
df2 <- df %>%
  group_by(state, `Departamento Residencia` ,date) %>%
  arrange(`Departamento Residencia`) %>%
  summarise(dailycases=sum(state=="Paraguay"))%>%
  select(state, date,`Departamento Residencia`,dailycases) %>%
  rename(site=`Departamento Residencia`)
df2$note<-rep("NA", nrow=df2) 
df2 <- df2[!is.na(df2$site), ]
write.csv(df2,'csv/Paraguay.csv')


########### COSTA RICA ###########
#### CSV CHE CAMBIA CON DATA 
dfcostarica = read_csv('http://geovision.uned.ac.cr/oges/archivos_covid/05_10/05_10_CSV_POSITIVOS.csv')
dfcostarica1<-dfcostarica%>% 
  group_by(provincia)%>% 
  gather(key='date', value= 'casi', `15/03/2020`:`01/05/2020`)%>%
  arrange(canton)%>%
  mutate(daily_cases = casi - lag(casi)) %>%
  mutate(daily_cases =case_when(is.na(daily_cases)~casi, TRUE ~ daily_cases )) 
dfcostarica1$date <- as.Date(dfcostarica1$date, format = "%d/%m/%y")
for (i in 1:nrow(dfcostarica1)){
  if(dfcostarica1$daily_cases[i]<0){dfcostarica1$daily_cases[i]<-0}}
dfcostarica1$state<-rep("Costa Rica", nrow=dfcostarica1) 
dfcostarica1<-dfcostarica1%>%
  select(state, date, provincia, daily_cases) %>%
  rename(site=provincia, dailycases=daily_cases)
dfcostarica1$note<-rep("NA", nrow=dfcostarica1)
head(dfcostarica1)
write.csv(dfcostarica1,'csv/costarica.csv')


########### BOLIVIA ###########
dfbolivia = read_csv('https://raw.githubusercontent.com/mauforonda/covid19-bolivia/master/confirmados.csv')
dfbolivia$data <- as.Date(dfbolivia$Fecha, format = "%d-%m-%y")
dfbolivia1<-dfbolivia%>% 
  gather(key='region', value= 'casi', `La Paz`:`Pando`)%>% 
  group_by(region) %>%
  arrange(region, data)%>%
  select(data,region,casi)%>%
  mutate(daily_cases=casi-lag(casi))%>%
  mutate(daily_cases=case_when(is.na(daily_cases)~casi, TRUE ~ daily_cases ))
dfbolivia1$state<-rep("Bolivia", nrow=dfbolivia1) 
dfbolivia1$note<-rep("NA", nrow=dfbolivia1) 
dfbolivia1<-dfbolivia1%>% 
  select(state,data,region,daily_cases,note)%>% 
  rename(state=state, date=data, site=region, dailycases=daily_cases, note=note)
head(dfbolivia1)
write.csv(dfbolivia1,'csv/bolivia.csv')

########### CUBA ##############
library("reticulate")
# INSERIRE IL PATH PER PYTHON
use_python("/home/randomx/anaconda3/bin/python") ### LINUX
##use_python("/Users/A/anaconda3/bin/python", required = T) ### Windows
# Check the version of Python
py_config()
py_run_file("cuba_extract.py")
df <- read_csv("covid19-cuba.csv")
df <- select (df,-c(info))

df$state <- rep("Cuba", nrow=df)
#df$note <- rep(("provincia"), nrow=df)

df2<-df %>%
  group_by(provincia_detección,deteccion, state, municipio_detección) %>%
  summarise(dailycase=sum(state=="Cuba"))%>%
  select(state,deteccion,`provincia_detección`,dailycase, `municipio_detección`) %>%
  rename(date=deteccion, site=`provincia_detección`, dailycases=dailycase, note=`municipio_detección`)

head(df2)

write.csv(df2,'csv/cuba.csv')

########### PUERTO RICO ############

df <- read_csv("https://raw.githubusercontent.com/marcmaceira/covid-19-pr-data/master/time_series/municipality/time_series-by_municipality-confirmed.csv")
df$state <- rep("Puerto Rico", nrow=df)
df$note <- rep(("NA"), nrow=df)
df2 <- df %>%
  group_by(`Municipality`)  %>%
  gather(key='date', value='casicumulati', `3/26/2020`:`4/12/2020`) %>%
  arrange(date, `Municipality`)  %>%
  mutate(daily_cases = casicumulati - lag(casicumulati)) %>% 
  mutate(daily_cases =case_when(is.na(daily_cases)~casicumulati, TRUE ~ daily_cases )) %>%
  select(state,date,`Municipality`,daily_cases, note) %>%
  rename(site=`Municipality`, dailycases=daily_cases)
df2$date <- as.Date(df2$date, format = "%m/%d/%Y")
head(df2)
write.csv(df2,'csv/puertorico.csv')

########### ARGENTINA ############
df <- read_csv("https://docs.google.com/spreadsheets/d/16-bnsDdmmgtSxdWbVMboIHo5FRuz76DBxsz_BbsEVWA/export?format=csv&id=16-bnsDdmmgtSxdWbVMboIHo5FRuz76DBxsz_BbsEVWA&gid=488163612")
df$fecha <- as.Date(df$fecha, format = "%d/%m/%y")
df$state <- rep("Argentina", nrow=df)
df$note <- rep(("NA"), nrow=df)
df2argentina<-df %>%
  group_by(covid19argentina_admin_level_4, fecha) %>%
  arrange(`covid19argentina_admin_level_4`)  %>%
  select(state, fecha, `covid19argentina_admin_level_4`, SUMnue_casosconf_diff, note) %>%
  rename(date=fecha, site=`covid19argentina_admin_level_4`, dailycases=SUMnue_casosconf_diff)
head(df2argentina)
write.csv(df2argentina,'csv/argentina.csv')




########### BRAZIL ############
df <- read_csv("https://raw.githubusercontent.com/elhenrico/covid19-Brazil-timeseries/master/confirmed-new.csv")
df$note <- rep(("NA"), nrow=df)
df$state<-rep(("Brazil"), nrow=df)
dfbrazil<-df[-1,-2]
df2brazil<-dfbrazil %>%
  group_by(X1) %>%
  gather(key='date', value='dailycases', `26/2`:`1/5`) %>%
  arrange(X1)%>%
  select(state, X1,  date, dailycases, note)%>%
  rename(site=X1)
df2brazil$date <- as.Date(df2brazil$date, format = "%d/%m")
write.csv(df2brazil,'csv/brazil.csv')


########### CHILE ############

df <- read_csv("https://raw.githubusercontent.com/YachayData/COVID-19/master/COVID19_Chile_Regiones-casos_nuevos.CSV")
df$state <- rep("Chile", nrow=df)
df$note <- rep(("NA"), nrow=df)

df2 <- df %>%
  group_by(`nombre_region`)  %>%
  gather(key='date', value='dailycases', `2020-03-02`:`2020-05-11`) %>%
  arrange(`nombre_region`)  %>%
  select(state,date,`nombre_region`,dailycases, note) %>%
  rename(site=`nombre_region`)

head(df2)

write.csv(df2,'csv/chile.csv')

########### PERU ############

df <- read_csv("https://raw.githubusercontent.com/jmcastagnetto/covid-19-peru-data/main/datos/covid-19-peru-data.csv")
df$state <- rep("Peru", nrow=df)
df$note <- rep(("NA"), nrow=df)
df$date <- as.Date(df$date, format = "%Y-%m-%y")

df <- df[!is.na(df$region), ]
view(df)
df2<-df %>%
  group_by(region) %>%
  arrange(date)  %>%
  mutate(dailycases = confirmed - lag(confirmed)) %>% 
  mutate(dailycases =case_when(is.na(dailycases)~confirmed, TRUE ~ dailycases )) %>%
  select(country, date, region, dailycases, note) %>%
  rename(state=country, site=region)
df2 <- df2[!is.na(df2$site), ]
write.csv(df2,'csv/peru.csv')

########### ECUADOR ############

# df <- read_csv("https://raw.githubusercontent.com/pablora19/COVID19_EC/master/covid_ec.csv")
# df$date <- as.Date(df$fecha, format = "%d/%m/%y")
# df$state <- rep("Ecuador", nrow=df)
# names(df)
# df2<-df %>%
#   group_by(state,nombre_provincia, date) %>%
#   summarise(daily_cases=sum(casos_confirmados)) 
# df3<-df2 %>% 
#   mutate(dailycases = daily_cases- lag(daily_cases)) %>% 
#   mutate(dailycases =case_when(is.na(dailycases)~daily_cases, TRUE ~ dailycases )) %>% 
#   select(state, nombre_provincia, date, dailycases)
# df4<-left_join(df3,df)%>% 
#   select(state, date, nombre_provincia, dailycases, poblacion_provincia)%>%
#   rename(site=nombre_provincia, note=poblacion_provincia)
# 
# write.csv(df4,'csv/ecuador.csv')

########### COLOMBIA ############

dfcolombia = read_csv('https://raw.githubusercontent.com/dfuribez/COVID-19-Colombia/master/dataset.csv')
dfcolombia$date <- as.Date(dfcolombia$"Fecha de notificación", format = "%d/%m/%y")
dfcolombia$caso<-as.factor(dfcolombia$Tipo)

dfcolombia1<-dfcolombia %>%
  group_by(`Departamento o Distrito`, date, `Ciudad de ubicación`)%>% 
  arrange()  %>%
  summarize(Importado=sum(caso=="Importado"), relacionado=sum(caso=="Relacionado"))

dfcolombia1$casi<-dfcolombia1$Importado+ dfcolombia1$relacionado
dfcolombia1$state <- rep("Colombia", nrow=df)

dfcolombia1<-dfcolombia1 %>%
  rename(site=`Departamento o Distrito`, dailycases=casi, note=`Ciudad de ubicación`) %>%
  select(state, date, site, dailycases, note)

head(dfcolombia1)

write.csv(dfcolombia1,'csv/colombia.csv')

#### R_BIND ####

library(plyr)
library(readr)

csv_dir = "csv/"
csv_files = list.files(path=csv_dir, pattern="*.csv", full.names=TRUE)
south_america = ldply(csv_files, read_csv)
south_america <- south_america[,-1]
write.csv(south_america,'south_america.csv')
