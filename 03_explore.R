# =============================================================
# 03_explore.R
# Exploratory plot: capybara sightings by month.
# =============================================================

library(tidyverse)

cutdf <- readRDS("data/capybara_clean_2025.rds")

capy_colors <- c(Jan = "#E57373", Feb = "#F08A5D", Mar = "#F4A259", Apr = "#F2C14E",
                 May = "#C5CE5C", Jun = "#8CC47A", Jul = "#5DB996", Aug = "#4FB0C6",
                 Sep = "#5B8FD9", Oct = "#7C7FD6", Nov = "#A47BC9", Dec = "#C86FA8")

ggplot(cutdf, aes(x = month, fill = month)) +
  geom_bar() +
  scale_fill_manual(values = capy_colors) +
  theme_minimal() +
  theme(legend.position = "none") +
  labs(x = "Month", y = "Number of sightings",
       title = "Capybara Sightings in Brazil by Month, 2025")
