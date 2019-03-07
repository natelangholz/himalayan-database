#do some mapping
#load peaks with lat/lon
pacman::p_load(feather,leaflet, ggmap,magrittr,dplyr)


peaks <- read_feather("data/peaks.feather")

###########################################################


mybins=seq(5000, 9000, by=5000)
mypalette = colorBin( palette="BuPu", domain=peaks$HEIGHTM, na.color="transparent", bins=mybins)
#BuPu
#YlOrBr
#Purples

mytext=paste( "Name: ", peaks$PKNAME, "<br/>", "Height: ", peaks$HEIGHTM, sep="") %>%
  lapply(htmltools::HTML)


leaflet(peaks) %>% 
  addTiles()  %>% 
  setView( lat=28.5, lng=84.6 , zoom=6) %>%
  addProviderTiles("CartoDB.DarkMatter") %>%
  addCircleMarkers(~lon, ~lat, 
                   fillColor = ~mypalette(HEIGHTM), fillOpacity = 0.7, color="white", radius=8, stroke=FALSE,
                   label = mytext,
                   labelOptions = labelOptions( style = list("font-weight" = "normal", padding = "3px 8px"), textsize = "13px", direction = "auto")
  ) 

#https://leaflet-extras.github.io/leaflet-providers/preview/
?addRasterImage()
###########################################################

# Easy to make it interactive!
library(plotly)
library(viridis)

NEPAL <- map_data(map = "world", region = "NEPAL")


mybreaks=c(0.02, 0.04, 0.08, 1, 7)
peaks %>%
  arrange(HEIGHTM) %>%
  mutate(HEIGHTM=HEIGHTM/1000) %>%
  ggplot() +
  geom_polygon(data = NEPAL, aes(x=long, y = lat, group = group), fill="grey", alpha=0.3) +
  geom_point(data = peaks,  aes(x=lon, y=lat, size=HEIGHTM, color=HEIGHTM, alpha=HEIGHTM), shape=20, stroke=FALSE) +
  scale_size_continuous(name="Population (in M)", trans="log", range=c(1,12), breaks=mybreaks) +
  scale_alpha_continuous(name="Population (in M)", trans="log", range=c(0.1, .9), breaks=mybreaks) +
  scale_color_viridis(option="magma", trans="log", breaks=mybreaks, name="Population (in M)" ) +
  theme_void()  + coord_map() + 
  guides( colour = guide_legend()) +
  ggtitle("The peaks in Nepal") +
  theme(
    legend.position = c(0.85, 0.8),
    text = element_text(color = "#22211d"),
    plot.background = element_rect(fill = "#f5f5f2", color = NA), 
    panel.background = element_rect(fill = "#f5f5f2", color = NA), 
    legend.background = element_rect(fill = "#f5f5f2", color = NA),
    plot.title = element_text(size= 16, hjust=0.1, color = "#4e4d47", margin = margin(b = -0.1, t = 0.4, l = 2, unit = "cm")),
  )


###########################################################

# plot
p=peaks %>%
  filter(MSUMMIT8K == 1) %>%
  arrange(HEIGHTM) %>%
  #mutate( name=factor(name, unique(name))) %>%
  mutate( mytext=paste("PEAK: ", PEAKID, "\n", "HEIGHT M: ", HEIGHTM, sep="")) %>%  # This prepare the text displayed on hover.
  # Makte the static plot calling this text:
  ggplot() +
  geom_polygon(data = NEPAL, aes(x=long, y = lat, group = group), fill="grey", alpha=0.3) +
  geom_point(aes(x=lon, y=lat, size=HEIGHTM/1000, color=HEIGHTM, text=mytext, alpha=HEIGHTM) , shape = 2 ) +
  
  scale_size_continuous(range=c(1,4)) +
  scale_color_viridis(option="inferno", trans="log" ) +
  scale_alpha_continuous(trans="log") +
  theme_void() +
  coord_map() +
  theme(legend.position = "none")

p=ggplotly(p, tooltip="text")
p
