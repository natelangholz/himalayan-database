#do some mapping
#load peaks with lat/lon

###########################################################
library(leaflet)


mybins=seq(5000, 9000, by=5000)
mypalette = colorBin( palette="YlOrBr", domain=peaks$HEIGHTM, na.color="transparent", bins=mybins)

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
