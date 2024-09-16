#### Preamble ####
# Purpose: Downloads and saves the data from Open Data Toronto
# Author: Tara Chakkithara
# Date: 21 September 2024
# Contact: tara.chakkithara@mail.utoronto.ca
# License: MIT


#### Workspace setup ####
library(opendatatoronto)
library(dplyr)

#### Download building evaluation data ####
resources <- list_package_resources("2b98b3f3-4f3a-42a4-a4e9-b44d3026595a")
datastore_resources <- filter(resources, tolower(format) %in% c('csv', 'geojson'))
data <- filter(datastore_resources, row_number()==1) %>% get_resource()

#### Save data ####
write_csv(data, "./data/raw_data/raw_data.csv") 




