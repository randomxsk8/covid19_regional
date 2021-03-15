import pandas as pd
import fuzzymatcher
import numpy as np
import warnings
warnings.filterwarnings("ignore", 'This pattern has match groups')

print ("############# SOUTH AMERICA ALIGNMENT ###############")

sa_df = pd.read_csv("csv_final/pre_build/south_america.csv", sep =",", engine='python').drop(['Unnamed: 0'], axis=1)
sa_df.head()

sa_df = sa_df[sa_df['site'].notna()]
sa_df = sa_df[sa_df.site != 'no-data']
sa_df = sa_df[sa_df.site != 'Desconiscido']
sa_df = sa_df[sa_df.site != 'OHiggins']
sa_df = sa_df[sa_df.site != 'No disponible']
sa_df = sa_df[sa_df.site != 'Lim�n']
sa_df = sa_df[sa_df.site != 'Desconocida']
sa_df = sa_df[sa_df.site != 'Centro-Oeste']
sa_df = sa_df[sa_df.site != 'Sul']
sa_df = sa_df[sa_df.site != 'Norte']
sa_df = sa_df[sa_df.site != 'Sudeste']
sa_df = sa_df[sa_df.site != 'Nordeste']
sa_df = sa_df[sa_df.state != 'Puerto Rico']


di = {"Artemisa":"Ciudad de la Habana",'BARRANQUILLA D.E.':'Atlántico', 'BOGOTÁ D.C.':'Cundinamarca', 'BUENAVENTURA D.E':'Valle del Cauca',
     'CARTAGENA D.T. Y C':'Bolívar', 'SAN ANDRÉS':'San Andrés y Providencia', 'SANTA MARTA D.T. Y C.':'Magdalena',
     'capital-federal':'Ciudad de Buenos Aires'}
sa_df = sa_df.replace({"site": di})
sa_df.head()
sa_df = sa_df.replace({"site": di})

code_2_df = pd.read_csv("gadm36_repo/gadm36_code_2.csv", sep=";")
code_2_df = code_2_df[code_2_df.country != 'Pakistan']
code_2_df = code_2_df[code_2_df.country != 'Nigeria']


left_on = ["state","site"]
# Columns to match on from df_right
right_on = ["country", "region_name"]


df_match = fuzzymatcher.fuzzy_left_join(sa_df, code_2_df, left_on, right_on)

df_match['new_site'] = df_match['region_name']


new_df = df_match[["state","date","region_name", "dailycases", "note", "CODE_2"]]
new_df = new_df.reset_index(drop=True)

new_df.to_csv("csv_final/south_america.csv")

print ("\n Ok... \n Done. \n")

############################

print ("############# OCEANIA ALIGNMENT ###############")

oc_df = pd.read_csv("csv_final/pre_build/Oceania.csv", sep =",", engine='python').drop(['Unnamed: 0'], axis=1)

di = {"ACT":"Australian Capital Territory", "NSW":"New South Wales", "NT":"Northern Territory", "QLD":"Queensland", "SA":"South Australia", "TAS":"Tasmania","VIC":"Victoria","WA":"Western Australia"}

oc_df = oc_df.replace({"site": di})

left_on = ["state","site"]
# Columns to match on from df_right
right_on = ["country","region_name"]

df_match = fuzzymatcher.fuzzy_left_join(oc_df, code_2_df, left_on, right_on)


new_df = df_match[["state","date","region_name", "dailycases", "note", "CODE_2"]]
new_df = new_df.reset_index(drop=True)

new_df.to_csv("csv_final/oceania.csv")

print ("\n Ok... \n Done. \n")

##############################

print ("############# AFRICA ALIGNMENT ###############")

code_2_df = pd.read_csv("gadm36_repo/gadm36_code_2.csv", sep=";")

af_df = pd.read_csv("csv_final/pre_build/Africa.csv", sep =",", engine='python').drop(['Unnamed: 0'], axis=1)

af_df = af_df[af_df['site'].notna()]

di = {'Abuja':'Federal Capital Territory', 'EC':'Eastern Cape', 'FS':'Free State', 'GP':'Gauteng', 
      'KZN':'KwaZulu-Natal','LP':'Limpopo','MP':'Mpumalanga','NC':'Northern Cape','NW':'North West',
      'WC':'Western Cape'
     }

af_df = af_df.replace({"site": di})

left_on = ["state","site"]

right_on = ["country", "region_name"]

df_match = fuzzymatcher.fuzzy_left_join(af_df, code_2_df, left_on, right_on)

new_df = df_match[["state","date","region_name", "dailycases", "note", "CODE_2"]]
new_df = new_df.reset_index(drop=True)

new_df.to_csv("csv_final/africa.csv")
print ("\n Ok... \n Done. \n")

print ("############# ASIA ALIGNMENT ###############")

as_df = pd.read_csv("csv_final/pre_build/Asia.csv", sep =",", engine='python').drop(['Unnamed: 0'], axis=1)
as_df = as_df[as_df['site'].notna()]
as_df = as_df[as_df.site != 'Qarantina']
as_df = as_df[as_df.site != 'Charter voli']
as_df = as_df[as_df.site != 'Cruise Ship']
as_df = as_df[as_df.site != '???????']
as_df = as_df[as_df.site != 'Sisaket']
as_df = as_df[as_df.site != 'DIY']
as_df = as_df[as_df.site != 'Singapore']


di = {'Babel':'Bangka Belitung','Jateng':'Jawa Tengah', 'Jatim':'Jawa Timur', 'Jabar':'Jawa Barat', 
      'Kalbar':'Kalimantan Barat','Kalsel':'Kalimantan Selatan', 'Kaltara':'Kalimantan Utara', 
      'Kalteng':'Kalimantan Tengah', 'Kaltim':'Kalimantan Timur', 'Kep Riau':'Kepulauan Riau',
      'Malut':'Maluku Utara', 'NTB':'Nusa Tenggara Barat', 'NTT':'Nusa Tenggara Timur',
      'Papbar':'Papua Barat', 'Sulbar':'Sulawesi Barat','Sulsel':'Sulawesi Selatan', 'Sulteng':'Sulawesi Selatan',
      'Sulteng':'Sulawesi Tengah','Sultra':'Sulawesi Tenggara','Sulut':'Sulawesi Utara',
      'Sumbar':'Sumatera Barat','Sumsel':'Sumatera Selatan','Sumut':'Sumatera Utara',
      'Chonburi':'Chon Buri','Prachinburi':'Prachin Buri','Phang Nga':'Phangnga','Lopburi':'Lop Buri',
      'Suphanburi':'Suphan Buri','Nongbua Lamphu':'Nong Bua Lam Phu'    
     }

as_df = as_df.replace({"site": di})

left_on = ["state","site"]
right_on = ["country", "region_name"]
df_match = fuzzymatcher.fuzzy_left_join(as_df, code_2_df, left_on, right_on)

new_df = df_match[["state","date","region_name", "dailycases", "note", "CODE_2"]]
new_df = new_df.reset_index(drop=True)


new_df.to_csv("csv_final/asia.csv")
print ("\n Ok... \n Done. \n")

print ("############# MIDDLE EAST ALIGNMENT ###############")

mes_df = pd.read_csv("csv_final/pre_build/mes.csv", sep =",", engine='python').drop(['Unnamed: 0'], axis=1)
mes_df = mes_df[mes_df.state != 'Afghanistan']
#mes_df = mes_df[mes_df.state != 'Lebanon']
#mes_df = mes_df[mes_df.state != 'Qatar']
#mes_df = mes_df[mes_df.state != 'Bahrain']
mes_df = mes_df[mes_df.state != 'United Arab Emirates']
mes_df = mes_df[mes_df.state != 'Beitar Illit']
mes_df = mes_df[mes_df.state != "Modi'in Illit"]
mes_df = mes_df[mes_df['site'].notna()]

di = {'AJK':'Azad Kashmir','BALOCHISTAN':'Baluchistan', 'GB':'Northern Areas','ISLAMABAD':'F.C.T.', 
      'KP':'N.W.F.P.','SINDH':'Sind','Ashdod':'HaDarom','Ashkelon':'HaDarom','Bat Yam':'Tel Aviv',
      "Be'er Sheva":'HaDarom','Beit Shemesh':'Jerusalem','Bnei Brak':'Tel Aviv',"El'ad":'HaMerkaz',
      'Herzliya':'Tel Aviv', 'Holon':'Tel Aviv', "Kiryat Ye'arim":'Jerusalem', 'Migdal Haemek':'HaZafon',
      "Modi'in-Maccabim-Re'ut":'HaMerkaz','Netanya': 'HaMerkaz','Or Yehuda':'Tel Aviv','Petah Tikva':'HaMerkaz',
      "Ra'anana":'HaMerkaz','Ramat Gan':'Tel Aviv', 'Rishon Lezion':'Teal Aviv', 'Tel Aviv - Yafo':'Tel Aviv',
      'Tiberias':'HaZafon'    
}

mes_df = mes_df.replace({"site": di})
df2_code = code_2_df[code_2_df['country'].isin(['India', 'Israel','Pakistan'])]
left_on = ["state","site"]
right_on = ["country", "region_name"]
df_match = fuzzymatcher.fuzzy_left_join(mes_df, df2_code, left_on, right_on)
new_df = df_match[["state","date","region_name", "dailycases", "note", "CODE_2"]]
new_df = new_df.reset_index(drop=True)

new_df.to_csv("csv_final/mes.csv")
print ("\n Ok... \n Done. \n")

print ("############# EUROPE ALIGNMENT ###############")

nuts_df = pd.read_csv('gadm36_repo/GADM_NUTS_names_dictionary.csv', sep = ';')
europe_df = pd.read_csv('csv_final/pre_build/Europe.csv', sep=",")

# ## Germany

df_ger_cod = nuts_df[nuts_df.NAME_0 == 'Germany']
df_ger_cod = df_ger_cod[["CODE_1","NUTS_2","NUTS_3","NUTS_L2_name"]].drop_duplicates()
df_ger_nos = europe_df[europe_df.state == 'Deutschland'].rename(columns={"note": "NUTS_3"})
final_df_ger =  pd.merge(df_ger_nos, df_ger_cod, on='NUTS_3')
final_df_ger = final_df_ger[["state","date","NUTS_L2_name","dailycases","NUTS_2"]]

# ## Italy

df_ita_cod = nuts_df[nuts_df.NAME_0 == 'Italy']
df_ita_cod=df_ita_cod[["CODE_1","NUTS_2", "NUTS_L2_name","region_name"]].drop_duplicates()
df_ita_nos = europe_df[europe_df.state == 'Italy'].rename(columns={"site": "region_name"})
final_df_ita =  pd.merge(df_ita_nos, df_ita_cod, on='region_name').drop_duplicates()
final_df_ita = final_df_ita[["state","date","NUTS_L2_name","dailycases","NUTS_2"]]
final_df_ita = final_df_ita[final_df_ita['NUTS_L2_name'].notna()]

# ## Spain
df_spa_cod = nuts_df[nuts_df.NAME_0 == 'Spain']
df_spa_cod = df_spa_cod[["CODE_1","NUTS_2", "NUTS_L2_name","NUTS_L3_name"]].drop_duplicates()
df_spa_nos = europe_df[europe_df.state == 'Spain'].rename(columns={"site": "NUTS_L3_name"})
di = {'Alicante':'Alicante / Alacant','Araba':'Araba/Álava','Castellón':'Castellón / Castelló','Palmas, Las':'La Palma',
     'Santa Cruz de Tenerife':'Tenerife','Valencia':'Valencia / València'}
df_spa_nos = df_spa_nos.replace({"NUTS_L3_name": di})
final_df_spa =  pd.merge(df_spa_nos, df_spa_cod, on='NUTS_L3_name')
final_df_spa=final_df_spa[["state","date","NUTS_L2_name","dailycases","NUTS_2"]]

# ## France
# presenti anche colonie: guyana, martinica e mayotte
#df_fra_cod = nuts_df[nuts_df.NAME_0 == 'France']
#df_fra_cod = df_fra_cod[["CODE_1","NUTS_2", "NUTS_L2_name","NUTS_L3_name"]].drop_duplicates()
#df_fra_nos = europe_df[europe_df.state == 'France'].rename(columns={"site": "NUTS_L3_name"})
#final_df_fra =  pd.merge(df_fra_nos, df_fra_cod, on='NUTS_L3_name')
#final_df_fra=final_df_fra[["state","date","NUTS_L2_name","dailycases","NUTS_2"]]
#final_df_fra.head()

# ## Uk

df_uk_cod = nuts_df[nuts_df.NAME_0 == 'United Kingdom']
df_uk_cod = df_uk_cod[["CODE_1","NUTS_2","NAME_2","NUTS_L3_name"]].drop_duplicates()
df_uk_nos = europe_df[europe_df.state == 'United Kingdom'].rename(columns={"site": "NAME_2"})
df_uk_nos = df_uk_nos[df_uk_nos['dailycases'].notna()]
di = {'Bedford':'Bedfordshire', 'Borders':'Scottish Borders', 'Bristol, City of':'Bristol', 
      'City of London':'Greater London','Greater Glasgow and Clyde' : 'Glasgow',   
      'Herefordshire, County of':  'Herefordshire',
      'Kingston upon Hull, City of':  'Kingston upon Hull',
      'Orkney': 'Orkney Islands', 'Swansea Bay': 'Swansea',
     }
df2 = df_uk_nos.replace({"NAME_2":di})
final_df_uk =  pd.merge(df2, df_uk_cod, on='NAME_2').rename(columns={"NAME_2": "NUTS_L2_name"})
final_df_uk = final_df_uk[["state","date","NUTS_L2_name","dailycases","NUTS_2"]]

# ## Netherlands

df_net_cod = nuts_df[nuts_df.NAME_0 == 'Netherlands']
df_net_cod = df_net_cod[["CODE_1","NUTS_2","NAME_2","NUTS_L2_name","NUTS_L3_name"]].drop_duplicates()
df_net_nos = europe_df[europe_df.state == 'Netherlands'].rename(columns={"site": "NAME_2"})
di = {'Bergen(L.)':'Bergen', 'Bergen(NH.)':'Bergen', 'Bodegraven-Reeuwijk':'Bodegraven', 'Dantumadiel':'Dantumadeel',
     'Eijsden-Margraten':'Eijsden','Geldrop-Mierlo':'Geldrop', 'Rijssen-Holten':'Rijssen'}
df_net_nos = df_net_nos.replace({"NUTS_L3_name":di})
final_df_net =  pd.merge(df_net_nos, df_net_cod, on='NAME_2')
final_df_net=final_df_net[["state","date","NUTS_L2_name","dailycases","NUTS_2"]]


# ## Norway
# Vest Agder e Aust Ager su nuts3 ma non sul nostro
df_nor_cod = nuts_df[nuts_df.NAME_0 == 'Norway']
df_nor_cod = df_nor_cod[["CODE_1","NUTS_2", "NUTS_L2_name","NUTS_3", "NUTS_L3_name"]].drop_duplicates()
df_nor_nos = europe_df[europe_df.state == 'Norway'].rename(columns={"site": "NUTS_L3_name"})
di = {'Hedmark':"Innlandet", "Oppland":"Innlandet", "Aust-Agder":"Agder", "Vest-Agder":"Agder",
     "Troms":"Troms og Finnmark", "Finnmark":"Troms og Finnmark", 'Sør-Trøndelag':'Trøndelag', 'Nord-Trøndelag':'Trøndelag',
     'Vestfold':'Vestfold og Telemark','Telemark':'Vestfold og Telemark', 'Hordaland':'Vestland','Sogn og Fjordane':'Vestland',
     'Akershus':'Viken','Aust-Agder':'Agder', 'Vest-Agder':'Agder'}
df2 = df_nor_cod.replace({"NUTS_L3_name":di})
di2 = {'NO041':"NO041+NO042", 'NO042':"NO041+NO042",
       "NO072":'NO072+NO073', 'NO073':'NO072+NO073',
       "NO051":"NO051+NO052", "NO052":"NO051+NO052",
       'NO022':'NO022+NO021', 'NO021':'NO022+NO021',
       'NO034':'NO034+NO033', 'NO033':'NO034+NO033',
      }
df3 = df2.replace({"NUTS_3":di2}).drop_duplicates()
final_df_nor =  pd.merge(df_nor_nos, df3, on='NUTS_L3_name')
final_df_nor = final_df_nor[["state","date","NUTS_L2_name","dailycases","NUTS_2"]]

# ## Austria
df_aus_cod = nuts_df[nuts_df.NAME_0 == 'Austria']
df_aus_cod = df_aus_cod[["CODE_1","NUTS_2" ,"NUTS_L2_name"]]
df_aus_nos = europe_df[europe_df.state == 'Austria'].rename(columns={"site": "NUTS_L2_name"})

di = {'B':'Burgenland','Noe':'Niederösterreich','Ooe':'Oberösterreich','Stmk':'Steiermark',
     'Szbg':'Salzburg','T':'Tirol','V':'Vorarlberg','W':'Wien'}
df_aus_nos = df_aus_nos.replace({"NUTS_L2_name":di})
final_df_aus =  pd.merge(df_aus_nos, df_aus_cod, on='NUTS_L2_name').drop_duplicates()
final_df_aus = final_df_aus[["state","date","NUTS_L2_name","dailycases","NUTS_2"]]

###### Romania
df_rom_cod = nuts_df[nuts_df.NAME_0 == 'Romania']
df_rom_cod = df_rom_cod[["CODE_1","NUTS_2","NAME_1","NUTS_L2_name"]].drop_duplicates()
df_rom_nos = europe_df[europe_df.state == 'Romania'].rename(columns={"site": "NAME_1"})
di = {'Mun. București':'Bucharest'}
df_rom_nos = df_rom_nos.replace({"NAME_1": di})
final_df_rom =  pd.merge(df_rom_nos, df_rom_cod, on='NAME_1')
final_df_rom = final_df_rom[["state","date","NUTS_L2_name","dailycases","NUTS_2"]]
# ## Sweden

df_swe_cod = nuts_df[nuts_df.NAME_0 == 'Sweden']
df_swe_cod = df_swe_cod[["CODE_1","NUTS_2" ,"NUTS_L2_name","NUTS_3" ,"NUTS_L3_name"]]
df_swe_nos = europe_df[europe_df.state == 'Sweden'].rename(columns={"site": "NUTS_L3_name"})
df_swe_nos = df_swe_nos[df_swe_nos['NUTS_L3_name'].notna()]
df_swe_nos = df_swe_nos[df_swe_nos['date'].notna()]
df_swe_nos = df_swe_nos[df_swe_nos['dailycases'].notna()]
di = {'Stockholm':'Stockholms län','Blekinge':'Blekinge län', 'Dalarna':'Dalarnas län',
     'Gävleborg':'Gävleborgs län','Gotland':'Gotlands län', 'Halland':'Hallands län',
     'Jämtland':'Jämtlands län','Jönköping':'Jönköpings län', 'Kronoberg':'Kronobergs län',
     'Norrbotten':'Norrbottens län', 'Örebro':'Örebro län', 'Östergötland':'Östergötlands län',
     'Skåne':'Skåne län','Sörmland':'Södermanlands län','Uppsala':'Uppsala län','Värmland':'Värmlands län',
     'Västerbotten':'Västerbottens län','Västernorrland':'Västernorrlands län','Västmanland':'Västmanlands län',
     'Västra Götaland':'Västra Götalands län'}
df_swe_nos = df_swe_nos.replace({"NUTS_L3_name": di})
final_df_swe =  pd.merge(df_swe_nos, df_swe_cod, on='NUTS_L3_name').drop_duplicates().reset_index()
final_df_swe = final_df_swe[["state","date","NUTS_L2_name","dailycases","NUTS_2"]]
final_df_swe

# ## Czech Republic

df_cze_cod = nuts_df[nuts_df.NAME_0 == 'Czech Republic']
df_cze_cod = df_cze_cod[["CODE_1","NUTS_2" ,"NUTS_L2_name","NUTS_3" ,"NUTS_L3_name"]].drop_duplicates()
df_cze_nos = europe_df[europe_df.state == 'Czech Republic'].rename(columns={"site": "NUTS_3"})
final_df_cze =  pd.merge(df_cze_nos, df_cze_cod, on='NUTS_3')
final_df_cze = final_df_cze[["state","date","NUTS_L2_name","dailycases","NUTS_2"]]

# ## Poland

df_pol_cod = nuts_df[nuts_df.NAME_0 == 'Poland']
df_pol_cod = df_pol_cod[["CODE_1","NUTS_2" ,"NUTS_L2_name","NAME_2"]].drop_duplicates()
df_pol_cod = df_pol_cod[~df_pol_cod.NAME_2.str.contains("(City)")]
df_pol_cod = df_pol_cod[~df_pol_cod.NAME_2.str.contains("(CIty)")]
df_pol_nos = europe_df[europe_df.state == 'Poland'].rename(columns={"site": "NAME_2"})
di = {'AleksandrówKujawski': 'Aleksandrów', 'AleksandrówŁódzki':'Aleksandrów',
     'BielskoBiała':'Bielsko','BielskPodlaski':'Bielsk'}
df_pol_nos = df_pol_nos.replace({"NAME_2": di})
final_df_pol =  pd.merge(df_pol_nos, df_pol_cod, on='NAME_2')
final_df_pol = final_df_pol[["state","date","NUTS_L2_name","dailycases","NUTS_2"]]
final_df_pol = final_df_pol[final_df_pol['NUTS_L2_name'].notna()]


# ## Luxembourg

df_lux_cod = nuts_df[nuts_df.NAME_0 == 'Luxembourg']
df_lux_cod = df_lux_cod[["CODE_1", "NAME_1", "region_name"]].drop_duplicates()
df_lux_nos = europe_df[europe_df.state == 'Luxembourg'].rename(columns={"site": "NAME_1"})
df_lux_nos['NUTS_L2_name']=df_lux_nos['note']
final_df_lux =  pd.merge(df_lux_nos, df_lux_cod, on='NAME_1')
final_df_lux = (final_df_lux[["state","date","NUTS_L2_name","dailycases","note"]]).rename(columns={'note':'NUTS_2'})


# ## Belgium
df_bel_cod = nuts_df[nuts_df.NAME_0 == 'Belgium']
df_bel_cod=df_bel_cod[["CODE_1","CODE_2","NUTS_2", "NUTS_L2_name"]].drop_duplicates()
df_bel_nos = europe_df[europe_df.state == 'Belgium'].rename(columns={"site": "NUTS_L2_name"})
di = {'Antwerpen':'Prov. Antwerpen', 'Brabant Wallon': 'Prov. Brabant Wallon',
      'BrabantWallon': 'Prov. Brabant Wallon',
     'Brussels':'Région de Bruxelles-Capitale/ Brussels Hoofdstedelijk Gewest',
      'Hainaut':'Prov. Hainaut','Liège':'Prov. Liège','Limburg':'Prov. Limburg (BE)',
     'Luxembourg':'Prov. Luxembourg (BE)','Namur':'Prov. Namur','Oost-Vlaanderen':'Prov. Oost-Vlaanderen',
      'OostVlaanderen':'Prov. Oost-Vlaanderen','VlaamsBrabant':'Prov. Vlaams-Brabant',
     'Vlaams Brabant':'Prov. Vlaams-Brabant','West-Vlaanderen':'Prov. West-Vlaanderen',
     'WestVlaanderen':'Prov. West-Vlaanderen'}
df_bel_nos = df_bel_nos.replace({"NUTS_L2_name": di})
final_df_bel =  pd.merge(df_bel_nos, df_bel_cod, on='NUTS_L2_name')
final_df_bel = final_df_bel[["state","date","NUTS_L2_name","dailycases","NUTS_2"]]

# ## Ireland

df_ire_cod = nuts_df[nuts_df.NAME_0 == 'Ireland']
df_ire_cod=df_ire_cod[["CODE_1","CODE_2","NAME_1","NUTS_2", "NUTS_L2_name"]].drop_duplicates()
df_ire_nos = europe_df[europe_df.state == 'Ireland'].rename(columns={"site": "NAME_1"})
di = {'Laois':'Laoighis'}
df_ire_nos = df_ire_nos.replace({"NAME_1": di})
final_df_ire =  pd.merge(df_ire_nos, df_ire_cod, on='NAME_1')
final_df_ire = final_df_ire[["state","date","NUTS_L2_name","dailycases","NUTS_2"]]

# ## New Df

df_eu = [final_df_bel,final_df_cze,final_df_ger,final_df_aus, final_df_ita,final_df_ire, final_df_spa, final_df_uk, final_df_net,final_df_rom, final_df_nor, final_df_swe, final_df_pol, final_df_lux]
df_final_eu = pd.concat(df_eu,sort=True).reset_index(drop=True)
df_2 = (df_final_eu[["state","NUTS_L2_name","date","dailycases","NUTS_2"]]).sort_values('state').rename(columns={"NUTS_L2_name": "site"}).reset_index(drop=True)
df_2.to_csv("csv_final/Europe_Nuts2.csv")
print ("\n Ok... \n Done. \n")

print ("############# NORTH AMERICA ALIGNMENT ###############")

na_df = pd.read_csv('csv_final/pre_build/na.csv', sep=",")
na_df.head()


# -----------------------
# ## Canada

df_can_cod = nuts_df[nuts_df.NAME_0 == 'Canada']
df_can_cod= df_can_cod[["CODE_2","NAME_1"]].drop_duplicates()
df_can_nos = na_df[na_df.state == 'Canada'].rename(columns={"site": "NAME_1"})

di = {'BC':'British Columbia', 'NL':'Newfoundland and Labrador', 'NWT':'Northwest Territories',
     'PEI':'Prince Edward Island','Quebec':'Qu?bec'}
df_can_nos = df_can_nos.replace({"NAME_1": di})
final_df_can =  pd.merge(df_can_nos, df_can_cod, on='NAME_1')



# ## USA

df_usa_cod = nuts_df[nuts_df.CODE_1 == 'USA']
df_usa_cod= df_usa_cod[["CODE_2","NAME_1"]].drop_duplicates()
df_usa_nos = na_df[na_df.state == 'United States of America'].rename(columns={"site": "NAME_1"})
final_df_usa =  pd.merge(df_usa_nos, df_usa_cod, on='NAME_1')

df_na = [final_df_can, final_df_usa]
df_final_na = pd.concat(df_na,sort=True).reset_index(drop=True)
df_final_na = df_final_na[["state","NAME_1","date","dailycases","CODE_2"]].rename(columns={"NAME_1": "site"})
df_final_na.to_csv("csv_final/North_America_code2.csv")
print ("\n Ok... \n Done. \n")


#---------------------------------

sa_df = pd.read_csv("csv_final/south_america.csv", sep = ",").rename(columns={"region_name": "site", "CODE_2":"CODE_2 | NUTS_2"})
na_df = pd.read_csv("csv_final/North_America_code2.csv", sep = ",").rename(columns={"region_name": "site", "CODE_2":"CODE_2 | NUTS_2"})
af_df = pd.read_csv("csv_final/africa.csv", sep = ",").rename(columns={"region_name": "site", "CODE_2":"CODE_2 | NUTS_2"})
eu_df = pd.read_csv("csv_final/Europe_Nuts2.csv", sep = ",").rename(columns={"NUTS_2":"CODE_2 | NUTS_2"})
mes_df = pd.read_csv("csv_final/mes.csv", sep = ",").rename(columns={"region_name": "site", "CODE_2":"CODE_2 | NUTS_2"})
oce_df = pd.read_csv("csv_final/oceania.csv", sep = ",").rename(columns={"region_name": "site", "CODE_2":"CODE_2 | NUTS_2"})
as_df = pd.read_csv("csv_final/asia.csv", sep = ",").rename(columns={"region_name": "site", "CODE_2":"CODE_2 | NUTS_2"})
df = [sa_df, na_df, oce_df, af_df, eu_df, mes_df, as_df]
df_final = pd.concat(df,sort=True).reset_index(drop=True)
df_final = df_final[["state", "date", "site", "dailycases","CODE_2 | NUTS_2"]]
df_final = df_final[(df_final['dailycases']>=0)]
df_final=df_final.reset_index(drop=True)
df_final.to_csv("csv_final/World_cases_by_region.csv")

