#polygon comparison
library(here)
library(tidyverse)
library(sf)

source(here("scripts/load_shapes.R"))

class(cook_shp)
class(cpd_sf)
#notes
# 1) There is no 13th district

#analysis
overlaps <- cpd_sf %>% st_join(cook_shp, join = st_overlaps)

glimpse(cpd_sf)

cpd_sf$dist_num %>% as.numeric()

within_cpd <- cpd_sf %>% st_join(cook_shp, join = st_within)

within_zip <- cook_shp %>% st_join(cpd_sf, join = st_within)

intersection <- cpd_sf %>% st_join(cook_shp, join = st_intersects)

commons <- cpd_sf %>% st_join(cook_shp, join = st_crosses)

crowded_zip <- cpd_sf %>% st_intersection(cook_shp) %>%
  ggplot() + 
  geom_sf(aes(fill = dist_num)) +
  geom_sf_label(aes(label = ZCTA5CE10))


plot(commons)

glimpse(intersection)

inverse_intersection <- cook_shp %>% st_join(cpd_sf, join = st_intersects)


intersection %>% 
  select(dist_num, ZCTA5CE10) %>%
  group_by(dist_num, ZCTA5CE10) %>%
  summarize(count = n()) %>%
  arrange(desc(as.numeric(dist_num)))

intersection$dist_num %>% class()

#plotting
intersection_plot <- intersection %>%
  group_by(dist_num, dist_label) %>%
  select(dist_num, dist_label, ZCTA5CE10, geometry) %>%
  summarize(count = n()) %>%
  arrange(desc(count)) %>%
  ggplot() +
  geom_sf(aes(fill = count)) +
  viridis::scale_fill_viridis(option = "cividis", discrete = FALSE) +
  geom_sf_label(aes(label = dist_label)) +
  theme_minimal()

#not sure if useful
# inverse_intersection %>%
#   group_by(dist_num) %>%
#   select(dist_num, ZCTA5CE10, geometry) %>%
#   summarize(count = n()) %>%
#   arrange(desc(count)) %>%
#   ggplot() +
#   geom_sf(aes(fill = count)) +
#   viridis::scale_fill_viridis(option = "cividis", discrete = FALSE) +
#   theme_minimal()


#check
# i <- intersection %>%
#   group_by(dist_num, dist_label) %>%
#   select(dist_num, dist_label, ZCTA5CE10) %>%
#   summarize(count = n())
# 
# i_1 <- intersection %>%
#   group_by(dist_num) %>%
#   select(dist_num, ZCTA5CE10) %>%
#   summarize(count = n())
# 
# all.equal(i, i_1)
