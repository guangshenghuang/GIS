library(tidyverse)
library(sf)
library(tmap)
library(janitor)
library(tmaptools)

rawstudentdata <- read_csv('homework2/Assessment Data.csv')
rawmapwashing <- st_read('homework2/Washington_Counties_with_Natural_Shoreline___washsh_area.shp')

rawmapwashing %>% st_geometry() %>% plot()
studentdata <- clean_names(rawstudentdata)
mapwashing <- clean_names(rawmapwashing)
mapwashing1 <- mapwashing[,c(2,6,7,8)]


Grade <- studentdata %>% 
  filter(county!='Multiple') %>% 
  filter(test_subject=='Science') %>% 
  filter(percent_met_standard!='Supressed:N<10') %>% 
  filter(percent_met_standard!='No Students')

Datatypelist <- Grade %>% 
  summarise_all(class) %>%
  pivot_longer(everything(), 
               names_to="All_variables", 
               values_to="Variable_class")

Grade <- Grade %>% dplyr::select('county',
                                       'count_of_students_expected_to_test_including_previously_passed',
                                       'count_met_standard',
                                       'grade_level')
Grade <- Grade[complete.cases(Grade),]


Grade$county = toupper(Grade$county)

washingstudent <- Grade %>% 
  left_join(mapwashing1,by=c('county'='county'))

washingstudent <- merge(mapwashing1, Grade, 
                        by.x = 'county', by.y = 'county',no.dups = TRUE)
washingstudent#

student_county <- washingstudent %>% 
  group_by(county)
student_county#group by county

grade_county <- student_county %>% 
  aggregate(student_county$count_of_students_expected_to_test_including_previously_passed,
          by=student_county$county,
          sum)

grade_county <- student_county %>% 
  summarise(sum_all=sum(count_of_students_expected_to_test_including_previously_passed),
            sum_standard=sum(count_met_standard))

grade_county

grade_county <- grade_county %>% 
  mutate(percentage=(sum_standard/sum_all)*100)

grade_county2 <- grade_county %>%
  mutate(Compare = case_when(percentage>average ~ "above  average",
                               TRUE ~ "below average")) %>% 
  mutate(discrepency=percentage-average)

grade_county3 <- mapwashing1 %>% 
  left_join(grade_county2,by=c('county'='county'))


#plot
tmap_mode("plot")

qtm(grade_county3, 
    fill = "discrepency")




