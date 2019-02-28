pacman::p_load(foreign, ggmap,magrittr)

#468 peaks
#no lat long of peaks???
peaks <- read.dbf("Himalayan Database/HIMDATA/peaks.DBF")


###########################################################
#geocode for lat long

register_google(key = 'AIzaSyB-EDrn9931fvpeBp1EBWUY2OB08dk7ekw')
mountain_long_lat <- NULL
for(i in 1:dim(peaks)[1]){
  mountain_long_lat <- rbind(mountain_long_lat,geocode(paste0(peaks$PKNAME[i],', Nepal')))
}

#some are obviously wrong
save(mountain_long_lat,file = 'mountain_long_lat.Rdata')

peaks %<>% mutate(lat = mountain_long_lat$lat, lon = mountain_long_lat$lon)


###########################################################
#lets try to fix some of that geocoding...
peaks %<>% arrange(desc(HEIGHTM))

peaks %>% filter(HEIGHTM > 8000)



###########################################################


#members
members <- read.dbf("Himalayan Database/HIMDATA/members.DBF")

#no unique id by person...must create
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
#expeditions
exped <- read.dbf("Himalayan Database/HIMDATA/exped.DBF")


#
refer <- read.dbf("Himalayan Database/HIMDATA/refer.DBF")
filters <- read.dbf("Himalayan Database/HIMDATA/filters.DBF")