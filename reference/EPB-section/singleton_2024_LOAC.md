# Singleton & Longley (2024) - London Output Area Classification

## Citation
Singleton, A. D., & Longley, P. A. (2024). Classifying and mapping residential structure through the London Output Area Classification. *Environment and Planning B: Urban Analytics and City Science*, 51(5), 1153-1164. https://doi.org/10.1177/23998083241242913

## Artifact Type
**Open Data Product (ODP)** - Geodemographic classification system for London

## What It Is
- London Output Area Classification (LOAC) 2021 from 2021 Census data
- Two-tier nested classification: 7 Supergroups → 16 Groups
- Covers all Output Areas in Greater London
- Created in partnership with Greater London Authority (GLA)
- 68 input variables covering demographics, ethnicity, living arrangements, health, education, employment

## Why It Matters
- National classifications underrepresent London's unique characteristics
- London-specific classification provides more nuanced residential typology
- Supports policy planning: school roll forecasting, public service planning, transport strategy
- Open and reproducible through R/Python code

## Key Technical Details
- **Method**: k-means clustering with 10,000 iterations for stability
- **Cluster selection**: Clustergrams (PCA-weighted visualization)
- **Data transformation**: Inverse hyperbolic sine + range standardization
- **Consultation**: Advisory Group with GLA and London Boroughs
- **Tools**: R (analysis), Python (Clustergrams)

## Classification Structure (Table 1)
| Supergroup | Groups |
|------------|--------|
| A: Professional Employment and Family Lifecycles | A1-A3 |
| B: The Greater London Mix | B1-B2 |
| C: Suburban Asian Communities | C1-C2 |
| D: Central Connected Professionals and Managers | D1-D3 |
| E: Social Rented Sector Families with Children | E1-E2 |
| F: Young Families and Mainstream Employment | F1-F2 |
| G: Older Residents in Owner-Occupied Suburbs | G1-G2 |

## Paper Structure (~3,000 words)
1. Introduction - History of geodemographics in UK, need for London-specific classification
2. Methodology - Data preparation, cluster analysis, Clustergrams
3. Cluster descriptions - Grand index for variable over/under-representation
4. End user consultation - Advisory Group process
5. Results - Interactive map, example Borough comparisons
6. Conclusion - Applications and future directions

## Relevance to Our Project
| Aspect | LOAC | Our Project |
|--------|------|-------------|
| Artifact type | Classification system | Workflow/pipeline |
| Geographic scope | London only | Korea (generalizable) |
| Temporal | Single census (2021) | Multiple years |
| Stakeholder involvement | Advisory Group | N/A |
| Output format | Data + interactive map | Quarto book + code |

## Lessons for Our Manuscript
1. **Stakeholder consultation**: Advisory Group ensured practical utility
2. **Multiple outputs**: Data download + interactive map + PDF reports
3. **Visualization tools**: Clustergrams for methodological decisions
4. **Clear justification**: Why London needs separate classification (we: why longitudinal + multimodal)
5. **Reproducibility**: GitHub repository with all code
6. **Policy applications**: Concrete examples of how classification was used
