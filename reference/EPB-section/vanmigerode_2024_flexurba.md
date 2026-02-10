# Van Migerode et al. (2024) - flexurba

## Citation
Van Migerode, C., Poorthuis, A., & Derudder, B. (2024). Flexurba: An open-source R package to flexibly reconstruct the Degree of Urbanisation classification. *Environment and Planning B: Urban Analytics and City Science*, 0(0), 1-9. https://doi.org/10.1177/23998083241262545

## Artifact Type
**Open Source Software (OSS)** - R package for urban classification

## What It Is
- R package `flexurba` reconstructing Degree of Urbanisation (DEGURBA) algorithm
- First open implementation of DEGURBA in any programming language
- Two-stage classification: (1) grid cells → (2) spatial units
- Customizable parameters: population thresholds, contiguity rules, edge smoothing
- Includes both GHSL Data Package 2022 and 2023 versions

## Why It Matters
- Existing GHSL tools use GUI, obscuring code and limiting customization
- Enables sensitivity analysis of classification parameters
- Facilitates comparative research on urban delineation
- Responds to Boeing's (2020) call for open-source spatial research software
- Integrates with common R spatial workflows (terra, sf)

## Key Technical Details
- **Stage 1 (Grid classification)**:
  - Urban centres: ≥1,500 inh/km², ≥50,000 total pop, rook contiguity
  - Urban clusters: ≥300 inh/km², ≥5,000 total pop, queen contiguity
  - Rural cells: everything else
- **Stage 2 (Spatial units)**: Cities, towns/semi-dense, rural areas
- **Optimization**: C++ via Rcpp for computationally intensive functions
- **Memory handling**: terra framework for large datasets

## Paper Structure (~3,000 words)
1. Introduction - Need for open DEGURBA implementation
2. The DEGURBA methodology - Two-stage classification rules
3. The flexurba package - Functionalities with code examples
4. Comparison with official classification - 0.002% global discrepancy
5. Technical details and computational requirements
6. Potential applications - Sensitivity analysis, alternative delineations
7. Conclusion

## Relevance to Our Project
| Aspect | flexurba | Our Project |
|--------|----------|-------------|
| Artifact type | R package | Workflow/pipeline |
| Focus | Urban classification | Accessibility analysis |
| Flexibility | Customizable parameters | Customizable time periods/modes |
| Validation | Compare to official GHSL | Compare to Google Maps |
| Code examples | Yes, with figures | Yes, in Quarto book |

## Lessons for Our Manuscript
1. **Open reconstruction value**: Reconstructing existing methodology openly enables sensitivity analysis
2. **Code examples in paper**: Show actual R code with different parameterizations
3. **Honest about limitations**: 0.002% discrepancy acknowledged, slower than GUI tools
4. **Multiple versions**: Support different algorithm versions (we: different years)
5. **Utility functions**: Include data download and preprocessing helpers
6. **Comparison table**: Cross-tabulate results with official classification
7. **Response to call**: Cite Boeing (2020) on open-source spatial software
