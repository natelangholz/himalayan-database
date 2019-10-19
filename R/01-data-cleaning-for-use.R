pacman::p_load(foreign,magrittr,dplyr,feather,readr)

#Nepal Himalaya
#468 peaks
#no lat long of peaks???
peaks <- read.dbf("Himalayan Database/HIMDATA/peaks.DBF")


###########################################################
#geocode for lat long

#mountain_long_lat <- NULL
#for(i in 1:dim(peaks)[1]){
  #mountain_long_lat <- rbind(mountain_long_lat,geocode(paste0(peaks$PKNAME[i],', Nepal')))
#[ ]}

#some are obviously wrong

#save(mountain_long_lat,file = 'mountain_long_lat.Rdata')
load('mountain_long_lat.Rdata')

peaks %<>% mutate(lat = mountain_long_lat$lat, lon = mountain_long_lat$lon)



###########################################################
#lets try to fix some of that geocoding...
peaks %<>% arrange(desc(HEIGHTM))


#8000M main summits
peaks %<>%
  mutate(MSUMMIT8K = if_else(PEAKID %in% c("EVER","KANG","LHOT","MAKA","CHOY","DHA1","MANA","ANN1"),1,0))

peaks %>% filter(lon < 0) %>% select(PEAKID,PKNAME,lat,lon,HEIGHTM)

#Domo...Jongsong east peak
#27.881476, 88.135732 #this is for Jongsong
peaks[peaks$PEAKID=="DOMO",c('lat','lon')] <- c(27.881476, 88.135732)

#Glacier Dome aka Tarke Kang; google search, peakbagger.com
#28.606743, 83.889495
peaks[peaks$PEAKID=="GLAC",c('lat','lon')] <- c(28.606743, 83.889495)

#junction peak, peakbagger.com
#27.949388, 86.983059
peaks[peaks$PEAKID=="JUNC",c('lat','lon')] <- c(27.949388, 86.983059)

#guras peak
#dunno

#pemthang ri
#langtang region

#nap 1-3, south
#unknown; can't find

#langmoche ri
#can't find

#mansail
#mustang

#Mingbo Ri
#27.845, 86.822...maybe?
peaks[peaks$PEAKID=="MING",c('lat','lon')] <- c(27.845, 86.822)

#amphu midldle
#27.871033, 86.955577 #this is just amphu (not middle)
peaks[peaks$PEAKID=="AMPM",c('lat','lon')] <- c(27.871033, 86.955577)

#dragmorpa ri
#can't find; langtang

#jabou ri
#can't find

#bhemdang ri (morimoto)
#28.273,85.6676
peaks[peaks$PEAKID=="BHEM",c('lat','lon')] <- c(28.273,85.6676)

#tawa
#can't find

peaks[which(peaks$lon < 0),c('lat','lon')] <- c(NA, NA)

#6 not in Nepal
#Sano Kailash; correct in china
#Lasa-- Is this Island Peak???? Or just generally LLhasa?
peaks[peaks$PEAKID=="LASA",c('lat','lon')] <- c(NA, NA)
#Mariyang; not sure--both in china/bhutan??
peaks[peaks$PEAKID=="MARI",c('lat','lon')] <- c(NA, NA)
#Mariyang West; not sure--can't find real coords
peaks[peaks$PEAKID=="MARW",c('lat','lon')] <- c(NA, NA)
#Bhairab Takura; again no idea
peaks[peaks$PEAKID=="BTAK",c('lat','lon')] <- c(NA, NA)
#Patrasi Himal; not clear
peaks[peaks$PEAKID=="PATR",c('lat','lon')] <- c(NA, NA)
#Tongu; somewhere near dhaluagari but no lat long
peaks[peaks$PEAKID=="TONG",c('lat','lon')] <- c(NA, NA)

#at least they're all in Nepal region...maybe off but close enough for now
write_feather(peaks,path = "data/peaks.feather")
write_csv(peaks,path = "data/peaks.csv")


###########################################################

#member records
#no unique id by person...must create
members <- read.dbf("Himalayan Database/HIMDATA/members.DBF")

#not sure what MEMBID is?? expedition member number? 
members %>% filter(LNAME =='Horrell')
#Jimmy Chin
members %>% filter(LNAME =='Chin')
#Jon Krakauer
members %>% filter(LNAME =='Krakauer')
#Alan Arnette
members %>% filter(LNAME =='Arnette')
#Ed Viesturs
members %>% filter(LNAME =='Viesturs')
#Jim Whittaker
members %>% filter(LNAME =='Whittaker')
#Ted Wheeler
members %>% filter(LNAME =='Wheeler')
#Colin O'Brady
members %>% filter(LNAME =="O'Brady")
#Reinhold Messner
members %>% filter(LNAME =="Messner")
#Conrad ANker
members %>% filter(LNAME =="Anker")
#Adrian Ballinger
members %>% filter(LNAME =="Ballinger")
#Killian Jornet ???
members %>% filter(LNAME =="Jornet Burgada")
#Ueli Steck
members %>% filter(LNAME =="Steck")
#Renan Ozturk
members %>% filter(LNAME =="Ozturk")

#unique id by first name,last name, and year of birth; looks like it works
#what should I do with unknown and Pasang Sherpa...they have different attributes
members %<>% 
  mutate(CLIMBERID = group_indices(.,FNAME,LNAME,YOB)) 

sort(table(members$CLIMBERID),decreasing = TRUE)

members %>% filter(CLIMBERID %in% c(37032,29639,25506,12009,26073)) %>% View()

write_feather(members, path = "data/members.feather")
write_csv(members,path = "data/members.csv")


###########################################################
#expedition records
#9959 expeditions; warnings..not sure what they mean
exped <- read.dbf("Himalayan Database/HIMDATA/exped.DBF")
write_feather(exped, path = "data/exped.feather" )
write_csv(exped,path = "data/exped.csv")


#literature records; where are the actual notes??
refer <- read.dbf("Himalayan Database/HIMDATA/refer.DBF")
write_feather(refer, path = "data/refer.feather")
write_csv(refer,path = "data/refer.csv")


#nothing??
filters <- read.dbf("Himalayan Database/HIMDATA/filters.DBF")
