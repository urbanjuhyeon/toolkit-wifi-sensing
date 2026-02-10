# CITYLID: A large-scale categorized aerial lidar dataset for street-level research

**Authors**: Deepank Verma, Olaf Mumm and Vanessa Miriam Carlow

**Journal**: EPB: Urban Analytics and City Science, 2025, Vol. 52(6) 1517–1524

**DOI**: 10.1177/23998083241312273

**Type**: Open Data Product - Categorized point cloud dataset

---

## Summary

CITYLID is a large-scale categorized aerial Lidar dataset covering the entire city of Berlin (1060 km²), created from publicly available raw point cloud data. The dataset categorizes ∼15 billion Lidar points into 3 standard urban classes (ground, buildings, trees) and 5 detailed street feature classes (driveways, medians, bikepaths, walkways, on-street parking). Additionally, shadow maps are generated using Digital Surface Models (DSM) and integrated with the point clouds, providing 5 shadow classes based on hours of received sunlight. The dataset addresses the common problem of uncategorized Lidar data by providing a documented workflow using LASTools for categorization and PDAL for fusing 2D street shapefiles with 3D point clouds.

---

## Key Contributions

1. **Large-scale categorized Lidar**: One of the largest categorized point cloud datasets available for urban research (∼15 billion points, 1060 tiles)
2. **Detailed street features**: Fuses 5 street component classes with standard point cloud categories
3. **Shadow integration**: Citywide shadow maps (summer solstice, 12 hours) integrated with point clouds
4. **Documented methodology**: Complete workflow from raw Lidar to categorized dataset with GitHub scripts
5. **Open accessibility**: Dataset on HuggingFace, R scripts for analysis, compatible with DL-DE license
6. **Application demonstrations**: Cross-section generation, street typology analysis, tree inventory

---

## Data Specifications

### Source Data
- **Aerial Lidar**: Berlin FISBroker Geoportal, captured 02.03.2021
- **Resolution**: 9.8 points/sqm
- **Coverage**: 1060 tiles, 1 km² each (entire city of Berlin)
- **Format**: LAS 1.4 format
- **Size**: ∼250 GB uncompressed, ∼15 billion points
- **Street data**: 67 2D shapefiles (created 2014, updated 2019)

### Point Cloud Classes

**Standard classes (3)**:
- Ground/water: 45%
- Trees: 30%
- Buildings: 7%
- Unassigned: 10% (building walls, street lamps, vehicles)

**Street feature classes (5)**:
- Streets: 8% (computed after fusion)
- Driveways
- Medians
- Bikepaths
- Walkways
- On-street parking

**Shadow classes (5)** based on hours of sunlight (June 21):
- 0–3 hours
- 3–5 hours
- 5–7 hours
- 7–10 hours
- 10–12 hours

---

## Methodology

### 1. Primary Classification (LASTools)
- **Tools**: lasground, lasheight, lasclassify (semi-proprietary)
- **Process**: Categorize raw point cloud into ground, buildings, trees
- **Note**: Water bodies classified as ground due to similar features
- **Limitation**: Building walls misclassified as unassigned; small vegetation sometimes missed

### 2. Street Feature Fusion (PDAL)
- **Input**: 5 2D street shapefiles (medians, driveways, bikepaths, walkways, parking)
- **Process**:
  1. Separate ground points from point cloud
  2. Use PDAL colorize function to paint points overlapping with street shapefiles
  3. Reattach fused points to remaining point cloud
- **Output**: 8-class urban features (3 standard + 5 street)

### 3. Shadow Map Generation (ArcGIS)
- **DSM resolution**: 0.5 m/px
- **Algorithm**: Hemispherical view shed (Rich et al., 1994)
- **Temporal scope**: Summer equinox (June 21), 0800–2000 h (12 hours)
- **Parameters**: Default settings (32 calc-directions, 0.3 diffuse proportion, 0.5 transmissivity, 8 azimuth/zenith divisions)
- **Output**: 5 shadow classes based on sunlight hours
- **Limitation**: General outlook only; precise shadow requires detailed radiation flux modeling

### 4. Final Integration
- **Result**: Two classification layers per point
  - Layer 1: 8 urban feature classes
  - Layer 2: 5 shadow classes

---

## Data Availability

### Repositories
- **Dataset**: HuggingFace (https://huggingface.co/datasets/Deepank/CITYLID)
  - Categorized point cloud (LAS format)
  - Shadow maps (raster format)
- **Code**: GitHub (https://github.com/deepankverma/navigating_streetscapes)
  - Processing scripts and code snippets
  - R-based analysis scripts (cross-sections, street distribution)
- **Raw data**: Berlin FISBroker Geoportal (https://fbinter.stadt-berlin.de/)

### License
- **DL-DE license** (Datenlizenz Deutschland): Allows commercial/research use, merging with other datasets, integration into products

---

## Applications

### Demonstrated Use Cases
1. **Street cross-sections**: Citywide generation and analysis (Verma et al., 2023)
2. **Street typology**: Generic street type comparison and metrics
3. **Tree inventory**: Identification, mapping, canopy metrics
4. **Environmental assessment**: Enclosure, sky view factors, greenery access
5. **Climate analysis**: Neighborhood heat vulnerability, shadow areas for pedestrians/cyclists
6. **Urban mobility**: Integration with street view images for visual features

### Potential Applications
- Land use planning and zoning
- Infrastructure development (bridges, buildings, roads, utilities)
- Vegetation monitoring and carbon estimation
- Disaster relief and vulnerability assessment
- AR/VR urban simulations
- Scene understanding for robotics/autonomous vehicles (when combined with terrestrial Lidar)

---

## Limitations

### 1. Resolution and Precision
- **Lower resolution** than terrestrial Lidar (9.8 points/sqm vs denser ground-based scans)
- **Not suitable** for precise measurements despite citywide coverage advantage
- **Misclassification**: Building walls → unassigned; small tree trunks/vegetation sometimes missed
- **Cause**: Point sparseness and occlusion from aerial acquisition

### 2. Shadow Generation
- **General outlook only**: Default ArcGIS parameters save processing time but lack precision
- **Limited temporal scope**: Only June 21 included; year-round analysis requires additional processing
- **Workaround**: Repository includes scripts to generate shadows for specific dates/times

### 3. Classification Methodology
- **Semi-proprietary algorithm**: LASTools inner workings unknown
- **No ground truth**: Classification accuracy difficult to ascertain
- **Visual coherence**: Results align with Berlin Geoportal building/street data
- **Generalizability concern**: Performance may vary in other regions with different built structures/vegetation
- **Future direction**: Develop DL models specifically for aerial Lidar classification

---

## Relevance to Our Project

### Methodological Parallels
1. **Open data processing**: Transform publicly available raw data (Lidar for them, GTFS/OSM for us) into analysis-ready format
2. **Fusion workflow**: Integrate 2D vector data (street shapefiles) with 3D data (point clouds) — similar to fusing GTFS with OSM networks
3. **Documented pipeline**: Complete methodology with GitHub scripts, enabling reproducibility
4. **Large-scale citywide coverage**: Berlin entire city vs Korean cities
5. **Honest limitation acknowledgment**: Classification accuracy issues, temporal scope limitations

### Key Differences
- **Data type**: 3D point clouds vs 2D accessibility metrics
- **Primary value**: Spatial categorization vs temporal accessibility trends
- **Application domain**: Urban form/street design vs service accessibility

### Lessons for Our Manuscript

**Structure insights**:
1. **Methodology diagram**: Figure 1 workflow diagram is excellent model (raw data → processing → fusion → final dataset)
2. **Quantify data volume**: "∼15 billion points", "1060 tiles", "250 GB" establishes dataset scale
3. **Classification breakdown**: Percentages for each class (45% ground, 30% trees, etc.)
4. **Tool transparency**: Clearly state software used (LASTools, PDAL, ArcGIS) with specific functions

**Limitation framing**:
- Address limitations without undermining contribution: "Although... proves advantageous for citywide applications"
- Provide workarounds: "Repository includes processes to generate shadow details for specific times"
- Acknowledge future improvements: "Aim to create DL models... in future studies"

**Application demonstration**:
- Show both realized applications (cross-sections paper) and potential uses
- Connect to broader research areas (climate, mobility, environmental assessment)
- Mention cross-disciplinary value (robotics, autonomous vehicles)

**Data availability best practices**:
1. Multiple repositories: HuggingFace (data) + GitHub (code)
2. Provide both processed dataset and raw data source
3. Include starter scripts for common analyses
4. Clear license statement enabling reuse

---

## Technical Details

### Software Stack
- **LASTools** (Rapidlasso): Point cloud classification (lasground, lasheight, lasclassify)
- **PDAL**: Point data abstraction library for fusion
- **ArcGIS**: Solar radiation pattern generation
- **R**: Analysis scripts for cross-sections and distributions

### File Format
- **Input**: LAS 1.4 (raw point cloud), Shapefiles (street features)
- **Output**: LAS 1.4 (categorized point cloud), Raster (shadow maps)

### Processing Workflow
1. Download raw Lidar (1060 tiles, 250 GB)
2. Primary classification with LASTools → ground, buildings, trees
3. Fusion with PDAL → add 5 street feature classes
4. DSM generation → 0.5 m/px resolution raster
5. Shadow calculation with ArcGIS → 5 shadow classes
6. Integration → final dataset with dual classification layers

---

## Notes

This paper is particularly relevant because:

1. **Similar data challenge**: Publicly available but uncategorized data (raw Lidar vs raw GTFS)
2. **Processing documentation value**: The workflow itself is the contribution, not new algorithms
3. **Fusion methodology**: Combining 2D vector data with 3D/temporal data structures
4. **Scale demonstration**: Citywide coverage proves workflow robustness
5. **Honest about tools**: Uses semi-proprietary LASTools, acknowledges unknown inner workings

The workflow diagram (Figure 1) showing parallel processing streams (primary classification + DSM generation + street fusion → final dataset) could inspire our GTFS processing visualization.

The three-limitation structure (resolution, shadow generation, classification methodology) provides a model for organizing our own limitations section (GTFS quality, 2024 data issues, R5R computational constraints).
