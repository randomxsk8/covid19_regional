setwd("~/covid19_regional/Oceania/")

library('tidyverse')


######### AUSTRALIA ##########

df = read_csv('https://raw.githubusercontent.com/pappubahry/AU_COVID19/master/time_series_cases.csv')
df$date <- as.Date(df$Date, format = "%d/%m/%Y")
df$state<-rep("Australia", nrow=df) 

df2 <- df %>%
  gather(key='site', value= 'casi', `NSW`:`NT`)%>% 
  group_by(site) %>%
  select (state, date, site, casi)

df2 <- df2[!is.na(df2$casi), ]
df2$casi <- as.numeric(df2$casi)
df2$note<-rep("NA", nrow=df2) 
df2 <- df2 %>%
  arrange(site, date)%>%
  mutate(dailycases=casi-lag(casi))%>%
  mutate(dailycases=case_when(is.na(dailycases)~casi, TRUE ~ dailycases )) %>%
  select(state, date,site,dailycases, note)
head(df2)


write.csv(df2,'csv/Australia.csv')



######### NEW ZELAND ##########
df = read_csv('https://raw.githubusercontent.com/UoA-eResearch/nz-covid19-data-auto/master/data.csv')
df$date <- as.Date(df$'Date of report', format = "%d/%m/%Y")
df$state<-rep("New Zeland", nrow=df) 

df$DHB<-as.factor(df$DHB)
df1<-df%>%
  select(date,DHB,state)  
df2<-df1%>%
  group_by(DHB,date)%>%
  summarise(dailycases=sum(state=="New Zeland"))%>%
  mutate(casicum=cumsum(dailycases))
df2$state<-rep("New Zeland", nrow=df2)
df2$note<-rep("NA", nrow=df2)
df2<-df2%>%
  select(state, date,DHB,dailycases, note)%>%
  rename(site=DHB) 
head(df2)

sum(df2$dailycases)

write.csv(df2,'csv/New_Zeland.csv')

#### MERGE

library(plyr)
library(readr)
csv_dir = "csv/"
csv_files = list.files(path=csv_dir, pattern="*.csv", full.names=TRUE)

Oceania = ldply(csv_files, read_csv)
Oceania <- Oceania[,-1]

write.csv(Oceania,'Oceania.csv')
