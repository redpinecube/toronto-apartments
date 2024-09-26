library(scales)
library(extrafont)
library(tidyverse)
library(sf)

font_import()
loadfonts(device='pdf')

data <- read_csv('./data/analysis_data/analysis_data.csv')

plot1 <- data |>
    filter(!is.na(entrance_accessibility)) |>
    mutate(
      entrance_accessibility = case_when(
        entrance_accessibility == "NO" ~ "Inaccessible Entrance",
        entrance_accessibility == "YES" ~ "Accessible Entrance"
      )
    ) |>
    ggplot(aes(x=entrance_accessibility, fill=property_type)) +
    geom_bar(position = 'dodge') +
    scale_fill_manual(values = c('gold', 'azure4', 'darkblue')) +
    theme_light() +
    theme(text = element_text(family = 'Georgia'), 
          plot.margin = unit(c(0.5, 0.5, 0.5, 0.5), "cm")) +
    labs(
      x = "",
      y = "",
      title = "Entrance Accessibility of Buildings in Toronto",
      fill = ""
    )

ggsave("./figures/entrance_accessibility.png", plot = plot1, width = 8, height = 6)


private <- data |>
  filter(property_type == "PRIVATE")
private_acc <- sum(private$accessible_units)
private_in <- sum(private$inaccessible_units)

social <- data |>
  filter(property_type == "SOCIAL HOUSING")
social_acc <- sum(social$accessible_units)
social_in <- sum(social$inaccessible_units)

tchc <- data |>
  filter(property_type == "TCHC")
tchc_acc <- sum(tchc$accessible_units)
tchc_in <- sum(tchc$inaccessible_units)

df <- data.frame(
  major = rep(c("PRIVATE", "SOCIAL HOUSING", "TCHC"), each = 2),
  amount = c(private_in, private_acc, social_in, social_acc, tchc_in, tchc_acc),
  gender = rep(c("Inaccessible", "Accessible"), 3)
)

plot2 <- ggplot(df, aes(x = gender, y = amount, fill = major)) +
  geom_bar(stat = "identity", position = 'dodge') + 
  scale_fill_manual(values = c('gold', 'azure4', 'darkblue')) +
  labs(title = "Accessible Housing Units in Toronto",
       x = "",
       y = "",
       fill = "") +
  theme_light() +
  theme(text = element_text(family = 'Georgia'), 
        plot.margin = unit(c(1, 1, 1, 1), "cm"))

ggsave("./figures/unit_accessibility.png", plot = plot2, width = 8, height = 6)

plot3 <- data |>
  ggplot(aes(x=percent_accessible)) +
  geom_density(adjust = 5, fill = "darkblue") +
  theme_light() +
  theme(text = element_text(family = 'Georgia'), 
        plot.margin = unit(c(1, 1, 1, 1), "cm")) +
  labs(
    title = "Density of Accessible Unit Percentages in Toronto Apartment Buildings",
    x = "Percentage of Accessible Units",
    y = "Density"
  )

ggsave("./figures/density.png", plot = plot3, width = 8, height = 6)

ward_data <- data |>
  group_by(ward) |>
  summarize(num = sum(accessible_units, na.rm = TRUE)) |>
  filter(ward != "YY") |>
  rename(AREA_SHORT_CODE = ward)

geo_data <- as_tibble(st_read('data/raw_data/toronto_wards.geojson'))
combined_data <- geo_data %>%
  left_join(ward_data, by = 'AREA_SHORT_CODE')
combined_data_sf <- st_as_sf(combined_data)

plot4 <- ggplot(data = combined_data_sf) +
  geom_sf(aes(fill = num)) +
  scale_fill_gradient(low = "white", high = "darkblue") +
  theme_light() +
  theme(text = element_text(family = 'Georgia'), 
        plot.margin = unit(c(1, 1, 1, 1), "cm")) +
  labs(title = "Number of Accessible Units in Toronto Appartments",
       fill = "Count")

ggsave("./figures/ward_accessibility.png", plot = plot4, width = 8, height = 6)
