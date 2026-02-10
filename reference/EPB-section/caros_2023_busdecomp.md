# Caros et al. (2023) - busdecomp

## Citation
Caros, N. S., Stewart, A. F., & Attanucci, J. (2023). An open-source program for spatial decomposition of bus transit networks. *Environment and Planning B: Urban Analytics and City Science*, 50(5), 1394–1401. https://doi.org/10.1177/23998083231174892

## Artifact Type
**Open Source Software (OSS)** - Python package for bus network decomposition and longitudinal comparison

## What It Is
- Python package that decomposes bus networks into block-length segments ("edges")
- Enables longitudinal transit performance analysis by matching networks across time periods using geometry rather than route/stop IDs
- Uses GTFS feeds and OpenStreetMap road network data
- Implements map matching via Valhalla library
- Encodes edge geometry using Google Encoded Polyline format for efficient comparison

## Why It Matters
- Route and stop IDs are unstable over time (reassigned, renamed during network redesigns)
- Existing studies require manual correction of identifier changes
- First generalizable method for evaluating temporal transit performance at disaggregate level
- No prior knowledge of network design changes required
- Enables policy analysis, agency benchmarking, and public communication

## Key Technical Details

### Unit of Analysis: "Edge"
- Distance between two intersections + additional boundaries at mid-block bus stops
- Stable geographic unit across which bus service is consistent
- Directional (separate edge for each travel direction)
- Average MBTA edge: >7 coordinate pairs (handles curved/irregular roads)

### Workflow
```
┌─────────────────┐     ┌─────────────────┐
│ Baseline        │     │ Comparison      │
│ GTFS Feed       │     │ GTFS Feed       │
└────────┬────────┘     └────────┬────────┘
         │                       │
         ▼                       ▼
┌────────────────────────────────────────┐
│ Snap bus travel paths to road network  │◄── Road Network
│ using map matching algorithm           │    Database (OSM)
└────────────────────────────────────────┘
                    │
                    ▼
┌────────────────────────────────────────┐
│ Decompose travel paths into            │
│ directional block-length segments      │
│ ("edges")                              │
└────────────────────────────────────────┘
                    │
                    ▼
┌────────────────────────────────────────┐
│ Convert edge geometry into Google      │
│ Encoded Polyline format                │
└────────────────────────────────────────┘
                    │
         ┌──────────┴──────────┐
         ▼                     ▼
┌─────────────────┐     ┌─────────────────┐
│ For each edge   │     │ Is there edge   │
│ in comparison   │────▶│ with same       │──Yes──▶ Match found
│ network         │     │ encoded polyline│
└─────────────────┘     └────────┬────────┘
                                 │ No
                                 ▼
                        ┌─────────────────┐
                        │ Intersecting    │
                        │ edge with       │──Yes──▶ Match found
                        │ similar bearing │
                        │ & min Hausdorff │
                        └────────┬────────┘
                                 │ No
                                 ▼
                        No match found in
                        baseline network
```

### Map Matching Process
1. Extract stop sequences ("patterns") from GTFS `stop_times.txt`
2. Get coordinates from GTFS `stops.txt` (optionally use `shapes.txt`)
3. Build graph from OSM (nodes = intersections, edges = streets)
4. Compute shortest path between coordinates
5. Split polylines at intersections and mid-block stops
6. Apply distance threshold to avoid small edges near intersections

### Edge Matching Algorithm
1. **Exact match**: Compare Google Encoded Polyline strings directly
2. **Fuzzy match** (for coordinate discrepancies):
   - Find spatial intersections between unmatched edges
   - Check Hausdorff distance below threshold
   - Verify bearing similarity (same direction of travel)

### Performance
| Operation | Time | Hardware |
|-----------|------|----------|
| Network comparison (2 periods) | 2 min | Intel i7-6600U, 16GB RAM |
| Single edge intersection check | <0.2 s | (against full MBTA network) |

### Encoding
- Google Encoded Polyline compression algorithm
- Rounding after 5th decimal place (~0.5m max error)
- Two orders of magnitude faster than geometric comparison

## Validation Example: MBTA (Boston)
| Metric | Value |
|--------|-------|
| Edges in Jan 2011 network | 42,796 |
| Matched in Jan 2021 network | 84% (35,667) |
| No longer served | 16% (7,129) |
| New edges in 2021 | 5,162 |

## Limitations
1. Requires GTFS feed (not all agencies maintain them)
2. Assumes shortest path between stops (may not hold for distant stops)
3. Assumes stable road network over time
4. OSM accuracy not guaranteed (volunteer-maintained)

## Paper Structure (~3,000 words)
1. Introduction - Problem of identifier instability
2. Description of the software package
   - Block-level decomposition
   - Geographic representation
   - Longitudinal comparison
3. Discussion - Applications and limitations

## Relevance to Our Project
| Aspect | busdecomp | Our Project |
|--------|-----------|-------------|
| Focus | Transit network evolution | Accessibility change |
| Data source | GTFS | GTFS |
| Temporal comparison | Edge-based matching | Year-to-year metrics |
| Unit of analysis | Block-length edges | Grid cells / zones |
| Challenge addressed | ID instability | Service quality variation |

## Lessons for Our Manuscript
1. **Stable reference geography**: Use geometry-based matching rather than unstable IDs
2. **Encoding for efficiency**: Google Encoded Polyline provides 100x speedup
3. **Two-stage matching**: Exact match first, then fuzzy match with Hausdorff distance
4. **Validation metrics**: Report % of edges matched across periods
5. **Practical benchmarks**: 2 min for network comparison, <0.2s per edge
6. **Clear workflow diagram**: Figure 1 shows complete process
7. **GTFS as input**: Standard machine-readable format enables generalizability
8. **Supplemental case studies**: Include empirical demonstrations in supplementary materials

## Notable Quotes
- "Bus networks are not stable over time; the patterns of stops that constitute a bus route are revised periodically and arbitrary stop numbers are reassigned to entirely different locations"
- "This is the first effort to develop a widely generalizable method for evaluating temporal changes in transit performance measured at a disaggregate level"
- "Any changes to route or stop IDs across the study period are automatically incorporated into the results"

## Repository
- **GitHub**: https://github.com/jtl-transit/busdecomp
- **Dependencies**: Valhalla (map matching), Shapely, OpenStreetMap
