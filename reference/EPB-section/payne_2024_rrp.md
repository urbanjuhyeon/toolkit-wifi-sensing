# Payne & McGlynn (2024) - Relational Reprojection Platform

## Citation
Payne, W. B., & McGlynn, E. (2024). Relational Reprojection Platform: Non-linear distance transformations of spatial data in R. *Environment and Planning B: Urban Analytics and City Science*, 51(2), 546–552. https://doi.org/10.1177/23998083231215463

## Artifact Type
**Open Source Software (OSS)** - R Shiny application for non-linear distance visualization

## What It Is
- Interactive R Shiny tool for visualizing spatial relationships using non-linear distance transformations
- Centers data on any reference point using stereographic (azimuthal) projection
- Transforms great circle distances using logarithmic, square root, or custom functions
- Produces schematic maps revealing patterns missed by standard Cartesian projections
- Accepts CSV files with coordinates and attribute data
- Exports SVG for further design iteration

## Why It Matters
- Standard GIS treats every mile equally, inappropriate for long-tail distance distributions
- Phenomena like retail customers, remittances, and migration follow non-linear distance decay
- Pre-GIS "analytical cartography" techniques (1960s-70s) are difficult to replicate in modern GIS
- Fills gap between non-Cartesian spatial theory and available visualization tools
- Inspired by Hägerstrand's "Migration and Area" (1957) and Bunge's "Nuclear War Atlas" (1988)

## Key Technical Details

### Distance Transformation Options
| Type | Formula | Use Case |
|------|---------|----------|
| Great Circle | Default (Haversine) | Standard azimuthal projection |
| Logarithmic | log(distance) | Long-tail distributions, retail customers |
| Square Root | sqrt(distance) | Migration, remittances |
| Custom | Piecewise linear with user-defined breaks | Specific distance decay patterns |

### Value Interpolation (Symbol Size)
- **Square root** (default): Areal values scale appropriately
- **Logarithmic**: For highly skewed value distributions
- **None**: Unscaled (not recommended for most data)

### Computational Steps
1. **Data parsing**: Read CSV, identify lat/lon/value/label columns via `dfparser()`
2. **Distance matrix**: Calculate great circle (Haversine) distances from center point
3. **Polar conversion**: Convert to polar coordinates (bearing + distance)
4. **Distance transformation**: Apply selected non-linear function
5. **Cartesian conversion**: Convert back for plotting
6. **Visualization**: Plot with ggplot2, distance band circles via geom_circle()

### R Libraries Used
| Library | Purpose |
|---------|---------|
| shiny | Interactive web application |
| tidyverse | Data manipulation (dplyr) + visualization (ggplot2) |
| geosphere | Geographic bearing calculations |
| gmt | Geodesic distance (geodist function) |
| ggforce | Distance band circles (geom_circle) |
| scico | Colorblind-friendly color ramps |

## User Interface Features
- Upload CSV file with coordinates
- Display options: labels, overlapping labels, center point, zero values
- Theme selection: Light, Dark, Mono (grayscale)
- Column selection for data and labels
- Quick quality check plot (lon/lat scatter)
- Symbol size range slider
- Distance cut points for custom transformation
- SVG export for further design work

## Use Cases Demonstrated

### 1. World Bank Remittances to India
- Shows global remittance flows to India
- Square root transformation reveals both:
  - Persian Gulf neighbors (strong migrant labor ties)
  - Distant North American countries (diaspora)

### 2. Yelp Reviews - Comet Ping Pong (#Pizzagate)
- Before Nov 2016: Reviews clustered locally around DC area
- After Nov 2016: Reviews from across US (conspiracy theory effect)
- Logarithmic view makes spatial shift immediately apparent
- "Messiness" of post-Pizzagate data viscerally demonstrates discrepancy

## Limitations
- Performance limitations for very large datasets
- Currently only accepts CSV (planned: GeoJSON support)
- No basemap support (planned feature)
- Labeling constraints for overlapping points

## Paper Structure (~3,000 words)
1. Introduction - Problem with Cartesian visualization
2. Background - Historical inspiration (Hägerstrand, Bunge, analytical cartography)
3. Methodology
   - Computation (data parsing, transformations)
   - Visualization (Shiny UI)
4. Use cases - Yelp reviews demonstration
5. Conclusion - Future development plans

## Relevance to Our Project
| Aspect | RRP | Our Project |
|--------|-----|-------------|
| Focus | Distance visualization | Accessibility metrics |
| Data type | Point data with central reference | Travel time matrices |
| Transformation | Non-linear distance decay | Threshold-based accessibility |
| Output | Schematic maps (SVG) | Spatial data (GeoPackage) |
| Use case | ESDA, exploratory visualization | Longitudinal comparison |

## Lessons for Our Manuscript
1. **Historical grounding**: Reference foundational work (Hägerstrand, Tobler) to situate tool
2. **Gap identification**: "Visualization capabilities have lagged behind theory"
3. **ESDA framing**: Position as exploratory tool rather than definitive analysis
4. **Multiple transformation options**: Provide flexibility for different phenomena
5. **Practical demonstrations**: Show before/after or comparison visualizations
6. **Interactive interface**: Shiny enables real-time parameter exploration
7. **Export functionality**: SVG output for further design iteration
8. **Clear library documentation**: List dependencies and their purposes

## Notable Quotes
- "The first mile of distance is fundamentally different from the hundredth, or the thousandth"
- "Web Mercator pin-maps and standardized GIS workflows have steamrolled older, more heterogeneous geographical imaginations"
- "We conceive of RRP as a component of an exploratory spatial data analysis (ESDA) workflow"
- "The 'messiness' of 2B viscerally demonstrates the discrepancy in spatial patterns"

## Repository
- **GitHub**: https://github.com/willbpayne/relational_reprojection_platform
- **Language**: R (Shiny)
- **Input**: CSV with lat/lon/value columns
- **Output**: Interactive visualization + SVG export
