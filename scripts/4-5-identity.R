# =============================================================================
# 4-5-identity.R: Visitor Identity
# =============================================================================
#
# Frequency-based classification (One-time vs Regular, full 26 days)
#
# Input:  data/sample_main/ (wifi.parquet, sensors.gpkg, poi.gpkg)
# Output: docs/materials/ch4/  (identity_*.png, identity_*.csv)
#
# =============================================================================

# Setup ----

library(tidyverse)
library(lubridate)
library(arrow)
library(sf)
library(ggmap)
library(ggrepel)

base_dir <- normalizePath(file.path(dirname(
  rstudioapi::getSourceEditorContext()$path
), ".."), winslash = "/")

sample_dir <- file.path(base_dir, "data/sample_main")
fig_dir <- file.path(base_dir, "docs/materials/ch4")
dir.create(fig_dir, recursive = TRUE, showWarnings = FALSE)

## Load Data ----

wifi <- read_parquet(file.path(sample_dir, "wifi.parquet")) |>
  mutate(date = as_date(timestamp1), hour = hour(timestamp1)) |>
  filter(date >= as_date("2019-10-21"), date <= as_date("2019-11-15"))

sensors <- st_read(file.path(sample_dir, "sensors.gpkg"), quiet = TRUE)
poi <- st_read(file.path(sample_dir, "poi.gpkg"), quiet = TRUE)

sensor_coords <- sensors |>
  st_coordinates() |>
  as_tibble() |>
  bind_cols(sensors |> st_drop_geometry() |> select(sensor_name))

## Load Basemap ----

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


# Frequency Classification ----

cat("\n=== Frequency Classification ===\n")

## 1. Classify Devices ----

device_days <- wifi |>
  group_by(source_address) |>
  summarise(n_days = n_distinct(date)) |>
  mutate(freq_type = case_when(
    n_days == 1 ~ "One-time",
    n_days >= 20 ~ "Regular",
    TRUE ~ "Occasional"
  ))

count(device_days, freq_type, sort = TRUE) |> print()

wifi <- wifi |>
  left_join(device_days |> select(source_address, freq_type), by = "source_address")

## 2. Visit Distribution ----

dist_data <- count(device_days, n_days) |>
  mutate(freq_group = factor(
    case_when(n_days == 1 ~ "One-time", n_days >= 20 ~ "Regular", TRUE ~ "Occasional"),
    levels = c("One-time", "Occasional", "Regular")
  ))
write_csv(dist_data, file.path(fig_dir, "identity_freq_dist.csv"))

# Group-level % labels + bracket ranges
group_pct <- dist_data |>
  group_by(freq_group) |>
  summarise(total = sum(n), x_min = min(n_days), x_max = max(n_days),
            x_mid = median(n_days), y_top = max(n), .groups = "drop") |>
  mutate(pct_label = paste0(round(total / sum(total) * 100), "%"))

bracket_groups <- group_pct |> filter(x_min != x_max)  # Occasional, Regular
bracket_y <- max(bracket_groups$y_top) * 1.08
label_y   <- bracket_y * 1.06

p_dist <- ggplot(dist_data, aes(n_days, n, fill = freq_group)) +
  geom_col(width = 0.8) +
  # One-time: simple text above the single bar
  geom_text(data = group_pct |> filter(x_min == x_max),
            aes(x = x_mid, y = y_top, label = pct_label),
            vjust = -0.5, fontface = "bold", size = 3.8, color = "#d7191c",
            inherit.aes = FALSE) +
  # Occasional & Regular: bracket + label
  geom_segment(data = bracket_groups,
               aes(x = x_min, xend = x_max, y = bracket_y, yend = bracket_y, color = freq_group),
               linewidth = 0.6, inherit.aes = FALSE, show.legend = FALSE) +
  geom_segment(data = bracket_groups,
               aes(x = x_min, xend = x_min, y = bracket_y * 0.98, yend = bracket_y, color = freq_group),
               linewidth = 0.6, inherit.aes = FALSE, show.legend = FALSE) +
  geom_segment(data = bracket_groups,
               aes(x = x_max, xend = x_max, y = bracket_y * 0.98, yend = bracket_y, color = freq_group),
               linewidth = 0.6, inherit.aes = FALSE, show.legend = FALSE) +
  geom_label(data = bracket_groups,
             aes(x = x_mid, y = bracket_y, label = pct_label, color = freq_group),
             fontface = "bold", size = 3.8, fill = "white", linewidth = 0,
             label.padding = unit(0.15, "lines"),
             inherit.aes = FALSE, show.legend = FALSE) +
  scale_fill_manual(
    values = c("One-time" = "#d7191c", "Occasional" = "gray55", "Regular" = "#2c7bb6"),
    name = NULL
  ) +
  scale_color_manual(
    values = c("One-time" = "#d7191c", "Occasional" = "gray55", "Regular" = "#2c7bb6")
  ) +
  scale_x_continuous(breaks = c(1, 5, 10, 15, 20, 26)) +
  scale_y_continuous(labels = scales::comma, expand = expansion(mult = c(0, 0.12))) +
  labs(title = "Distribution of Visit Frequency",
       subtitle = "Most devices appear once; 14% persist for 20+ days",
       x = "Days Observed", y = NULL) +
  theme_bw() +
  theme(plot.title = element_text(face = "bold"),
        plot.subtitle = element_text(color = "gray40"),
        legend.position = "top", legend.justification = "left",
        legend.margin = margin(1.5, -0.5, 0, 0), legend.box.just = "left",
        # legend symbol size
        legend.key.size = unit(1, "lines"),
        panel.grid.minor = element_blank())

ggsave(file.path(fig_dir, "identity_freq_dist.png"), p_dist,
       width = 6, height = 4, dpi = 300, bg = "white")

## 3. Hourly Pattern ----

wifi_freq <- wifi |> filter(freq_type %in% c("One-time", "Regular"))

h_freq <- wifi_freq |>
  group_by(freq_type, hour) |>
  summarise(n = n_distinct(source_address), .groups = "drop") |>
  group_by(freq_type) |>
  mutate(pct = n / sum(n) * 100)

write_csv(h_freq, file.path(fig_dir, "identity_freq_hourly.csv"))

p_fh <- ggplot(h_freq, aes(hour, pct, color = freq_type)) +
  geom_line(linewidth = 0.8) + geom_point(size = 1.8) +
  scale_x_continuous(
    breaks = c(0, 4, 8, 12, 16, 20, 23),
    labels = c("0AM", "4", "8", "12PM", "16", "20", "23")
  ) +
  scale_y_continuous(breaks = seq(2, 10, 2)) +
  scale_color_manual(values = c("One-time" = "#d7191c", "Regular" = "#2c7bb6"), name = NULL) +
  labs(title = "Hourly Detection Rates",
       subtitle = "One-time visitors peak at midday; regulars spread evenly",
       x = NULL, y = "%") +
  theme_bw() +
  theme(plot.title = element_text(face = "bold"),
        plot.subtitle = element_text(color = "gray40"),
        legend.position = "top", legend.justification = "left",
        legend.margin = margin(1.5, -0.5, 0, 0), legend.box.just = "left",
        legend.key.size = unit(1, "lines"),
        legend.key = element_rect(fill = NA, color = NA),
        panel.grid.minor = element_blank())

ggsave(file.path(fig_dir, "identity_freq_hourly.png"), p_fh,
       width = 6, height = 4, dpi = 300, bg = "white")

## 4. Spatial Distribution ----

# Compute per-sensor % for each group, then difference
s_freq_wide <- wifi_freq |>
  count(freq_type, sensor_name) |>
  group_by(freq_type) |>
  mutate(pct = n / sum(n) * 100) |>
  ungroup() |>
  select(freq_type, sensor_name, pct) |>
  pivot_wider(names_from = freq_type, values_from = pct, values_fill = 0) |>
  rename(pct_onetime = `One-time`, pct_regular = Regular) |>
  mutate(diff = pct_onetime - pct_regular,
         abs_diff = abs(diff),
         dominant = if_else(diff > 0, "One-time", "Regular")) |>
  left_join(sensor_coords, by = "sensor_name")

write_csv(s_freq_wide |> select(-X, -Y), file.path(fig_dir, "identity_freq_sensor.csv"))

# Label sensors with largest differences
top_diff <- s_freq_wide |> slice_max(abs_diff, n = 10)

p_fs <- ggmap(base_map, darken = c(0.3, "white")) +
  geom_point(data = sensor_coords, aes(x = X, y = Y),
             size = 1.2, color = "grey60", inherit.aes = FALSE) +
  geom_point(data = s_freq_wide, aes(x = X, y = Y, size = abs_diff, color = dominant),
             alpha = 0.75, inherit.aes = FALSE) +
  geom_text_repel(
    data = top_diff, aes(x = X, y = Y, label = sensor_name),
    size = 2.2, fontface = "bold.italic", color = "black",
    bg.color = "white", bg.r = 0.12,
    box.padding = 0.35, point.padding = 0.2,
    max.overlaps = 15, seed = 42, inherit.aes = FALSE
  ) +
  scale_size_continuous(range = c(1.5, 10), name = "% point\ndifference") +
  scale_color_manual(values = c("One-time" = "#d7191c", "Regular" = "#2c7bb6"),
                     name = "Higher share") +
  coord_sf(crs = 4326,
           xlim = c(bbox["xmin"] - pad * 0.5, bbox["xmax"] + pad * 0.35),
           ylim = c(bbox["ymin"] + pad * 0.2, bbox["ymax"] - pad * 0.025)) +
  labs(title = "Spatial Distribution",
       subtitle = "One-time visitors concentrate at transit; regulars at residential") +
  theme_bw() +
  theme(plot.title = element_text(face = "bold"),
        plot.subtitle = element_text(color = "gray40"),
        legend.position = "right",
        axis.title = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank(),
        panel.grid = element_blank())

ggsave(file.path(fig_dir, "identity_freq_sensor.png"), p_fs,
       width = 6, height = 5, dpi = 300, bg = "white")

## 5. Spatial Coverage ----

# Per-visit stats: detections and sensors per visit
visit_stats <- wifi_freq |>
  group_by(source_address, date, freq_type) |>
  summarise(
    n_detections = n(),
    n_sensors = n_distinct(sensor_name),
    duration_mins = as.numeric(difftime(max(timestamp1), min(timestamp1), units = "mins")),
    .groups = "drop"
  )

visit_summary <- visit_stats |>
  group_by(freq_type) |>
  summarise(
    n_visits = n(),
    median_detections = median(n_detections),
    mean_detections = mean(n_detections),
    median_sensors = median(n_sensors),
    mean_sensors = mean(n_sensors),
    median_duration = median(duration_mins),
    mean_duration = mean(duration_mins),
    .groups = "drop"
  )

write_csv(visit_summary, file.path(fig_dir, "identity_freq_visit_summary.csv"))
cat("\nVisit characteristics by frequency group:\n")
print(visit_summary)

# Violin plot: sensors per visit
p_sensors <- ggplot(visit_stats, aes(x = freq_type, y = n_sensors, fill = freq_type)) +
  geom_violin(alpha = 0.7, draw_quantiles = c(0.25, 0.5, 0.75)) +
  geom_boxplot(width = 0.12, fill = "white", alpha = 0.8, outlier.shape = NA) +
  scale_fill_manual(values = c("One-time" = "#d7191c", "Regular" = "#2c7bb6")) +
  scale_y_continuous(breaks = seq(0, 25, 5)) +
  labs(title = "Spatial Coverage per Day",
       subtitle = "Regulars visit median 10 sensors; one-time visitors only 3",
       x = NULL, y = "Number of sensors") +
  theme_bw() +
  theme(plot.title = element_text(face = "bold"),
        plot.subtitle = element_text(color = "gray40"),
        legend.position = "none",
        panel.grid.minor = element_blank())

ggsave(file.path(fig_dir, "identity_freq_sensors.png"), p_sensors,
       width = 5, height = 4.5, dpi = 300, bg = "white")

## 6. Movement Flows ----

od_freq <- wifi_freq |>
  arrange(source_address, timestamp1) |>
  group_by(source_address) |>
  mutate(gap = as.numeric(difftime(timestamp1, lag(timestamp1), units = "mins")),
         trip_id = cumsum(is.na(gap) | gap > 30)) |>
  group_by(source_address, trip_id, freq_type) |>
  summarise(origin = first(sensor_name), destination = last(sensor_name),
            n_det = n(), .groups = "drop") |>
  filter(origin != destination, n_det >= 2) |>
  count(freq_type, origin, destination, name = "n_trips") |>
  group_by(freq_type) |>
  slice_max(n_trips, n = 7) |>
  ungroup() |>
  mutate(route = paste0(origin, " -> ", destination))

write_csv(od_freq, file.path(fig_dir, "identity_freq_od.csv"))

# Join coordinates for flow map
edges_freq <- od_freq |>
  left_join(sensor_coords, by = c("origin" = "sensor_name")) |>
  rename(x_from = X, y_from = Y) |>
  left_join(sensor_coords, by = c("destination" = "sensor_name")) |>
  rename(x_to = X, y_to = Y) |>
  mutate(freq_type = factor(freq_type, levels = c("One-time", "Regular")))

# Sensor labels for OD endpoints
od_sensors_freq <- unique(c(edges_freq$origin, edges_freq$destination))
od_labels_freq <- sensor_coords |> filter(sensor_name %in% od_sensors_freq)

# Build faceted flow map
p_fo <- ggmap(base_map, darken = c(0.3, "white")) +
  geom_point(data = sensor_coords, aes(x = X, y = Y),
             size = 1, color = "grey50", inherit.aes = FALSE) +
  geom_curve(data = edges_freq,
             aes(x = x_from, y = y_from, xend = x_to, yend = y_to,
                 linewidth = n_trips, color = freq_type),
             curvature = 0.25, alpha = 0.8,
             arrow = arrow(length = unit(0.18, "cm"), type = "closed"),
             inherit.aes = FALSE, show.legend = FALSE) +
  geom_point(data = od_labels_freq, aes(x = X, y = Y),
             size = 2.5, color = "white", inherit.aes = FALSE) +
  geom_point(data = od_labels_freq, aes(x = X, y = Y),
             size = 2, color = "#333333", inherit.aes = FALSE) +
  geom_text_repel(data = od_labels_freq, aes(x = X, y = Y, label = sensor_name),
                  size = 2.2, fontface = "bold.italic", color = "black",
                  bg.color = "white", bg.r = 0.12,
                  box.padding = 0.35, point.padding = 0.2,
                  max.overlaps = 20, seed = 42, inherit.aes = FALSE) +
  scale_linewidth_continuous(range = c(0.5, 3)) +
  scale_color_manual(values = c("One-time" = "#d7191c", "Regular" = "#2c7bb6")) +
  facet_wrap(~ freq_type) +
  coord_sf(crs = 4326,
           xlim = c(bbox["xmin"] - pad * 0.5, bbox["xmax"] + pad * 0.35),
           ylim = c(bbox["ymin"] + pad * 0.2, bbox["ymax"] - pad * 0.025)) +
  labs(title = "Primary Movement Corridors",
       subtitle = "Both groups share main routes; regulars dominate dormitory paths") +
  theme_bw() +
  theme(plot.title = element_text(face = "bold"),
        plot.subtitle = element_text(color = "gray40"),
        strip.text = element_text(face = "bold"),
        legend.position = "none",
        axis.title = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank(),
        panel.grid = element_blank())

ggsave(file.path(fig_dir, "identity_freq_od.png"), p_fo,
       width = 6.75, height = 4.25, dpi = 300, bg = "white")


# Summary ----

cat("\n=== Done ===\n")
cat("Figures saved to:", fig_dir, "\n")
