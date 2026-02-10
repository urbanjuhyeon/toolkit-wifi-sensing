# Kotov et al. (2026) - spanishoddata

## Citation
Kotov, E., Vidal-Tortosa, E., Cantú-Ros, O. G., Burrieza-Galán, J., Herranz, R., Gullón Muñoz-Repiso, T., & Lovelace, R. (2026). spanishoddata: A package for accessing and working with Spanish Open Mobility Big Data. *Environment and Planning B: Urban Analytics and City Science*, 0(0), 1–13. https://doi.org/10.1177/23998083251415040

## Artifact Type
**Open Source Software (OSS)** - R package for accessing Spanish mobile-phone-derived mobility data

## What It Is
- R package enabling fast, efficient access to Spain's open origin-destination human mobility datasets
- Data derived from anonymised mobile-phone records (13 million Orange Spain subscribers, ~20-22% market share)
- Released by Spanish Ministry of Transport and Sustainable Mobility (MITMS)
- Automates retrieval, validation, and conversion to analysis-ready formats (DuckDB, Parquet)
- Enables multi-month and multi-year analysis on consumer-grade hardware
- 2200+ CRAN downloads (Dec 2024 - Sep 2025)

## Why It Matters
- Unprecedented open-access national-scale OD mobility data
- Raw data is large and complex: 70-180 MB/day compressed, 22-200+ GB total
- Prior studies: none shared data-acquisition code, inconsistent citations, hindering reproducibility
- 80% of data science time spent on finding, cleaning, organizing data
- Package reduces ETL burden, improves reproducibility, enables research otherwise impossible

## Dataset Versions Supported

### Version 1 (2020-2021)
| Aspect | Details |
|--------|---------|
| Coverage | COVID-19 pandemic period |
| Spatial units | 2,850 districts, municipalities |
| Activities | Home, work/study, other |
| File size | ~70 MB/day (csv.gz), 22+ GB total |
| Memory | ~500 MB/day when loaded |

### Version 2 (2022 onwards)
| Aspect | Details |
|--------|---------|
| Coverage | Post-pandemic, ongoing |
| Spatial units | 3,792 districts (enhanced) |
| Activities | Home, work, study, frequent, infrequent |
| Sociodemographic | Income, age, sex |
| Cross-border | Portugal, France (NUTS3) |
| File size | ~180 MB/day (csv.gz), 200+ GB total |
| Memory | ~2 GB/day when loaded |

## Key Functions

| Function | Purpose |
|----------|---------|
| `spod_set_data_dir()` | Set local data directory |
| `spod_codebook()` | Explore variable codebooks |
| `spod_available_data()` | Check dataset metadata |
| `spod_get_valid_dates()` | Retrieve covered date ranges |
| `spod_convert()` | Download + convert to DuckDB/Parquet |
| `spod_connect()` | Connect to converted database |
| `spod_get()` | Quick analysis without conversion (up to ~1 week) |
| `spod_download()` | Download only (no conversion) |
| `spod_get_zones()` | Retrieve mobility zone polygons (sf object) |
| `spod_cite()` | Generate proper citations |

## Technical Architecture

### Data Pipeline
1. Download raw csv.gz from official MITMS source
2. Concurrent downloads with resume capability
3. File and schema validation
4. Convert to DuckDB or Parquet format
5. Connect via dplyr-compatible interface

### Performance Benefits
- DuckDB: 3-8x faster than CSV for aggregation queries
- Streams data in chunks (no full dataset loading)
- Reads only needed columns
- Optimal use of RAM and CPU cores
- Transparent to user (no manual optimization needed)

### R Dependencies
| Package | Purpose |
|---------|---------|
| duckdb | Database backend |
| dplyr | Data manipulation interface |
| sf | Spatial data handling |

## Example Applications

### 1. Cycling Potential (Valencia)
- Filter trips 0.5-10 km (cycleable distance)
- Intra-zonal analysis: cycling potential by district
- Inter-zonal analysis: desire lines with cycling network connectivity
- Overlay with OpenStreetMap cycling infrastructure

### 2. Work vs Non-work Trips (Madrid)
- Analyse by activity type: home, work/study, frequent, infrequent
- Morning (7-11) vs evening (17-21) commuting patterns
- Reverse direction patterns visible
- Evening trips more spread out temporally
- Infrequent destinations show broader spatial spread

## Literature Review Findings
- 36 studies using MITMS data reviewed
- Most focused on COVID-19/epidemiology
- None shared data-acquisition code
- Inconsistent citation practices
- 44% used Python, 30% R, 22% unspecified
- Only 2 studies used post-2021 data

## Design Principles
1. **Always download from official source** - maintain trust, prevent outdated snapshots
2. **Convert to efficient formats** - DuckDB/Parquet for performance
3. **User-friendly interface** - tutorials, documentation, familiar dplyr syntax
4. **Proper citation** - ensure data and package are correctly cited

## Limitations
- R-only (Python package pySpainMobility in development)
- Single mobile carrier sample (expanded to represent population)
- No transport mode information (distance categories as proxy)

## Paper Structure (~5,000 words)
1. Introduction - Open data challenges, reproducibility crisis
2. Datasets and previous uses - MITMS data description, literature review
3. The spanishoddata R package - Functions, workflow, features
4. Examples - Valencia cycling, Madrid trip types
5. Discussion and conclusion - Impact, design principles, future work

## Relevance to Our Project
| Aspect | spanishoddata | Our Project |
|--------|---------------|-------------|
| Data type | Mobile phone OD flows | Transit accessibility |
| Geographic scope | Spain national | Korean cities |
| Data source | MITMS (government) | GTFS + OSM |
| Output format | DuckDB/Parquet | GeoPackage |
| Challenge addressed | Large data accessibility | Accessibility calculation |
| Reproducibility | Code + citation functions | Reproducible workflow |

## Lessons for Our Manuscript
1. **Quantify reproducibility gap**: Review prior studies' code sharing practices
2. **Performance benchmarks**: Show speedup vs raw data (3-8x)
3. **Download statistics**: Report adoption metrics (2200+ downloads)
4. **Time savings estimate**: Calculate researcher-hours saved (660-1980 hours)
5. **Design principles**: Articulate approach for enabling data access
6. **Multiple use cases**: Demonstrate diverse applications
7. **Citation function**: Include proper attribution mechanism
8. **Official source**: Always download from authoritative source, don't re-host

## Notable Quotes
- "Data practitioners spend 80% of their valuable time finding, cleaning, and organising the data"
- "To the best of our knowledge, these datasets are unprecedented in open access worldwide"
- "None of the articles supplied data-acquisition code"
- "Do not re-upload the data; always download from the official source to maintain trust"

## Repository
- **CRAN**: https://doi.org/10.32614/CRAN.package.spanishoddata
- **GitHub**: https://github.com/rOpenSpain/spanishoddata/
- **Website**: https://ropenspain.github.io/spanishoddata/
- **Zenodo**: https://doi.org/10.5281/zenodo.15207374 (code + data for paper)
- **License**: Open source (rOpenSpain project)
