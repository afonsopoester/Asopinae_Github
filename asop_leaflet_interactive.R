cntr <- st_read("countries.shp")
cntr_spat <- as_Spatial(cntr)

asop <- read.csv("Asopinae_2023.csv")
asop <- asop %>%
  dplyr::select(c("Species", "Longitude",  "Latitude")) %>%
  na.omit(asop) 
colnames(asop) <- c("Species", "decimalLongitude", "decimalLatitude")

class <- speciesgeocodeR::SpGeoCod(asop, cntr_spat, areanames = "NAME")

asop_class <- class$polygons
asop_class@data$sppol

# Library
library(leaflet)

# Create a color palette for the map:
mypalette <- colorNumeric(palette="viridis", domain=asop_class@data$sppol, na.color="transparent")
mypalette(c(45,43))

mytext <- paste(
  "Country: ", asop_class@data$NAME, "<br/>", 
  "Richness: ", asop_class@data$sppol) %>%
  lapply(htmltools::HTML)

# Basic choropleth with leaflet?
m <- leaflet(asop_class) %>% 
  addTiles()  %>% 
  setView( lat=10, lng=0 , zoom=2) %>%
  addPolygons( 
              fillColor = ~mypalette(sppol), 
              stroke=FALSE,
              label = mytext) %>%
  addLegend(pal = mypalette, values = asop_class@data$sppol)

m

# save the widget in a html file if needed.
# library(htmlwidgets)
# saveWidget(m, file=paste0( getwd(), "/HtmlWidget/choroplethLeaflet1.html"))


