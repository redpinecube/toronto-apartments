#### Preamble ####
# Purpose: 
# Author: 
# Date: 
# Contact:
# License:
# Pre-requisites:
# Any other information needed?

#### Workspace setup ####
library(tidyverse)
library(janitor)

#### Clean data ####
data <- read_csv('./data/raw_data/raw_data.csv')
data <- clean_names(data)
clean_data <- data |>
  select(barrier_free_accessibilty_entr,
         confirmed_storeys,
         confirmed_units,
         no_barrier_free_accessble_units,
         no_of_accessible_parking_spaces,
         prop_management_company_name,
         property_type,
         ward,
         year_built,
         year_of_replacement) |>
  rename(accs_entrance = barrier_free_accessibilty_entr,
         num_storeys = confirmed_storeys,
         num_units = confirmed_units,
         num_accs_units = no_barrier_free_accessble_units,
         num_accs_parking = no_of_accessible_parking_spaces,
         company = prop_management_company_name,
         year_replaced = year_of_replacement)


#### Save data ####
write_csv(clean_data, "./data/analysis_data/analysis_data.csv")
