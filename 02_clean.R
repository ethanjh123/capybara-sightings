# =============================================================
# 02_clean.R
# Selects relevant columns, audits data quality, applies the
# coordinate-uncertainty cutoff, and saves the cleaned dataset
# used by every script after this one.
# =============================================================

library(tidyverse)

df <- readRDS("data/capybara_raw_2025.rds")

# 1. Rename the awkward auto-generated captive/cultivated column
df <- df %>% rename(captive = http...unknown.org.captive_cultivated)

# 2. Keep only the columns this project actually uses
org_df <- df %>%
  select(captive, year, coordinateUncertaintyInMeters, eventDate,
         month, stateProvince, references, recordedBy,
         decimalLatitude, decimalLongitude)

# 3. Turn month into a labeled factor (Jan, Feb, ... instead of 1, 2, ...)
org_df <- org_df %>%
  mutate(month = factor(month, levels = 1:12, labels = month.abb))

# =============================================================
# Data quality audit
# =============================================================

# Wild vs. captive status
table(org_df$captive, useNA = "ifany")
# 1,239 wild, 8 unknown status

# Duplicate check - use a column guaranteed unique per record (key/gbifID),
# NOT a low-cardinality column, and NOT one with NAs (n_distinct() folds
# all NAs into a single "value" and creates a false duplicate count)
nrow(df) - n_distinct(df$key)

# Are the 8 unknown-captive rows the same 8 rows missing a references link?
org_df %>% filter(is.na(captive), is.na(references)) %>% nrow()

# Missing values per column
colSums(is.na(org_df))

# Where are the 11 records with no stateProvince?
org_df %>% filter(is.na(stateProvince)) %>%
  select(decimalLatitude, decimalLongitude)

# =============================================================
# Coordinate precision cutoff
# =============================================================

# How many rows would be excluded at each candidate cutoff (in meters)?
cutoffs <- c(500, 1000, 5000, 20000, 50000)
sapply(cutoffs, function(x) sum(org_df$coordinateUncertaintyInMeters > x, na.rm = TRUE))

# Chosen cutoff: 20 km. Well below the scale of a Brazilian state,
# while removing only ~2.6% of records. Rows with UNKNOWN uncertainty
# (NA) are kept rather than dropped, since missing metadata isn't
# evidence of a bad coordinate.
cutdf <- org_df %>%
  filter(is.na(coordinateUncertaintyInMeters) | coordinateUncertaintyInMeters <= 20000)

nrow(org_df)
nrow(cutdf)

# Sensitivity check: does the monthly distribution's shape hold up
# after the cutoff, or did it remove a lopsided chunk of one month?
table(org_df$month)
table(cutdf$month)

# 4. Save the cleaned dataset for 03_explore.R and 04_map.R
saveRDS(cutdf, "data/capybara_clean_2025.rds")
