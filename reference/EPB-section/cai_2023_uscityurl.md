# Cai et al. (2023) - UScityURL

## Citation
Cai, M., Huang, H., & Decaminada, T. (2023). Local data at a national scale: Introducing a dataset of official municipal websites in the United States for text-based analytics. *Environment and Planning B: Urban Analytics and City Science*, 50(7), 1988–1993. https://doi.org/10.1177/23998083231190961

## Artifact Type
**Open Data Product (ODP)** - Dataset of US municipal website URLs

## What It Is
- Complete, manually verified dataset of official website URLs for all 19,518 US municipalities
- CSV format with 5 columns: GEOID, MUNICIPALITY, STATE, WEBSITE_AVAILABLE, WEBSITE_URL
- Includes ready-to-use Python code for systematic keyword searches on municipal websites
- Derived from 2020 US Census (IPUMS NHGIS)
- As of September 2022: 13,724 municipalities (70%) have official websites

## Why It Matters
- No comprehensive, accurate database of municipal websites previously existed
- City-level data is scattered across agencies and not easily accessible
- Open data portals exist only for large cities with non-comparable measures
- Traditional data collection (surveys, interviews) too costly for national-scale studies
- Municipal websites offer authoritative, up-to-date, free access to local government information
- 45% of web addresses from Google search required manual correction

## Dataset Structure
| Column | Description |
|--------|-------------|
| GEOID | Unique identifier for US Census linkage |
| MUNICIPALITY | Municipality name |
| STATE | State name |
| WEBSITE_AVAILABLE | 1 = available, 0 = not available |
| WEBSITE_URL | Web address (blank if no website) |

## Data Collection Process
1. **Source**: 2020 US Census results from IPUMS
2. **Automated search**: Google Custom Search API with keywords "[city name] [state name] official website"
3. **Manual verification**: Each entry validated by two researchers with urban/regional studies expertise
4. **Validation criteria**:
   - City and state names correct
   - Website is official (not Wikipedia, Twitter, Facebook)
   - URL at root level (e.g., www.lacity.gov not lacity.gov/government)
5. **Corrections**: 8,863 web addresses corrected (45% error rate from Google search)
6. **Effort**: 180 man-hours for manual verification

## Key Statistics
| Metric | Value |
|--------|-------|
| Total municipalities | 19,518 |
| With official website | 13,724 (70%) |
| Without website | 5,794 (30%) |
| URLs corrected | 8,863 (45%) |
| Verification time | 180 man-hours |

**Note**: All municipalities without websites have populations below 6,000.

## How to Use
1. Search municipal websites with Google Custom Search API
2. Define keywords for specific topics (e.g., "smart city", "climate action")
3. Analyze search results for text-based analytics
4. Track topic prevalence over time by repeating searches

## Example Application
- Search smart city-related terms on official websites
- Determine which cities are engaged in smart city discussions
- Monitor topic prevalence over time (e.g., Smart City Tracker)

## Limitations
1. Web addresses may become outdated as municipalities update URLs
2. New websites may be created after dataset compilation
3. Instructions focus on text extraction; image analysis not covered
4. Some websites may block automatic data harvesting

## Paper Structure (~3,000 words)
1. Introduction - Data gap in city-level research
2. Description of the dataset - Structure and coverage
3. How to use this dataset - Python code and examples
4. Concluding remarks - Applications and limitations

## Relevance to Our Project
| Aspect | UScityURL | Our Project |
|--------|-----------|-------------|
| Artifact type | URL dataset | Accessibility metrics dataset |
| Geographic coverage | US national (19,518 municipalities) | Korean cities |
| Data source | Census + Google search | GTFS + OSM |
| Verification | Manual (180 hours) | Automated + manual |
| Use case | Text mining, NLP | Spatial analysis, accessibility |
| Linkage | GEOID for Census | Grid/zone identifiers |

## Lessons for Our Manuscript
1. **Manual verification value**: 45% error rate from automated search justifies manual effort
2. **Quantify effort**: Report man-hours spent (180 hours)
3. **Clear data structure**: Table showing column definitions
4. **Practical code**: Provide ready-to-use Python code with tutorial
5. **Usage example**: Show concrete application (Smart City Tracker)
6. **Honest limitations**: Acknowledge temporal decay of data accuracy
7. **Open science framing**: "In the spirit of open science, we introduce..."
8. **Census linkage**: GEOID enables connection to demographic/geographic data

## Notable Quotes
- "A publicly accessible, comprehensive, and accurate database of municipal websites did not exist"
- "45% of the web addresses obtained through search engine queries required correction"
- "This new data source benefits urban scholars who struggle to access high-quality local data for nationwide studies"
- "Notably, all the municipalities without official websites have populations below 6,000"

## Repository
- **GitHub**: https://github.com/caimeng2/UScityURL
- **Tutorial**: https://github.com/caimeng2/UScityURL/blob/master/how_to_use_tutorial.ipynb
- **License**: CC BY 4.0
