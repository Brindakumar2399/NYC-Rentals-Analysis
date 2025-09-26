library(dplyr)
library(ggplot2)

airbnb_data <- read.csv("/Users/brindakumar/Downloads/Dvizproj/combined_airbnb_listings.csv", stringsAsFactors = FALSE)

filtered_years <- c('2019', '2023', '2024')

filtered_data <- airbnb_data %>%
  filter(year %in% filtered_years)

listing_counts <- filtered_data %>%
  group_by(year) %>%
  summarise(count = n())

count_2019 <- listing_counts$count[listing_counts$year == '2019']
listing_counts <- listing_counts %>%
  mutate(
    perc_decrease = ifelse(year != '2019', (count_2019 - count) / count_2019 * 100, NA)
  )

listing_counts$year <- factor(listing_counts$year, levels = filtered_years)

ggplot(listing_counts, aes(x = year, y = count)) +
  geom_bar(stat = "identity", fill = "#FF5A5F") +
  geom_text(
    aes(label = ifelse(!is.na(perc_decrease), paste0("↓ ", round(perc_decrease, 1), "%"), "")),
    vjust = -0.5,
    color = "black",
    size = 5,
    fontface = "bold"
  ) +
  labs(x = "Year", y = "Number of Listings", 
       title = "Airbnb Listings") +
  scale_y_continuous(breaks = seq(0, max(listing_counts$count) * 1.1, by = 5000)) +
  theme_minimal()

#-------------------------------------------------------------------------------------------------------------------------------------------------------

library(tidyr)

pre_ll18_color <- "#ff5a5f"
post_ll18_color <- "#717171"

data_summary <- airbnb_data %>%
  filter(year %in% c('2019', '2023')) %>%
  group_by(neighbourhood_group, year) %>%
  summarise(listings = n(), .groups = "drop") %>%
  tidyr::pivot_wider(names_from = year, values_from = listings, names_prefix = "year_")

data_plot <- data_summary %>%
  tidyr::pivot_longer(cols = c(year_2019, year_2023), names_to = "Period", values_to = "Listings") %>%
  mutate(Period = recode(Period, "year_2019" = "PRE-LL18", "year_2023" = "POST-LL18"))

data_plot$Period <- factor(data_plot$Period, levels = c("PRE-LL18", "POST-LL18"))

ggplot(data_plot, aes(x = neighbourhood_group, y = Listings, fill = Period)) +
  geom_bar(stat = "identity", position = position_dodge(width = 0.7), width = 0.6) +
  scale_fill_manual(values = c("PRE-LL18" = pre_ll18_color, "POST-LL18" = post_ll18_color)) +
  geom_text(aes(label = format(Listings, big.mark = ",")),
            position = position_dodge(width = 0.7),
            vjust = -0.3, fontface = "bold", size = 4, color = "black") +
  labs(x = "Borough", y = "Number of Listings",
       title = "Airbnb Listings Comparison by Borough (2019 vs 2024)") +
  theme_minimal() +
  theme(plot.title = element_text(face = "bold", size = 14),
        axis.text.x = element_text(size = 12),
        axis.title = element_text(size = 12))
#-------------------------------------------------------------------------------------------------------------------------------------------------------

rental_summary <- airbnb_data %>%
  filter(year >= 2019 & year <= 2024) %>%
  mutate(stay_category = ifelse(minimum_nights < 30, "< 30 Nights", "≥ 30 Nights")) %>%
  group_by(year, stay_category) %>%
  summarise(listings = n(), .groups = "drop")

ggplot(rental_summary, aes(x = factor(year), y = listings, fill = stay_category)) +
  geom_bar(position = position_dodge(width = 0.7), stat = "identity", width = 0.6) +
  scale_fill_manual(values = c("< 30 Nights" = "#ff5a5f", "≥ 30 Nights" = "#717171")) +
  labs(title = "New York Airbnb Rentals by Minimum Stay Duration (2019-2024)",
       x = "Year",
       y = "Number of Listings",
       fill = "Minimum Nights") +
  theme_minimal() +
  theme(plot.title = element_text(size = 16, face = "bold"),
        axis.title = element_text(size = 12, face = "bold"),
        axis.text.x = element_text(size = 12),
        axis.text.y = element_text(size = 12),
        legend.title = element_text(size = 12),
        legend.text = element_text(size = 12))

#-------------------------------------------------------------------------------------------------------------------------------------------------------
library(readr)
library(lubridate)

rent_data <- read_csv("/Users/brindakumar/Downloads/Dvizproj/medianAskingRent_All.csv")

rent_data_long <- rent_data %>%
  pivot_longer(cols = -c(areaName, Borough, areaType), names_to = "date", values_to = "median_rent") %>%
  mutate(date = ym(date))

filtered_boroughs <- c("Manhattan", "Brooklyn", "Queens")
rent_data_filtered <- rent_data_long %>%
  filter(Borough %in% filtered_boroughs)

rent_data_grouped <- rent_data_filtered %>%
  group_by(date, Borough) %>%
  summarise(median_rent = mean(median_rent, na.rm = TRUE), .groups = "drop")

ggplot(rent_data_grouped, aes(x = date, y = median_rent, color = Borough)) +
  geom_line(linewidth = 1.2) +
  geom_vline(xintercept = as.Date("2023-09-01"), color = "red", linetype = "dashed", linewidth = 1.2) +
  labs(title = "Did Rents Drop After the Short term rental Crackdown?",
       x = "Year",
       y = "Median Rent Price ($)",
       color = "Borough") +
  theme_minimal() +
  theme(plot.title = element_text(size = 16, face = "bold"),
        axis.title = element_text(size = 13),
        axis.text = element_text(size = 12)) +
  scale_color_manual(values = c("Manhattan" = "#FF5A5F", "Brooklyn" = "#717171", "Queens" = "#FC642D"))

#-------------------------------------------------------------------------------------------------------------------------------------------------------

library(ggplot2)

historical_vacancy_data <- read.csv("/Users/brindakumar/Downloads/Dvizproj/nyc_vacancy_rates.csv")
colnames(historical_vacancy_data)[2] <- "Rental_Vacancy_Rate"

ggplot(historical_vacancy_data, aes(x = Year, y = Rental_Vacancy_Rate)) +
  geom_line(color = "#717171", size = 1) +
  geom_point(color = "#717171", size = 3) +
  labs(
    title = "Historical Rental Vacancy Rates in NYC (2008-2023)",
    x = "Year",
    y = "Vacancy Rate (%)"
  ) +
  scale_y_continuous(breaks = seq(1, 4, by = 1)) +
  theme_minimal() +
  theme(
    plot.title = element_text(color = "#FF5A5F", size = 14, face = "bold"),
    axis.title.x = element_text(color = "#FF5A5F", size = 12),
    axis.title.y = element_text(color = "#FF5A5F", size = 12),
    axis.text.x = element_text(color = "#FF5A5F", angle = 45, hjust = 1, size = 10),
    axis.text.y = element_text(color = "#FF5A5F", size = 10)
  )

#-------------------------------------------------------------------------------------------------------------------------------------------------------

rental_types <- c("Citywide Rentals", "Airbnb Listings")
rental_counts <- c(2324000, 42931)
colors <- c("#717171", "#FF5A5F")

percentages <- rental_counts / sum(rental_counts) * 100

rental_data <- data.frame(
  RentalType = rental_types,
  Count = rental_counts,
  Percentage = percentages
)

ggplot(rental_data, aes(x = "", y = Percentage, fill = RentalType)) +
  geom_bar(stat = "identity", width = 1, show.legend = FALSE) +
  coord_polar(theta = "y") +  
  geom_text(aes(label = paste0(round(Percentage, 1), "%")), 
            position = position_stack(vjust = 0.5), size = 6, 
            angle = 90) +  
  scale_fill_manual(values = colors) +
  theme_void() +  
  ggtitle("Proportion of Citywide Rentals vs. Airbnb Listings in NYC (2023)") +
  theme(plot.title = element_text(hjust = 0.5))

#-------------------------------------------------------------------------------------------------------------------------------------------------------
library(ggplot2)
library(dplyr)

loss_data <- data.frame(
  Borough = c("Manhattan", "Brooklyn", "Queens", "Bronx", "Staten Island"),
  Loss = c(889, 977, 438, 108, 37)
)

loss_data <- loss_data %>%
  mutate(
    Percentage = round(Loss / sum(Loss) * 100, 1),
    Label = paste0(Borough, " ($", Loss, "M)\n", Percentage, "%")
  )

ggplot(loss_data, aes(x = 2, y = Loss, fill = Borough)) +
  geom_bar(stat = "identity", width = 1, color = "white") +
  coord_polar(theta = "y", start = 0) +
  geom_text(aes(label = paste0(Percentage, "%")), 
            position = position_stack(vjust = 0.5), size = 4, color = "black") +
  xlim(0.5, 2.5) +  # Creates donut effect
  scale_fill_manual(values = c(
    "Manhattan" = "#fc642d",
    "Brooklyn" = "#FF5A5F",
    "Queens" = "#00A699",
    "Bronx" = "#484848",
    "Staten Island" = "#767676"
  )) +
  theme_void() +
  theme(
    legend.title = element_blank(),
    plot.title = element_text(hjust = 0.5, color = "#FF5A5F", size = 14, face = "bold")
  ) +
  ggtitle("Total Airbnb Guest Spending Loss by Borough Post-LL18")
#-------------------------------------------------------------------------------------------------------------------------------------------------------
library(ggplot2)

vacancy_data <- data.frame(
  Year = c(1975, 1978, 1981, 1984, 1987,
           1991, 1993, 1996, 1999, 2002, 2005, 2008, 2011,
           2014, 2017, 2021, 2023),
  VacancyRate = c(1.50, 1.80, 2.00, 2.30, 2.50,
                  3.00, 3.20, 3.50, 3.20, 2.94, 3.09, 2.88, 3.12,
                  3.45, 3.63, 4.54, 1.41)
)

ggplot(vacancy_data, aes(x = Year, y = VacancyRate)) +
  geom_line(color = "#484848", size = 1) +
  geom_point(color = "#484848", size = 2.5) +
  labs(
    title = "NYC Rental Vacancy Rate (1975–2023)",
    x = "Year",
    y = "Vacancy Rate (%)"
  ) +
  scale_y_continuous(breaks = seq(0, 6, by = 1), limits = c(0, 6)) +
  theme_minimal() +
  theme(
    plot.title = element_text(color = "#484848", face = "bold", size = 14),
    axis.title = element_text(color = "#484848"),
    axis.text = element_text(color = "#484848")
  )
