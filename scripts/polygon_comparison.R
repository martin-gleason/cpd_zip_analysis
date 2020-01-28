#polygon comparison
library(here)
library(tidyverse)
library(sf)

source(here("scripts/load_shapes.R"))

class(cook_shp)
class(cpd_sf)

overlaps <- cpd_sf %>% st_join(cook_shp, join = st_overlaps)

within_cpd <- cpd_sf %>% st_join(cook_shp, join = st_within)

within_zip <- cook_shp %>% st_join(cpd_sf, join = st_within)

intersection <- cpd_sf %>% st_join(cook_shp, join = st_intersects)

glimpse(intersection)

intersection %>%
  group_by(dist_num) %>%
  select(dist_num, ZCTA5CE10, geometry) %>%
  summarize(count = n()) %>%
  arrange(desc(count)) %>%
  ggplot() +
  geom_sf(aes(fill = count)) +
  viridis::scale_fill_viridis(option = "cividis", discrete = FALSE) +
  theme_minimal()

intersection %>%
  filter(dist_num == 16) %>%
  nrow()

plot(overlaps)

plot(within_cpd)
plot(within_zip)

intersection %>% plot()

ggplot() + 
  geom_sf(data = overlaps$geometry, aes(fill = overlaps$dist_num))
