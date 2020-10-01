setwd("~/covid19_regional/Middle East/")
library('tidyverse')




############ PAKISTAN ############
df = read_csv('https://raw.githubusercontent.com/ShahrozTanveer/covid19-pakistan/master/data/covid-19-pakistan-data.csv')
df$date <- as.Date(df$date, format = "%d-%m-%Y")
df$state<-rep("Pakistan", nrow=df) 

df2 <- df %>%
  arrange(province, date)%>%
  mutate(dailycases=total_cases-lag(total_cases))%>%
  mutate(dailycases=case_when(is.na(dailycases)~total_cases, TRUE ~ dailycases )) %>%
  rename(site=province) %>%
  select(state, date,site,dailycases)

df2$note<-rep("NA", nrow=df2)
head(df2)
write.csv(df2,'csv/Pakistan.csv')


############ INDIA ############
df = read_csv('https://raw.githubusercontent.com/mrinal000/covid19_india_data/master/Archive_data/covid19_data/csv/individual/ncov19individual_clean.csv')
df$date <- as.Date(df$dateannounced, format = "%d/%m/%Y")
df$state<-rep("India", nrow=df) 

df2<-df%>%
  select(date,detectedstate,state) %>%
  group_by(detectedstate,date)%>%
  summarise(dailycases=sum(state=="India"))

df2$note<-rep("NA", nrow=df2)
df2$state<-rep("India", nrow=df2)
df2 <- df2 %>% select(state, date,detectedstate,dailycases )%>%
  rename(site=detectedstate) 
head(df2)
write.csv(df2,'csv/India.csv')

############ QATAR ############
df = read_csv('https://raw.githubusercontent.com/thlaegler/covid-19-monitor/456bcb1bd4a08963a8acc31529cad64899c52586/data/by_country/Qatar.csv')
df$date <- as.Date(df$dateId, format = "%Y-%m-%d")
df$site<-rep("Qatar", nrow=df)

df2<-df%>%
  group_by(country, date)%>% 
  summarize(casi=sum(confirmed)) %>% 
  mutate(dailycases=casi-lag(casi))%>%
  mutate(dailycases=case_when(is.na(dailycases)~casi, TRUE ~ dailycases )) 

df2$site<-rep("Qatar", nrow=df2)

df2<-df2%>%
  select(country, date, site, dailycases) %>%
  rename(state=country)


df2$note<-rep("NA", nrow=df2)
head(df2)
write.csv(df2,'csv/Qatar.csv')

############ BAHRAIN ############
df = read_csv('https://raw.githubusercontent.com/thlaegler/covid-19-monitor/456bcb1bd4a08963a8acc31529cad64899c52586/data/by_country/Bahrain.csv')
df$date <- as.Date(df$dateId, format = "%Y-%m-%d")
df$site<-rep("Bahrain", nrow=df)
df2<-df%>%
  group_by(country, date)%>% 
  summarize(casi=sum(confirmed)) %>% 
  mutate(dailycases=casi-lag(casi))%>%
  mutate(dailycases=case_when(is.na(dailycases)~casi, TRUE ~ dailycases )) 

df2$site<-rep("Bahrain", nrow=df2)

df2<-df2%>%
  select(country, date, site, dailycases) %>%
  rename(state=country)

head(df2)
df2$note<-rep("NA", nrow=df2)
write.csv(df2,'csv/Bahrain.csv')

############ LEBANON ############
df = read_csv('https://raw.githubusercontent.com/thlaegler/covid-19-monitor/456bcb1bd4a08963a8acc31529cad64899c52586/data/by_country/Lebanon.csv')
df$date <- as.Date(df$dateId, format = "%Y-%m-%d")
df$site<-rep("Lebanon", nrow=df)
df2<-df%>%
  group_by(country, date)%>% 
  summarize(casi=sum(confirmed)) %>% 
  mutate(dailycases=casi-lag(casi))%>%
  mutate(dailycases=case_when(is.na(dailycases)~casi, TRUE ~ dailycases )) 

df2$site<-rep("Lebanon", nrow=df2)

df2<-df2%>%
  select(country, date, site, dailycases) %>%
  rename(state=country)


df2$note<-rep("NA", nrow=df2)
head(df2)
write.csv(df2,'csv/Lebanon.csv')
#############à SAUDI ############

df = read_csv('https://raw.githubusercontent.com/mrg0lden/COVID19-SA/master/covid-sa-by-city.csv')
df$date <- as.Date(df$date, format = "%Y-%m-%d")

df2 = read_csv('https://raw.githubusercontent.com/mrg0lden/COVID19-SA/master/cities/cities.csv')

df3<-merge(df,df2)
df3$note<-rep("NA", nrow=df3)
df3$state<-rep("United Arab Emirates", nrow=df3)

df4<-df3%>%
  group_by(name_en, date)%>% 
  select(state, date, name_en, new_cases, note) %>%
  rename(site= name_en, dailycases=new_cases)
head(df4)

write.csv(df4,'csv/Saudi.csv')

############ ISRAEL ############
# Lost!
# df = read_csv('https://raw.githubusercontent.com/COVID-19-Israel/Covid-19-data/master/data/other/israeli_health_ministry_telegram_data/csv/cities/Cities.csv')
# df$Date <- as.Date(df$Date, format = "%d/%m/%Y")
# head(df)
# 
# df2 <- df %>%
#   group_by(City_Name, Date) %>%
#   arrange(Date) %>%
#   summarize(casi=sum(Infected))
# 
# df2 <- df2[!is.na(df2$Date), ]
# df2$state<-rep("Israel", nrow=df2)
# df2 <- df2 %>%
#   mutate(dailycases=casi-lag(casi))%>%
#   mutate(dailycases=case_when(is.na(dailycases)~casi, TRUE ~ dailycases )) %>%
#   select(state, City_Name, Date, casi) %>%
#   rename(site=City_Name, date=Date, dailycases=casi)
# 
# 
# df2$note<-rep("NA", nrow=df2)
# head(df2)
# 
# write.csv(df2,'csv/Israel.csv')

############ AFGHANISTAN #############
df = read_csv('https://docs.google.com/spreadsheets/d/1F-AMEDtqK78EA6LYME2oOsWQsgJi4CT3V_G4Uo-47Rg/export?format=csv')
df$date <- as.Date(as.character(df$Date),format="%Y-%m-%d")
df$state<-rep("Afghanistan", nrow=df) 
df$note<-rep("NA", nrow=df) 
df$Cases <- as.numeric(df$Cases)
df2 <- df %>%
  group_by(Province) %>%
  arrange(Province, date)%>%
  mutate(dailycases=Cases-lag(Cases))%>%
  mutate(dailycases=case_when(is.na(dailycases)~Cases, TRUE ~ dailycases )) %>%
  select(state, date,Province,dailycases) %>%
  rename(site=Province)

df2 <- df2[!is.na(df$date), ]
head(df2)

write.csv(df2,'csv/Afghanistan.csv')

#### MERGE

library(plyr)
library(readr)
csv_dir = "csv/"
csv_files = list.files(path=csv_dir, pattern="*.csv", full.names=TRUE)

mes = ldply(csv_files, read_csv)
mes <- mes[,-1]

write.csv(mes,'mes.csv')

