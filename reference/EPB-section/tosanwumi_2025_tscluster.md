# Tosanwumi et al. (2025) - tscluster

## Citation
Tosanwumi, J., Liang, J., Silver, D., Fosse, E., & Sanner, S. (2025). tscluster: A python package for the optimal temporal clustering framework. *Environment and Planning B: Urban Analytics and City Science*, 52(4), 1014–1024. https://doi.org/10.1177/23998083241293833

## Type
Open Source Software (OSS) - Python package

## Summary
tscluster is an open-source Python framework for temporal clustering that groups time series data according to shared temporal trends across sociospatial units. The package introduces novel methods bridging traditional Time Series Clustering (TSC) and Sequence Label Analysis (SLA), with applications in urban science for studying neighbourhood change.

## Key Contributions
1. **Bounded Dynamic Clustering (BDC)**: Novel method allowing users to set upper bounds on label changes to identify atypical/volatile time series
2. **Mixed-Integer Linear Programming (MILP)**: Guarantees globally optimal solutions for reproducibility (unlike initialization-sensitive methods)
3. **Unified framework**: Covers six temporal clustering methods spanning static/dynamic cluster centres and static/bounded/unbounded labels
4. **Visualization tools**: tsplots sub-package for interpreting clustering results

## Artifact Details
- **Distribution**: PyPI (pypi.org/project/tscluster)
- **Source code**: GitHub (github.com/tscluster-project/tscluster)
- **Documentation**: tscluster.readthedocs.io
- **Dependencies**: numpy, pandas, scikit-learn, tslearn, gurobipy (for MILP)

## Methods Framework
| | Static Labels | Bounded Dynamic | Unbounded Dynamic |
|---|---|---|---|
| **Static Centres** | Static Clustering (SC) | BSLA | SLA |
| **Dynamic Centres** | TSC | BDC | FDC |

## Workflow
1. **Preprocessing**: Load temporal data (T timestamps × N entities × F features), normalize
2. **Clustering**: Select method, set parameters (K clusters, B max changes)
3. **Interpreting**: Visualize results, extract insights from cluster centres and labels

## Case Study
- **Location**: Toronto, Canada
- **Data**: Census data (1996-2021, 6 timestamps)
- **Units**: 96 Forward Sortation Areas (FSAs)
- **Features**: 4 socioeconomic indicators
- **Finding**: BDC identified M5E as atypical FSA due to Toronto Waterfront Revitalization Initiative (2000), avoiding false positives like M3B that fluctuate due to noise

## Relevance to Our Project
- **Methodological parallel**: Both address temporal analysis of urban phenomena
- **Different focus**: tscluster for neighbourhood typology clustering; our project for accessibility measurement
- **Paper structure**: Clear Introduction → Methodology → Case Study → Conclusion format for OSS paper

## Lessons for Our Manuscript
1. Provide multiple access points (PyPI, GitHub, ReadTheDocs)
2. Include mathematical formulation in supplemental materials
3. Case study demonstrates method capabilities, not deep policy analysis
4. Clear comparison with existing methods (tslearn)
5. Visualization important for interpretation
