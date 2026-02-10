# =============================================================================
# 4-6-activities.R: Activity Detection
# =============================================================================
#
# Stay detection using spatial proximity (150m threshold, 5+ min duration)
# Distinguishes stationary activities from pass-through movements
#
# Input:  data/sample_main/ (wifi.parquet, sensors.gpkg)
# Output: docs/materials/ch4/  (activities_*.png, activities_*.csv)
#
# =============================================================================

# Setup ----

library(tidyverse)
library(lubridate)
library(arrow)
library(sf)
library(ggmap)
library(ggrepel)
library(data.table)

base_dir <- normalizePath(file.path(dirname(
  rstudioapi::getSourceEditorContext()$path
), ".."), winslash = "/")

sample_dir <- file.path(base_dir, "data/sample_main")
fig_dir <- file.path(base_dir, "docs/materials/ch4")
dir.create(fig_dir, recursive = TRUE, showWarnings = FALSE)

## Load data ----

wifi <- read_parquet(file.path(sample_dir, "wifi.parquet")) |>
  mutate(date = as_date(timestamp1), hour = hour(timestamp1)) |>
  filter(date >= as_date("2019-10-21"), date <= as_date("2019-11-15"))

sensors <- st_read(file.path(sample_dir, "sensors.gpkg"), quiet = TRUE)

## Sensor coordinates ----

sensor_coords <- sensors |>
  st_coordinates() |>
  as_tibble() |>
  bind_cols(sensors |> st_drop_geometry() |> select(sensor_name))

sensor_coords_utm <- sensors |>
  st_transform(5179) |>
  st_coordinates() |>
  as_tibble() |>
  bind_cols(sensors |> st_drop_geometry() |> select(sensor_name))

## Basemap ----

api_key_file <- file.path(base_dir, ".google_api_key")
if (file.exists(api_key_file)) {
  register_google(key = readLines(api_key_file, warn = FALSE))
}

bbox <- st_bbox(sensors)
pad <- 0.002
center_lon <- (bbox["xmin"] + bbox["xmax"]) / 2
center_lat <- (bbox["ymin"] + bbox["ymax"]) / 2

base_map <- get_map(
  location = c(lon = center_lon, lat = center_lat),
  zoom = 16, maptype = "satellite", source = "google",
  color = "bw"
)

cat("Rows:", format(nrow(wifi), big.mark = ","), "\n")
cat("Devices:", n_distinct(wifi$source_address), "\n")
cat("Period:", as.character(range(wifi$date)), "\n")


# Stay Detection ----

cat("\n=== Stay Detection ===\n")

## Define trajectories ----

gap_threshold <- 30   # minutes
dist_threshold <- 150 # meters
time_threshold <- 5   # minutes (changed from 3)

# Convert to data.table
dt <- as.data.table(wifi)
coords_dt <- as.data.table(sensor_coords_utm)
setnames(coords_dt, c("X", "Y"), c("x_curr", "y_curr"))

# Join coordinates
dt <- coords_dt[dt, on = "sensor_name"]

# Sort and compute trajectories + segments
setorder(dt, source_address, timestamp1)

cat("Computing trajectories...\n")
dt[, `:=`(
  time_gap = as.numeric(difftime(timestamp1, shift(timestamp1), units = "mins")),
  x_prev = shift(x_curr),
  y_prev = shift(y_curr)
), by = source_address]

dt[, `:=`(
  new_traj = is.na(time_gap) | time_gap > gap_threshold,
  dist_to_prev = sqrt((x_curr - x_prev)^2 + (y_curr - y_prev)^2)
)]

dt[, traj_id := cumsum(new_traj), by = source_address]
dt[, new_segment := is.na(dist_to_prev) | dist_to_prev > dist_threshold]
dt[, segment_id := cumsum(new_segment), by = .(source_address, traj_id)]

cat("Total trajectories:", format(dt[, uniqueN(paste(source_address, traj_id))], big.mark = ","), "\n")

# Summarize segments (optimized - removed expensive table() call)
cat("Summarizing segments...\n")
stays <- dt[, .(
  start_time = min(timestamp1),
  end_time = max(timestamp1),
  duration_mins = as.numeric(difftime(max(timestamp1), min(timestamp1), units = "mins")),
  n_detections = .N,
  primary_sensor = sensor_name[1],  # first sensor instead of mode (much faster)
  n_sensors = uniqueN(sensor_name),
  date = date[1],
  hour = hour[1]
), by = .(source_address, traj_id, segment_id)]

stays[, `:=`(
  is_stay = duration_mins >= time_threshold,
  activity_type = factor(
    fcase(
      duration_mins < time_threshold, "Pass-through",
      duration_mins < 15, "Short stay",
      duration_mins < 60, "Medium stay",
      default = "Long stay"
    ),
    levels = c("Pass-through", "Short stay", "Medium stay", "Long stay")
  )
)]

# Convert back to tibble for ggplot compatibility
stays <- as_tibble(stays)

stay_summary <- stays |>
  summarise(
    total_segments = n(),
    n_stays = sum(is_stay),
    pct_stays = mean(is_stay) * 100,
    median_duration = median(duration_mins[is_stay]),
    mean_duration = mean(duration_mins[is_stay])
  )

cat("\nStay detection results:\n")
cat("  Total segments:", format(stay_summary$total_segments, big.mark = ","), "\n")
cat("  Stays (>=5min):", format(stay_summary$n_stays, big.mark = ","),
    "(", round(stay_summary$pct_stays, 1), "%)\n")
cat("  Median stay duration:", round(stay_summary$median_duration, 1), "mins\n")

write_csv(stay_summary, file.path(fig_dir, "activities_stay_summary.csv"))


# Behavioral Differences ----

cat("\n=== Behavioral Differences ===\n")

## Activity distribution ----

activity_dist <- stays |>
  count(activity_type) |>
  mutate(pct = n / sum(n) * 100)

write_csv(activity_dist, file.path(fig_dir, "activities_type_dist.csv"))
cat("\nActivity type distribution:\n")
print(activity_dist)

p_dist <- ggplot(activity_dist, aes(activity_type, pct, fill = activity_type)) +
  geom_col(width = 0.7) +
  geom_text(aes(label = paste0(round(pct, 1), "%")),
            vjust = -0.5, fontface = "bold", size = 3.5) +
  scale_fill_manual(values = c("Pass-through" = "gray55",
                               "Short stay" = "#fdae61",
                               "Medium stay" = "#f46d43",
                               "Long stay" = "#d73027")) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.15))) +
  labs(title = "Activity Type Distribution",
       subtitle = "Most segments are pass-throughs; stays require 5+ minutes of spatial stability",
       x = NULL, y = "%") +
  theme_bw() +
  theme(plot.title = element_text(face = "bold"),
        plot.subtitle = element_text(color = "gray40"),
        legend.position = "none",
        panel.grid.minor = element_blank())

ggsave(file.path(fig_dir, "activities_type_dist.png"), p_dist,
       width = 5.5, height = 4, dpi = 300, bg = "white")

## Duration distribution ----

stays_only <- stays |> filter(is_stay)

duration_bins <- stays_only |>
  mutate(duration_bin = cut(duration_mins,
                            breaks = c(5, 10, 15, 30, 60, 120, Inf),
                            labels = c("5-10", "10-15", "15-30", "30-60", "60-120", "120+"),
                            right = FALSE)) |>
  count(duration_bin) |>
  mutate(pct = n / sum(n) * 100)

write_csv(duration_bins, file.path(fig_dir, "activities_duration_dist.csv"))

p_duration <- ggplot(duration_bins, aes(duration_bin, pct)) +
  geom_col(fill = "gray45", width = 0.7) +
  geom_text(aes(label = paste0(round(pct, 1), "%")),
            vjust = -0.5, size = 3.2) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.15))) +
  labs(title = "Stay Duration Distribution",
       subtitle = "Most stays last 15-60 minutes; 20% exceed one hour",
       x = "Duration (minutes)", y = "%") +
  theme_bw() +
  theme(plot.title = element_text(face = "bold"),
        plot.subtitle = element_text(color = "gray40"),
        panel.grid.minor = element_blank())

ggsave(file.path(fig_dir, "activities_duration_dist.png"), p_duration,
       width = 5.5, height = 4, dpi = 300, bg = "white")

## Hourly pattern ----

hourly_stays <- stays |>
  group_by(hour) |>
  summarise(
    n_total = n(),
    n_stays = sum(is_stay),
    stay_rate = mean(is_stay) * 100,
    .groups = "drop"
  )

write_csv(hourly_stays, file.path(fig_dir, "activities_hourly.csv"))

p_hourly <- ggplot(hourly_stays, aes(hour, n_stays)) +
  geom_col(fill = "gray45", width = 0.8) +
  scale_x_continuous(breaks = c(0, 4, 8, 12, 16, 20, 23),
                     labels = c("0AM", "4", "8", "12PM", "16", "20", "23")) +
  scale_y_continuous(labels = scales::comma) +
  labs(title = "Hourly Stay Count",
       subtitle = "Stays concentrate during daytime activity hours",
       x = NULL, y = "Number of stays") +
  theme_bw() +
  theme(plot.title = element_text(face = "bold"),
        plot.subtitle = element_text(color = "gray40"),
        panel.grid.minor = element_blank())

ggsave(file.path(fig_dir, "activities_hourly.png"), p_hourly,
       width = 6, height = 4, dpi = 300, bg = "white")

## Spatial pattern ----

sensor_activity <- stays |>
  group_by(primary_sensor) |>
  summarise(
    n_segments = n(),
    n_stays = sum(is_stay),
    stay_rate = mean(is_stay) * 100,
    avg_duration = mean(duration_mins[is_stay], na.rm = TRUE),
    .groups = "drop"
  ) |>
  left_join(sensor_coords, by = c("primary_sensor" = "sensor_name"))

write_csv(sensor_activity |> select(-X, -Y), file.path(fig_dir, "activities_sensor.csv"))

# Top sensors by stay rate
top_stay_sensors <- sensor_activity |>
  filter(n_segments >= 100) |>
  slice_max(stay_rate, n = 10)

p_sensor <- ggmap(base_map, darken = c(0.3, "white")) +
  geom_point(data = sensor_coords, aes(x = X, y = Y),
             size = 1.2, color = "grey60", inherit.aes = FALSE) +
  geom_point(data = sensor_activity,
             aes(x = X, y = Y, size = n_stays, color = stay_rate),
             alpha = 0.8, inherit.aes = FALSE) +
  geom_text_repel(
    data = top_stay_sensors, aes(x = X, y = Y, label = primary_sensor),
    size = 2.2, fontface = "bold.italic", color = "black",
    bg.color = "white", bg.r = 0.12,
    box.padding = 0.35, point.padding = 0.2,
    max.overlaps = 15, seed = 42, inherit.aes = FALSE
  ) +
  scale_size_continuous(range = c(1.5, 10), name = "Stay\ncount") +
  scale_color_gradient(low = "#fee08b", high = "#d73027", name = "Stay\nrate (%)") +
  coord_sf(crs = 4326,
           xlim = c(bbox["xmin"] - pad * 0.5, bbox["xmax"] + pad * 0.35),
           ylim = c(bbox["ymin"] + pad * 0.2, bbox["ymax"] - pad * 0.025)) +
  labs(title = "Spatial Distribution of Stays",
       subtitle = "Dormitory and academic sensors show highest stay rates") +
  theme_bw() +
  theme(plot.title = element_text(face = "bold"),
        plot.subtitle = element_text(color = "gray40"),
        legend.position = "right",
        axis.title = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank(),
        panel.grid = element_blank())

ggsave(file.path(fig_dir, "activities_sensor.png"), p_sensor,
       width = 6, height = 5, dpi = 300, bg = "white")

## By visitor type ----

device_days <- wifi |>
  group_by(source_address) |>
  summarise(n_days = n_distinct(date)) |>
  mutate(freq_type = case_when(
    n_days == 1 ~ "One-time",
    n_days >= 20 ~ "Regular",
    TRUE ~ "Occasional"
  ))

stays_with_freq <- stays |>
  left_join(device_days |> select(source_address, freq_type), by = "source_address") |>
  filter(freq_type %in% c("One-time", "Regular"))

stay_by_freq <- stays_with_freq |>
  group_by(freq_type) |>
  summarise(
    n_segments = n(),
    n_stays = sum(is_stay),
    stay_rate = mean(is_stay) * 100,
    median_duration = median(duration_mins[is_stay], na.rm = TRUE),
    mean_duration = mean(duration_mins[is_stay], na.rm = TRUE),
    .groups = "drop"
  )

write_csv(stay_by_freq, file.path(fig_dir, "activities_by_freq.csv"))
cat("\nStay patterns by visitor type:\n")
print(stay_by_freq)

# Activity type distribution by freq_type
activity_by_freq <- stays_with_freq |>
  count(freq_type, activity_type) |>
  group_by(freq_type) |>
  mutate(pct = n / sum(n) * 100) |>
  ungroup()

write_csv(activity_by_freq, file.path(fig_dir, "activities_type_by_freq.csv"))

p_freq <- ggplot(activity_by_freq, aes(activity_type, pct, fill = freq_type)) +
  geom_col(position = "dodge", width = 0.7) +
  scale_fill_manual(values = c("One-time" = "#d7191c", "Regular" = "#2c7bb6"),
                    name = NULL) +
  labs(title = "Activity Types by Visitor Frequency",
       subtitle = "Regulars show more long stays; one-time visitors mostly pass through",
       x = NULL, y = "%") +
  theme_bw() +
  theme(plot.title = element_text(face = "bold"),
        plot.subtitle = element_text(color = "gray40"),
        legend.position = "top", legend.justification = "left",
        legend.margin = margin(1.5, -0.5, 0, 0),
        panel.grid.minor = element_blank())

ggsave(file.path(fig_dir, "activities_by_freq.png"), p_freq,
       width = 6, height = 4, dpi = 300, bg = "white")


# Summary ----

cat("\n=== Done ===\n")
cat("Figures saved to:", fig_dir, "\n")
