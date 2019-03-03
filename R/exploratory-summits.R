pacman::p_load(feather,leaflet, ggmap,magrittr,dplyr)


members <- read_feather("data/members.feather")

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
  summarise(SUMMITS = sum(MSUCCESS)) %>%
  arrange(desc(MYEAR)) %>% 

plot(yearly_summits %>% filter(PEAKID == 'EVER') %>% select(SUMMITS))

