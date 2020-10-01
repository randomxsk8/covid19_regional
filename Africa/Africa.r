setwd("~/covid19_regional/Africa/")


library('tidyverse')

####### NIGERIA #######

dfnigeria = read_csv('https://raw.githubusercontent.com/dsfsi/covid19africa/master/data/line_lists/line-list-nigeria.csv')

dfnigeria$"province/state"<-as.factor(dfnigeria$"province/state")
dfnigeria$data <- as.Date(dfnigeria$date, format = "%m/%d/%y")
dfnigeria1<-dfnigeria%>%
  select(data,`province/state`,country)  
dfnigeria2<-dfnigeria1%>%
  group_by(`province/state`,data)%>%
 summarise(dailycases=sum(country=="Nigeria"))%>%
  mutate(casicum=cumsum(dailycases))
dfnigeria2$state<-rep("Nigeria", nrow=dfnigeria2)
dfnigeria2$note<-rep("NA", nrow=dfnigeria2)
dfnigeria2<-dfnigeria2%>%
  select(state, data,`province/state`,dailycases, note)%>%
  rename(region=`province/state`)
head(dfnigeria2)

write.csv(dfnigeria2,'csv/Nigeria.csv')

####### ETHIOPIA #######

df = read_csv('https://raw.githubusercontent.com/dsfsi/covid19africa/master/data/line_lists/line-list-ethiopia.csv')

df$"province/state"<-as.factor(df$"province/state")
df$date <- as.Date(df$date_confirmation, format = "%m/%d/%y")
df1<-df%>%
  select(date,`province/state`,country)  
df2<-df1%>%
  group_by(`province/state`,date)%>%
  summarise(dailycases=sum(country=="Ethiopia"))%>%
  mutate(casicum=cumsum(dailycases))
df2$state<-rep("Ethiopia", nrow=df2)
df2$note<-rep("NA", nrow=df2)
df2<-df2%>%
  select(state, date,`province/state`,dailycases, note)%>%
  rename(site=`province/state`) 
head(df2)

write.csv(df2,'csv/Ethiopia.csv')

####### GHANA #######

df = read_csv('https://raw.githubusercontent.com/dsfsi/covid19africa/master/data/line_lists/line-list-ghana.csv')

df$"province/state"<-as.factor(df$"province/state")
df$date <- as.Date(df$date_confirmation, format = "%d-%m-%y")
df1<-df%>%
  select(date,`province/state`,country)  
df2<-df1%>%
  group_by(`province/state`,date)%>%
  summarise(dailycases=sum(country=="Ghana"))%>%
  mutate(casicum=cumsum(dailycases))
df2$state<-rep("Ghana", nrow=df2)
df2$note<-rep("NA", nrow=df2)
df2<-df2%>%
  select(state, date,`province/state`,dailycases, note)%>%
  rename(site=`province/state`) 
df2 <- df2[!is.na(df2$site), ]

head(df2)

write.csv(df2,'csv/Ghana.csv')

####### NIGER #######

df = read_csv('https://raw.githubusercontent.com/dsfsi/covid19africa/master/data/line_lists/line-list-niger.csv')
df$"province/state"<-as.factor(df$"province/state")
df$date <- as.Date(df$date, format = "%Y-%m-%d")
df1<-df%>%
  select(date,`province/state`,country)  
df2<-df1%>%
  group_by(`province/state`,date)%>%
 summarise(dailycases=sum(country=="Niger"))%>%
  mutate(casicum=cumsum(dailycases))
df2$state<-rep("Niger", nrow=df2)
df2$note<-rep("NA", nrow=df2)
df2<-df2%>%
  select(state, date,`province/state`,dailycases, note) %>%
  rename(site=`province/state`) 
df2 <- df2[!is.na(df2$site), ]
head(df2)

write.csv(df2,'csv/Niger.csv')

####### SENEGAL #######

df = read_csv('https://raw.githubusercontent.com/senegalouvert/COVID-19/master/data/2020.csv')

df$date <- as.Date(df$date, format = "%y-%m-%d")
df$country<-rep("Senegal", nrow=df)
df1<-df%>%
  select(date, region, country)  
df2<-df1%>%
  group_by(region,date)%>%
  summarise(dailycases=sum(country=="Senegal"))%>%
  mutate(casicum=cumsum(dailycases))
df2$state<-rep("Senegal", nrow=df2)
df2$note<-rep("NA", nrow=df2)
df2<-df2%>%
  select(state, date,region,dailycases, note) %>%
  rename(site=region) 

head(df2)

write.csv(df2,'csv/Senegal.csv')

####### ALGERIA #######

df = read_csv('https://raw.githubusercontent.com/dsfsi/covid19africa/master/data/line_lists/line-list-algeria.csv')

df$"province/state"<-as.factor(df$"province/state")
df$date <- as.Date(df$date, format = "%y-%m-%d")
df1<-df%>%
  select(date,`province/state`,country)  
df2<-df1%>%
  group_by(`province/state`,date)%>%
  summarise(dailycases=sum(country=="Algeria"))%>%
  mutate(casicum=cumsum(dailycases))
df2$state<-rep("Algeria", nrow=df2)
df2$note<-rep("NA", nrow=df2)
df2<-df2%>%
  select(state, date,`province/state`,dailycases, note) %>%
  rename(site=`province/state`) 
head(df2)

write.csv(df2,'csv/Algeria.csv')


####### SOUTH AFRICA #######

df = read_csv(('https://raw.githubusercontent.com/dsfsi/covid19za/master/data/covid19za_provincial_cumulative_timeline_confirmed.csv'))
df$date <- as.Date(df$date, format = "%d-%m-%Y")
df <- df[!is.na(df$WC), ]

df2 <- df %>%
  gather(key='nazione', value='casi', `EC`:`WC`) %>%
  group_by(nazione) %>%
  arrange(nazione, date) %>%
  select(date, nazione, casi) %>%
  mutate(dailycases=casi-lag(casi))%>%
  mutate(dailycases=case_when(is.na(dailycases)~casi, TRUE ~ dailycases ))

df2$state<-rep("South Africa", nrow=df2)
df2$note<-rep("NA", nrow=df2)
df2 <- df2 %>%
  select(state,date, nazione,dailycases, note) %>%
  rename(site=nazione) 

head(df2)

write.csv(df2,'csv/South_Africa.csv')

### RBIND ###

library(plyr)
library(readr)

csv_dir = "csv/"
csv_files = list.files(path=csv_dir, pattern="*.csv", full.names=TRUE)

Africa = ldply(csv_files, read_csv)
Africa <- Africa[,-1]

write.csv(Africa,'africa.csv')
