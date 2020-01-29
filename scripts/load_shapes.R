#load shape files

library(tidyverse)
library(sf)
library(rgdal)
library(here)
library(leaflet)

cpd <- here("shapefiles/Boundaries - Police Districts (current).geojson")
zips_cook <- here("shapefiles/shp_sf")

cpd_sf <- st_read(cpd) %>% st_transform("+proj=longlat +datum=WGS84")
cook_shp <- st_read(zips_cook) %>% st_transform("+proj=longlat +datum=WGS84")



CookCounty <- leaflet() %>%
  setView(lat = 41.8781, lng = -87.6298, zoom = 10) %>%
  addTiles()  %>%
  addProviderTiles("Hydda.Full")

cpd_sf <- cpd_sf %>%
  filter(dist_num != 31)

cpd_pal <- colorFactor("magma", domain = cpd_sf$dist_num)

cc_cpd_zip <- CookCounty %>%
  addPolygons(data = cook_shp,
               color = "black",
              weight = 2,
               label = cook_shp$ZCTA5CE10,
              highlightOptions = highlightOptions(color = "black",
                                                  weight = 2,
                                                  bringToFront = TRUE)) %>%
  addPolygons(data = cpd_sf,
              stroke = TRUE,
              color = "white",
              weight = 1.5,
              label = cpd_sf$dist_num,
              fill = TRUE,
              fillColor = ~cpd_pal(cpd_sf$dist_num),
              fillOpacity = .5, 
              highlightOptions = highlightOptions(color = "red",
                                                  weight = 2,
                                                  bringToFront = TRUE))
