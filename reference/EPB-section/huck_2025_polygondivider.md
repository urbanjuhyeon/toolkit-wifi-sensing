# Huck (2025) - QGIS Polygon Divider

## Citation
Huck, J. (2025). The QGIS Polygon Divider: Polygon partition into an irregular equal area grid. *Environment and Planning B: Urban Analytics and City Science*, 0(0), 1–9. https://doi.org/10.1177/23998083251378340

## Artifact Type
**Open Source Software (OSS)** - QGIS plugin for polygon equipartition

## What It Is
- QGIS plugin that partitions arbitrarily complex polygons into irregular grids of equal area rectangles
- Uses Brent's method (efficient optimization algorithm) to locate cutlines
- User specifies either target cell area or desired number of divisions
- Supports rotation of grid axes and handling of "offcuts"
- Available in official QGIS plugin repository

## Why It Matters
- Equipartition into irregular grids was not available in major GIS software at time of release
- Existing methods limited to convex polygons or require partitions connected to boundary
- Voronoi-based approaches don't preserve polygon boundaries
- Useful when divisions need to be smaller than available administrative geographies
- Applicable to phenomena not related to population demographics (e.g., urban heat island)
- Works in settings without administrative divisions (e.g., informal settlements)

## Key Technical Details

### Input Requirements
- Projected coordinate system (2D Cartesian x, y)
- Plugin detects and rejects geographic coordinate systems
- Multi-polygons automatically separated and processed individually

### User Parameters
| Parameter | Description |
|-----------|-------------|
| Input Layer | Source polygon layer |
| Output File | Result file (e.g., .gpkg) |
| Target Area | Desired cell area in CRS units |
| Number of Divisions | Alternative: specify cell count |
| Cut Direction | left→right, top→bottom, right→left, bottom→top |
| Tolerance | How close each polygon can be to desired area |
| Rotation | Grid axes rotation (degrees) |
| Absorb Offcuts | Merge remainders into partitions or keep separate |

### Algorithm Overview
1. Calculate side length of square with target area: $\sqrt{\alpha}$
2. Take initial "slice" along one axis (area = n × α)
3. Divide slice perpendicular to cut direction into n polygons of area α
4. Repeat until polygon fully partitioned

### Brent's Method for Cutline Optimization
Three iterative approaches with fallback hierarchy:

| Method | Order | Description |
|--------|-------|-------------|
| Inverse Quadratic Interpolation (IQI) | ≈1.84 | Most efficient; uses Lagrange polynomial |
| Secant | ≈1.62 | Fallback if IQI fails (equal values) |
| Bisection | 1.0 | Guaranteed convergence; least efficient |

**Function to optimize:**
$$f(c) = \alpha - \alpha_t$$

Where:
- $c$ = cutline coordinate position
- $\alpha$ = area of cut polygon
- $\alpha_t$ = target area
- Root found when $\alpha = \alpha_t$

### Complexity
- Function evaluation: $O(n)$
- Brent's method worst case: $O(\log \frac{1}{\varepsilon})$
- Practice: superlinear convergence $O(\log \log \frac{1}{\varepsilon})$

### Handling Non-Continuities
- Complex geometries (e.g., 'W' shape) can cause discontinuities
- Solution: automatically change cut direction and resume

## Applications

### Original Use Case
- **Litter monitoring in Scotland** (Zero Waste Scotland, 2018)
- Legal requirement for UK duty bodies
- Partition land into 1000 m² zones for monitoring

### Research Applications
| Domain | Application | Reference |
|--------|-------------|-----------|
| Urban planning | Transport accessibility | Wang et al., 2019 |
| Urban planning | Greenspace exposure | Labib et al., 2021 |
| Urban planning | Habitat restoration | Boncourt et al., 2024 |
| Ecology | Habitat diversity | Fernández-García et al., 2021 |
| Ecology | Riparian forests | Huylenbroeck et al., 2021 |
| Forestry | Sustainable planning | Picchio et al., 2020 |

## Limitations
- Requires projected coordinate system
- Non-continuous area functions in complex geometries (handled by direction change)
- Similar tool now available in ArcGIS Pro (algorithm undocumented)

## Paper Structure (~3,500 words)
1. Introduction - Polygon partitioning problem, existing limitations
2. Algorithm description - Brent's method, cutline optimization
3. Conclusion - Applications, future developments

## Relevance to Our Project
| Aspect | Polygon Divider | Our Project |
|--------|-----------------|-------------|
| Purpose | Spatial subdivision | Accessibility calculation |
| Input | Arbitrary polygon | Transit network + POIs |
| Output | Equal-area grid | Accessibility metrics |
| Platform | QGIS plugin | Python library |
| Use case | Sampling, monitoring | Service coverage analysis |

## Lessons for Our Manuscript
1. **Gap identification**: "At the time that the plugin was created, this functionality was not available"
2. **Algorithm explanation**: Detailed description of optimization method (Brent's)
3. **Handling edge cases**: Document how non-standard situations are resolved
4. **Diverse applications**: Show uses beyond original purpose
5. **Computational complexity**: Report algorithm efficiency
6. **Prior art acknowledgment**: Credit original ideas (William Huber's forum post)
7. **Funding transparency**: List financial supporters for different versions
8. **Simple interface**: User-friendly dialogue with sensible defaults

## Notable Quotes
- "In the context of city science, this is particularly useful where the desired size of the divisions is smaller than available small area geographies"
- "Neither of these limitations are acceptable for GIS or city science applications"
- "Brent's method is guaranteed to converge for functions that are computable within the interval"

## Repository
- **QGIS Plugin Repository**: https://plugins.qgis.org/plugins/Submission/
- **GitHub**: https://github.com/jonnyhuck/RFCL-PolygonDivider
- **Language**: Python (QGIS plugin)
- **Dependencies**: QGIS, pyroots (BSD license)
- **Funding**: Zero Waste Scotland Ltd (v2.x), Deutsche Forestservice GmbH (v3.x)
