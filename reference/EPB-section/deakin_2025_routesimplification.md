# Route network simplification for transport planning

**Authors**: Will Deakin, Zhao Wang, Josiah Parry and Robin Lovelace

**Journal**: EPB: Urban Analytics and City Science, 2025, Vol. 0(0) 1–13

**DOI**: 10.1177/23998083251387986

**Type**: Open Source Software - Python package (parenx) for route network simplification

---

## Summary

This paper presents two open-source methods for simplifying complex route networks by consolidating multiple parallel linestrings (e.g., dual carriageways) into single centrelines. The problem: OpenStreetMap and detailed geographic datasets represent single transport corridors with multiple parallel lines, creating visual clutter and obscuring flow patterns in transport models. The solution: (1) **Skeletonization** - rasterize buffered networks, apply thinning algorithm, convert back to vectors (fast, ~5 sec for 1 km² urban core); (2) **Voronoi-based** - derive centrelines from Voronoi diagrams of buffered boundaries (cleaner geometry, 3.6–5.1× slower). Implemented in the **parenx Python package** and demonstrated in Scotland's Network Planning Tool (https://www.npt.scot). Case study: Edinburgh city centre successfully simplifies dual carriageways, roundabouts, and complex intersections. Both methods preserve network connectivity while reducing file sizes and rendering times. The work addresses a fundamental pre-processing need for strategic transport planning visualization and analysis.

---

## Key Contributions

1. **Two complementary simplification methods**: Skeletonization (raster-based thinning) and Voronoi (vector-based centreline extraction) for route networks
2. **Open-source Python implementation**: parenx package with reproducible code on GitHub (https://github.com/nptscot/networkmerge)
3. **Production application**: Powers "Simplified network" layer in Network Planning Tool for Scotland (Transport Scotland-funded)
4. **Performance benchmarks**: Skeletonization ~5 sec for 1 km² urban core, 5 hours for entire British rail network; Voronoi 3.6–5.1× slower but superior geometry
5. **Pre-processing for transport planning**: Addresses longstanding problem of parallel lines creating visual clutter in model outputs (e.g., Propensity to Cycle Tool)
6. **Real-world validation**: Edinburgh case study demonstrates both methods consolidate dual carriageways, simplify roundabouts, preserve connectivity

---

## Problem Definition

**Challenge**: Multiple parallel lines representing single transport corridors

**Example from Propensity to Cycle Tool (PCT)**:
- Otley Road: Single line, flow value 818 (clear visualization)
- Armley Road: Three parallel lines with flow values 515 + 288 + 47 = 850 (higher total flow than Otley, but NOT clear from visualization)

**Limitations of existing approaches**:
- Douglas–Peucker / Visvalingam–Whyatt: Reduce vertices (file size) but don't merge parallel lines
- Vector smoothing: Improve aesthetics but don't simplify network structure
- overline() function (stplanr R package): Aggregates overlapping routes but retains redundant vertices and doesn't merge parallel ways

**Simplification goals**:
1. Replace 2+ parallel lines with single centreline
2. Convert complex intersections (e.g., roundabouts) into single nodes
3. Preserve network connectivity and spatial structure
4. Reduce file sizes and rendering times

---

## Methodology

### Common Parameters

**Buffer size**: 8 meters (default)
- Based on UK Design Manual for Roads and Bridges (DMRB): 2-way road min 4.8 m, max 8.8 m
- GB rail centreline track separation: 3.26 m + 2 × 1.435 m standard gauge
- User-adjustable via `buffer` parameter

**Coordinate system**: Projected CRS (e.g., EPSG:27700 for UK)

**Common first step**: Buffer network lines in projected coordinate system

### Method 1: Skeletonization (Raster-Based Thinning)

**Workflow**:
1. **Identify overlapping lines**: Split buffer at end of each line-segment, identify where >1 buffered segment overlaps
2. **Buffer overlapping segments**: Create unified polygon for parallel ways
3. **Rasterize**: Convert buffered polygon to raster image
4. **Affine scale up**: Increase resolution to retain detail (mitigate rasterization artefacts)
5. **Pre-process raster**: Eliminate small holes where lines run parallel or intersect at shallow angles
6. **Apply thinning algorithm**: Iterative grassfire transform (Leymarie and Levine, 1992) to extract skeleton
7. **Convert skeleton to vectors**: Connect adjacent pixels into line segments, merge into continuous lines
8. **Affine scale down**: Reverse transformation to original coordinate system

**Advantages**:
- **Fast**: 1 km² urban core ~5 seconds, 3 km² ~30–60 seconds, entire British rail network ~5 hours
- **Scalable**: Preferred for large areas (e.g., 100 km²)
- **Memory efficient**: Suitable for commodity hardware

**Limitations**:
- Raster-to-vector conversion introduces minor geometric distortions near complex intersections
- "Wobbly" lines possible
- Affine scaling increases detail but at cost of memory (varies as square of scale value)

### Method 2: Voronoi-Based Centreline Extraction

**Workflow**:
1. **Buffer network**: Same as skeletonization
2. **Segment buffer edges**: Convert buffer boundaries into sequences of points
3. **Generate Voronoi diagram**: Construct Voronoi polygons covering boundary points
4. **Extract centreline**: Retain only Voronoi edges entirely within buffer and within half-buffer-width of boundary
5. **Clean artefacts**: Remove knot-like features

**Advantages**:
- **Superior geometry**: Cleaner intersection handling, smoother centrelines
- **Vector-based**: Preserves more original geometric relationships
- **Aesthetically preferable**: Suitable for high-quality cartographic presentation

**Limitations**:
- **Slower**: 3.6–5.1× slower than skeletonization
- **Computational cost**: Preferred for smaller networks (≤1 km²)
- More prone to knot artefacts (requires post-processing)

### Post-Processing (Both Methods)

**Remove "knots"**: Short, tangled segments near intersections
- Cluster short segments together
- Determine central point for each cluster
- Realign endpoints of longer connecting lines to cluster central points

**Optional: Primal network**:
- Remove all nodes except intersections
- Direct lines connecting junctions
- Highest level of simplification (topological structure only)
- Downside: Sudden sharp angles and discontinuities around loops

---

## Performance Comparison

| Metric | Skeletonization | Voronoi |
|--------|-----------------|---------|
| **Processing speed** | Fast (baseline) | 3.6–5.1× slower |
| **1 km² urban core** | ~5 seconds | ~18–26 seconds |
| **3 km² urban core** | ~30–60 seconds | ~2–5 minutes |
| **Entire British rail** | ~5 hours | Not tested (too slow) |
| **Geometric quality** | Good (minor distortions) | Superior (cleaner) |
| **Intersection handling** | Adequate (raster artefacts) | Excellent |
| **Use case** | Large areas (≥100 km²) | Small areas (≤1 km²) |

---

## Case Study: Edinburgh City Centre

**Study area**: ~1 km (E-W) × 0.5 km (N-S), focused on Princes Street

**Network characteristics**:
- Multi-lane roads (dual carriageways)
- Historic winding streets
- Roundabouts
- Complex intersections

**Input data**: OpenStreetMap (EPSG:27700 projected CRS)

**Results** (Figure 3):
- **Skeletonized**: Consolidates dual carriageways, occasional minor distortions near complex intersections
- **Voronoi**: Cleaner alignments, superior intersection handling, smoother centrelines
- **Primal**: Highest simplification, direct connections between junctions (sharp angles around loops)
- **Neatnet comparison**: Similar to Voronoi, effective roundabout removal, occasional fragmented segments

**Key findings**:
1. Both methods successfully collapse dual carriageways into single centrelines
2. Network connectivity preserved across all methods
3. No single "right" answer (flexibility important for different applications)
4. More work needed for automated outputs that "just work" (none perfect from visual/connectivity perspectives)

**Practical benefits**:
- Reduced visual clutter
- Clearer identification of traffic flow patterns and bottlenecks
- Valid routing algorithms and accessibility analyses (connectivity preserved)
- Improved computational performance for network analysis tasks

---

## Technical Specifications

### Platform
- **Language**: Python
- **Package**: parenx (https://github.com/anisotropi4/parenx)
- **Repository**: https://github.com/nptscot/networkmerge (Edinburgh application)
- **Continuous integration**: Paper rebuilds automatically on repository changes

### Key Libraries
- **Rasterization** (skeletonization): Affine transformations, thinning algorithms
- **Voronoi**: Spatial diagram construction
- **Geometry**: GeoPandas, Shapely (vector operations)

### Data Formats
- **Input**: GeoPackage (.gpkg), GeoJSON (.geojson), shapefiles
- **Output**: Simplified vector geometries (same formats)

### Comparison with Related Tools
- **neatnet** (Fleischmann et al., 2025): Python package for street geometry processing, similar output to Voronoi, faster performance (motivates future parenx optimization)
- **stplanr::overline()** (R): Aggregates overlapping routes but doesn't merge parallel ways (this paper addresses that limitation)
- **cmgo** (R): River centreline extraction (hydrology domain)
- **RivWidthCloud** (Google Earth Engine): River width extraction
- **riverdist** (R): Braided river channel simplification

---

## Data Availability

### GitHub Repository
- **URL**: https://github.com/nptscot/networkmerge
- **Contents**:
  - Full code for Edinburgh application
  - Reproducible methods
  - Continuous integration (paper rebuilds automatically)

### Python Package
- **parenx**: https://github.com/anisotropi4/parenx
- **Documentation**: Methods appendix + Cookbook appendix (step-by-step guide)
- **Alternative datasets**: Railway-based examples included

### Production Application
- **Network Planning Tool for Scotland**: https://www.npt.scot
- "Simplified network" layer uses these methods
- Funded by Transport Scotland, developed via Sustrans contract

---

## Validation and Limitations

### Strengths
1. **Preserves connectivity**: Routing and accessibility analyses remain valid
2. **Reduces file sizes**: Faster rendering for web-based tools and large-scale analysis
3. **Eliminates visual clutter**: Clearer identification of patterns in transport flows
4. **Open-source**: Reproducible, accessible, adaptable by research community
5. **Production-tested**: Powers Scotland NPT, British rail network simplified
6. **Flexible parameters**: Buffer size, affine scale, knot removal adjustable to context

### Limitations

**1. Attribute conflation NOT addressed**:
- Methods simplify geometry only
- Joining attributes from source to simplified network is separate challenge
- Tools exist (stplanr::rnet_merge(), anime Rust crate) but not integrated
- "Fuzzy" or "keyless" join process requires user-selected parameters
- Future work needed on joining strategies

**2. Generic method limitations** (both skeletonization and Voronoi):
- Do not preserve links between attributes and simplified network
- Do not identify which edges require simplification (apply to all overlapping segments)
- Resulting lines can be wobbly
- Memory- and CPU-intensive (speed depends on network density and overlap)

**3. Skeletonization-specific**:
- Raster-to-vector conversion introduces minor geometric distortions
- Affine scaling trades off detail vs processing time/memory (square of scale value)
- May affect aesthetic quality for presentation purposes

**4. Voronoi-specific**:
- 3.6–5.1× slower than skeletonization
- More prone to knot artefacts near intersections

**5. No single "right" answer**:
- Edinburgh case study: differences between skeletonization, Voronoi, neatnet, official centrelines
- Flexibility important, but automated outputs not yet "perfect"
- May require manual correction for specific applications

---

## Future Directions

### Methodological Improvements
1. **Hybrid approaches**: Combine skeletonization speed with Voronoi geometric quality
2. **Performance optimization**: Parallel processing, lower-level languages, algorithmic improvements (neatnet benchmarks show room for improvement)
3. **Attribute conflation**: Automated joining from source to simplified network (fuzzy matching strategies)
4. **Parameter tuning**: Adaptive buffer sizes, context-aware simplification levels

### Integration
1. **Transport modelling workflows**: Seamless integration with PCT, NPT, other tools
2. **Automated attribute transfer**: From complex to simplified networks
3. **Quality metrics**: Automated assessment of simplification quality

### Applications Beyond Transport
1. **Hydrology**: River centreline extraction from braided river systems
2. **Utility networks**: Simplified pipeline/cable representations for maintenance planning
3. **Ecological corridors**: Consolidated habitat connectivity maps from fragmented landscape data
4. **Flow networks**: Any overlapping linear features requiring aggregation

---

## Relevance to Our Project

### Methodological Parallels
1. **Network pre-processing**: They simplify OSM networks for visualization; we process GTFS/OSM for routing
2. **Open-source Python**: parenx package parallels our R5R workflow documentation
3. **Production application**: Scotland NPT demonstrates real-world utility (similar to our goal)
4. **Performance benchmarks**: Document processing times (1 km² ~5 sec, British rail ~5 hours)
5. **Honest limitations**: Acknowledge trade-offs without undermining contribution

### Key Differences
- **Purpose**: Visual simplification (parallel lines → centreline); we calculate accessibility metrics
- **Temporal scope**: Single time point; we do longitudinal analysis
- **Primary challenge**: Geometric complexity; we face GTFS quality and temporal data management
- **Output**: Simplified network geometries; we produce accessibility values and temporal trends

### Lessons for Our Manuscript

**Methods documentation**:
- Clear problem definition with visual example (PCT Otley vs Armley Roads)
- Two methods presented side-by-side with performance comparison table
- Methods appendix + Cookbook appendix structure (technical details separate from main text)
- Could inspire our workflow documentation (GTFS download → quality check → R5R → accessibility)

**Performance reporting**:
- Specific benchmarks: "1 km² urban core ~5 seconds", "British rail network ~5 hours"
- Memory/CPU trade-offs explicitly discussed (affine scaling varies as square of scale value)
- We could report: "Processing time for Busan 2021 GTFS: X minutes"

**Limitation framing**:
- "Both methods have following known issues" → lists specific problems
- "More work needed to achieve automated outputs that 'just work'" → honest about imperfections
- Future work section clearly articulates next steps (attribute conflation, hybrid approaches, performance optimization)
- We can use similar framing for GTFS quality issues, 2024 data problems

**Production application narrative**:
- Network Planning Tool for Scotland demonstrates real-world utility
- Transport Scotland funding validates practical value
- We can mention: "Workflow has been used to analyze X cities for Y research project"

**Open-source contribution**:
- parenx package on GitHub with continuous integration (paper rebuilds automatically)
- Methods + Cookbook appendices provide user guidance
- We can structure our repository similarly (workflow scripts + sample data + documentation)

**Figure strategy**:
- Figure 1: Problem visualization (parallel lines obscuring total flow)
- Figure 2: Method comparison (Original → Skeletonized → Voronoi for two examples)
- Figure 3: Edinburgh application (6 panels: Input, Official centrelines, Skeletonized, Voronoi, Primal, Neatnet)
- Could inspire our multi-panel comparisons (2021 vs 2024, car vs transit, etc.)

**Comparison with related tools**:
- Neatnet Python package comparison (similar approach, faster performance motivates future work)
- stplanr::overline() R function (aggregates routes but doesn't merge parallel ways)
- Hydrology tools (cmgo, RivWidthCloud, riverdist) show broader applicability
- We could compare with existing accessibility tools (r5r intro_access_book, accessibility R package, etc.)

---

## Notes

This paper is relevant because:

1. **Pre-processing for visualization**: Addresses fundamental challenge of presenting complex network data clearly (parallel to our challenge of presenting temporal accessibility patterns)
2. **Python package documentation**: parenx structure (main package + Methods appendix + Cookbook) provides model for our R5R workflow documentation
3. **Performance benchmarking**: Explicit reporting of processing times and memory trade-offs
4. **Production application**: Scotland NPT demonstrates real-world utility beyond academic exercise
5. **Honest about limitations**: "None of the outputs are perfect" → acknowledges trade-offs without undermining contribution

The skeletonization vs Voronoi comparison (fast vs beautiful) parallels potential trade-offs in our workflow (e.g., temporal resolution vs computational feasibility, hexagon grid size vs detail).

The attribute conflation challenge (joining source attributes to simplified network) is analogous to our challenge of aggregating accessibility metrics from individual departure times to representative values.

The "no single right answer" framing (Edinburgh case study shows differences between methods and official centrelines) could apply to our threshold choices (10min car, 30min transit) and temporal aggregation strategies (percentiles vs averages).
