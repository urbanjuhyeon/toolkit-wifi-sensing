# =============================================================================
# 4-2-location.R: WiFi Localization Analysis - UNIST Campus
# =============================================================================
#
# This script runs localization analysis on the full dataset and generates
# a validation plot comparing three methods.
#
# Three localization methods compared:
# - Proximity: assign to sensor with strongest signal
# - Centroid: simple average of detecting sensor coordinates
# - Weighted Centroid: weighted average using (100 + RSSI) as weight
#
# Input (from data/sample/):
#   - db_wifi_unist19_ALL.csv: WiFi with RSSI
#   - db_GPS_unist19_ALL.csv: GPS ground truth
#   - unist_basemap.gpkg: sensor locations (outdoor)
#
# Output (to docs/materials/ch4/):
#   - localization_error.png: Median error by sampling time
#   - localization_error.csv: Summary statistics
#
# =============================================================================

# Setup ----

library(data.table)
library(sf)
library(ggplot2)

# Paths
base_dir <- normalizePath(file.path(dirname(
  rstudioapi::getSourceEditorContext()$path
), ".."), winslash = "/")

sample_dir <- file.path(base_dir, "data/sample")
fig_dir <- file.path(base_dir, "docs/materials/ch4")

dir.create(fig_dir, recursive = TRUE, showWarnings = FALSE)

sampling_times <- c(1, 5, seq(10, 120, by = 10))

# Load Data ----

cat("Loading data...\n")

## WiFi and GPS ----

wifi_dt <- fread(file.path(sample_dir, "db_wifi_unist19_ALL.csv"))[
  , timestamp_wifi := as.POSIXct(timestamp_wifi, tz = "UTC")
]

gps_dt <- fread(file.path(sample_dir, "db_GPS_unist19_ALL.csv"))[
  , timestamp_GPS := as.POSIXct(timestamp_GPS, tz = "UTC")
]

## Sensors ----

sensor_locs <- st_read(
  file.path(sample_dir, "unist_basemap.gpkg"),
  layer = "sensors", quiet = TRUE
) |>
  subset(outdoor == 1)
sensor_locs$x_sensor <- st_coordinates(sensor_locs)[, 1]
sensor_locs$y_sensor <- st_coordinates(sensor_locs)[, 2]
sensor_locs$sensor_name <- paste0("sensor_", sensor_locs$id_last)
sensor_dt <- as.data.table(st_drop_geometry(sensor_locs))[
  , .(sensor_name, x_sensor, y_sensor)
]

cat("WiFi records:", format(nrow(wifi_dt), big.mark = ","), "\n")
cat("GPS records:", format(nrow(gps_dt), big.mark = ","), "\n")
cat("Sensors:", nrow(sensor_dt), "\n")

# Localization Analysis ----

cat("\nRunning localization analysis...\n")

## Prepare Data ----

wifi_dt <- wifi_dt[sensor_dt, on = "sensor_name", nomatch = NULL]
wifi_dt[, strength := 100 + RSSI]

gps_dt[, timestamp_temp := timestamp_GPS]
setkey(gps_dt, source_address, timestamp_temp)

## Run Methods ----

run_localization <- function(ts) {
  cat("  ts =", ts, "sec\n")

  # Generate step timestamps per device
  wifi_steps <- wifi_dt[
    , .(timestamp_step = seq(
      from = min(timestamp_wifi) + (ts / 2),
      to = max(timestamp_wifi) - (ts / 2),
      by = ts
    )),
    by = source_address
  ]

  wifi_steps[, `:=`(
    window_start = timestamp_step - (ts / 2),
    window_end = timestamp_step + (ts / 2)
  )]

  # Aggregate WiFi by step and sensor
  wifi_agg <- wifi_dt[
    wifi_steps,
    on = .(source_address,
           timestamp_wifi >= window_start,
           timestamp_wifi <= window_end),
    allow.cartesian = TRUE,
    nomatch = NULL
  ][
    , .(
      rssi_sum = sum(RSSI),
      strength_sum = sum(strength),
      x_sensor = first(x_sensor),
      y_sensor = first(y_sensor)
    ),
    by = .(source_address, timestamp_step, sensor_name)
  ]

  # Method 1: Proximity (strongest cumulative RSSI)
  prox <- wifi_agg[
    order(source_address, timestamp_step, -rssi_sum)
  ][
    , head(.SD, 1), by = .(source_address, timestamp_step)
  ][
    , .(source_address, timestamp_step,
        x_est = x_sensor, y_est = y_sensor,
        method = "Proximity")
  ]

  # Method 2: Centroid
  cent <- wifi_agg[
    , .(x_est = mean(x_sensor), y_est = mean(y_sensor)),
    by = .(source_address, timestamp_step)
  ][, method := "Centroid"]

  # Method 3: Weighted Centroid
  wcent <- wifi_agg[
    , .(
      x_est = sum(x_sensor * strength_sum) / sum(strength_sum),
      y_est = sum(y_sensor * strength_sum) / sum(strength_sum)
    ),
    by = .(source_address, timestamp_step)
  ][, method := "Wcentroid"]

  # Combine and join with GPS
  all_methods <- rbindlist(list(prox, cent, wcent), use.names = TRUE)
  all_methods[, timestamp_temp := timestamp_step]
  setkey(all_methods, source_address, timestamp_temp)

  result <- gps_dt[all_methods, roll = "nearest"]
  result <- result[abs(difftime(timestamp_GPS, timestamp_step, units = "secs")) <= ts]

  result[, `:=`(
    error = sqrt((x_est - x)^2 + (y_est - y)^2),
    time_sampling = ts
  )]

  result[, .(source_address, timestamp_step, x_est, y_est, method,
             timestamp_GPS, x_gps = x, y_gps = y, error, time_sampling)]
}

results <- rbindlist(lapply(sampling_times, run_localization))

cat("Total observations:", format(nrow(results), big.mark = ","), "\n")

# Results ----

## Summary Statistics ----

summary_stats <- results[
  !is.na(error),
  .(
    median_error = median(error),
    mean_error = mean(error),
    q25 = quantile(error, 0.25),
    q75 = quantile(error, 0.75),
    n = .N
  ),
  by = .(method, time_sampling)
][order(method, time_sampling)]

cat("\n========== Summary Statistics ==========\n")
print(summary_stats)

fwrite(summary_stats, file.path(fig_dir, "localization_error.csv"))

## Validation Plot ----

n_participants <- wifi_dt[, uniqueN(source_address)]
n_days <- wifi_dt[, as.integer(difftime(max(timestamp_wifi), min(timestamp_wifi), units = "days"))]

method_order <- c("Proximity", "Wcentroid", "Centroid")
summary_stats[, method := factor(method, levels = method_order)]

p <- ggplot(summary_stats, aes(x = time_sampling, y = median_error,
                                color = method, shape = method)) +
  annotate("rect", xmin = 10, xmax = 30, ymin = -Inf, ymax = Inf,
           fill = "gray90", alpha = 0.5) +
  geom_line(linewidth = 0.8) +
  geom_point(size = 2.5) +
  scale_x_continuous(breaks = c(1, 5, seq(10, 120, by = 10))) +
  coord_cartesian(ylim = c(
    min(summary_stats$median_error) * 0.9,
    max(summary_stats$median_error) * 1.1
  )) +
  scale_color_manual(
    breaks = method_order,
    values = c(Proximity = "black", Wcentroid = "firebrick", Centroid = "steelblue"),
    labels = c("Proximity", "Weighted Centroid", "Centroid")
  ) +
  scale_shape_manual(
    breaks = method_order,
    values = c(Proximity = 16, Wcentroid = 15, Centroid = 17),
    labels = c("Proximity", "Weighted Centroid", "Centroid")
  ) +
  labs(
    title = "Localization Error by Sampling Time",
    subtitle = sprintf("UNIST Campus (%d participants, %d days)", n_participants, n_days),
    x = "Sampling Time (seconds)",
    y = "Median Localization Error (m)",
    color = NULL, shape = NULL
  ) +
  theme_bw() +
  theme(
    legend.position = "top",
    legend.justification = "left",
    legend.margin = margin(t = 0, r = 0, b = -5, l = 0),
    legend.text = element_text(size = 9),
    plot.title = element_text(size = 14, face = "bold"),
    plot.subtitle = element_text(size = 10, color = "gray40")
  )

ggsave(file.path(fig_dir, "localization_error.png"),
       p, width = 6.5, height = 4, dpi = 300)

cat("\nSaved:", file.path(fig_dir, "localization_error.png"), "\n")
cat("Done!\n")
