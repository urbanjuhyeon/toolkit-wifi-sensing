# Ha et al. (2025) - spnaf

## Citation
Ha, H. J., Lee, Y., Kim, K., Park, S., & Lee, J. (2025). Spnaf: An R package for analyzing and mapping the hotspots of flow datasets. *Environment and Planning B: Urban Analytics and City Science*, 52(2), 509-517. https://doi.org/10.1177/23998083241276021

## Artifact Type
**Open Source Software (OSS)** - R package for flow hotspot analysis

## What It Is
- R package `{spnaf}` (spatial network autocorrelation for flows)
- Implements Berglund and Karlström's Gij* index for flow hotspot detection
- Detects statistically significant flow clusters using network spatial weight matrices
- Works with both polygon and point data
- Available on CRAN with vignette and sample data

## Why It Matters
- Gap in open-source tools for flow data ESDA (vs. point/lattice data tools like spdep, rgeoda)
- Human mobility data has proliferated but analysis tools are lacking
- First R package specifically designed for flow dataset hotspot analysis
- Applications: migration, bike-sharing, commodity flows, animal movement

## Key Technical Details
- **Method**: Berglund and Karlström's Gij* statistic (extension of Getis-Ord G)
- **Spatial weight options**: Queen contiguity, KNN, fixed distance
- **Neighbor structure**: origin-only (o), destination-only (d), or total (t)
- **Validation**: Bootstrapping (default 1,000 replications) for p-values
- **Output**: sf class with line strings for visualization

## Main Functions
| Function | Purpose |
|----------|---------|
| Gij.flow | Main function calling all sub-functions |
| SpatialWeights | Calculate spatial weight matrices |
| Gstat | Compute Gij* statistic |
| Boot | Bootstrap validation for p-values |
| Resultlines | Generate output with geometry |

## Workflow (Figure 1)
1. Input: data.frame (oid, did, n) + sf shapefile (polygon or point)
2. SpatialWeights: Create spatial weight matrix
3. Gstat: Calculate Gij* values
4. Boot: Validate with bootstrapping
5. Resultlines: Output with line strings for visualization

## Paper Structure (~3,000 words)
1. Introduction - Need for flow ESDA tools
2. Background - Berglund & Karlström's G statistic, previous studies
3. Working with {spnaf} - Overview of functions and workflow
4. Examples - Polygon (bike-sharing) and point (airports) demonstrations
5. Conclusion - Future directions

## Examples Demonstrated
1. **CoGo bike-sharing (Columbus, Ohio)**: 1,416 OD pairs, 180s processing
2. **US airport passengers**: 396 OD pairs, 25s processing

## Relevance to Our Project
| Aspect | spnaf | Our Project |
|--------|-------|-------------|
| Artifact type | R package | Workflow/pipeline |
| Focus | Flow hotspots | Accessibility change |
| Data type | OD flow data | Travel time matrices |
| Analysis | Spatial autocorrelation | Temporal comparison |
| Scale | Micro to macro | City to national |

## Lessons for Our Manuscript
1. **Fill a gap**: Explicitly state what tools are missing (flow ESDA vs point/lattice)
2. **CRAN availability**: Package on CRAN with vignette adds credibility
3. **Two scale examples**: Micro (bike-sharing) and macro (airports) show versatility
4. **Performance benchmarks**: Report computation time on specific hardware
5. **Multiple weight options**: Provide flexibility for different analysis contexts
6. **Korean author connection**: Co-author from Seoul National University
7. **Early-stage acknowledgment**: "still in its early stages...hope interested readers can contribute"
8. **Formula presentation**: Include key equations (Gij* formula)

## Notable Quotes
- "there is a lack of open-source codes or user-friendly programs for facilitating that process"
- "first R package specifically designed for hotspot analysis of flow datasets"
- "empower researchers to address a wide array of research questions related to the flows of moving objects"
