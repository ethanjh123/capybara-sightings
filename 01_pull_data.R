# =============================================================
# 01_pull_data.R
# Pulls capybara occurrence records from GBIF (via rgbif) for
# Brazil, 2025. Saves the raw result so later steps never need
# to hit the API again.
# =============================================================

library(rgbif)
library(tidyverse)

dir.create("data", showWarnings = FALSE)

# 1. Confirm how many records match before pulling anything
occ_count(scientificName = "Hydrochoerus hydrochaeris",
          eventDate = "2025-01-01,2025-12-31",
          hasCoordinate = TRUE,
          country = "BR")

# 2. Fetch data (limit set well above the expected count so
#    rgbif's default 500-record cap doesn't silently truncate us)
capy_data <- occ_search(scientificName = "Hydrochoerus hydrochaeris",
                        eventDate = "2025-01-01,2025-12-31",
                        hasCoordinate = TRUE,
                        country = "BR",
                        limit = 2000)

# 3. Extract the data frame
df <- data.frame(capy_data$data)

# 4. Sanity checks - confirm the pull matches occ_count() above
nrow(df)
table(df$month)
head(df)

# 5. Save raw pull so 02_clean.R can start from here
saveRDS(df, "data/capybara_raw_2025.rds")
