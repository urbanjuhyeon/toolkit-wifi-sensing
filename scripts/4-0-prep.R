# =============================================================================
# 4-0-prep.R: Prepare Sample Data for Part 4 (Extracting Metrics)
# =============================================================================
#
# PURPOSE:
#   Creates distribution packages for metric chapters in Part 4.
#   data/sample_main/ → Count, Track, Identity (26 days) + zip
#   data/sample_loc/  → Location (single device + GPS) + zip
#
# EXPERIMENT PERIOD: Oct 21 - Nov 15, 2019 (26 days)
#
# KEY EVENTS:
#   - Oct 21-25: Midterm exams
#   - Nov 1-2:   Campus Interview (outsiders visit)
#   - Nov 3-5:   School Festival
#
# INPUT (from data/sample/):
#   - db_WiFi_count_filtered_unist19.csv  (main)
#   - db_wifi_unist19_ALL.csv             (location)
#   - db_GPS_unist19_ALL.csv              (location)
#   - unist_basemap.gpkg
#   - poi_campus.gpkg
#
# OUTPUT:
#   data/sample_main/
#     - wifi.parquet, sensors.gpkg, poi.gpkg, sample_main.zip
#
#   data/sample_loc/
#     - wifi.csv, gps.csv, sensors.csv, sample_loc.zip
#
# =============================================================================

# Setup ----

library(data.table)
library(arrow)
library(sf)
library(digest)

# Paths
base_dir <- normalizePath(file.path(dirname(
  rstudioapi::getSourceEditorContext()$path
), ".."), winslash = "/")

# Input (all from data/sample/)
input_dir <- file.path(base_dir, "data/sample")
input_wifi_csv <- file.path(input_dir, "db_WiFi_count_filtered_unist19.csv")
input_wifi_rssi <- file.path(input_dir, "db_wifi_unist19_ALL.csv")
input_gps <- file.path(input_dir, "db_GPS_unist19_ALL.csv")
input_basemap <- file.path(input_dir, "unist_basemap.gpkg")
input_poi <- file.path(input_dir, "poi_campus.gpkg")

# Output
out_main <- file.path(base_dir, "data/sample_main")
out_loc <- file.path(base_dir, "data/sample_loc")
dir.create(out_main, recursive = TRUE, showWarnings = FALSE)
dir.create(out_loc, recursive = TRUE, showWarnings = FALSE)


# Main Dataset ----

cat("======================================================================\n")
cat("Main Dataset (26 days) -> data/sample_main/\n")
cat("======================================================================\n\n")

## Load and Process WiFi ----

cat("Loading WiFi data...\n")
wifi_raw <- fread(
  input_wifi_csv,
  select = c("timestamp1", "source_address", "sensor_name")
)
wifi_raw[, timestamp1 := as.POSIXct(timestamp1, format = "%Y-%m-%dT%H:%M:%SZ", tz = "UTC")]

cat("  Rows:", format(nrow(wifi_raw), big.mark = ","), "\n")
cat("  Date range:", as.character(min(wifi_raw$timestamp1)), "to",
    as.character(max(wifi_raw$timestamp1)), "\n")

# Hash MAC addresses
cat("\nHashing MAC addresses...\n")
unique_addrs <- unique(wifi_raw$source_address)
hash_map <- setNames(
  sapply(unique_addrs, function(x) substr(digest(x, algo = "sha256"), 1, 8)),
  unique_addrs
)
wifi_raw[, source_address := hash_map[source_address]]
cat("  Unique devices:", format(uniqueN(wifi_raw$source_address), big.mark = ","), "\n")

# Save as Parquet
cat("\nSaving as Parquet...\n")
parquet_path <- file.path(out_main, "wifi.parquet")
write_parquet(wifi_raw, parquet_path)
parquet_size <- file.info(parquet_path)$size / 1024^2
cat("  Saved:", parquet_path, sprintf("(%.1f MB)\n", parquet_size))

## Extract Spatial Data ----

cat("\nExtracting outdoor sensors...\n")
sensors <- st_read(input_basemap, layer = "sensors", quiet = TRUE) |>
  subset(outdoor == 1) |>
  transform(sensor_name = id_last) |>
  st_transform(4326)
sensors <- sensors[, c("sensor_name", "geom")]

sensors_path <- file.path(out_main, "sensors.gpkg")
st_write(sensors, sensors_path, delete_dsn = TRUE, quiet = TRUE)
cat("  Saved:", sensors_path, "(", nrow(sensors), "sensors)\n")

cat("\nExtracting POI...\n")
poi <- st_read(input_poi, quiet = TRUE) |>
  st_transform(4326)

poi_path <- file.path(out_main, "poi.gpkg")
st_write(poi, poi_path, delete_dsn = TRUE, quiet = TRUE)
cat("  Saved:", poi_path, "(", nrow(poi), "features)\n")

## Create ZIP ----

cat("\nCreating ZIP...\n")
zip_main_path <- file.path(out_main, "sample_main.zip")
if (file.exists(zip_main_path)) file.remove(zip_main_path)

files_main <- c(parquet_path, sensors_path, poi_path)
if (.Platform$OS.type == "windows") {
  ps_cmd <- sprintf(
    'Compress-Archive -Path "%s" -DestinationPath "%s" -Force',
    paste(files_main, collapse = '","'),
    zip_main_path
  )
  system2("powershell", args = c("-Command", ps_cmd), wait = TRUE)
} else {
  zip(zip_main_path, files = files_main, flags = "-j")
}
zip_main_size <- file.info(zip_main_path)$size / 1024^2
cat("  Saved:", zip_main_path, sprintf("(%.1f MB)\n", zip_main_size))


# Location Dataset ----

cat("\n======================================================================\n")
cat("Location Dataset (Single Device + GPS) -> data/sample_loc/\n")
cat("======================================================================\n\n")

## Load Source Data ----

cat("Loading WiFi with RSSI...\n")
wifi_rssi <- fread(input_wifi_rssi)[
  , timestamp_wifi := as.POSIXct(timestamp_wifi, tz = "UTC")
]
cat("  Rows:", format(nrow(wifi_rssi), big.mark = ","), "\n")

cat("\nLoading GPS ground truth...\n")
gps_dt <- fread(input_gps)[
  , timestamp_GPS := as.POSIXct(timestamp_GPS, tz = "UTC")
]
cat("  Rows:", format(nrow(gps_dt), big.mark = ","), "\n")

## Extract Sample Device ----

cat("\nSelecting sample device (most detections)...\n")
sample_mac <- wifi_rssi[sensor_name != "", .N, source_address][order(-N)][1, source_address]
hashed_mac <- substr(digest(sample_mac, algo = "sha256"), 1, 16)
cat("  Selected:", sample_mac, "->", hashed_mac, "\n")

# WiFi sample
wifi_sample <- wifi_rssi[
  source_address == sample_mac & sensor_name != "",
  .(source_address = hashed_mac,
    timestamp = timestamp_wifi,
    sensor_name,
    rssi = RSSI - 100)
]
cat("  WiFi detections:", format(nrow(wifi_sample), big.mark = ","), "\n")

# GPS sample
gps_sample <- gps_dt[
  source_address == sample_mac,
  .(source_address = hashed_mac, timestamp = timestamp_GPS, x, y)
]
cat("  GPS points:", format(nrow(gps_sample), big.mark = ","), "\n")

## Save Files ----

cat("\nSaving location files...\n")

wifi_loc_path <- file.path(out_loc, "wifi.csv")
gps_loc_path <- file.path(out_loc, "gps.csv")
fwrite(wifi_sample, wifi_loc_path)
fwrite(gps_sample, gps_loc_path)

# Sensor coordinates (UTM for location chapter)
sensor_coords <- st_read(input_basemap, layer = "sensors", quiet = TRUE) |>
  subset(outdoor == 1)
sensor_coords$x_sensor <- st_coordinates(sensor_coords)[, 1]
sensor_coords$y_sensor <- st_coordinates(sensor_coords)[, 2]
sensor_coords$sensor_name <- paste0("sensor_", sensor_coords$id_last)
sensor_loc_dt <- as.data.table(st_drop_geometry(sensor_coords))[
  , .(sensor_name, x_sensor, y_sensor)
]
sensors_loc_path <- file.path(out_loc, "sensors.csv")
fwrite(sensor_loc_dt, sensors_loc_path)

cat("  Saved:", wifi_loc_path, "\n")
cat("  Saved:", gps_loc_path, "\n")
cat("  Saved:", sensors_loc_path, "\n")

## Create ZIP ----

cat("\nCreating ZIP...\n")
zip_loc_path <- file.path(out_loc, "sample_loc.zip")
if (file.exists(zip_loc_path)) file.remove(zip_loc_path)

files_loc <- c(wifi_loc_path, gps_loc_path, sensors_loc_path)
if (.Platform$OS.type == "windows") {
  ps_cmd <- sprintf(
    'Compress-Archive -Path "%s" -DestinationPath "%s" -Force',
    paste(files_loc, collapse = '","'),
    zip_loc_path
  )
  system2("powershell", args = c("-Command", ps_cmd), wait = TRUE)
} else {
  zip(zip_loc_path, files = files_loc, flags = "-j")
}
zip_loc_size <- file.info(zip_loc_path)$size / 1024^2
cat("  Saved:", zip_loc_path, sprintf("(%.1f MB)\n", zip_loc_size))


# Summary ----

cat("\n======================================================================\n")
cat("SUMMARY\n")
cat("======================================================================\n")

cat("\nPeriod: Oct 21 - Nov 15, 2019 (26 days)\n")

cat("\nKey Events:\n")
cat("  Oct 21-25: Midterm exams\n")
cat("  Nov 1-2:   Campus Interview (outsiders)\n")
cat("  Nov 3-5:   School Festival\n")

cat("\nMain Dataset (data/sample_main/):\n")
cat("  WiFi observations:", format(nrow(wifi_raw), big.mark = ","), "\n")
cat("  Unique devices:", format(uniqueN(wifi_raw$source_address), big.mark = ","), "\n")
cat("  sample_main.zip:", sprintf("%.1f MB\n", zip_main_size))

cat("\nLocation Dataset (data/sample_loc/):\n")
cat("  WiFi detections:", format(nrow(wifi_sample), big.mark = ","), "\n")
cat("  GPS points:", format(nrow(gps_sample), big.mark = ","), "\n")
cat("  sample_loc.zip:", sprintf("%.1f MB\n", zip_loc_size))

cat("\nUsage:\n")
cat("  4-2 Location: data/sample_loc/sample_loc.zip\n")
cat("  4-3 Count:    data/sample_main/sample_main.zip\n")
cat("  4-4 Track:    data/sample_main/sample_main.zip\n")
cat("  4-5 Identity: data/sample_main/sample_main.zip\n")

cat("\nDone!\n")
