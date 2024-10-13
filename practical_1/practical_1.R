#read in the shapefile
library(sf)
shape <- st_read("/Users/yujiama/casa/casa05/practical-1/DATA/statsnz-territorial-authority-2018-generalised-SHP/territorial-authority-2018-generalised.shp")
summary(shape)
# simplify the shapefile, if dont mind the boundry of shp. is detailed
simplified_shapefile <- st_simplify(shape,dTolerance = 1000)

#show the simplified_shapefile
library(sf)
simplified_shapefile %>% 
  st_geometry() %>%
  plot()
# read in the csv
library(tidyverse)
mycsv <-  read_csv("/Users/yujiama/casa/casa05/practical-1/DATA/join_1.csv")
mycsv

# merge csv and shapefile
simplified_shapefile <- simplified_shapefile%>%
  merge(.,
        mycsv,
        by.x="TA2018_V1_", 
        by.y="Territorial authority code (2018 areas)")
#Check the merge was successful
simplified_shapefile %>%
  head(., n=10)
# set tmap to plot
library(tmap)
# have a look at the map
tmap_mode("plot")
simplified_shapefile %>%
  qtm(.,fill = "Paid employee")
# write to a .gpkg
simplified_shapefile %>%
  st_write(.,"/Users/yujiama/casa/casa05/practical-1/NewZealand_paid_employee.gpkg")
# connect to the .gpkg
library(readr)
library(RSQLite)
con <- dbConnect(RSQLite::SQLite(),dbname="/Users/yujiama/casa/casa05/practical-1/NewZealand_paid_employee.gpkg")
# list what is in it
con %>%
  dbListTables()
# add the original .csv
con %>%
  dbWriteTable(.,
               "original_csv",
               mycsv,
               overwrite=TRUE)
# disconnect from it
con %>% 
  dbDisconnect()

