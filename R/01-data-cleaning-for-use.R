pacman::p_load(foreign, ggmap,magrittr,dplyr)

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
#Lasa-- Is this Island Peak????
#Mariyang West
#Bhairab Takura
#Patrasi Himal


#Tongu

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

###########################################################
#expedition records
#9959 expeditions; warnings..not sure what they mean
exped <- read.dbf("Himalayan Database/HIMDATA/exped.DBF")

#literature records; where are the actual notes??
refer <- read.dbf("Himalayan Database/HIMDATA/refer.DBF")

#nothing??
filters <- read.dbf("Himalayan Database/HIMDATA/filters.DBF")
