#load shape files

library(tidyverse)
library(sf)
library(rgdal)
library(here)
library(leaflet)
library(jsonlite)

stations <- read_csv(here("shapefiles/police_stations.csv"))

cpd <- here("shapefiles/Boundaries - Police Districts (current).geojson")
zips_cook <- here("shapefiles/shp_sf")
boundary <- here("shapefiles/Historical - ccgisdata - Municipality 2014")

cpd_sf <- st_read(cpd) %>% st_transform("+proj=longlat +datum=WGS84")
cook_shp <- st_read(zips_cook) %>% st_transform("+proj=longlat +datum=WGS84")
boundary_sf <- st_read(boundary) %>% st_transform("+proj=longlat +datum=WGS84")

stations_sf <- stations %>% st_as_sf(coords = c("LONGITUDE", "LATITUDE"))

boundary_layer <- boundary_sf %>% st_union()

CookCounty <- leaflet() %>%
  setView(lat = 41.8781, lng = -87.6298, zoom = 10) %>%
  addTiles()  %>%
  addProviderTiles("Hydda.Full")

cpd_sf <- cpd_sf %>%
  filter(dist_num != 31)

cpd_pal <- colorFactor("viridis", domain = as.factor(cpd_sf$dist_num))

stations_drop <- stations_sf %>% st_drop_geometry()

labs <- lapply(seq(nrow(stations_drop)), function(i) {
  paste0( '<p>', stations_drop[i, "DISTRICT"], '<p></p>', 
          stations_drop[i, "DISTRICT NAME"], '</p>')
          })
  
cc_cpd_zip <- CookCounty %>%
  addPolygons(data = cpd_sf,
              stroke = TRUE,
              color = "black",
              weight = 1.5,
              label = cpd_sf$dist_num,
              fill = TRUE,
              fillColor = ~cpd_pal(cpd_sf$dist_num),
              fillOpacity = 1) %>%
  addPolygons(data = cook_shp,
            color = "white",
            weight = 2,
            label = cook_shp$ZCTA5CE10,
            highlightOptions = highlightOptions(color = "red",
                                                weight = 2,
                                                bringToFront = TRUE)) %>%
  addPolylines(data = boundary_layer,
               color = "black",
               weight = 2) %>%
  addMarkers(data = stations_sf,
            label = lapply(labs, htmltools::HTML),
            labelOptions = labelOptions(noHide = FALSE, direction = "bottom",
                                        style = list(
                                          "color" = "black",
                                          "font-family" = "san-serif",
                                          "font-size" = "12px"
                                        ))) %>%
  addLegend("topright", 
            pal = cpd_pal, 
            title = "Chicago Police Districts as of 1/29/20",
            opacity = .75,
            values = as.numeric(cpd_sf$dist_num))





