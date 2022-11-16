library(sf)
library(tidyverse)
library(janitor)
library(here)

world <- st_read(here('wk4_data/World_Countries__Generalized_.shp'))%>% 
  clean_names()
gender <- read_csv(here('wk4_data/HDR21-22_Composite_indices_complete_time_series.csv')) %>%
  clean_names() 
gender_gii <- gender %>% select(country,gii_2019,gii_2010)


world_omit <- world %>% na.omit()
gender_omit <- gender_gii %>% na.omit()

gender_difference <- gender_omit %>% 
  mutate(difference=gii_2019-gii_2010)

gender_spatial <- world_omit %>% 
  left_join(gender_difference,by=c("country"="country"))

## create map

library(tmap)

# check gender_spatial
summary(gender_spatial$difference)

# set breaks for map

gender_map <- tm_shape(gender_spatial) + 
  tm_polygons("difference",
              style="pretty", 
              palette="Bu") + 
  tm_layout(frame=FALSE, legend.outside = TRUE)

gender_map
