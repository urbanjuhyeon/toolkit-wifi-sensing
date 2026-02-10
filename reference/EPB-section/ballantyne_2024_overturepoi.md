# Ballantyne & Berragan (2024) - Overture POI UK

## Citation
Ballantyne, P., & Berragan, C. (2024). Overture Point of Interest data for the United Kingdom: A comprehensive, queryable open data product, validated against Geolytix supermarket data. *Environment and Planning B: Urban Analytics and City Science*, 51(8), 1974–1980. https://doi.org/10.1177/23998083241263124

## Artifact Type
**Open Data Product (ODP)** - Processed UK national subset of Overture Maps Places database

## What It Is
- Processed UK subset of Overture Maps Foundation Places (POI) dataset
- 358 MB GeoParquet file with comprehensive POI attributes
- Includes spatial joins to UK census geographies (OA, LSOA, MSOA, LAD)
- Contains H3 hexagon addresses (resolutions 1-9)
- Validated against Geolytix supermarket data using ISO 19157 quality standards

## Why It Matters
- Good quality, globally available, open access POI data is sparse
- OpenStreetMap has coverage/completeness issues at fine spatial resolutions
- Commercial POI data (Ordnance Survey, Local Data Company, SafeGraph) not open access
- Full Overture global dataset is 200+ GB, requires cloud querying skills
- Bridges skills gap for researchers without data engineering expertise

## Dataset Attributes

| Field | Description |
|-------|-------------|
| Names | POI names (processed from nested JSON) |
| Category | POI category classification |
| Address | Location address information |
| Brand | Brand name information |
| sources_dataset | Data source (Meta or Microsoft) |
| OA, LSOA, MSOA, LAD | England/Wales census geography joins |
| Data Zone | Scotland/Northern Ireland geography joins |
| H3 (1-9) | Hexagon addresses at multiple resolutions |

## Data Processing Pipeline

1. **Query**: DuckDB SQL query using UK bounding box (EPSG:27700)
2. **Download**: GeoPackage file (1.34 GB) from AWS
3. **Clip**: To UK administrative boundaries
4. **Parse**: Flatten nested JSON columns (Names, Category, Address, Brand)
5. **Join**: Spatial join to census geographies
6. **Output**: 358 MB GeoParquet file

## Validation Against Geolytix

### Completeness (POI Count)
| Retailer | Geolytix Count | Overture Count | Difference |
|----------|---------------|----------------|------------|
| Waitrose | 422 | 420 | <5% |
| Spar | 2339 | 2304 | <5% |
| Tesco | 2840 | 2753 | <5% |

### Positional Accuracy
| Retailer | Average Distance (m) |
|----------|---------------------|
| Waitrose | 8.24 |
| Spar | 6.47 |
| Tesco | 6.17 |

*Note: Values <10m deemed optimal per ISO 19157 (Fonte, 2017)*

### Thematic Accuracy by Source

| Retailer | category_main (Meta) | category_main (Microsoft) | brand_name_value (Meta) | brand_name_value (Microsoft) |
|----------|---------------------|--------------------------|------------------------|----------------------------|
| Waitrose | 100.00% | N/A | 76.67% | N/A |
| Spar | 99.82% | 0.00% | 88.37% | 0.00% |
| Tesco | 100.00% | N/A | 97.71% | N/A |

## ISO 19157 Quality Criteria

| Criterion | Assessment |
|-----------|------------|
| Positional accuracy | High (<10m average distance) |
| Thematic accuracy | Variable (Meta: high, Microsoft: low) |
| Completeness | Good (<5% difference from ground truth) |
| Logical consistency | Not explicitly tested |
| Usability | Good (queryable format, census joins) |

## Limitations
- Low thematic accuracy for Microsoft-sourced POIs
- Brand information less complete than category information
- Ambiguity in Overture data assembly process
- Further validation needed for non-retail POIs (GP practices, post offices)

## Technical Details
- **Format**: GeoParquet (column-oriented, efficient querying)
- **Query Engine**: DuckDB SQL
- **Cloud Access**: Amazon Web Services (AWS)
- **Programming**: Python preferred (virtual environment support)
- **Updates**: Committed to 6-month refresh cycle via CDRC

## Use Cases
1. **Health research**: Access to healthy assets/hazards
2. **Urban mobility**: 15-minute city accessibility analysis
3. **Retail analysis**: Store location and performance
4. **Transportation**: Transit-oriented development
5. **Urban indicators**: Spatial inequality measurement

## Paper Structure (~2,500 words)
1. Introduction - POI data challenges, ISO 19157 quality framework
2. Data - Overture Maps, processing pipeline
3. Reliability analysis - Comparison with Geolytix
4. Application - Mapping supermarkets example
5. Conclusion - Limitations and future work

## Relevance to Our Project
| Aspect | Overture POI UK | Our Project |
|--------|----------------|-------------|
| Data Type | Point of Interest | Transit + POI accessibility |
| Coverage | United Kingdom | Study area specific |
| Format | GeoParquet | Python outputs |
| Validation | ISO 19157 framework | Quality assessment needed |
| Use Case | Retail, health, mobility | Service coverage analysis |

## Lessons for Our Manuscript
1. **Quality framework**: Use ISO 19157 criteria for validation
2. **Ground truth comparison**: Validate against established datasets
3. **Source transparency**: Document data sources and their quality differences
4. **Practical limitations**: Be explicit about thematic accuracy issues
5. **Update commitment**: State refresh/maintenance schedule
6. **Skills bridging**: Address technical barriers for wider audience
7. **Reproducibility**: Provide example workflows in multiple languages (Python, R)

## Notable Quotes
- "Point of Interest data that is globally available, open access and of good quality is sparse"
- "A specific challenge for urban analytics researchers and city scientists is that the majority will not have the data engineering or 'quantitative' skills to query these datasets"
- "Users need to be cautious about how they are using this data, especially when the POIs they are using are largely sourced from Microsoft"

## Repository
- **CDRC**: https://data.cdrc.ac.uk/dataset/point-interest-data-united-kingdom (updated version)
- **DagsHub**: https://dagshub.com/cjber/overture-uk (paper version)
- **Format**: GeoParquet (358 MB)
- **Source**: Overture Maps Foundation (Microsoft + Meta)
- **Validation Data**: Geolytix Supermarket Retail Points
