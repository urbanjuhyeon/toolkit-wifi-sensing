# Phillips & McCarthy (2024) - Warehouse CITY

## Citation
Phillips, S. A., & McCarthy, M. C. (2024). Warehouse CITY – An open data product for evaluating warehouse land-use in Southern California. *Environment and Planning B: Urban Analytics and City Science*, 0(0), 1-9. https://doi.org/10.1177/23998083241262553

## Artifact Type
**Open Data Product (ODP)** - Dashboard and dataset for cumulative impact analysis

## What It Is
- Interactive dashboard to visualize and quantify warehouse cumulative impacts in Southern California
- CITY = "Cumulative Impact Tool for communitY"
- Covers Los Angeles, Riverside, San Bernardino, Orange counties
- Estimates: warehouse counts, acreage, building footprint, truck trips, diesel PM, NOx, CO2, jobs
- Categories: existing warehouses + planned/approved projects

## Why It Matters
- CEQA requires cumulative impact analysis but existing data is inaccessible
- Proprietary CoStar data cannot be shared; Census business patterns lack spatial resolution
- Tool used in: project approvals, advocacy, lawsuits, education, policy guidance
- Real example: expert testimony in county redistricting case (environmental justice)
- Air district using tool to adjust CEQA cumulative significance thresholds

## Key Technical Details
- **Data sources**: County assessor parcel data (open), TIGER/Line boundaries, EMFAC2021 emission factors
- **Processing**: R (sf, tidyverse, shiny, leaflet)
- **Dashboard components**: (1) User interface, (2) Summary table, (3) Map, (4) Detailed table
- **Calculation factors**: Floor area ratio, truck trips per sq ft, emission factors per mile
- **Spatial selection**: Circle radius for great circle distance analysis

## Paper Structure (~3,000 words)
1. Introduction - Warehouse growth, environmental justice, CEQA requirements
2. Methods - Data sources, processing, calculation factors
3. Results - Dashboard description with annotated screenshot
4. Lessons learned - Peer review, export options, political districts
5. Concluding remarks

## Relevance to Our Project
| Aspect | Warehouse CITY | Our Project |
|--------|----------------|-------------|
| Artifact type | Dashboard + data | Workflow/pipeline |
| Focus | Cumulative impact | Accessibility change |
| Policy relevance | CEQA compliance | Service equity |
| User base | Community groups, agencies | Researchers, planners |
| Interactive | Yes (Shiny dashboard) | No (static book) |

## Lessons for Our Manuscript
1. **Real-world applications**: Document actual use cases (lawsuits, policy guidance)
2. **Multiple user types**: Tool serves community groups, agencies, researchers differently
3. **Transparent calculations**: Show equations and allow user to override defaults
4. **Expert peer review**: Internal review improved emission calculations
5. **Export options**: Critical for offline testimony and data sharing
6. **Data heterogeneity**: Harmonizing county-specific data into unified structure
7. **Maintenance challenge**: Keeping data updated is time-consuming
8. **Political relevance**: Including legislative district selections enhances utility
