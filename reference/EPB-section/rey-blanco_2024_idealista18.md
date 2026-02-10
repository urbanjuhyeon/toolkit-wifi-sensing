# Rey-Blanco et al. (2024) - idealista18

## Citation
Rey-Blanco, D., Arbues, P., Lopez, F., & Paez, A. (2024). A geo-referenced micro-data set of real estate listings for Spain's three largest cities. *Environment and Planning B: Urban Analytics and City Science*, 51(6), 1369-1379. https://doi.org/10.1177/23998083241242844

## Artifact Type
**Open Data Product (ODP)** - R package with geo-referenced real estate listings

## What It Is
- R package `{idealista18}` containing geo-referenced micro-data of 2018 real estate listings
- Covers Spain's three largest cities: Madrid (94,815), Barcelona (61,486), Valencia (33,622)
- 189,923 total dwelling listings with 42 variables each
- Includes: coordinates, asking prices, indoor characteristics, cadastre data, distance to POIs
- Also includes neighborhood polygons and points of interest

## Why It Matters
- Largest publicly available geo-referenced housing dataset in Spain
- Supports reproducible research in housing market analysis
- Enables hedonic price models, submarket identification, ML experiments
- Clean data directly from Idealista (no web scraping errors)
- FAIR-compliant: documented R package with persistent DOI

## Key Technical Details
- **Data objects**: 10 sf objects (3 cities × [listings + polygons + POIs] + district counts)
- **Privacy protection**: Price masking (±2.5% random noise), coordinate displacement (30-60m)
- **Enrichment**: Cadastre info, distance to city center/metro/major streets
- **License**: Open Database License
- **Repository**: https://github.com/paezha/idealista18

## Paper Structure (~3,000 words)
1. Introduction - Need for open geo-referenced housing data
2. Data description - Package contents and data source
3. Dwelling listings - Variables and characteristics
4. Neighborhood polygons - Spatial boundaries
5. Points of interest - City centers, metro stations
6. Masking the prices - Privacy protection methodology
7. Conclusion

## Relevance to Our Project
| Aspect | idealista18 | Our Project |
|--------|-------------|-------------|
| Artifact type | ODP (dataset) | Workflow/pipeline |
| Distribution | R package | Quarto book + code |
| Focus | Housing prices | Accessibility analysis |
| Temporal | Single year (2018) | Multiple years (2021-2023) |
| Data source | Private company | GTFS/OSM (public) |

## Lessons for Our Manuscript
1. **Privacy handling**: Detailed explanation of data masking (we have no privacy concerns with aggregated accessibility)
2. **FAIR principles**: Explicit statement about findability, accessibility, interoperability, reusability
3. **Coverage validation**: Compare dataset to official statistics (we could compare to Google Maps)
4. **Clear variable documentation**: Tables with variable names, descriptions, and summary stats
5. **R package distribution**: Analysis-ready format reduces friction for users
