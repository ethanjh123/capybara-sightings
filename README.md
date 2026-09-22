 🐹 Capybara Sightings Tracker

An interactive map of capybara sightings across Brazil in 2025, built in R using citizen-science data from GBIF/iNaturalist. Sightings are plotted as clustered markers that break apart into individual capybara icons on zoom, each linking back to the original observation.

![Map screenshot](map-screenshot.png)

---

## Overview

This project explores where and when capybaras were reported in Brazil in 2025, using publicly available citizen-science observation data. The goal was to build a clean data pipeline from raw API pull to a polished, interactive deliverable while being explicit about the data's limitations along the way.

**Question:** Where and when are capybaras being sighted across Brazil, and what does that distribution actually reflect?

## Data Source

Observation records were pulled from [GBIF](https://www.gbif.org/) (Global Biodiversity Information Facility) via the `rgbif` R package, sourced from iNaturalist's research-grade citizen-science observations.

- **Species:** *Hydrochoerus hydrochaeris*
- **Region:** Brazil
- **Time range:** January 1 – December 31, 2025
- **Records pulled:** 1,247 

## Methodology

The pipeline is split into numbered scripts, run in order:

| Script | Purpose |
|---|---|
| `01_pull_data.R` | Queries the GBIF API via `rgbif` |
| `02_clean.R` | Selects relevant columns, applies data quality filters, saves a clean dataset |
| `03_explore.R` | Exploratory plots (sightings by month) |
| `04_map.R` | Builds the interactive leaflet map and exports it as standalone HTML |

### Data cleaning decisions

- **Coordinate precision:** Records with a stated coordinate uncertainty greater than 20 km were removed (33 rows, 2.6% of the dataset), a threshold well below the scale of a Brazilian state. Records with *unknown* precision (266 rows) were kept, since missing metadata isn't evidence of a bad coordinate. A sensitivity check confirmed the monthly distribution's shape was unaffected by this cutoff.
- **Captive vs. wild status:** Of 1,247 records, 1,239 were flagged wild and 0 captive; 8 had no status recorded. These 8 were kept, since they represent 0.6% of the data and their omission doesn't change the overall pattern.
- **Missing state data:** 11 records had no state field populated, mostly in interior/border regions. Kept on the point map but excluded from any future state-level aggregation.
- **Duplicates:** Checked against unique GBIF record IDs (`key`) — confirmed 0 duplicate records.

## Features

- 📍 Individual markers for all 1,214 cleaned sightings, each with a popup linking to the original iNaturalist observation
- 🔗 Popups include sighting month, state, and a direct link to the source record
- 🧩 Marker clustering, with cluster badges styled using the project's capybara icon and sized by sighting count
- 🗺️ Built on Esri World Imagery satellite basemap tiles

## Limitations

- **Sampling bias:** This data reflects where *people* reported capybaras, not necessarily where capybara populations are highest. Sightings cluster heavily around populated areas (São Paulo, Rio de Janeiro) and are sparse in less-visited regions like the Amazon interior — a pattern that says as much about iNaturalist user density as it does about capybaras.
- **Reporting lag:** iNaturalist observations pass through a review process before reaching GBIF as "research-grade," so very recent sightings may not yet be reflected.
- **Stated precision, not verified accuracy:** The coordinate uncertainty filter removes records that *claim* to be imprecise, but can't catch records that are precisely wrong.

## Tech Stack

- **R** — `rgbif`, `dplyr`, `ggplot2`, `leaflet`, `htmlwidgets`
- **Data source** — GBIF API / iNaturalist
- **Hosting** — Netlify

## Running Locally

```r
# Clone the repo, then from the project root:
install.packages(c("rgbif", "dplyr", "ggplot2", "leaflet", "htmlwidgets"))
source("01_pull_data.R")
source("02_clean.R")
source("03_explore.R")
source("04_map.R")
```

## Credits

Observation data courtesy of [iNaturalist](https://www.inaturalist.org/) contributors, accessed via [GBIF.org](https://www.gbif.org/). Licensed under CC BY-NC 4.0 / CC BY 4.0 per individual record — see GBIF citation for full attribution.

---

*Built by Ethan Hicks as a portfolio project exploring data cleaning & geospatial visualization.
