# Salat et al. (2023) - Synthetic Population Catalyst

## Citation
Salat, H., Carlino, D., Benitez-Paez, F., Zanchetta, A., Arribas-Bel, D., & Birkin, M. (2023). Synthetic population Catalyst: A micro-simulated population of England with circadian activities. *Environment and Planning B: Urban Analytics and City Science*, 50(8), 2309–2316. https://doi.org/10.1177/23998083231203066

## Artifact Type
**Open Source Software (OSS) + Open Data Product (ODP)** - Rust tool for synthetic population generation

## What It Is
- Open-source tool for generating synthetic populations for any area in England
- Creates individual-level data with sociodemographic characteristics and geolocalized daily activities
- Outputs available for all lieutenancy areas in England without running the code
- Built in Rust for high performance (30 seconds for 2.3M individuals, 13 minutes for 8.7M)
- Protocol buffer output format for efficient data transfer

## Why It Matters
- Fills gap between census data (small area counts, limited attributes) and surveys (rich attributes, no geography)
- Enables research on social interactions without precise transport trip modelling
- Applications: pandemic spread, segregation patterns, inequality of opportunity
- Addresses challenges of computational requirements, data source integration, and area coverage
- Originated from Royal Society's RAMP initiative for COVID-19 pandemic modelling (DyME project)

## Key Technical Details

### Data Sources
| Category | Source | Description |
|----------|--------|-------------|
| Population | SPENSER | 2011 census disaggregated to MSOA, updated to 2020 |
| Health | Health Survey for England 2017 | Joined via propensity score matching |
| Time use | Time Use Survey 2014-15 | Daily activity patterns |
| Income | ONS salary data | Hourly wage/annual salary by SOC, region, hours, sex |
| Mobility | QUANT project | Probability matrix of flows between MSOAs |
| Commuting | Nomis datasets | Workplace breakdown by size and industry (LSOA) |
| Lockdown | Google mobility reports | Daily coefficients for COVID-19 period |
| Geography | ONS boundaries + OSM | MSOA boundaries and building footprints |

### Implementation
- **Language**: Rust (type safety, concurrency, high performance)
- **Output format**: Protocol buffer (efficient binary, auto-generated parsers)
- **Scale**: MSOA level (~8,000 people per unit) for year 2020
- **Coverage**: All of England

### Performance Benchmarks
| Area | Population | Runtime |
|------|-----------|---------|
| West Yorkshire | 2.3 million | ~30 seconds |
| Greater London | 8.7 million | ~13 minutes |

## Main Functions / Workflow
```
User Inputs                    Data Sources                    Applications
     │                              │                              │
     ▼                              ▼                              ▼
┌─────────────┐           ┌─────────────────────┐         ┌─────────────┐
│ List of     │           │ SPENSER + Health    │         │ ASPICS      │
│ MSOAs       │──────────▶│ Survey + Time Use   │────────▶│ (Epidemics) │
│             │           │ + ONS Income        │         ├─────────────┤
│ Parameters  │           │ + QUANT + Nomis     │         │ DyME-CHH    │
│             │           │ + Google Mobility   │         │ (Climate)   │
└─────────────┘           └─────────────────────┘         ├─────────────┤
                                   │                      │ Segregation │
                                   ▼                      │ Analysis    │
                          ┌─────────────────────┐         └─────────────┘
                          │ Synthetic Population│
                          │ with Daily Activities│
                          │ (Protocol Buffer)   │
                          └─────────────────────┘
```

## Usage Options
1. **Pre-compiled outputs**: Download proto-buffer files for lieutenancy areas directly
2. **Custom areas**: Install tool, provide list of MSOA codes, generate output
3. **Format conversion**: Guidance for JSON, numpy arrays, map visualization

## Limitations
1. Outputs only contain individuals within specified area; activities constrained to same area
2. Daily retail/school activities limited to fixed set of 10/5 venues per MSOA
3. No weekend/weekday distinction
4. Combining areas requires re-running SPC with merged MSOA list (not file append)

## Applications Demonstrated
1. **ASPICS**: Agent-based Simulation of ePIdemics at National Scale (SEIR model for COVID-19)
2. **DyME-CHH**: Dynamic Microsimulation for Environment - Climate, Heat, and Health
3. **Segregation analysis**: Patterns beyond physical proximity, exclusionary interactions

## Paper Structure (~3,000 words)
1. Introduction - Need for synthetic population data
2. Data sources and methods - Framework, data integration, Rust implementation
3. Usage and limitations - Output format, pre-compiled data, constraints
4. Applications - Three example use cases
5. Conclusions and future directions

## Relevance to Our Project
| Aspect | SPC | Our Project |
|--------|-----|-------------|
| Artifact type | Rust tool + pre-compiled data | Python workflow + calculated metrics |
| Focus | Synthetic population with activities | Accessibility metrics |
| Data integration | Census + surveys + mobility | GTFS + OSM + POI |
| Scale | Individual level (MSOA) | Grid/zone level |
| Coverage | England national | Korean cities |
| Output | Protocol buffer | GeoPackage/CSV |

## Lessons for Our Manuscript
1. **Dual artifact**: Describe both software AND pre-computed data product
2. **Performance benchmarks**: Report runtime on specific hardware (30s for 2.3M, 13min for 8.7M)
3. **Pre-compiled outputs**: Provide ready-to-use data for users who don't want to run code
4. **Multiple access modes**: Direct download vs custom generation
5. **Application examples**: Show concrete use cases (ASPICS, DyME-CHH)
6. **Limitations transparency**: Explicit list of constraints (area boundaries, venue limits)
7. **Language choice justification**: Explain why Rust (type safety, performance)
8. **Versioned schema**: Allow users to migrate to updated versions at convenience
9. **Origin story**: Trace lineage from initial project (DyME → SPC)

## Notable Quotes
- "The lack of reproducibility, reusability, and the scarcity of data sources and tools create significant impediments for researchers"
- "This paper is therefore the description of both open-source software and an open data product"
- "Users do not need to install the SPC to get familiar with the synthetic population characteristics"
- "We would like to encourage other researchers wanting to enrich the synthetic population to contact the SPC team"

## Repository
- **GitHub**: https://github.com/alan-turing-institute/uatk-spc
- **Documentation**: https://alan-turing-institute.github.io/uatk-spc/
- **DOI**: 10.5281/zenodo.6586791
- **License**: MIT
