pacman::p_load(feather,leaflet, ggmap,magrittr,dplyr)


members <- read_feather("data/members.feather")

#this is dumb; but works
members$MYEAR <- as.numeric(levels(members$MYEAR))[as.numeric(members$MYEAR)]

#total number of climber ids; 37034
length(unique(members$CLIMBERID))

table(members$MSUCCESS)

members %>% 
  group_by(CLIMBERID,FNAME,LNAME) %>%
  summarise(SUMMITS = sum(MSUCCESS)) %>%
  filter(SUMMITS > 0) %>%
  arrange(desc(SUMMITS)) %>% 
  View()

members %>% 
  filter(LNAME != 'Sherpa') %>% 
  group_by(CLIMBERID,FNAME,LNAME) %>%
  summarise(SUMMITS = sum(MSUCCESS)) %>%
  filter(SUMMITS > 0) %>%
  arrange(desc(SUMMITS)) %>% 
  View()
  
  everest_summitters <- members %>% 
    filter(PEAKID == 'EVER') %>%
    group_by(CLIMBERID,FNAME,LNAME,PEAKID) %>%
    summarise(SUMMITS = sum(MSUCCESS)) %>%
    filter(SUMMITS > 0) %>%
    arrange(desc(SUMMITS)) 

sum(everest_summitters$SUMMITS)  


yearly_summits <- members %>%
  group_by(PEAKID,MYEAR) %>%
  summarise(CLIMBERS = n(),HIRED = sum(HIRED),SHERPA = sum(SHERPA), SUMMITS = sum(MSUCCESS),DEATH = sum(DEATH)) %>%
  arrange(desc(MYEAR)) %>% 
  ungroup()

plot( %>% filter(PEAKID == 'EVER') %>% select(SUMMITS))



1 EVER      9044
2 AMAD      4084
3 CHOY      3709
4 MANA      1460
5 LHOT       777
6 BARU       628
7 DHA1       543
8 PUMO       510
9 MAKA       484
10 HIML       464

e1 <- which(yearly_summits$PEAKID == 'MANA')
plot(seq(1900,2020,10),seq(100,1300,100),ylim = c(0,1000),type = 'n',ylab = 'Summits',xlab = 'Year')
points(yearly_summits$MYEAR[e1],yearly_summits$SUMMITS[e1])
points(yearly_summits$MYEAR[e1],yearly_summits$SUMMITS[e1],type = 'l')

