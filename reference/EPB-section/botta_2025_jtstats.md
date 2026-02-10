# Botta et al. (2025) - jtstats

## Citation
Botta, F., Lovelace, R., Gilbert, L., & Turrell, A. (2025). Packaging code and data for reproducible research: A case study of journey time statistics. *Environment and Planning B: Urban Analytics and City Science*, 52(4), 1002-1013. https://doi.org/10.1177/23998083241267331

## Artifact Type
**Open Source Software (OSS)** - Python + R packages for accessing UK government journey time data

## What It Is
- `jtstats` packages (Python primary, R secondary) for UK Department for Transport (DfT) journey time statistics
- Converts complex ODS files to analysis-ready pandas/R dataframes
- Includes additional IMD (deprivation) data access
- Provides geographic boundary files (LSOA, local authority)
- Basic plotting/visualization functions

## Why It Matters
- Open data alone is not enough - needs to be "analysis-ready"
- Original ODS files too complex/slow for typical analysis
- Packages reduce barriers to entry for researchers
- Enables reproducible research with government data
- Demonstrates public sector data science best practices

## Key Technical Details
- **Data**: DfT Journey Time Statistics (JTS) - modelled journeys to services (employment, schools, hospitals, etc.)
- **Geographic levels**: LSOA to national/regional/local authority
- **Modes**: Car, walking, cycling, public transport
- **Python modules**: jts (main data), imd (deprivation), geo (boundaries), plot (visualization)
- **Format conversion**: ODS → CSV → pandas DataFrame / R tibble
- **Testing**: pytest for validation of data processing

## JTS Data Tables (Table 1)
| Table | Description | Dimensions |
|-------|-------------|------------|
| JTS0501 | Employment centres | 32844 × 113 |
| JTS0502 | Primary schools | 32844 × 41 |
| JTS0503 | Secondary schools | 32844 × 41 |
| JTS0505 | GPs | 32844 × 41 |
| JTS0506 | Hospitals | 32844 × 41 |
| JTS0507 | Food stores | 32844 × 41 |

## Paper Structure (~4,000 words)
1. Introduction - Open data value, analysis-ready formats, prior examples (tidycensus, stats19)
2. Data - JTS description, complexity challenges
3. Code - Python and R implementation details
4. Conclusion - Lessons for public sector, limitations, future work

## Relevance to Our Project
| Aspect | jtstats | Our Project |
|--------|---------|-------------|
| Artifact type | Data access package | Workflow/pipeline |
| Data type | Pre-computed travel times | Computed accessibility |
| Source | Government statistics | GTFS/OSM + R5R |
| Focus | Data accessibility | Analysis methodology |
| Output | Analysis-ready data | Accessibility metrics |
| Geographic context | England (UK) | Korea |

## Lessons for Our Manuscript
1. **Analysis-ready emphasis**: "Open access is necessary but not sufficient"
2. **Prior art citation**: tidycensus, census, stats19 as exemplar packages
3. **Multi-language**: Python primary + R secondary shows flexibility
4. **Government collaboration**: Authors from academia, ONS, 10 Downing Street
5. **Testing/validation**: pytest for ensuring data fidelity
6. **Data linkage**: Combining JTS with IMD shows value of easy-to-join data
7. **Honest limitations**: Validation challenges, format improvements needed (Parquet)
8. **Impact examples**: Parliamentary library dashboard, industry blog posts

## Notable Quotes
- "Open access is a necessary but not sufficient condition to ensuring that the value invested in datasets is returned to society"
- "Datasets need to be shared in formats that are easy to work with in the popular analytical tools used in data science"
- "Publishing such packages alongside open datasets will add vast amounts of value to government digital assets"
- "The true potential of publicly available data sets can only be realised when a broad range of data scientists and analysts can work with them, with minimal barriers to entry"
