# Werner et al. (2024) - NetAScore

## Citation
Werner, C., Wendel, R., Kaziyeva, D., Stutz, P., van der Meer, L., Effertz, L., Zagel, B., & Loidl, M. (2024). NetAScore: An open and extendible software for segment-scale bikeability and walkability. *Environment and Planning B: Urban Analytics and City Science*, 0(0), 1-10. https://doi.org/10.1177/23998083241293177

## Artifact Type
**Open Source Software (OSS)** - Python package for bikeability/walkability assessment

## What It Is
- Open source software for automated segment-scale bikeability and walkability computation
- Uses OpenStreetMap data by default (extendable to other networks)
- Computes weighted suitability index [0.0-1.0] per road segment
- Default mode profiles for utilitarian cycling and walking
- Customizable via YAML configuration files

## Why It Matters
- Previous methods limited by: high data requirements, closed-source, constrained indicators
- Fills gaps in openness, transparency, reproducibility (Kellstedt et al., 2021)
- Supports active mobility promotion and sustainable transport planning
- Results can inform accessibility and area-based assessments
- Foundation for interdisciplinary research on infrastructure suitability

## Key Technical Details
- **Implementation**: Python + PostgreSQL/PostGIS; Docker image available
- **Data sources**: OpenStreetMap (default), optional DEM, noise data, Austrian GIP
- **Workflow**: 5 steps (import → preprocess → derive indicators → compute index → export)
- **Output**: GeoPackage with edge/node layers, index values, indicator explanations
- **Indicators**: 15 total (road category, infrastructure, speed, lanes, gradient, pavement, etc.)

## Workflow Steps
1. Import data (network + optional layers)
2. Preprocess network (filter, topological cleaning)
3. Derive indicators (spatial joins, attribute assessment)
4. Compute index (weighted average of indicator values)
5. Export data (GeoPackage)

## Indicators (Table 1)
| Indicator | Description |
|-----------|-------------|
| road category | primary, secondary, residential, service, calmed, etc. |
| bicycle infrastructure | bicycle way, mixed way, lane, shared lane, etc. |
| pedestrian infrastructure | pedestrian area, way, mixed way, stairs, sidewalk |
| max speed | speed limit for motorized traffic |
| gradient | steepness of segment |
| pavement | asphalt, gravel, soft, cobble |
| greenness | share of green space within 30m buffer |
| water | water bodies within 30m buffer |
| noise | traffic noise level |
| buildings | building area within 20m buffer |
| facilities | facilities per 100m within 30m buffer |
| crossings | pedestrian crossings per 100m |

## Paper Structure (~3,000 words)
1. Introduction - Need for open, adjustable bikeability/walkability methods
2. Method - Data, workflow, parametrization, implementation
3. Applicability and examples - Validation studies, Salzburg example
4. Discussion and conclusions - Limitations, future directions

## Relevance to Our Project
| Aspect | NetAScore | Our Project |
|--------|-----------|-------------|
| Artifact type | Software package | Workflow/pipeline |
| Focus | Infrastructure suitability | Service accessibility |
| Metric | Bikeability/walkability index | Travel time |
| Modes | Bicycle, pedestrian | Car, transit |
| Data source | OpenStreetMap | GTFS + OSM |
| Customization | YAML config files | R parameters |

## Lessons for Our Manuscript
1. **Configuration-based customization**: YAML profiles allow reproducible, shareable settings
2. **Indicator abstraction**: Raw data → indicators → composite index (similar to our workflow)
3. **Docker containerization**: Streamlines setup and reproducibility
4. **Validation studies**: Referenced external validation papers
5. **Explicit limitations**: Acknowledges intersections not assessed, segment-level only
6. **Multi-author team**: 8 authors from same institution
7. **Zenodo DOI**: Both software (doi.org/10.5281/zenodo.7695369) and example data (doi.org/10.5281/zenodo.10886961)
8. **Detailed author bios**: Extensive biographies for all 8 authors

## Notable Quotes
- "openness, transparency, and reproducibility combined with the use of open and widely available data"
- "The lack of transparency, limited reproducibility, and the high effort required to re-implement customized and extended variants of such methods inhibit wider application"
- "We therefore encourage experimentation with different definitions of bikeability and walkability"
