# Higgs et al. (2025) - Global Healthy and Sustainable City Indicators

## Citation
Higgs, C., Lowe, M., Giles-Corti, B., Boeing, G., Delclòs-Alió, X., Puig-Ribera, A., ... & Alderton, A. (2025). Global Healthy and Sustainable City Indicators: Collaborative development of an open science toolkit for calculating and reporting on urban indicators internationally. *Environment and Planning B: Urban Analytics and City Science*, 52(5), 1252–1270. https://doi.org/10.1177/23998083241292102

## Type
Open Source Software (OSS) - Python toolkit

## Summary
Describes the collaborative development of an open-source software toolkit for calculating and reporting policy and spatial indicators of urban design and transport features for healthy and sustainable cities. The software was developed through action research engaging 20 co-researchers from diverse global contexts to support the 1000 Cities Challenge.

## Key Contributions
1. **Action research-informed software development**: Fusion of action research methodology with Agile software engineering practices
2. **Integrated toolkit**: Combines policy auditing with spatial indicator analysis and report generation
3. **Multiple usage modes**: Web app, command-line, Python module, Jupyter notebook
4. **Customization capacity**: Support for local data, alternative population sources, custom study boundaries
5. **Reproducibility focus**: Detailed provenance logging, open data formats, documented workflows

## Methodology
- **Participants**: 20 co-researchers from 13 cities across 9 countries (51.3% participation rate from 39 invited)
- **Data collection**: Online survey + workshops (March-October 2023)
- **Engagement**: Iterative feedback cycles via workshops, emails, GitHub discussions
- **Ethics approval**: RMIT University (project ID 25552)

## Software Features
### Four-step workflow:
1. **Configure**: Define regions, indicators, data sources
2. **Analyse**: Calculate spatial indicators
3. **Generate**: Produce maps, reports, data outputs
4. **Compare**: Within/between city comparisons

### Outputs:
- Policy and spatial indicator reports (PDF)
- Spatial data (GeoPackage, CSV)
- Interactive maps (HTML)
- Metadata (XML, YML)

## Co-researcher Feedback Themes
1. **Ease of use**: Need for non-technical accessibility vs. flexibility trade-offs
2. **Configuration**: Initially complex, improved with city-specific files and better documentation
3. **Customization**: Support for alternative data (OSM alternatives, official population grids, demographic subgroups)
4. **Comparisons**: Within-city and peer-city comparisons; avoid league tables
5. **Validation**: Need for guidance on data quality checks
6. **Reporting**: Contextual information, multilingual support, sub-region flexibility
7. **Guidance**: Short videos, visual instructions, code examples

## Technical Details
- **Language**: Python
- **Distribution**: PyPI, GitHub, Docker
- **Data sources**: OpenStreetMap, Global Human Settlements Layer, custom data options
- **Indicators**: Walkability, population density, intersection density, access to fresh food/public transport/public open space
- **Documentation**: https://healthysustainablecities.github.io

## Use Cases
- Benchmarking cities internationally
- Monitoring changes over time (longitudinal analysis)
- Before/after intervention impact assessment
- Sensitivity analyses for methodological decisions
- Sub-population analysis (age, gender stratification)

## Challenges Addressed
1. **Open data limitations**: Flexibility to use alternative official data where OSM quality is poor
2. **Reproducibility crisis**: MILP-based optimization, detailed provenance, FAIR principles
3. **Local contextualization**: User-configurable summaries, multilingual reporting
4. **Neo-colonial science**: Empowering local teams to represent their own urban realities

## Relevance to Our Project
- **Methodological parallel**: Both projects emphasize open science, reproducibility, accessibility
- **Different scope**: GHSCI focuses on walkability/accessibility indicators; our project on longitudinal multimodal accessibility
- **Shared challenges**: Data quality, validation, contextualization, report generation
- **Paper structure**: Action research approach, co-development with stakeholders

## Lessons for Our Manuscript
1. Demonstrate user engagement process (workshops, surveys)
2. Provide multiple access/usage modes for different skill levels
3. Emphasize reproducibility through detailed documentation
4. Include validation guidance
5. Support customization for local contexts
6. Balance standardization with flexibility
7. Avoid paternalistic or neo-colonial framing
