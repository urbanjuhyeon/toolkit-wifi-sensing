# Kaths (2024) - RoadUserPathways

## Citation
Kaths, H. A. (2024). Crossing intersections: A tool for investigating road user pathways. *Environment and Planning B: Urban Analytics and City Science*, 51(1), 275–281. https://doi.org/10.1177/23998083231215462

## Artifact Type
**Open Source Software (OSS)** - Python tool for trajectory clustering at intersections

## What It Is
- Python tool that automatically identifies pathway types used by cyclists, pedestrians, and micromobility users at intersections
- Uses Affinity Propagation (AP) clustering algorithm to group similar trajectories
- Outputs: number of pathway types, representative trajectory (exemplar) for each type, count/percentage per pathway
- Identifies "desire lines" - actual movement patterns that differ from traffic engineer-planned routes
- Works with trajectory data from video extraction (e.g., Traffic Intelligence)

## Why It Matters
- Actual movement patterns often differ from planned infrastructure design
- Manual observation limits trajectory collection scale
- Automated identification enables analysis of large datasets across many intersections
- Reveals unexpected behaviors that inform infrastructure (re)design
- Inspired by Copenhagenize Design Co.'s desire line studies in cycling

## Key Technical Details

### Input Data
- Trajectories as position coordinates (x, y)
- SQLite database format (Traffic Intelligence structure)
- Developed with 25 observations/second (lower frequency acceptable if shape captured)
- UTM local coordinate system
- Preprocessing: polygon-based filtering and trimming

### Clustering Approach
1. **Feature extraction**: Sample N position coordinates from each trajectory (equal spatial segments)
2. **Pattern matrix**: Combine all feature vectors into matrix A*
3. **Distance measure**: Euclidean (unnormalized)
4. **Algorithm**: Affinity Propagation (AP)
   - Centroid-based (exemplar represents cluster)
   - Number of clusters determined automatically
   - scikit-learn implementation

### Why Affinity Propagation?
- Handles varying cluster sizes and densities
- No need to specify number of clusters in advance
- Produces exemplar trajectory (centroid) as desire line representation
- Works with globular/convex cluster shapes

### Outputs
| Output | Description |
|--------|-------------|
| Number of pathway types | Automatically determined clusters |
| Representative trajectory | Exemplar showing average shape of each pathway |
| Count/percentage | Road users per pathway type |
| Clustered visualization | All trajectories colored by cluster |

## Case Studies
| Intersection | # Observations | # Pathways | Silhouette Score |
|--------------|----------------|------------|------------------|
| Munich | 277 | 11 | 0.83 (strong) |
| inD A | 78 | 10 | 0.57 |
| inD B | 424 | 9 | 0.53 |
| inD C | 1666 | 37 | 0.32 |
| inD D | 39 | 5 | 0.64 |

**Findings**:
- Munich: concentrated infrastructure use (cyclists use bicycle lanes)
- inD A: dispersed use (roadway, sidewalk, bicycle lane)
- inD B: desire lines match planned patterns
- inD C: wide divergence from intended use → redesign needed
- Qualitative error rate: 0.4–2.5%

## Use Cases
1. **Count data / turning ratios**: Derive maneuver frequencies (straight, left, right, U-turn)
2. **Tactical insights**: Understand how different modes execute maneuvers
3. **Before/after studies**: Evaluate infrastructure measure effects
4. **Mode comparison**: Compare behavior of cyclists vs pedestrians vs micromobility
5. **Safety analysis**: Link pathway types to surrogate safety indicators

## Limitations
- AP algorithm needs more systematic comparison with k-means, Mean Shift
- Trajectories reflect reactive behavior (to traffic, obstacles), not pure desire
- Lacks contextual information (why users chose specific paths)
- Silhouette scores vary considerably across intersections

## Paper Structure (~3,000 words)
1. Introduction - Desire lines concept, gap in automated identification
2. Methodology
   - Data requirements
   - Clustering approach
   - Open-source tool
3. Case studies - Five German intersections
4. Discussion and conclusion - Use cases and limitations

## Relevance to Our Project
| Aspect | RoadUserPathways | Our Project |
|--------|------------------|-------------|
| Focus | Movement patterns at intersections | Accessibility patterns |
| Data type | Trajectory coordinates | Travel time matrices |
| Method | Clustering (AP) | Cumulative opportunities |
| Output | Pathway types + exemplars | Accessibility metrics |
| Application | Infrastructure design | Service coverage analysis |

## Lessons for Our Manuscript
1. **Conceptual framing**: "Desire lines" concept bridges actual vs planned behavior
2. **Algorithm selection justification**: Explain why AP (auto-determines clusters, produces exemplar)
3. **Validation metrics**: Silhouette Score for clustering quality (>0.70 = strong)
4. **Error reporting**: Qualitative error rate (0.4–2.5%)
5. **Multiple case studies**: Test across different contexts (5 intersections)
6. **Practical use cases**: List concrete applications (5 use cases)
7. **Limitations honesty**: Acknowledge reactive behavior, lack of context
8. **Visual outputs**: Show both clustered trajectories and representative exemplars

## Notable Quotes
- "The pathways used by cyclists, pedestrians, and users of micromobility to cross intersections do not always align with those planned by traffic engineers"
- "Akin to pedestrians treading new pathways, these actual movement patterns of cyclists can point to weaknesses in the intersection design"
- "Although automated data processing methods allow researchers to study large datasets, trajectories remain a sterile form of data that do not include contextual information"

## Repository
- **GitHub**: RoadUserPathways (link in paper)
- **Language**: Python
- **Dependencies**: scikit-learn, Traffic Intelligence data format
- **License**: Open source
