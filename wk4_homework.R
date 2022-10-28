library(sf)
library(tidyverse)
library(janitor)
world <- st_read('G:/UCL/GIS/wk4/World_Countries__Generalized_.shp') %>% clean_names()
gender <- read_csv('G:/UCL/GIS/wk4/HDR21-22_Composite_indices_complete_time_series.csv') %>%
  clean_names() 
gender_gii <- gender %>% select(country,gii_2019,gii_2010)


world_omit <- world %>% na.omit()
gender_omit <- gender_gii %>% na.omit()

gender_difference <- gender_omit %>% 
  mutate()

print('')