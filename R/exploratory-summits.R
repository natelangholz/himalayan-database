pacman::p_load(readr,leaflet, ggmap,magrittr,dplyr)


members <- read_csv("data/members.csv")


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

plot(yearly_summits %>% filter(PEAKID == 'EVER') %>% select(SUMMITS))



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

e1 <- which(yearly_summits$PEAKID == 'CHOY')
plot(seq(1900,2020,10),seq(100,1300,100),ylim = c(0,1000),type = 'n',ylab = 'Summits',xlab = 'Year')
points(yearly_summits$MYEAR[e1],yearly_summits$SUMMITS[e1],col = 'black')
points(yearly_summits$MYEAR[e1],yearly_summits$SUMMITS[e1],type = 'l', col = 'black')

e1 <- which(yearly_summits$PEAKID == 'EVER')
points(yearly_summits$MYEAR[e1],yearly_summits$SUMMITS[e1],col = 'red')
points(yearly_summits$MYEAR[e1],yearly_summits$SUMMITS[e1],type = 'l', col = 'red')

e1 <- which(yearly_summits$PEAKID == 'AMAD')
points(yearly_summits$MYEAR[e1],yearly_summits$SUMMITS[e1],col = 'light blue')
points(yearly_summits$MYEAR[e1],yearly_summits$SUMMITS[e1],type = 'l', col = 'light blue')


e1 <- which(yearly_summits$PEAKID == 'MANA')
points(yearly_summits$MYEAR[e1],yearly_summits$SUMMITS[e1],col = 'maroon')
points(yearly_summits$MYEAR[e1],yearly_summits$SUMMITS[e1],type = 'l', col = 'maroon')


#death rates by mountain
death_summary <-members %>% 
  group_by(PEAKID) %>%
  tally() %>%
  arrange(desc(n)) %>%
  left_join(members %>% 
              group_by(PEAKID) %>%  
              summarise(MT_DEATHS = sum(DEATH)) %>%
              filter(MT_DEATHS > 0) %>%
              arrange(desc(MT_DEATHS)), by = 'PEAKID') %>%
  mutate(DEATH_RATE = MT_DEATHS/n) %>%
  arrange(desc(DEATH_RATE))

death_summary %>% View()  



