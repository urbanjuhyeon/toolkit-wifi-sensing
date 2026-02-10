# Beecham et al. (2025) - gridmappr

## Citation
Beecham, R., Tennekes, M., & Wood, J. (2025). gridmappr: An R package for creating small multiple gridmap layouts. *Environment and Planning B: Urban Analytics and City Science*, 0(0), 1–7. https://doi.org/10.1177/23998083251374737

## Artifact Type
**Open Source Software (OSS)** - R package for automated gridmap layout generation

## What It Is
- R package automating generation of gridmaps (small multiples laid out geographically)
- Allocates geographic points to regular-sized grid cells
- Minimizes distance between real and grid locations
- Uses linear programming via `ompr` R package for constraint handling
- Produces layouts compatible with standard ggplot2 for visualization
- Enables glyphmaps and origin-destination map creation

## Why It Matters
- Gridmaps allow complex multivariate structure to be depicted within geographic context
- Manual gridmap creation (e.g., LondonSquared, geofacet) is time-consuming
- Automatic allocation considers multiple constraints: compactness, alignment, distance, topology, shape
- Regular cell sizes enable data-dense visualizations not possible with irregular geographies
- Overcomes difficulties of standard OD flow visualization techniques

## Key Functions

| Function | Purpose |
|----------|---------|
| `points_to_grid()` | Main allocation function - assigns points to grid cells |
| `make_grid()` | Generates polygon file for grid with cell positions |

### `points_to_grid()` Parameters
| Parameter | Description |
|-----------|-------------|
| `pts` | Tibble of geographic points (x, y) |
| `nrow` | Maximum number of rows in grid |
| `ncol` | Maximum number of columns in grid |
| `compactness` | 0-1 value: 0=edges, 0.5=preserve scaled location, 1=center |
| `spacers` | List of fixed cells that cannot be allocated (e.g., water bodies) |

### Output Structure
Returns data frame with:
- `row`: Grid row ID
- `col`: Grid column ID
- Original point identifiers

## Algorithm
- Uses linear programming (via `ompr` package)
- Minimizes total squared distances between geographic and grid locations
- Constraints:
  - Each point allocated to exactly one cell
  - Each cell contains at most one point
  - Spacer cells cannot be allocated
  - Compactness affects center vs edge positioning

## Comparison with Alternatives

| Package | Method | Constraints | Trade-off |
|---------|--------|-------------|-----------|
| gridmappr | Linear programming | Distance + compactness + spacers | More control, higher overhead |
| geogrid | Gradient descent + Hungarian algorithm | Distance only | Faster, less control |
| geofacet | Manual/pre-defined | N/A | No automation |

## Visualization Applications

### 1. Glyphmaps
- Small multiple charts within geographic context
- Uses ggplot2's `facet_grid()` with row/col IDs
- Any ggplot2 chart type can be embedded (bar charts, etc.)

### 2. Origin-Destination Maps
- Map-within-map layouts for OD data
- Destinations as large reference cells
- Origins as smaller cells within each destination
- Overcomes standard flow map limitations

## Example: France Départements
- 96 départements allocated to 13×12 grid
- Spacers separate Corsica from mainland
- Compactness parameter varies layout style
- Displacement vectors show geographic distortion

## Technical Details
- Integrates with sf package for spatial data
- Returns sf objects from `make_grid()`
- Grid origin: bottom-left (1,1)
- ggplot2 facet_grid origin: top-left (requires `-row` hack)

## Future Development
- Simulated annealing for efficient optimization
- Additional constraints: topology, shape
- Hybrid data-spatial layouts (Van Beusekom et al., 2023)

## Paper Structure (~3,000 words)
1. Introduction - Gridmaps concept, existing tools
2. Defining layouts with gridmappr - Function parameters, examples
3. Building glyphmaps - ggplot2 integration
4. Origin-destination maps - Map-within-map layouts
5. Conclusion - Current capabilities, future work

## Relevance to Our Project
| Aspect | gridmappr | Our Project |
|--------|-----------|-------------|
| Purpose | Geographic visualization | Accessibility metrics |
| Spatial unit | Administrative regions | Grid cells / zones |
| Visualization | Small multiples, OD maps | Maps, charts |
| Integration | ggplot2 | Python visualization |
| Use case | Multivariate geographic analysis | Service coverage analysis |

## Lessons for Our Manuscript
1. **ggplot2 integration**: Demonstrate how outputs work with standard tools
2. **Parameter trade-offs**: Explain grid size vs data density trade-off
3. **Multiple use cases**: Show glyphmaps AND OD maps from same package
4. **Comparison with alternatives**: Position relative to geogrid, geofacet
5. **Visual examples**: Show different parameterizations and their effects
6. **Code snippets**: Include minimal working examples
7. **Displacement vectors**: Visualize algorithm behavior for understanding

## Notable Quotes
- "The advantage is that complex multivariate structure, rather than single values, can be depicted"
- "gridmappr offers more control over the constraints in returned layouts than does geogrid, but with greater computational overhead"
- "To design glyphmaps, it is helpful to think of the spatial units that form gridmaps in the same way – as categorical conditioning variables"

## Repository
- **GitHub**: https://github.com/rogerbeecham/gridmappr
- **Website**: https://www.roger-beecham.com/gridmappr/
- **Zenodo**: doi: 10.5281/zenodo.16878384 (v0.2)
- **License**: GPL 3.0
- **Inspired by**: Jo Wood's Observable notebook on Grid map allocation
