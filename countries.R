library(tidyverse)

#READ DISTRBUTION DATA
asop_c <- read.csv("Asopinae_2023.csv", sep = ",") 

asop_c <- asop_c %>%
  relocate(X_Longitude, .before = Y_Latitude)

colnames(asop_c) <- c("Genus", "species", "decimallongitude", "decimallatitude")
asop_c$decimallongitude <- as.numeric(asop_c$decimallongitude) 
asop_c$decimallatitude <- as.numeric(asop_c$decimallatitude)

asop_c <- na.omit(asop_c)

library(speciesgeocodeR)
library(sf)

cntr <- st_read("Shapes/world-administrative-boundaries.shp")
cntr_spat <- as_Spatial(cntr)

a <- SpGeoCod(asop_c, cntr_spat, areanames = "name")

aaa <- a$samples

asop_c$country <- aaa$homepolygon

write.csv(asop_c, "Asopinae_2023_Countries.csv", row.names = FALSE)
