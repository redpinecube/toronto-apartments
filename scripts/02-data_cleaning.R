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
  
  mutate(
    accessible_units = case_when(
      is.na(no_barrier_free_accessble_units) ~ 0,
      TRUE ~ no_barrier_free_accessble_units)
  ) |>
  
  mutate(
    inaccessible_units = confirmed_units - accessible_units,
    percent_accessible = 100*(accessible_units/confirmed_units)) |>
  
  rename(entrance_accessibility = barrier_free_accessibilty_entr) |>
  
  select(entrance_accessibility,
         inaccessible_units,
         accessible_units,
         percent_accessible,
         year_built,
         year_of_replacement,
         property_type,
         ward)

#### Save data ####
write_csv(clean_data, "./data/analysis_data/analysis_data.csv")
