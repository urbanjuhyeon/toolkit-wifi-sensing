# =============================================================================
# 4-4-track.R: WiFi Tracking Analysis - OD Patterns
# =============================================================================
#
# This script analyzes movement patterns from WiFi detection data by building
# origin-destination (OD) matrices and flow maps.
#
# Input (from data/sample_main/):
#   - wifi.parquet: 26-day WiFi data (Oct 21 - Nov 15, 2019)
#   - sensors.gpkg: outdoor sensor locations
#   - poi.gpkg: campus points of interest
#
# Output (to docs/materials/ch4/):
#   - track_od_heatmap.png: OD probability matrix
#   - track_od_map.png: Top 5 flow map with sensor labels
#   - track_od_weekday_weekend.png: Weekday vs Weekend comparison
#   - track_od_morning_evening.png: Morning vs Evening comparison
#
# =============================================================================

# Setup ----

library(tidyverse)
library(lubridate)
library(arrow)
library(sf)
library(ggmap)
library(ggrepel)

# Paths
base_dir <- normalizePath(file.path(dirname(
  rstudioapi::getSourceEditorContext()$path
), ".."), winslash = "/")

sample_dir <- file.path(base_dir, "data/sample_main")
fig_dir <- file.path(base_dir, "docs/materials/ch4")

dir.create(fig_dir, recursive = TRUE, showWarnings = FALSE)

# Google Maps API (optional - for basemap)
api_key_file <- file.path(base_dir, ".google_api_key")
if (file.exists(api_key_file)) {
  google_api_key <- readLines(api_key_file, warn = FALSE)
  register_google(key = google_api_key)
}

# Load Data ----

cat("Loading WiFi data...\n")
wifi_raw <- read_parquet(file.path(sample_dir, "wifi.parquet"))

cat("  Rows:", format(nrow(wifi_raw), big.mark = ","), "\n")
cat("  Period:", as.character(min(wifi_raw$timestamp1)), "to",
    as.character(max(wifi_raw$timestamp1)), "\n")
cat("  Devices:", format(n_distinct(wifi_raw$source_address), big.mark = ","), "\n")

cat("\nLoading sensors...\n")
sensors <- st_read(file.path(sample_dir, "sensors.gpkg"), quiet = TRUE)

sensor_coords <- sensors |>
  st_coordinates() |>
  as_tibble() |>
  bind_cols(sensors |> st_drop_geometry() |> select(sensor_name))

cat("  Sensors:", nrow(sensors), "\n")

cat("\nLoading POI...\n")
poi <- st_read(file.path(sample_dir, "poi.gpkg"), quiet = TRUE) |>
  filter(str_detect(name, "Dormitory|Engineering"))

poi_coords <- poi |>
  st_centroid() |>
  st_coordinates() |>
  as_tibble() |>
  bind_cols(poi |> st_drop_geometry() |> select(name)) |>
  mutate(label = case_when(
    name == "Engineering" ~ "Engineering\nBldg",
    TRUE ~ name
  ))

## Load Basemap ----

cat("\nLoading basemap...\n")
bbox <- st_bbox(sensors)
pad <- 0.002
center_lon <- (bbox["xmin"] + bbox["xmax"]) / 2
center_lat <- (bbox["ymin"] + bbox["ymax"]) / 2

base_map <- get_map(
  location = c(lon = center_lon, lat = center_lat),
  zoom = 16, maptype = "satellite", source = "google",
  color = "bw"
)

# Build OD Matrix ----

cat("\nBuilding OD matrix...\n")

## Define Trips ----

gap_threshold <- 30  # minutes

trips <- wifi_raw |>
  arrange(source_address, timestamp1) |>
  group_by(source_address) |>
  mutate(
    time_gap = as.numeric(difftime(timestamp1, lag(timestamp1), units = "mins")),
    new_trip = is.na(time_gap) | time_gap > gap_threshold,
    trip_id = cumsum(new_trip)
  ) |>
  ungroup()

## Extract OD Pairs ----

od_pairs <- trips |>
  group_by(source_address, trip_id) |>
  summarise(
    origin = first(sensor_name),
    destination = last(sensor_name),
    trip_start = min(timestamp1),
    trip_end = max(timestamp1),
    n_detections = n(),
    .groups = "drop"
  ) |>
  filter(
    origin != destination,
    n_detections >= 2
  )

cat("  Total trips:", format(nrow(od_pairs), big.mark = ","), "\n")

## Count OD Trips ----

od_counts <- od_pairs |>
  count(origin, destination, name = "n_trips")

od_probs <- od_counts |>
  group_by(origin) |>
  mutate(
    total_from = sum(n_trips),
    prob = n_trips / total_from
  ) |>
  ungroup()

## Split by Day Type ----

od_by_daytype <- od_pairs |>
  mutate(day_type = if_else(wday(trip_start) %in% c(1, 7), "Weekend", "Weekday")) |>
  count(origin, destination, day_type, name = "n_trips") |>
  group_by(origin, day_type) |>
  mutate(
    total_from = sum(n_trips),
    prob = n_trips / total_from
  ) |>
  ungroup()

## Split by Time Period ----

od_time_period <- od_pairs |>
  filter(wday(trip_start) %in% 2:6) |>
  mutate(
    hour = hour(trip_start),
    time_period = case_when(
      hour >= 7 & hour < 10 ~ "1_Morning (7-10)",
      hour >= 17 & hour < 20 ~ "2_Evening (17-20)",
      TRUE ~ NA_character_
    )
  ) |>
  filter(!is.na(time_period)) |>
  count(origin, destination, time_period, name = "n_trips")

# Visualizations ----

cat("\nGenerating visualizations...\n")

## Helper: Add curvature and offset ----

add_curve_offset <- function(edges, group_var = "destination") {
  edges |>
    group_by(across(all_of(group_var))) |>
    mutate(
      n_incoming = n(),
      idx = row_number(),
      curvature = if_else(n_incoming == 1, 0.3,
                          0.2 + (idx - 1) * 0.3 / max(1, n_incoming - 1)),
      angle = 2 * pi * (idx - 1) / n_incoming + pi / 4,
      offset_dist = 0.00015,
      x_to_offset = x_to + cos(angle) * offset_dist * (n_incoming > 1),
      y_to_offset = y_to + sin(angle) * offset_dist * (n_incoming > 1)
    ) |>
    ungroup()
}

## Helper: Join coordinates ----

join_coords <- function(od_data) {
  od_data |>
    left_join(sensor_coords, by = c("origin" = "sensor_name")) |>
    rename(x_from = X, y_from = Y) |>
    left_join(sensor_coords, by = c("destination" = "sensor_name")) |>
    rename(x_to = X, y_to = Y) |>
    filter(!is.na(x_from), !is.na(x_to))
}

## Figure 1: Heatmap ----

cat("  - Heatmap...\n")

p1 <- ggplot(od_probs, aes(x = destination, y = origin, fill = prob)) +
  geom_tile(color = "white") +
  geom_text(aes(label = ifelse(prob >= 0.1, sprintf("%.0f%%", prob * 100), "")),
            size = 2.5, color = "white") +
  scale_fill_gradient(low = "gray90", high = "#d7191c",
                      labels = scales::percent, name = "Probability") +
  labs(x = "Destination", y = "Origin") +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, size = 8),
    axis.text.y = element_text(size = 8),
    panel.grid = element_blank()
  )

ggsave(file.path(fig_dir, "track_od_heatmap.png"),
       p1, width = 8, height = 7, dpi = 300, bg = "white")

## Figure 2: Flow Map (Top 5) ----

cat("  - Flow map (top 5)...\n")

set.seed(42)
edges_top5 <- od_probs |>
  slice_max(n_trips, n = 5) |>
  join_coords() |>
  add_curve_offset()

write_csv(edges_top5 |>
            select(origin, destination, n_trips, prob) |>
            arrange(desc(n_trips)),
          file.path(fig_dir, "track_od_map_data.csv"))

# Get sensor labels for origins and destinations in top 5
od_sensors <- unique(c(edges_top5$origin, edges_top5$destination))
sensor_labels <- sensor_coords |>
  filter(sensor_name %in% od_sensors) |>
  mutate(label = str_replace_all(sensor_name, "_", "\n") |>
           str_wrap(width = 8))

p2 <- ggmap(base_map, darken = c(0.3, "white"))

for (i in 1:nrow(edges_top5)) {
  row <- edges_top5[i, ]
  p2 <- p2 +
    geom_curve(data = row,
               aes(x = x_from, y = y_from, xend = x_to_offset, yend = y_to_offset),
               linewidth = 0.8 + row$n_trips / max(edges_top5$n_trips) * 3,
               color = "#2c7bb6", curvature = row$curvature, alpha = 0.85,
               arrow = arrow(length = unit(0.22, "cm"), type = "closed"),
               inherit.aes = FALSE)
}

p2 <- p2 +
  # All sensors as small grey dots
  geom_point(data = sensor_coords, aes(x = X, y = Y),
             size = 1.5, color = "grey50", inherit.aes = FALSE) +
  # OD sensors as larger points

  geom_point(data = sensor_labels, aes(x = X, y = Y),
             size = 3, color = "white", inherit.aes = FALSE) +
  geom_point(data = sensor_labels, aes(x = X, y = Y),
             size = 2.5, color = "#d7191c", inherit.aes = FALSE) +
  # Sensor name labels
  geom_text_repel(data = sensor_labels,
                  aes(x = X, y = Y, label = label),
                  size = 2.5, fontface = "bold.italic",
                  color = "black", bg.color = "white", bg.r = 0.12,
                  box.padding = 0.4, point.padding = 0.3,
                  max.overlaps = 20, seed = 42, inherit.aes = FALSE) +
  coord_sf(crs = 4326,
           xlim = c(bbox["xmin"] - pad * 0.5, bbox["xmax"] + pad * 0.35),
           ylim = c(bbox["ymin"] + pad * 0.2, bbox["ymax"] - pad * 0.025)) +
  theme_bw() +
  theme(axis.title = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank(),
        legend.position = "none")

ggsave(file.path(fig_dir, "track_od_map.png"),
       p2, width = 4, height = 4, dpi = 300)

## Figure 3: Weekday vs Weekend ----

cat("  - Weekday vs Weekend...\n")

set.seed(42)
edges_daytype_top <- od_by_daytype |>
  group_by(day_type) |>
  slice_max(n_trips, n = 15) |>
  ungroup() |>
  mutate(
    day_type_ordered = if_else(day_type == "Weekday", "1_Weekday", "2_Weekend"),
    curve_color = if_else(day_type == "Weekday", "#FF8C00", "#00CED1")
  ) |>
  join_coords() |>
  group_by(destination, day_type_ordered) |>
  mutate(
    n_incoming = n(),
    idx = row_number(),
    curvature = if_else(n_incoming == 1, 0.3,
                        0.2 + (idx - 1) * 0.3 / max(1, n_incoming - 1)),
    angle = 2 * pi * (idx - 1) / n_incoming + pi / 4,
    offset_dist = 0.00015,
    x_to_offset = x_to + cos(angle) * offset_dist * (n_incoming > 1),
    y_to_offset = y_to + sin(angle) * offset_dist * (n_incoming > 1)
  ) |>
  ungroup()

write_csv(edges_daytype_top |>
            select(day_type, origin, destination, n_trips) |>
            arrange(day_type, desc(n_trips)),
          file.path(fig_dir, "track_od_weekday_weekend_data.csv"))

p3 <- ggmap(base_map, darken = c(0.3, "white"))

for (i in 1:nrow(edges_daytype_top)) {
  row <- edges_daytype_top[i, ]
  p3 <- p3 +
    geom_curve(data = row,
               aes(x = x_from, y = y_from, xend = x_to_offset, yend = y_to_offset),
               linewidth = 0.6 + row$n_trips / max(edges_daytype_top$n_trips) * 2.5,
               color = row$curve_color, curvature = row$curvature, alpha = 0.9,
               arrow = arrow(length = unit(0.18, "cm"), type = "closed"),
               inherit.aes = FALSE)
}

sensor_coords_daytype <- sensor_coords |>
  crossing(day_type_ordered = c("1_Weekday", "2_Weekend"))

p3 <- p3 +
  geom_point(data = sensor_coords_daytype, aes(x = X, y = Y),
             size = 2, color = "white", inherit.aes = FALSE) +
  geom_point(data = sensor_coords_daytype, aes(x = X, y = Y),
             size = 1.5, color = "grey20", inherit.aes = FALSE) +
  geom_text_repel(data = poi_coords |>
                    mutate(label = str_wrap(label, width = 12)) |>
                    crossing(day_type_ordered = c("1_Weekday", "2_Weekend")),
                  aes(x = X, y = Y, label = label),
                  size = 3, fontface = "bold.italic",
                  color = "black", bg.color = "white", bg.r = 0.15,
                  seed = 42, inherit.aes = FALSE) +
  facet_wrap(~ day_type_ordered, ncol = 2,
             labeller = labeller(day_type_ordered = c(
               "1_Weekday" = "Weekday",
               "2_Weekend" = "Weekend"
             ))) +
  coord_sf(crs = 4326,
           xlim = c(bbox["xmin"] - pad, bbox["xmax"] + pad),
           ylim = c(bbox["ymin"] - pad, bbox["ymax"] + pad)) +
  theme_bw() +
  theme(
    axis.title = element_blank(),
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    strip.text = element_text(size = 11, face = "bold"),
    legend.position = "none"
  )

ggsave(file.path(fig_dir, "track_od_weekday_weekend.png"),
       p3, width = 9, height = 4.5, dpi = 300)

## Figure 4: Morning vs Evening ----

cat("  - Morning vs Evening...\n")

set.seed(42)
edges_time_top <- od_time_period |>
  group_by(time_period) |>
  slice_max(n_trips, n = 15) |>
  ungroup() |>
  mutate(curve_color = if_else(grepl("Morning", time_period), "#FF8C00", "#00CED1")) |>
  join_coords() |>
  group_by(destination, time_period) |>
  mutate(
    n_incoming = n(),
    idx = row_number(),
    curvature = if_else(n_incoming == 1, 0.3,
                        0.2 + (idx - 1) * 0.3 / max(1, n_incoming - 1)),
    angle = 2 * pi * (idx - 1) / n_incoming + pi / 4,
    offset_dist = 0.00015,
    x_to_offset = x_to + cos(angle) * offset_dist * (n_incoming > 1),
    y_to_offset = y_to + sin(angle) * offset_dist * (n_incoming > 1)
  ) |>
  ungroup()

write_csv(edges_time_top |>
            select(time_period, origin, destination, n_trips) |>
            arrange(time_period, desc(n_trips)),
          file.path(fig_dir, "track_od_morning_evening_data.csv"))

p4 <- ggmap(base_map, darken = c(0.3, "white"))

for (i in 1:nrow(edges_time_top)) {
  row <- edges_time_top[i, ]
  p4 <- p4 +
    geom_curve(data = row,
               aes(x = x_from, y = y_from, xend = x_to_offset, yend = y_to_offset),
               linewidth = 0.6 + row$n_trips / max(edges_time_top$n_trips) * 2.5,
               color = row$curve_color, curvature = row$curvature, alpha = 0.9,
               arrow = arrow(length = unit(0.18, "cm"), type = "closed"),
               inherit.aes = FALSE)
}

sensor_coords_time <- sensor_coords |>
  crossing(time_period = c("1_Morning (7-10)", "2_Evening (17-20)"))

p4 <- p4 +
  geom_point(data = sensor_coords_time, aes(x = X, y = Y),
             size = 2, color = "white", inherit.aes = FALSE) +
  geom_point(data = sensor_coords_time, aes(x = X, y = Y),
             size = 1.5, color = "grey20", inherit.aes = FALSE) +
  geom_text_repel(data = poi_coords |>
                    mutate(label = str_wrap(label, width = 12)) |>
                    crossing(time_period = c("1_Morning (7-10)", "2_Evening (17-20)")),
                  aes(x = X, y = Y, label = label),
                  size = 3, fontface = "bold.italic",
                  color = "black", bg.color = "white", bg.r = 0.15,
                  seed = 42, inherit.aes = FALSE) +
  facet_wrap(~ time_period, ncol = 2,
             labeller = labeller(time_period = c(
               "1_Morning (7-10)" = "Morning (7-10)",
               "2_Evening (17-20)" = "Evening (17-20)"
             ))) +
  coord_sf(crs = 4326,
           xlim = c(bbox["xmin"] - pad, bbox["xmax"] + pad),
           ylim = c(bbox["ymin"] - pad, bbox["ymax"] + pad)) +
  theme_bw() +
  theme(
    axis.title = element_blank(),
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    strip.text = element_text(size = 11, face = "bold"),
    legend.position = "none"
  )

ggsave(file.path(fig_dir, "track_od_morning_evening.png"),
       p4, width = 9, height = 4.5, dpi = 300)

# Summary ----

cat("\n=== Track Analysis Summary ===\n")
cat("Data period: Oct 21 - Nov 15, 2019 (26 days)\n")
cat("Total observations:", format(nrow(wifi_raw), big.mark = ","), "\n")
cat("Total trips:", format(nrow(od_pairs), big.mark = ","), "\n")
cat("Unique devices:", n_distinct(od_pairs$source_address), "\n\n")

cat("Top 5 OD pairs:\n")
od_probs |> arrange(desc(n_trips)) |> head(5) |> print()

cat("\nFigures saved to:", fig_dir, "\n")
