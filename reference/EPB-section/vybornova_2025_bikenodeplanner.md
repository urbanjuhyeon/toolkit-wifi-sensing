# BikeNodePlanner: A data-driven decision support tool for bicycle node network planning

**Authors**: Anastassia Vybornova, Ane Rahbek Vierø, Kirsten Krogh Hansen and Michael Szell

**Journal**: EPB: Urban Analytics and City Science, 2025, Vol. 52(7) 1771–1780

**DOI**: 10.1177/23998083251355999

**Type**: Open Source Software - Decision support tool (PyQGIS)

---

## Summary

BikeNodePlanner is the first fully open-source, reproducible decision support tool for bicycle node network planning. A bicycle node network is a wayfinding system for recreational cyclists consisting of numbered signposts placed along existing infrastructure—requiring no new road construction, making it cost-effective. The BikeNodePlanner is a modular PyQGIS tool that evaluates network design proposals against best-practice criteria including edge/loop lengths, network connectivity, accessibility to facilities/services/POIs, landscape variation, and elevation. Developed in collaboration with Dansk Kyst- og Naturturisme (DKNT) for Denmark's nationwide bicycle node network implementation, the tool is applicable to any study area worldwide and designed for users with minimal GIS experience.

---

## Key Contributions

1. **First dedicated tool**: No previous data-driven decision support tools existed for bicycle node network planning
2. **Open-source PyQGIS**: Modular Python scripts running in free QGIS software, fully reproducible
3. **Best-practice criteria integration**: Incorporates DKNT's bicycle node network planning handbook (DKNT, 2024)
4. **Network structure analysis**: Includes graph theory metrics (loops, disconnected components) critical for node networks
5. **Multi-criteria evaluation**: 8 customizable evaluation metrics with interactive QGIS visualization
6. **Accessibility focus**: No programming background required, detailed step-by-step documentation
7. **Demonstrated application**: Applied to Fyn and Islands (Funen) region, Denmark's first large-scale implementation

---

## Bicycle Node Networks: Concept

### Definition
- **Map view**: Numbered locations (nodes) connected by recreational cycling routes (edges)
- **Cyclist view**: Signposts at each node directing to neighboring nodes
- **Key advantage**: Flexible round trips vs traditional A-to-B routes; customizable trip lengths

### Implementation
- Install signposts only—no infrastructure upgrades required
- Cost-effective compared to protected bicycle path networks
- First implemented: Belgium 1990s
- Current adoption: Netherlands, Luxembourg, France, Germany, Denmark

### Benefits
- Encourages sustainable tourism and rural cycling
- "Gateway" to utility cycling for non-regular cyclists
- Decreases mass tourism's climate burden
- Boosts everyday cycling in rural areas

---

## Planning Challenge

**Problem**: Planning a regional network involves:
- Millions of potential node placements
- Numerous constraining conditions (safety, connectivity, variation, services)
- Currently manual process requiring substantial planner resources

**Research gap**:
- Rural cycling heavily understudied vs urban cycling
- Existing cycling network literature focuses on urban protected infrastructure
- Few studies on recreational networks; none provide reproducible tools
- Previous approaches: Mathematical optimization (not reproducible) or desktop GIS heuristics (no network structure analysis)

---

## BikeNodePlanner Features

### Evaluation Metrics (Table 1)

| Metric | Criteria | Default thresholds | Output |
|--------|----------|-------------------|--------|
| **Edge length** | Allow shorter trips, route variation | Ideal: 1–5 km; Max: 10 km (3 km for dead-ends) | Color-coded edges by length category |
| **Loop length** | Enable roundtrips | Ideal: 8–20 km | Color-coded loops by length category |
| **Disconnected components** | No isolated sub-networks | Count = 0 | Each component shown in different color |
| **Facilities accessibility** | Toilets, picnic areas, food | Every 10 km (toilets), 5 km (picnic); Buffer: 100 m | Within/outside reach visualization |
| **Services accessibility** | Camping, hotels (overnight accommodation) | Buffer: 750 m | Within/outside reach visualization |
| **POI accessibility** | Tourist destinations, recreational value | Buffer: 1500 m | Within/outside reach visualization |
| **Landscape variation** | Route through diverse land uses | User-defined | Network segments through each landscape type |
| **Elevation** | Avoid steep slopes | Max slope: 6% | Color-coded slope; highlights exceeding threshold |

### Workflow (Figure 3)

**I. Installation**
- Install QGIS
- Python setup

**II. Data and parameters**
- Fill out config files
- Generate input data (for Denmark: automated via `bike-node-planner-data-denmark`)

**III. Analysis** (8 modular PyQGIS scripts):
0. Verify input data
1. Visualize input network and study area
2. Evaluate network access (point and polygon data)
3. Evaluate network slope
4. Evaluate network structure (disconnected components)
5. Evaluate network edge lengths
6. Evaluate network loop lengths
7. Summarize evaluation (statistics)
8. Export map visualizations

**Output**: Interactive QGIS layers + .gpkg files for each evaluation

---

## Data Requirements

### Required Input
- **Network design proposal**: Spatial dataset with nodes and edges

### Optional Input (all optional—tool runs without them)
- **Point data**: Facilities (toilets, picnic areas), services (camping, hotels), POIs (tourist attractions)
- **Polygon data**: Land use, landscape types (forests, water, cultural areas)
- **Elevation data**: DEM for slope calculation

### Customization
- User-defined distance buffers for accessibility metrics
- User-defined thresholds for edge/loop length classification
- User-defined slope thresholds

---

## Case Study: Fyn and Islands (Funen), Denmark

**Context**: First region in Denmark for large-scale bicycle node network implementation

**Results** (Figure 2):
- a) Edge length classification: Identifies too-short, ideal, above-ideal, too-long edges
- b) Loop length classification: Shortest roundtrips at each node
- c) Network components: Single connected network vs isolated segments
- d) Accessibility: Facilities/services/POIs within vs outside network reach
- e) Landscape variation: Network coverage through cultural/natural areas
- f) Slope: Highlights edges exceeding 6% slope threshold

**Value**: Highlights areas needing adjustments before signpost installation

---

## Technical Specifications

### Platform
- **Software**: QGIS (free and open-source GIS)
- **Language**: Python (PyQGIS)
- **OS**: Developed on MacOS, tested on MacOS and Windows

### Repositories
- **Main tool**: github.com/anastassiavybornova/bike-node-planner
  - Zenodo snapshot: doi.org/10.5281/zenodo.14536130
- **Denmark data**: github.com/anastassiavybornova/bike-node-planner-data-denmark
  - Zenodo snapshot: doi.org/10.5281/zenodo.14536147

### Design Principles
- **Modular**: Each evaluation step is independent script
- **Accessible**: Detailed instructions for non-programmers
- **Customizable**: User-defined parameters for all metrics
- **Reproducible**: Complete workflow documentation

---

## Limitations and Future Work

### Current Limitations
1. **No iterative editing**: Not yet live feedback with continuously updated evaluation results
2. **Evaluation-only**: Does not generate design proposals, only evaluates existing proposals
3. **Manual proposal creation**: Planners must create initial network design

### Future Directions
1. **Automated generation**: Data-driven design proposal generation for regional networks
2. **Public transport integration**: Increase network accessibility via transit connections
3. **Iterative workflow**: Real-time evaluation updates during network editing

---

## Relevance to Our Project

### Methodological Parallels
1. **Decision support framing**: Tool for evaluating proposals, not prescriptive algorithm
2. **Multi-criteria evaluation**: Similar to our accessibility metrics (coverage, choice, temporal trends)
3. **Network structure analysis**: Graph theory metrics (connectivity, loops) parallel to our transport network routing
4. **Open-source PyQGIS**: Python-based GIS workflow with reproducible scripts
5. **User-defined thresholds**: Customizable parameters (like our 10min car / 30min transit thresholds)

### Key Differences
- **Domain**: Recreational cycling (rural) vs service accessibility (urban/suburban)
- **Network type**: Signposted routes on existing roads vs routing on transport networks
- **Primary metric**: Physical network quality vs accessibility to destinations
- **Temporal scope**: Single time point vs longitudinal comparison

### Lessons for Our Manuscript

**Tool documentation**:
1. **Feature table**: Table 1 clearly maps criteria → quantification → tool output → figure reference
2. **Workflow diagram**: Figure 3 shows installation → data prep → modular analysis steps
3. **Modular structure**: 8 numbered steps with clear inputs/outputs
4. **User guidance**: "Designed for users with minimal experience using GIS software"

**Evaluation presentation**:
1. **Visual grid**: Figure 2 shows 6 evaluation types side-by-side for comparison
2. **Color coding**: Consistent logic (green=ideal, yellow=acceptable, red=problematic)
3. **Default thresholds**: Provides recommended values but allows customization
4. **Interactive outputs**: QGIS layers for exploration, not just static maps

**Research gap framing**:
- "Rural cycling heavily understudied" → We can say "Longitudinal multimodal accessibility workflows heavily undocumented"
- "No data-driven decision support tools available" → Similar gap we're filling
- Cites existing work (mathematical optimization, desktop GIS) but explains why not sufficient

**Collaboration narrative**:
- "Developed in collaboration with DKNT" → Real-world planning partner validates tool utility
- "Part of larger effort to implement nationwide network" → Practical application context

**Future work**:
- Honest about limitations (no iterative editing, no automated generation)
- Clear about next steps without overpromising

---

## Notes

This paper is highly relevant because:

1. **Similar tool contribution**: Decision support tool, not new algorithm—workflow documentation as scholarly contribution
2. **PyQGIS/Python approach**: Could inform our future workflow tool development
3. **Multi-criteria evaluation structure**: Organizing multiple metrics with customizable thresholds
4. **Rural/regional focus**: Parallels our subnational multi-city coverage
5. **Practical collaboration**: DKNT partnership shows real-world utility

The modular workflow structure (8 numbered steps) could inspire how we document our R5R pipeline (GTFS download → quality checks → network build → routing → accessibility calculation).

The "best-practice criteria" framing (Table 1) mirrors how we could present our methodology choices (e.g., percentile aggregation, temporal thresholds, coverage vs choice metrics).

The paper demonstrates that "first tool of its kind" is a valid contribution even when underlying methods exist—the value is in making them accessible and reproducible.
