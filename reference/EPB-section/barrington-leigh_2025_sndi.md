# Barrington-Leigh & Millard-Ball (2025) - SNDi Global Time Series

## Citation
Barrington-Leigh, C., & Millard-Ball, A. (2025). A high-resolution global time series of street-network sprawl. *Environment and Planning B: Urban Analytics and City Science*, 52(6), 1525–1536. https://doi.org/10.1177/23998083241306829

## Type
Open Data Product (ODP) - Global street network dataset

## Summary
Provides a global, high-resolution time series (1975-2023) of the Street Network Disconnectedness Index (SNDi) quantifying street connectivity worldwide. Data released as 1 km grid, vector network (nodes/edges), and aggregated to countries and 5 subnational administrative levels.

## Key Contributions
1. **High-resolution global dataset**: SNDi at 1 km grid resolution for entire planet
2. **Time series**: Longitudinal analysis 1975-2019 using GHSL urban expansion data
3. **Network simplification algorithm**: Corrects systematic biases from complex intersections and divided roads
4. **Multiple formats**: Raw network (nodes/edges), 1 km grid, administrative boundaries

## Data Specifications
- **Temporal coverage**: Cross-section (2023), time series (1975-2019 in 4 epochs)
- **Spatial resolution**: 1 km grid + vector network
- **Geographic scope**: Global
- **Source**: OpenStreetMap (October 2023 vintage)
- **Urban classification**: GHSL GHS-SMOD (degree of urbanization)
- **License**: CC BY 4.0
- **Access**: OSF (https://osf.io/c9hjy), interactive maps (sprawlmap.org)

## SNDi Methodology
### 13 connectivity measures aggregated via PCA:
- Nodal degree (proportion of 4-way intersections, deadends)
- Circuity (network distance / Euclidean distance)
- Sinuosity (curviness of street edges)
- Graph-theoretic properties (bridges, dendricity)

### Network Simplification (new algorithm):
1. **Complex intersections**: Identify clusters of nodes within 20m, select representative node, ignore intra-cluster nodes/edges in aggregation
2. **Divided roads**: Identify parallel edges with same OSM name, randomly select one to represent
3. **Annealing**: Remove degree-2 nodes (not intersections)

Higher SNDi = more sprawl = less connectivity

## Key Findings
- **Global patterns**: Highest connectivity in South America (Argentina), Europe, North Africa, Japan/South Korea. Lowest in Southeast Asia (Thailand, Bangladesh, Indonesia, Philippines).
- **Temporal trends**: Rapidly worsening connectivity globally, especially in developing/middle-income countries and Southeast Asia
- **Recent development (2005-19)**: Even more disconnected than historical stock in most regions
- **Lock-in**: Street patterns rarely change even after fires, wars, earthquakes

## Technical Details
- **Computation**: PostgreSQL/PostGIS, Python, 56 processors, ~0.7 TB RAM
- **Processing time**: ~1 month for entire planet
- **Costly stages**: Network simplification (~12 days), circuity/graph properties (~14 days)
- **Circuity correction**: Relaxed distance constraint from 3 km to 5d₂ (e.g., 15 km for 2.5-3 km band)

## Data Formats
1. **Gridded**: 1 km resolution with SNDi and 13 component metrics
2. **Vector polygons**: Aggregated to GADM v4.1 boundaries (countries + 5 subnational levels)
3. **Vector network**: Nodes and edges with characteristics

## Differences from Previous Work (2019)
1. Updated OSM data (2019 → 2023 vintage)
2. Improved simplification algorithm (complex intersections, divided roads)
3. Extended time series (2015 → 2019)
4. Released full 1 km grid (previously only countries/200 cities)
5. GHSL-based urban classification (previously custom thresholds)

## Comparison with Boeing (2021)
- Boeing: Urban centers only, no time series, excludes bike/ped paths
- This work: 1 km grid (not confined to urban boundaries), time series 1975-2020, includes bike/ped paths, network simplification

## Relevance to Our Project
- **Methodological parallel**: Both produce global longitudinal datasets on urban form
- **Different focus**: SNDi on street connectivity; our project on accessibility
- **Complementary**: Street connectivity is input to accessibility analysis
- **Open data**: Both emphasize reproducibility, open data, global coverage

## Lessons for Our Manuscript
1. Release data in multiple formats (grid, vector, aggregated)
2. Provide interactive visualization website
3. Document algorithm changes and their impacts
4. Compare with existing datasets explicitly
5. Use established data sources (GHSL, GADM) for comparability
6. Emphasize temporal lock-in and importance of current decisions
