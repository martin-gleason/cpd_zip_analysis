##getshape file
library(here)
library(rgdal)
library(foreign)
library(tidyverse)

zips <- readOGR("/Users/marty/Downloads/tl_2019_us_county")

#cook_zips <- readOGR("/Users/marty/Downloads/tl_2013_17031_addrfn/")
cook_zips <- read.dbf("/Users/marty/Downloads/tl_2013_17031_addrfn/tl_2013_17031_addrfn.dbf")
glimpse(cook_zips)
#cook_zip_xml <- read

