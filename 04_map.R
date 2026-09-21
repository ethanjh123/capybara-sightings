# =============================================================
# 04_map.R
# Builds the interactive capybara sightings map (clustered
# markers, custom icons, popups) and exports it as a
# standalone HTML file for deployment.
# =============================================================

library(leaflet)
library(htmlwidgets)

cutdf <- readRDS("data/capybara_clean_2025.rds")

# Icon used for individual (non-clustered) markers
capy_icon <- makeIcon(
  iconUrl = "https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/1dbc1935-6542-4ee3-822f-135cff4ba62c/djsfnoh-f622c01f-6cfd-4fe2-ac1c-e686f80c4365.png/v1/fill/w_1280,h_960/capybara_transparent__by_speedcam_djsfnoh-fullview.png?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7ImhlaWdodCI6Ijw9OTYwIiwicGF0aCI6Ii9mLzFkYmMxOTM1LTY1NDItNGVlMy04MjJmLTEzNWNmZjRiYTYyYy9kanNmbm9oLWY2MjJjMDFmLTZjZmQtNGZlMi1hYzFjLWU2ODZmODBjNDM2NS5wbmciLCJ3aWR0aCI6Ijw9MTI4MCJ9XV0sImF1ZCI6WyJ1cm46c2VydmljZTppbWFnZS5vcGVyYXRpb25zIl19.dFTAsNPl9SvO9HAz5dO0zE5OUydTy0xvk-QPap-Q9Ls",
  iconWidth = 25,
  iconHeight = 25
)

# Same image used as the background for cluster badges
capy_badge_url <- "https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/1dbc1935-6542-4ee3-822f-135cff4ba62c/djsfnoh-f622c01f-6cfd-4fe2-ac1c-e686f80c4365.png/v1/fill/w_1280,h_960/capybara_transparent__by_speedcam_djsfnoh-fullview.png?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7ImhlaWdodCI6Ijw9OTYwIiwicGF0aCI6Ii9mLzFkYmMxOTM1LTY1NDItNGVlMy04MjJmLTEzNWNmZjRiYTYyYy9kanNmbm9oLWY2MjJjMDFmLTZjZmQtNGZlMi1hYzFjLWU2ODZmODBjNDM2NS5wbmciLCJ3aWR0aCI6Ijw9MTI4MCJ9XV0sImF1ZCI6WyJ1cm46c2VydmljZTppbWFnZS5vcGVyYXRpb25zIl19.dFTAsNPl9SvO9HAz5dO0zE5OUydTy0xvk-QPap-Q9Ls"

capy_map <- leaflet(cutdf) %>%
  addProviderTiles(providers$Esri.WorldImagery) %>%
  setView(lng = -51.9, lat = -14.2, zoom = 4) %>%
  addMarkers(
    lng = ~decimalLongitude,
    lat = ~decimalLatitude,
    icon = capy_icon,
    clusterOptions = markerClusterOptions(
      maxClusterRadius = 30,
      disableClusteringAtZoom = 10,
      iconCreateFunction = JS(paste0("function(cluster) {
        var count = cluster.getChildCount();
        var size = count < 20 ? 35 : count < 200 ? 45 : 55;
        return L.divIcon({
          html: '<div style=\"background-image:url(", capy_badge_url, "); background-size:cover; background-position:center; border-radius:50%; width:' + size + 'px; height:' + size + 'px; display:flex; align-items:center; justify-content:center; color:white; font-weight:bold; text-shadow:0 0 4px black, 0 0 4px black; box-shadow:0 2px 6px rgba(0,0,0,0.5);\">' + count + '</div>',
          className: 'custom-cluster',
          iconSize: L.point(size, size)
        });
      }"))
    ),
    popup = ~paste0("<b>Capybara sighting</b><br>",
                    "<a href='", references, "' target='_blank'>View on iNaturalist</a><br>",
                    "Month: ", month, "<br>",
                    "State: ", stateProvince)
  ) %>%
  addControl(
    html = "<h4 style='margin:0'>Capybara Sightings in Brazil, 2025</h4>",
    position = "topright"
  )

capy_map

# Export as standalone HTML for deployment (e.g. Netlify)
saveWidget(capy_map, "capybara_map.html", selfcontained = TRUE)
