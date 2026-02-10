# Poorthuis et al. (2024) - De-identified Activity Spaces Dataset

## Citation
Poorthuis, A., Chen, Q., & Zook, M. (2024). A nationwide dataset of de-identified activity spaces derived from geotagged social media data. *Environment and Planning B: Urban Analytics and City Science*, 51(9), 2264–2275. https://doi.org/10.1177/23998083241264051

## Artifact Type
**Open Data Product (ODP)** - De-identified, spatially aggregated activity space dataset from geotagged Twitter data

## What It Is
- Historical dataset of activity spaces from US geotagged Twitter posts (2012-2019)
- Approximately 2 million users and 1.2 billion data points
- De-identified and spatially aggregated using H3 hexagonal grid system
- Hosted as Parquet files (13 GB) for efficient partial download
- Includes inferred home locations using `homelocator` R package ensemble method

## Why It Matters
- Social media data access increasingly restricted (closed APIs, walled-off data)
- Activity spaces are cornerstone of geographic thought (Hägerstrand's time geography)
- Enables research on gentrification, segregation, green space access
- Open, standardized data source for geographic research on human mobility
- Addresses fragmented landscape where studies are difficult to compare/replicate

## Dataset Fields

| Field | Description |
|-------|-------------|
| `id` | Randomly generated identifier for each data point |
| `user_id` | Randomly generated identifier for each user |
| `timestamp` | UTC date-time stamp, rounded to nearest hour |
| `timezone` | Time zone corresponding to data point location |
| `loc_h3_7` | Geographic location at H3 resolution 7 (~1221m) |
| `loc_h3_8` | Geographic location at H3 resolution 8 (~461m, urban only) |
| `home_loc_h3_7` | Inferred home location at H3 resolution 7 |
| `home_loc_h3_8` | Inferred home location at H3 resolution 8 (urban only) |

## De-identification Process

### Data Collection Pipeline
1. Twitter Streaming API collection (2012-2023)
2. Filter: users with 15-10,000 observations
3. Only precise coordinate locations (not "place" tags)
4. Retain only timestamp and location (discard username, text)
5. Infer home locations using `homelocator` ensemble approach (81.5% precision)

### Privacy Protection Steps
1. **Filtering**: Only timestamp and location retained
2. **Aggregation**: Timestamp to nearest hour; location to 500-1500m grid
3. **Perturbation**: Random noise added to timestamps and locations
4. **Thresholding**: Remove locations with ≤5 observations

## Bias Analysis

### Correlation with Census Population
| Geographic Level | Pearson's r |
|-----------------|-------------|
| State | 0.99 |
| County | 0.98 |
| Census Tract | 0.34 |

### GWR Analysis Variables
- Census population (logged)
- Median household income
- Median age (negative effect nationally)
- Percentage of white population (spatially varying effect)

### Key Findings
- Younger users overrepresented (consistent with PEW Research)
- Racial bias varies geographically (positive in Pacific Northwest, negative in California/Gulf Coast)
- Manhattan: consistent underrepresentation of non-white users
- Los Angeles: mixed effects by neighborhood

## Technical Details
- **Format**: Parquet files (efficient columnar storage)
- **Size**: 13 GB total
- **Spatial Grid**: H3 hexagonal hierarchy (Uber Technologies)
- **Home Inference**: `homelocator` R package with ensemble method
- **Analysis**: Geographically-weighted regression (GWR) with Poisson GLM

## Use Cases
1. **Gentrification studies**: Track neighborhood change through mobility patterns
2. **Segregation analysis**: Compare residential vs activity space segregation
3. **Green space access**: Analyze who visits parks and from where
4. **Urban mobility**: Study commuting and daily activity patterns
5. **Temporal analysis**: Compare weekday vs weekend activity patterns

## Addressing Bias
- Weight users from different neighborhoods to match population of interest
- Oversample underrepresented groups
- Focus analysis on specific neighborhoods of interest
- Consider bias at research design phase

## Paper Structure (~4,000 words)
1. Introduction - LBS, changing data landscape, activity spaces concept
2. Data - Collection, de-identification, dataset structure
3. Bias - Comparison with Census, GWR analysis, spatial variation
4. Conclusion - Future of social media research

## Relevance to Our Project
| Aspect | Activity Spaces Dataset | Our Project |
|--------|------------------------|-------------|
| Data Type | Social media mobility | Transit/POI accessibility |
| Coverage | United States (nationwide) | Study area specific |
| Temporal | 2012-2019 historical | Current/planning horizons |
| Privacy | De-identification pipeline | N/A (aggregate data) |
| Use Case | Activity space research | Service coverage analysis |

## Lessons for Our Manuscript
1. **De-identification pipeline**: Document privacy protection steps clearly
2. **Bias transparency**: Acknowledge and quantify data limitations upfront
3. **Multi-scale validation**: Test correlation at different geographic levels
4. **Practical guidance**: Provide strategies for users to address known biases
5. **Format choice**: Use efficient formats (Parquet) for large datasets
6. **Code availability**: Provide replication code separately from data
7. **Use case examples**: Include appendix with concrete analysis examples

## Notable Quotes
- "The open platforms of the early 2000s have been largely replaced by closed APIs and walled-off data"
- "The reliability of the data is spatially dependent"
- "The relationship between race and the density of users in the dataset might very well vary between these two major cities"
- "General and generalizing use of this data should be done cautiously"

## Repository
- **Data**: https://doi.org/10.48804/MBT32W (KU Leuven RDR)
- **Replication Code**: https://doi.org/10.48804/CO9CWN
- **Format**: Parquet files
- **Funding**: KU Leuven Internal Funds (STG/20/2021)
- **Collection History**: University of Kentucky (2012-2016), SUTD (2016-2020), KU Leuven (2020-2023)
