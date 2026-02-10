# Santos et al. (2025) - ActiveCA

## Citation
Santos, B. D. d., Moghadasi, M., & Páez, A. (2025). ActiveCA: Time use data from the general social survey of Canada to study active travel. *Environment and Planning B: Urban Analytics and City Science*, 52(8), 2037–2047. https://doi.org/10.1177/23998083251374724

## Type
Open Data Product (ODP) - R data package

## Summary
ActiveCA is an R data package providing analysis-ready data on active travel (walking and cycling) from 7 cycles of Canada's Time Use Survey (1986-2022), spanning almost 40 years. Extracted from General Social Survey PUMFs with labeled variables, factored categories, and joined main/episode files.

## Key Contributions
1. **Longitudinal coverage**: 7 TUS cycles from 1986 to 2022 (nearly 40 years)
2. **Analysis-ready**: Labeled variables, factored categories, processed and joined files
3. **Active travel focus**: Walking (all cycles) and cycling (1992 onwards)
4. **Multiple formats**: Episode files, main files, unified dataset
5. **Python integration**: Jupyter notebook for converting .rda to Pandas DataFrames

## Data Coverage
### TUS Cycles included:
- Cycle 2 (1986): 16,390 respondents, 4,347 active episodes
- Cycle 7 (1992): 9,815 respondents, 1,635 active episodes
- Cycle 12 (1998): 10,749 respondents, 1,789 active episodes
- Cycle 19 (2005): 19,597 respondents, 5,866 active episodes
- Cycle 24 (2010): 15,390 respondents, 4,615 active episodes
- Cycle 29 (2015): 17,390 respondents, 3,496 active episodes
- Cycle 34 (2022): 12,336 respondents, 1,765 active episodes

**Total**: 101,667 records (181.5M weighted respondents), 23,513 active episodes (44.3M weighted)

## Data Attributes
### Episode-level:
- Mode: Walking, Cycling
- Duration: Minutes spent on trip
- Origin/Destination: Home, work/school, other's home, grocery store, restaurant, outdoor, etc.
- Episode weights: For population-wide estimates

### Individual-level (from main files):
- Age group, sex, marital status, number of children
- Stress levels, time use patterns
- Episode weights (WGHT_PER, WGHT_EPI)

### Geographic:
- Province
- Population center type: CMA, CA, non-CMA/CA
- Urban/rural setting

## Data Processing Workflow
1. **Selection**: Identify walking/cycling episodes + activities before/after (for origin/destination)
2. **Labeling**: Convert coded variables to descriptive labels
3. **Factoring**: Categorical → factor variables, ordinal → ordered factors
4. **Joining**: Merge episode and main files using identifiers
5. **Output**: Processed episode files by year, unified dataset, processed main files

## Key Findings (2022)
- **Trip purposes**: Home ↔ work/school most common (17% + 13% = 30%)
- **Recreation**: 7% of trips started and ended at home
- **Grocery**: 10% of trips from home to grocery stores
- **Home centrality**: <10% of trips didn't involve home as origin or destination
- **Walking duration**: Median 15 min (2022), increased from 10 min (historical)
- **Cycling duration**: Median 30 min (2022), varied 10-30 min historically
- **Urban/rural gap**: CMA/CA residents walk longer than non-CMA/CA (e.g., Nova Scotia: 30 min vs 5 min)

## Distribution
- **Platform**: R package via GitHub (dias-bruno/ActiveCA)
- **Installation**: GitHub repository
- **Documentation**: Vignettes with usage examples
- **License**: Open (following ODP principles)

## Relevance to Our Project
- **Methodological parallel**: Both produce longitudinal accessibility/mobility datasets
- **Different focus**: ActiveCA on time use/active travel episodes; our project on multimodal accessibility
- **Complementary**: Active travel patterns inform accessibility analysis
- **Open data**: Both emphasize reproducibility, transparency, analysis-ready data

## Lessons for Our Manuscript
1. Distribute as R package for ease of use
2. Provide both raw and processed/aggregated data
3. Label all coded variables explicitly
4. Include visualization examples in documentation
5. Support multiple programming languages (R + Python)
6. Emphasize longitudinal value (40 years)
7. Clear data processing workflow diagram
8. Acknowledge data limitations (methodological changes over time)
