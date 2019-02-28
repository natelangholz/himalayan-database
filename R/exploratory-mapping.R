#do some mapping
#load peaks with lat/lon

###########################################################
library(leaflet)

m=leaflet()

m=addTiles(m)

m=setView(m, lng = 86.9, lat = 28.0, zoom = 11)
m


m=leaflet() %>% addTiles() %>% setView( lng = 166.45, lat = -22.25, zoom = 8 )
m


mybins=seq(5000, 9000, by=5000)
mypalette = colorBin( palette="YlOrBr", domain=peaks$HEIGHTM, na.color="transparent", bins=mybins)

mytext=paste( "Name: ", peaks$PKNAME, "<br/>", "Height: ", peaks$HEIGHTM, sep="") %>%
  lapply(htmltools::HTML)


leaflet(peaks) %>% 
  addTiles()  %>% 
  setView( lat=28, lng=86.9 , zoom=4) %>%
  addProviderTiles("CartoDB.DarkMatter") %>%
  addCircleMarkers(~lon, ~lat, 
                   fillColor = ~mypalette(HEIGHTM), fillOpacity = 0.7, color="white", radius=8, stroke=FALSE,
                   label = mytext,
                   labelOptions = labelOptions( style = list("font-weight" = "normal", padding = "3px 8px"), textsize = "13px", direction = "auto")
  ) 
