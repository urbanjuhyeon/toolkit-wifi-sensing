# MAP: Mapping accessibility for ethically informed urban planning

**Authors**: Ruth Nelson, Martijn Warnier and Trivik Verma

**Journal**: EPB: Urban Analytics and City Science, 2025, Vol. 0(0) 1–9

**DOI**: 10.1177/23998083251387382

**Type**: Open Source Software - Python notebooks for spatial justice in accessibility analysis

---

## Summary

MAP (Mapping Accessibility for Ethically Informed Urban Planning) is an open-source Python software package that operationalizes multiple notions of justice in accessibility analysis. Designed specifically NOT to require GTFS data (to serve data-scarce regions), MAP uses open-access data sources (OSM, Google Routes API, government data) to build Urban Network Models and calculate Neighbourhood Reach Centrality. The package enables evaluation of accessibility from three ethical perspectives: Egalitarian (equality-based), Utilitarian (maximize benefit for greatest population), and Rawlsian (maximize benefit for most vulnerable). Demonstrated with Cape Town, South Africa data (MyCiti BRT + MetroRail), MAP provides 6 Jupyter notebooks covering network construction, accessibility calculation, and spatial justice metric visualization. The output maps serve as boundary objects for stakeholder engagement in ethically informed urban planning.

---

## Key Contributions

1. **Multi-perspective justice framework**: First package to operationalize Egalitarian, Utilitarian, and Rawlsian principles in a single comparative framework for accessibility analysis
2. **GTFS-free design**: Specifically designed NOT to require GTFS data, enabling analysis in data-scarce regions using alternative sources (OSM, Google Routes API, government data)
3. **Three-stage workflow**: (a) Urban Network Model creation, (b) Neighbourhood Reach Centrality calculation, (c) Spatial Justice Metrics
4. **Ready-to-use data product**: Cape Town example data (MyCiti BRT + MetroRail + employment POIs + socio-economic indicators) provided
5. **Boundary object for stakeholder engagement**: Maps visualize trade-offs between justice perspectives to facilitate interdisciplinary decision-making
6. **Modular Python notebooks**: 6 notebooks (A-F) with clear documentation, adaptable to any context

---

## Methodology

### Conceptual Framework

**Accessibility as social-economic opportunities** derived from proximity to employment, healthcare, education (Geurs and Van Wee, 2004)

**Three notions of justice**:
- **Egalitarian**: All neighbourhoods should have equal access (ideal = average access)
- **Utilitarian**: Access maximized for neighbourhoods with greatest population (ideal proportional to population size)
- **Rawlsian**: Access maximized for most vulnerable neighbourhoods (ideal proportional to vulnerability score based on income, employment, education)

**Gap metrics**: Difference between existing and ideal Neighbourhood Reach Centrality
- Gap ≥ 0: Neighbourhood meets or exceeds justice criterion
- Gap < 0: Neighbourhood falls short of ideal access

### Urban Network Model (UNM)

**Directed graph representation**:
- **Vertices**: Street intersections, land use POIs, transport stations/stops
- **Edges**: Streets, transport routes, connector edges (land use to street, transport to street)
- **Edge weights**: Travel time (walking or public transport)

**Libraries used**:
- OSMnx: Download street network from OpenStreetMap
- GeoPandas: Spatial data handling
- SNKIT: Connect land use/transport vertices to nearest street edges
- NetworkX: Graph construction and analysis

### Neighbourhood Reach Centrality (NRC)

**Cumulative accessibility metric**: Count of opportunities (e.g., employment) reachable within time threshold T

**Calculation parameters**:
- Time thresholds: 15, 30, 45, 60 minutes
- Maximum walking time threshold (user-defined)
- Source: All street vertices within each neighbourhood
- Target: Employment vertices (or other POIs)

**Aggregation**: NRC calculated per neighbourhood (not per vertex) to link with socio-economic data

### Spatial Justice Metrics

**Equality Reach Gap**:
```
Ideal_access = Average NRC across all neighbourhoods
Gap = Existing NRC - Ideal_access
```

**Utilitarian Reach Gap**:
```
Ideal_access = Total_opportunities × (Neighbourhood_population / Total_population)
Gap = Existing NRC - Ideal_access
```

**Rawls' Reach Gap**:
```
Vulnerability_score = Composite index (0-1) from income, employment, education
Ideal_access = Total_opportunities × (Neighbourhood_vulnerability / Total_vulnerability)
Gap = Existing NRC - Ideal_access
```

---

## Data Requirements

### Required Inputs

**1. Point of Interest (POI) data** (shapefile/GeoJSON):
- Point geometry with coordinates
- Type/name of each POI
- Example: Employment locations, healthcare facilities, educational institutions, parks

**2. Transport data** (for each mode):
- **Routes file** (shapefile/GeoJSON): Source station, target station, travel time (minutes), line geometry
- **Stations file** (CSV): Station/stop names (must be unique), x/y coordinates
- Example: MyCiti BRT, MetroRail trains

**3. Socio-economic data** (shapefile/GeoJSON):
- Neighbourhood administrative units (polygon geometry)
- Population, age distribution, education levels, employment, income
- Example: Total population, population 18+, matric diploma holders, employed population, average income

**4. Street network**: Downloaded automatically from OSM via OSMnx

### Data Sources (NOT requiring GTFS)

- **OpenStreetMap**: Street networks (via OSMnx)
- **Google Routes API**: Travel times between stations/stops
- **Government agencies**: Official transport data
- **Transport operators**: Route and schedule information

**Note**: If GTFS data is available, it can be simplified to required format by extracting station names, coordinates, and average travel times. Multiple UNMs can be created for different times of day.

---

## Software Package Structure

### Repository Organization

**Metadata folder**:
- `Data Dictionaries.xlsx`: Contents, format, structure of datasets and outputs
- `Notebook descriptions.xlsx`: Summary of each notebook's purpose

**Py folder**:
- `spatial_justice.py`: Functions for calculating NRC and spatial justice metrics (equality, utility, rawls, vul_score)

**Libraries folder**:
- `requirements.md`: List of Python packages to install

**Notebooks folder** (3 subfolders):

1. **Graph preparation** (Notebooks A-D):
   - Notebook A: Link road network + land use data
   - Notebook B: Link transport networks (run for each mode)
   - Notebook C: Concatenate transport routes
   - Notebook D: Create two-way connector edges

2. **Reach calculations**:
   - Notebook E: Calculate Neighbourhood Reach Centrality

3. **Spatial justice calculations**:
   - Notebook F: Calculate Equality, Utilitarian, Rawls' Reach Gap

---

## Workflow (6 Notebooks)

### Notebook A: Linking road network and land use data

**Input**: Land use POIs (shapefile/GeoJSON)
**Process**:
1. Download street network from OSM using OSMnx
2. Convert to GeoPandas DataFrames (edges, vertices)
3. Concatenate street vertices + land use vertices
4. Use SNKIT to connect each land use vertex to nearest street edge (creates connector edges)
5. Label vertices/edges (street vs land use)
**Output**: Network A (edges + vertices shapefiles)

### Notebook B: Linking transport network/s

**Input**: Network A, transport vertices (e.g., MyCiti BRT stations)
**Process**:
1. Load Network A edges + vertices
2. Separate land use connectors from streets
3. Use SNKIT to connect BRT vertices to nearest street edges
4. Rejoin separated edges/vertices
**Output**: Network B (edges + vertices shapefiles)
**Note**: Run separately for each transport mode (BRT, rail, etc.)

### Notebook C: Concatenating transport routes

**Input**: Network B edges (with lengths calculated in QGIS), transport routes
**Process**:
1. Calculate edge lengths in QGIS (Field Calculator, considers earth curvature)
2. Load Network B edges + transport routes as DataFrames
3. Concatenate together
4. Add `time-cost` column (walking time for streets, specific times for connector edges)
**Output**: Network B with transport routes (edges shapefile)

### Notebook D: Creating two-way connector edges

**Input**: Edges from Notebook C
**Process**: Create two-directional edges for one-directional connector edges (required for directed graph)
**Output**: Bidirectional connector edges (edges shapefile)

### Notebook E: Calculating Neighbourhood Reach Centrality

**Input**: Edges (Notebook D), vertices (Notebook C), neighbourhood geometries, `spatial_justice.py`
**Process**:
1. Spatial join: Assign each vertex to neighbourhood
2. Create NetworkX graph from vertices + edges
3. Define source vertices (street vertices, grouped by neighbourhood)
4. Define target vertices (employment vertices)
5. Calculate NRC using `calculate_reach_centrality` function (15, 30, 45, 60 min thresholds)
6. Create DataFrame with NRC values + socio-economic data + geometries
**Output**: Neighbourhood geometries with NRC values (shapefile)

### Notebook F: Spatial Justice Metrics

**Input**: Neighbourhood geometries (Notebook E), `spatial_justice.py`
**Process**:
1. Import neighbourhoods + socio-economic data
2. Normalize socio-economic data for relative comparisons
3. Calculate vulnerability score using `vul_score` function (composite index from income, employment, education)
4. Apply `equality` function: Ideal access = average NRC
5. Apply `utility` function: Ideal access proportional to population
6. Apply `rawls` function: Ideal access proportional to vulnerability score
7. Calculate gaps (existing - ideal) for each framework
8. Visualize results in maps for comparison
**Output**: Maps showing Equality, Utilitarian, Rawls' Reach Gap

---

## Case Study: Cape Town, South Africa

**Study area**: Metropolitan area of Cape Town

**Transport modes**:
- MyCiti Bus Rapid Transit (BRT)
- MetroRail train network

**Points of interest**: Employment locations

**Socio-economic indicators**:
- Total population
- Population 18+, population 18-65
- Education (matric diploma holders = finished Grade 12)
- Employment (total employed population)
- Income (average income in Rands)

**Accessibility thresholds**: 15, 30, 45, 60 minutes

**Justice evaluation**: Maps showing which neighbourhoods meet/fall short of Equality, Utilitarian, Rawlsian ideals

---

## Technical Specifications

### Platform
- **Language**: Python
- **Environment**: Jupyter Notebooks
- **Key libraries**: OSMnx, GeoPandas, SNKIT, NetworkX, Pandas

### Data Formats
- **Input**: Shapefile, GeoJSON, CSV
- **Output**: Shapefile (network edges/vertices, neighbourhood geometries with metrics)

### Graph Representation
- **Type**: Directed graph (all edges have directionality)
- **Vertices**: Street intersections, land use POIs, transport stations/stops
- **Edges**: Streets, transport routes, connector edges
- **Edge weights**: Time cost (walking or public transport)

### Spatial Operations
- **Street network download**: OSMnx from OpenStreetMap
- **Network topology**: SNKIT for connecting vertices to nearest edges
- **Distance calculation**: QGIS Field Calculator (considers earth curvature)
- **Graph analysis**: NetworkX shortest path algorithms

---

## Data Availability

### Repository
- **URL**: https://data.4tu.nl/datasets/c34ff74b-30ce-4ed2-9e45-1910ca3e3470
- **Contents**:
  - 6 Jupyter notebooks (A-F)
  - `spatial_justice.py` file
  - Metadata (data dictionaries, notebook descriptions)
  - Libraries list
  - Cape Town example data (transport networks, employment POIs, socio-economic data)

### License
- Open-source (no funding, no conflicts of interest declared)

---

## Validation and Limitations

### Strengths
1. **No GTFS requirement**: Enables analysis in data-scarce regions using open-access alternatives
2. **Multi-perspective framework**: Explicitly compares trade-offs between justice notions
3. **Modular design**: Notebooks can be run independently, adapted to different contexts
4. **Documented workflow**: Clear comments in each notebook
5. **Ready-to-use example**: Cape Town data enables immediate experimentation
6. **Boundary object**: Maps facilitate stakeholder engagement across disciplines

### Limitations

**1. Open-access data quality**:
- Potential incompleteness or inaccuracies in OSM, Google Routes API
- Trade-off: Vital source when proprietary data unavailable

**2. Single time point**:
- Does not model time-varying accessibility (peak vs off-peak)
- Workaround: Create multiple UNMs with different travel times (if GTFS available)

**3. Static network representation**:
- No dynamic congestion, schedule adherence, service disruptions
- Assumes average travel times

**4. Vulnerability score subjectivity**:
- Composite index requires user to define weights for income, employment, education
- Different vulnerability definitions yield different Rawlsian ideals

**5. Justice frameworks**:
- Only three perspectives operationalized (Equality, Utilitarian, Rawlsian)
- Could be extended to sufficientarianism (Martens, 2016) or other theories

---

## Future Directions

### Methodological Extensions
1. **Additional justice metrics**: Sufficientarianism, capabilities approach
2. **Time-varying accessibility**: Multiple UNMs for different times of day (if GTFS available)
3. **Multi-criteria accessibility**: Employment + healthcare + education combined
4. **Sensitivity analysis**: Test impact of vulnerability score weights

### Research Applications
1. **Comparative justice analysis**: Evaluate infrastructure proposals against multiple ethical criteria
2. **Stakeholder engagement**: Use maps as boundary objects in participatory planning
3. **Educational tool**: Train urban planners/engineers to incorporate equity considerations
4. **Policy evaluation**: Compare existing vs ideal accessibility for different justice perspectives
5. **UN SDG alignment**: Support Goals 10 (Reduced Inequalities) and 11 (Sustainable Cities)

---

## Relevance to Our Project

### Methodological Parallels
1. **Accessibility measurement**: Cumulative opportunities metric (NRC) similar to our approach
2. **Open-source ethos**: Documented workflow as scholarly contribution (not just algorithm)
3. **Python notebooks**: Modular scripts with clear documentation
4. **Ready-to-use data**: Example dataset (Cape Town) parallels our pilot region data
5. **Multiple perspectives**: They evaluate Equality/Utilitarian/Rawlsian; we evaluate coverage/choice/temporal trends

### Key Differences
- **GTFS**: They avoid GTFS (data-scarce focus); we rely on GTFS (longitudinal transit analysis)
- **Temporal scope**: Single time point; we do multi-year comparison
- **Transport modes**: Walk + transit combined in UNM; we separate car vs transit
- **Routing**: NetworkX shortest path; we use R5R detailed routing
- **Primary metric**: Justice gap (existing vs ideal); we measure temporal accessibility change
- **Geographic scale**: Neighbourhood aggregation; we use hexagon grid + admin units

### Lessons for Our Manuscript

**Framing GTFS reliance**:
- MAP highlights GTFS unavailability as problem → justifies their approach
- We can acknowledge: "Unlike MAP (Nelson et al., 2025) which avoids GTFS for data-scarce regions, our workflow leverages GTFS availability to enable longitudinal multimodal analysis"
- Positions our work as complementary (GTFS-rich regions) not contradictory

**Justice/equity considerations**:
- MAP foregrounds equity as primary motivation
- We focus on measurement methodology, but could mention: "Future applications could incorporate spatial justice frameworks (e.g., Nelson et al., 2025) to evaluate who benefits from accessibility changes"

**Notebook documentation**:
- Clear structure: Notebook A (land use + streets) → B (transport) → C (routes) → D (connectors) → E (NRC) → F (justice)
- Could inspire our workflow: Script 1 (GTFS download) → 2 (quality check) → 3 (OSM network) → 4 (R5R build) → 5 (routing) → 6 (accessibility)

**Data product framing**:
- "Can be adapted to a researcher/stakeholder's own data for any context, but an example data set from Cape Town... is also made available"
- We can use: "Can be adapted to any region with GTFS coverage, demonstrated with Korean banking data"

**Boundary object concept**:
- Maps facilitate stakeholder engagement across disciplines
- We could mention: "Accessibility maps can serve as boundary objects (Star and Griesemer, 1989) for stakeholder discussions about transport equity"

**Software package structure**:
- Metadata folder (data dictionaries, notebook descriptions)
- Py folder (reusable functions)
- Libraries folder (requirements)
- Notebooks folder (modular scripts)
- Could inform our repository organization

**Figure strategy**:
- Figure 1: Three-panel overview (UNM creation → NRC calculation → Justice metrics)
- Similar to our potential workflow diagram

**Limitation honesty**:
- "There are limitations associated with open-access data, such as potential incompleteness or inaccuracies. However, when working in regions which are data scarce, they are a vital source of information."
- Acknowledges trade-offs without undermining contribution

---

## Notes

This paper is highly relevant because:

1. **Most similar to our project**: Open-source workflow for accessibility analysis, documented Python notebooks, example data provided, EPB Urban Data/Code publication
2. **Complementary GTFS positioning**: They avoid GTFS (data scarcity), we use GTFS (longitudinal analysis) → frames our work for GTFS-rich contexts
3. **Spatial justice framing**: Shows how accessibility analysis can be evaluated through multiple ethical lenses (could inform future applications of our data)
4. **Modular workflow documentation**: 6 notebooks (A-F) with clear purposes provides model for our script documentation
5. **Boundary object concept**: Maps as stakeholder engagement tools (relevant for policy applications of our workflow)

The GTFS-free design is the key differentiator. MAP is designed for data-scarce regions (South Africa, Global South) where GTFS is unavailable → uses OSM + Google Routes API + government data. Our project serves GTFS-rich regions (Korea, potentially other countries) where longitudinal transit analysis is possible → uses GTFS + R5R.

This complementarity should be highlighted: "MAP (Nelson et al., 2025) demonstrates accessibility analysis without GTFS for data-scarce regions. Our workflow addresses the complementary challenge: leveraging GTFS availability for longitudinal multimodal analysis in data-rich contexts."

The three-stage structure (Network Model → Accessibility Metric → Evaluation Framework) parallels our (Data Preparation → Routing → Accessibility Calculation → Temporal Analysis). The modular notebook design with clear documentation and example data is a strong model for our repository.
