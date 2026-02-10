# Botta (2024) - Rail Fares

## Citation
Botta, F. (2024). Rail journey cost calculator for Great Britain. *Environment and Planning B: Urban Analytics and City Science*, 52(3), 747-755. https://doi.org/10.1177/23998083241276569

## Artifact Type
**Open Source Software (OSS)** - Python package + output dataset for rail fare analysis

## What It Is
- Python package `railfares` to analyse cost of train journeys in Great Britain
- Parses complex ATOC/RDG fares data into usable format
- Generates station-to-station minimum fare matrix
- Calculates accessibility to services (hospitals, employment) by cost threshold
- Output: fare data between all station pairs for one-way any-time single tickets

## Why It Matters
- Transport affordability research is under-explored (Lucas et al., 2016)
- Cost dimension often omitted from accessibility analysis
- UK fares structure is complex: routes, companies, clusters, ticket types
- Supports "levelling up" policy analysis (geographical inequality)
- Net zero transition requires understanding rail vs car cost tradeoffs

## Key Technical Details
- **Data sources**: RDG fares data (data.atoc.org), NaPTAN station locations, DfT Journey Time Statistics
- **Processing**: Python with Poetry environment
- **Core files**: `data_parsing.py`, `functionalities.py`, `download_data.py`
- **Fares structure**: Flow ID → Fare; flows can be station-station or cluster-cluster
- **Station clusters**: Group stations with same fare for long-distance journeys
- **Default focus**: Lowest available one-way any-time single fare

## Paper Structure (~3,000 words)
1. Introduction - Transport poverty, affordability gap in research
2. Data - ATOC fares, NaPTAN, DfT Journey Time Statistics
3. Code - Python package structure and scripts
4. Output data - Station-pair fares, service accessibility metrics
5. Conclusion - Levelling up implications, limitations

## Key Figures
- Figure 1: (A) All stations, (B) Station cluster example, (C) Fares from Exeter, (D) Distance reachable for £25, (E) Hospitals reachable for £25
- Figure 2: Fare distributions - all GB vs Exmouth vs Birmingham
- Figure 3: Price vs distance for 6 stations

## Summary Statistics (Table 1)
| Mean | Median | Min | Max | Lower quartile | Upper quartile |
|------|--------|-----|-----|----------------|----------------|
| £111.64 | £106.7 | £0.65 | £283.3 | £55.5 | £166.0 |

## Relevance to Our Project
| Aspect | Rail Fares | Our Project |
|--------|------------|-------------|
| Artifact type | Python package + data | Workflow/pipeline |
| Accessibility metric | Cost (£) | Travel time |
| Focus | Rail only | Car + Transit |
| Temporal | Snapshot (Feb 2022) | Longitudinal (2019-2024) |
| Policy context | Levelling up, net zero | Service equity |
| Data complexity | Fares structure | GTFS + OSM |

## Lessons for Our Manuscript
1. **Complementary dimension**: We measure time; cost is another barrier (could mention as future extension)
2. **Complex data parsing**: Acknowledge data complexity (fares clusters ↔ GTFS quirks)
3. **Service accessibility example**: Hospital accessibility by cost ↔ Bank accessibility by time
4. **Honest limitations**: Simplified choices, data freshness issues
5. **Policy framing**: Connect to policy goals (levelling up ↔ service equity)
6. **Urban-rural distinction**: Clear patterns in Figure 1D (we may see similar)
7. **Single-author paper**: Shows Urban Data/Code accepts solo submissions

## Notable Quotes
- "The affordability of such journeys has often been overlooked"
- "Transport affordability and the more general notion of transport poverty have been recognised as issues that require significant further research"
- "Coupling openly available data with openly available tools can help maximise the usability and impact of analysis"
