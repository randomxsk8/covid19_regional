setwd("~/covid19_regional/North America/")
library('tidyverse')

############## USA ##############À

df = read_csv('https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-states.csv')
df$date <- as.Date(as.character(df$date),format="%Y-%m-%d")
df$nat<-rep("United States of America", nrow=df) 
head(df)

df2 <- df %>%
  group_by(state) %>%
  arrange(state, date)%>%
  mutate(dailycases=cases-lag(cases))%>%
  mutate(dailycases=case_when(is.na(dailycases)~cases, TRUE ~ dailycases )) %>%  
  select(nat, date,state, dailycases) %>%
  rename(site=state, state=nat)
df2$note<-rep("NA", nrow=df2) 
write.csv(df2,'csv/Usa.csv')



############## CANADA ##############À


df = read_csv('https://github.com/ishaberry/Covid19Canada/blob/master/cases.csv?raw=true')

df$province<-as.factor(df$province)
df$date <- as.Date(df$date_report, format = "%d-%m-%y")
df<-df%>%
  select(date, province, country)  
df2<-df%>%
  group_by(province,date)%>%
 summarise(dailycases=sum(country=="Canada"))%>%
  mutate(casicum=cumsum(dailycases))
df2$state<-rep("Canada", nrow=df2)
df2$note<-rep("NA", nrow=df2)
df2<-df2%>%
  select(state, date,province,dailycases, note)%>%
  rename(site=province) 

write.csv(df2,'csv/Canada.csv')

#### Merge ########

library(plyr)
library(readr)
csv_dir = "csv/"
csv_files = list.files(path=csv_dir, pattern="*.csv", full.names=TRUE)

na = ldply(csv_files, read_csv)
na <- na[,-1]

write.csv(na,'na.csv')












