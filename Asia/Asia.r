setwd("~/covid19_regional/Asia/")

library('tidyverse')
library('reticulate')

############ THAI ############

df = read_csv('raw_thai.csv')
df$date <- as.Date(df$ANN.DATE,format="%Y/%m/%d")
df$state<-rep("Thai", nrow=df) 
df <- df %>%
  select(date, PR.ISOL, state)
df <- df[!is.na(df$date), ]

df2 <- df %>%
  group_by(PR.ISOL, date) %>%
  summarise(dailycases=sum(state=="Thai"))%>%
  mutate(casicum=cumsum(dailycases))

df2$state<-rep("Thai", nrow=df2)
df2$note<-rep("NA", nrow=df2) 
df2<-df2%>%
  select(state, date,PR.ISOL,dailycases, note)%>%
  rename(site=PR.ISOL) 
head(df2)

write.csv(df2,'csv/Thai.csv')

############ KOREA ############
df = read_csv('raw_korea.csv')
df$date <- as.Date(as.character(df$date_report),format="%Y-%m-%d")
df$state<-rep("Korea", nrow=df) 
head(df)
df2 <- df %>%
  gather(key='site', value= 'dailycases', `Daegu`:`Jeju-do`)%>% 
  group_by(site) %>%
  arrange(site, date) %>%
  select (state, date, site, dailycases)

df2 <- df2[!is.na(df2$dailycases), ]
df2$dailycases <- as.numeric(df2$dailycases)
df2$note<-rep("NA", nrow=df2) 
head(df2)
write.csv(df2,'csv/Korea.csv')


############ CHINA ############

df <- read_csv("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/who_covid_19_situation_reports/who_covid_19_sit_rep_time_series/who_covid_19_sit_rep_time_series.csv")
df <- slice(df, 6:39)
df$state<-rep("China", nrow=df) 

df2 <- df %>%
  gather(key='date', value= 'casi', `1/21/20`:`8/16/20`)%>% 
  group_by(`Province/States`) %>%
  select (state, date, `Province/States`, casi) %>%
  rename(site=`Province/States`)
df2 <- df2[!is.na(df2$casi), ]
df2$date <- as.Date(df2$date, format = "%m/%d/%Y")
df2$casi <- as.numeric(df2$casi)
df2$note<-rep("NA", nrow=df2) 
df2 <- df2 %>%
  group_by(site) %>%
  arrange(site,date) %>%
  mutate(dailycases=casi-lag(casi))%>%
  mutate(dailycases=case_when(is.na(dailycases)~casi, TRUE ~ dailycases )) %>%
  select(state,date,site, dailycases, note)

df2 <- df2[!is.na(df2$dailycases), ]
write.csv(df2,'csv/China.csv')

############ MALAYSIA ############

df = read_csv('https://raw.githubusercontent.com/ynshung/covid-19-malaysia/master/covid-19-my-states-cases.csv')
df$date <- as.Date(df$date, format = "%d/%m/%Y")
df$state<-rep("Malaysia", nrow=df) 

df2 <- df %>%
  gather(key='site', value= 'casi', `perlis`:`wp-labuan`)%>% 
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

write.csv(df2,'csv/Malasya.csv')

############ JAPAN ############

df = read_csv('https://raw.githubusercontent.com/swsoyee/2019-ncov-japan/master/50_Data/byDate.csv')
df$date <- as.Date(as.character(df$date),format="%Y%m%d")
df$state<-rep("Japan", nrow=df) 


df2 <- df %>%
  gather(key='site', value= 'dailycases', `北海道`:`クルーズ船`)%>% 
  group_by(site, date) %>%
  select(state, date, site, dailycases)

df2 <- df2[!is.na(df2$dailycases), ]
df2$note<-rep("NA", nrow=df2) 
head(df2)

write.csv(df2,'csv/Japan.csv')



############ INDONESIA ############


df = read_csv('raw_indo.csv')
df$date <- as.Date(df$Date,format="%Y-%m-%d")
#view(df)
df$state<-rep("Indonesia", nrow=df) 

df2 <- df %>%
  gather(key='site', value= 'total_count', `Aceh`:`Gorontalo`)%>% 
  group_by(site) %>%
  arrange(site, date)%>%
  mutate(dailycases=total_count-lag(total_count))%>%
  mutate(dailycases=case_when(is.na(dailycases)~total_count, TRUE ~ dailycases )) %>%
  select(state, date,site, dailycases)
df2$note<-rep("NA", nrow=df2) 

write.csv(df2,'csv/Indonesia.csv')

############ SINGAPORE ############


# df = read_csv('https://raw.githubusercontent.com/jaabberwocky/covid-19-singapore-dash/master/data/total-cases-new/latest_data.csv')
# df$date <- as.Date(as.character(df$Date),format="%d/%m/%Y")
# df$state<-rep("Singapore", nrow=df) 
# df$site<-rep("Singapore", nrow=df) 
# 
# head(df)
# 
# df2 <- df %>%
#   select (state, date, site, Value) %>%
#   rename (dailycases = Value)
# df2
# 
# write.csv(df2,'csv/Singapore.csv')





#### MERGE

library(plyr)
library(readr)
csv_dir = "csv/"
csv_files = list.files(path=csv_dir, pattern="*.csv", full.names=TRUE)

Asia = ldply(csv_files, read_csv)
Asia <- Asia[,-1]

write.csv(Asia,'Asia.csv')

detach("package:tidyverse", unload=TRUE)
detach("package:plyr", unload=TRUE)

#####################

py_run_file("asia_convert.py")
