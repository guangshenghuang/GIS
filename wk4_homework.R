library(sf)
library(tidyverse)
library(janitor)
library(here)

world <- st_read(here('wk4_data/World_Countries__Generalized_.shp'))%>% 
  clean_names()
gender <- read_csv(here('wk4_data/HDR21-22_Composite_indices_complete_time_series.csv'))%>%
  clean_names() 

gender_gii <- gender %>% select(country,gii_2019,gii_2010)

world_omit <- world %>% na.omit()
gender_omit <- gender_gii %>% na.omit()

gender_difference <- gender_omit %>% 
  mutate(difference=(gii_2019-gii_2010)*100)

gender_spatial <- world_omit %>% 
  left_join(gender_difference,by=c("country"="country"))

### start mapping
library(tmap)
library(tmaptools)

tmap_mode("plot")

t = tm_shape(gender_spatial) + 
  tm_polygons("difference", 
              style="jenks",
              colorNA = NULL,
              title="Change in inequality 2010-2019 (%)",
              palette="RdYlGn",
              border.alpha =0.30,
              border.color = "grey80",
              midpoint = NA)+
  tm_layout(frame = FALSE, 
            main.title = "Difference in gender inequality index",
            main.title.size = 1,
            legend.show = TRUE,
            legend.position = c(0,0.04),
            legend.title.size = 0.9)+
  tm_credits("(c) United Nations Development Programme and Esri")+
  tm_compass(north=0, position = c(0,0.3), size = 1.4, text.size = 0.6)

### export 
tmap_save(t, 'hw5_fork.png')



