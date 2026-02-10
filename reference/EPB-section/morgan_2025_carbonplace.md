# Carbon & Place: Data and tools to understand the spatial variation in carbon footprints

**Author**: Malcolm Morgan

**Journal**: EPB: Urban Analytics and City Science, 2025, Vol. 0(0) 1–17

**DOI**: 10.1177/23998083251401613

**Type**: Open Source Software - Web tools and data for neighborhood-level carbon footprints

---

## Summary

Carbon & Place (https://www.carbon.place) is a family of free open-source web tools explaining spatial variation in per-capita consumption-based carbon footprints across Great Britain (2010–present) and future decarbonization scenarios (to 2050). The tools use a two-tier methodology: (1) When local data available (gas/electricity), calculate directly from small area statistics; (2) When unavailable (food, goods, services), construct synthetic populations matching Census data to Living Costs and Food Survey (LCFS) via Iterative Proportional Fitting (IPF). Analysis performed in R using targets framework with **300+ stages**, producing per-capita emissions for all LSOAs (Lower Super Output Areas) annually since 2010. Outputs presented via interactive 3D dasymetric maps using custom building stock model from LIDAR + OSM. Synthetic population validated against Census (R²=0.96 for income, R²=0.72 for rooms). Website updated every 6 months, provides bulk data downloads, and will incorporate downscaled PLEF (Positive Low Energy Futures) net-zero scenarios by 2028. The project demonstrates that neighborhood-level carbon footprinting is possible despite data limitations, with thousands of monthly uses suggesting utility for communities and policymakers.

---

## Key Contributions

1. **Neighborhood-scale carbon footprints**: Per-capita consumption-based emissions for all LSOAs in Great Britain (England, Wales, Scotland) annually since 2010
2. **Two-tier methodology**: Direct calculation when local data available (gas/electricity); synthetic population approach when not (food, goods, services)
3. **Synthetic population via IPF**: Match 12,000 LCFS households to Census using 5 main variables + income weighting (56.9% perfect match, only 2.2% < 95% match)
4. **Comprehensive analysis pipeline**: R + targets framework, 300+ stages, fully reproducible (GitHub: https://github.com/PlaceBasedCarbonCalculator/build/)
5. **Interactive 3D web tools**: https://www.carbon.place with dasymetric mapping, custom building stock model (LIDAR + OSM), multiple topic-specific tools (Transport, Retrofit, Land Ownership)
6. **Validated outputs**: Internal consistency checks, synthetic population R²=0.96 (income), R²=0.72 (rooms), statistically significant correlations across demographic variables
7. **Temporal coverage**: Historical (2010–2022) + future scenarios (downscaled PLEF to 2050, in progress)
8. **Open data and code**: Bulk downloads, manual, GitHub repositories, long-term archiving via UK Data Service

---

## Problem Definition

**Gap in existing research**:
- Carbon footprints commonly calculated for large areas (countries/regions/cities) OR groups/individuals (companies/households)
- **Intermediate scale of neighborhoods far less studied** (Heinonen et al., 2020)
- Yet neighborhood characteristics significantly affect carbon footprint (building properties, travel patterns) (Marsden et al., 2020)
- Place-based solutions more effective for decarbonization (Lai et al., 2025; Middlemiss et al., 2024)
- Local governments on front line of policy delivery (Bedford et al., 2023; McMillan et al., 2024)

**Few existing neighborhood-level datasets**:
- Dawkins et al. (2024): Sweden municipal and postcode level
- Jones and Kammen (2014): U.S. household carbon footprints reveal suburbanization
- Morgan et al. (2021): Earlier place-based carbon calculator for England

**Gap this work fills**: Free open-source web tools for Great Britain with historical data (2010–present) and future scenarios, using reproducible analysis pipeline

---

## Methodology

### Two-Tier Approach

**Fundamental challenge**: Cannot know everything about everyone (privacy + practical limits)

**Solution**:
1. **Tier 1 - Local data available**: Use neighborhood-specific small area statistics
   - Examples: Domestic gas/electricity consumption, vehicle registrations
   - Method: Multiply consumption (kWh) by carbon intensities (BEIS, 2022b), divide by population

2. **Tier 2 - Local data unavailable**: Construct synthetic populations representative of each neighborhood
   - Examples: Food, goods, services, flights
   - Method: Match national survey (LCFS) to Census via Iterative Proportional Fitting

**Common unit**: LSOA (Lower Super Output Area) in England/Wales, Data Zone in Scotland
- 40-250 households per area
- Temporal range: Annually since 2010

### Input Data

**Small area statistics** (Table 1 - high geographic resolution):
- Boundaries, Census (2011/2021), population estimates
- OSM, Ordnance Survey, LIDAR (terrain/surface)
- Energy Performance Certificates (England/Wales: MHCLG; Scotland: Energy Savings Trust)
- Gas/electricity consumption (DESNZ)
- Council tax, house prices, income (MSOA)
- Transport: Propensity to Cycle Tool, public transport frequency, vehicle registrations

**National/aggregate data** (Table 2 - establish consumption patterns):
- **UK consumption-based accounts** (ONS, 2023b)
- **Emissions factors 2010–present** (BEIS, 2022a)
- **Living Costs and Food Survey (LCFS)** - 12,000 households, 34 COICOP categories (ONS, 2024c) - **KEY DATASET**
- Understanding Society, National Travel Survey, Anonymised MOT tests
- UK flights and emissions 1990–2021 (Morgan et al., 2025)

### Boundary Adjustments

**Challenge**: Convert all datasets to 2021 LSOA boundaries

**Three types of changes**:
1. **No change**: Most LSOAs in England/Wales unchanged between 2011 and 2021
2. **Merged LSOAs**: Simple - add pre-2021 data, use population-weighted mean for averages
3. **Split LSOAs** (most common due to population growth):
   - Use 3 metrics: households (Census 2011/2021), adults (ONS mid-year estimates), dwellings (VOA)
   - Assume households proportional to dwellings + linear interpolation of adults per household
   - Estimate households each year → use ratio to split data
4. **Complex changes** (6 LSOAs): Small adjustments, one-to-one pairing (introduces small errors)
5. **Scotland**: Most 2011 Data Zones replaced in 2022 → more complex transformation

**Importance**: Accurate population estimates critical (under/over estimation distorts emissions, misleading trends) (Morgan et al., 2022)

### Synthetic Population Construction

**Purpose**: Identify which subset of LCFS (12,000 households) best represents each LSOA

**Method**: **Iterative Proportional Fitting (IPF)** using R package mipfp

**Five main variables** (Table 3):
1. **Tenure** (4 categories): Owned outright, owned with mortgage, social rent, private rent/rent free
2. **Household composition** (11 categories): One person >=66, one person <66, couple types, lone parent, family, other
3. **Cars & vans** (4 categories): 0, 1, 2, 3 or more
4. **Household size** (4 categories): 1, 2, 3, 4 or more
5. **Output area classification** (21 categories): Rural-urban fringe, affluent rural, university towns, mining legacy, etc.

**Additional intermediate variables** (help when data missing):
- Accommodation Type
- Household Composition (6 Variables)

**Income weighting** (sixth variable):
- Normal distribution from ONS average income + confidence intervals (ONS, 2023a)
- Weight selection to ensure households within 99% confidence intervals

**Multivariate tables** (Table 4):
- 14 different combinations of variables from Census 2021
- Coverage ranges 58.0% to 100% of LSOAs
- ONS excludes where tables would be disclosive

**IPF seeding**: National population distribution → reduces impossible households (e.g., couple in one-person household)

**Matching process**:
- Maximize similarity score across all 6 variables
- Each pair weighted by similarity (e.g., Detached to Semi-Detached = 0.8)

**Match quality**:
- **56.9%**: Perfect match across all 6 variables
- **Only 2.2%**: Match score < 95% (single small compromise)
- **Lowest score**: 80% (affects just 1 of 24.6 million households)

### Flights

**Challenge**: No local datasets, National Travel Survey misses infrequent trips (Wadud et al., 2024)

**Official emissions problems**:
- Only flights leaving country (not returns)
- Only CO2 (not CO2 equivalent)

**Solution**: Passenger origin-destination data (Morgan et al., 2025)

**Metric**: Total number of flights in past 12 months (not spending)

**LCFS categories**: Domestic vs international (distinguished)

**Limitation**: Does NOT distinguish short-haul vs long-haul (significant for emissions)

### Analysis Pipeline

**Platform**: R programming language (R Core Team, 2025)

**Framework**: targets (Landau, 2021) - dynamic make-like pipeline for reproducibility

**Complexity**: **300+ stages**

**Repository**: https://github.com/PlaceBasedCarbonCalculator/build/

**Update frequency**: Annually as new input data becomes available

**Data lag**: Many datasets 2–3 year lag; COVID-19 affected several → larger delay for recent years

**Workflow**: Figure 1 (simplified overview) shows major steps from input datasets → per-capita emissions → visualizations

---

## Validation

### Challenge

No directly comparable small area emissions statistics exist to compare against

### Internal Consistency

**Approach**: When national emissions downscaled to LSOAs, check sum equals national total

### Synthetic Population Validation

**Figure 3 - Income distribution** (MSOAs, England/Wales, 2020):
- Synthetic vs observed average household income
- **R² = 0.96** (strong correlation)
- **Limitation**: Underestimates wealthiest areas (shortage of high-income households in LCFS)

**Figure 4 - Household characteristics**:
- Observed (Census 2021) vs modeled (Synthetic Population)
- Each point = LSOA × household composition × tenure × cars
- **R² = 0.96**, **RMSE = 3.7**
- Strong correlation, small disagreements expected (ONS adds random error for privacy)

**Figure 5 - Gas & electricity bills** (2021):
- Synthetic vs meter readings
- **Average bills**: £1,197 (synthetic) vs £1,253 (observed) - **almost perfect**
- **Correlation**: Weak but statistically significant (p < 0.001) across LSOAs
- **Unfair test**: Synthetic Population not designed for energy prediction, lacks housing variables

**Figure 6 - Other variables NOT used to constrain**:
- **Rooms per household**: R² = 0.72, RMSE = 1.46
- **Employment status**: Employee R²=0.19, self-employed R²=0.1, unemployed R²=0.16, retired R²=0.15
- **Ethnicity**: White R²=0.7, Asian R²=0.43, Black R²=0.69
- **Rural/urban**: Percentage from rural/urban areas
- **All statistically significant** (p < 0.001)

**Conclusion**: High collinearity between geodemographic characteristics supports synthetic population approach for identifying spatial carbon footprint distribution

---

## Website and Tools

### Main Website

**URL**: https://www.carbon.place

**Primary function**: Provide access to analysis and data in accessible format for non-technical users

**Key difference**: Visualization and communication integral (not just data)

**Update frequency**: Every 6 months until at least 2028 (end of EDRC - Energy Demand Research Centre)

### Technical Implementation

**Key technologies**:
- **Maplibre** (Maplibre, 2024): Interactive maps
- **Tippecanoe** (Fisher, 2024): Vector tiles
- **PMtiles** (Protomaps, 2024): Efficient tile delivery

### 3D Building Stock Model

**Custom 2m terrain/surface model**:
- Open LIDAR data (England: Environment Agency, Wales: Welsh Government, Scotland: Scottish Government)
- OS + OSM building outlines (OSM more detailed, limited coverage)
- Land Registry INSPIRE polygons (segment large buildings, e.g., terraced rows)

**Dasymetric mapping** (Figure 7):
- Data refers to buildings/occupants (not areas)
- Roads and buildings visible for navigation
- Example: London (Stratford → City), 3D buildings colored blue (below average) to red (above average) emissions

**Grading system**:
- A+ to F− (percentile bands)
- National median = C/D+
- A+/F− = best/worst 1%

### Map Layers and Reports

**Main maps** supplemented with:
- Optional layers (e.g., individual building EPCs)
- **Pop-up reports** (Figure 8) when clicking neighborhood:
  - Dwelling changes graph (2020–present by building type, VOA data)
  - Community photo (demographic icons showing household composition, socio-economic classification, ethnicity from 2021 Census)

### Multiple Tools

**Topics**:
- Transport and Accessibility
- Retrofit
- Land Ownership
- (Others)

**Common backend**: All share analysis pipeline

### Bulk Data

**Data page**: https://www.carbon.place/data

**Provided**:
- Finalized outputs
- Experimental outputs (Beta tools, work in progress)

**Documentation**:
- Website manual: https://www.carbon.place/manual
- GitHub repositories: https://github.com/PlaceBasedCarbonCalculator

**Long-term archiving**: UK Data Service (at project end)

---

## Future Scenarios

**Ultimate goal**: Local decarbonization scenarios for each LSOA

**Approach**: Downscale **Positive Low Energy Futures (PLEF)** scenarios (Brand et al., 2022)
- PLEF = range of national UK scenarios for net-zero by 2050

**Local scenarios will**:
- Be consistent with PLEF
- Recognize pre-existing neighborhood differences
- Account for how differences affect speed/method to achieve net-zero

**Outputs (neighborhood scale)**:
- What changes need to occur
- When they need to be finished
- Whether currently on-track for net-zero

**Use cases**: Communities, planners, policymakers to design, deliver, evaluate policies

**Builds on**: Place and Futures themes in Energy Demand Research Centre

---

## Strengths and Limitations

### Strengths

1. **Comprehensive coverage**: All LSOAs in Great Britain (England, Wales, Scotland)
2. **Temporal depth**: Annual data since 2010, future scenarios to 2050
3. **Two-tier methodology**: Leverages local data when available, models when not
4. **Strong validation**: Synthetic population R²=0.96 (income), R²=0.72 (rooms), all demographic variables statistically significant
5. **Reproducible pipeline**: R + targets framework, 300+ stages, GitHub repository
6. **Interactive visualization**: 3D dasymetric maps, custom building stock, accessible to non-technical users
7. **Open data and code**: Bulk downloads, manual, long-term archiving
8. **Continuous updates**: Every 6 months until at least 2028
9. **Multiple tools**: Topic-specific (Transport, Retrofit, Land Ownership) sharing common backend
10. **Practical use**: Thousands of monthly users (communities, policymakers)

### Limitations

**1. Data quality and coverage**:
- Synthetic population underestimates high-income households (LCFS shortage)
- Under-represented groups (students, care home residents, prisoners) less accurate
- Not designed to predict domestic energy use (lacks housing type, size variables)

**2. Validation constraints**:
- No directly comparable neighborhood carbon footprint data
- Relies on internal consistency and cross-checks
- Cannot validate against ground truth

**3. Flights data**:
- LCFS only covers 3 months (brief for infrequent trips)
- Does NOT distinguish short-haul vs long-haul (significant for emissions)
- National Travel Survey misses infrequent trips (Wadud et al., 2024)

**4. Data lag**:
- 2–3 year publication lag for many datasets
- COVID-19 affected several datasets
- Larger delay for recent comprehensive analysis

**5. Boundary changes**:
- 6 LSOAs with complex changes (one-to-one pairing introduces small errors)
- Scotland: Most 2011 Data Zones replaced in 2022 (complex transformation)

**6. LCFS limitations** (older versions had housing variables, ONS removed from current/future):
- Missing housing type, number of rooms
- Would improve energy use predictions

**7. Population estimation sensitivity**:
- Under/over estimation distorts emissions calculations (Morgan et al., 2022)
- Misleading trends if population wrong

### Ongoing Research

- How to best distribute survey respondents
- Address under-represented groups
- Improve high-income modeling

---

## Relevance to Our Project

### Methodological Parallels

1. **Synthetic population approach**: Match survey data (LCFS) to Census via IPF (similar to activity-based travel demand pipeline, Mahfouz et al. 2025)
2. **Two-tier methodology**: Use local data when available, model when not (we do similar: GTFS direct use vs modeled accessibility)
3. **Reproducible pipeline**: R + targets framework, 300+ stages (we use R scripts + Quarto)
4. **Interactive web tools**: GitHub Pages deployment, accessible to non-technical users
5. **Temporal analysis**: Annual data since 2010 (we do 2021–2024 longitudinal)
6. **Boundary adjustments**: Handle LSOA changes 2011→2021 (we handle GTFS service area changes)
7. **Validation section**: Scatter plots showing R², RMSE (model for our validation approach)
8. **Open data and code**: GitHub repository, bulk downloads (same goal for our workflow)

### Key Differences

- **Domain**: Carbon footprints (housing, transport, consumption); we measure accessibility to services
- **Spatial unit**: LSOA (40-250 households); we use hexagon grid + admin units
- **Data sources**: LCFS + Census + small area statistics; we use GTFS + OSM + R5R
- **Primary method**: Synthetic population (IPF); we calculate cumulative opportunities
- **Geographic coverage**: Great Britain; we focus on Korean cities
- **Temporal scope**: Historical (2010–present) + future scenarios (to 2050); we do 2021–2024

### Lessons for Our Manuscript

**Validation strategy**:
- **Multiple scatter plots** (Figures 3-6): Income R²=0.96, rooms R²=0.72, employment/ethnicity/rural-urban all p<0.001
- **Honest about limitations**: "Unfair test... not designed to predict domestic energy use"
- **Internal + cross-checks**: Sum of LSOAs = national total, compare synthetic to Census
- We can adopt: Validation routes + GTFS quality checks + compare to existing studies

**Two-tier framing**:
- "When local data available → direct calculation; when unavailable → model"
- Explicitly states which parts use which approach (Figure 1 flowchart)
- We can use: "When GTFS available → R5R routing; when service changes → document impact"

**Limitation transparency**:
- "No directly comparable small area emissions statistics exist to compare against"
- "Under-represented groups... less accurately modeled"
- "Underestimates wealthiest areas (shortage of high-income households in LCFS)"
- We can acknowledge: "GTFS quality varies across regions/years; 2024 data issues documented"

**Interactive visualization**:
- 3D dasymetric maps with custom building stock (LIDAR + OSM)
- Multiple topic-specific tools sharing common backend
- Pop-up reports with graphs + demographic icons
- We can provide: Interactive maps (GitHub Pages) + downloadable data + workflow scripts

**Synthetic population validation**:
- Figure 4: Scatter plot of Census vs Synthetic Population (each point = LSOA × characteristics)
- R² = 0.96, RMSE = 3.7, strong correlation
- We could validate: Accessibility values against Google Maps travel times, compare to intro_access_book results

**Grading system for accessibility**:
- A+ to F− (percentile bands), national median = C/D+, best/worst 1%
- Clear for non-technical users
- We could adopt: Grade LSOAs/hexagons by accessibility (A+ = best-served, F− = underserved)

**Future scenarios**:
- Downscale national scenarios (PLEF) to neighborhood level
- Show what/when/whether on-track for goals
- We could mention: "Future work could incorporate service improvement scenarios"

**Update frequency**:
- Every 6 months until 2028
- Annual updates as new data becomes available
- We can state: "Workflow can be re-run annually as new GTFS releases become available"

**Boundary object framing**:
- Maps + reports enable stakeholder engagement
- Tools for communities, planners, policymakers (not just researchers)
- We can position: "Accessibility maps can inform transport equity discussions"

**Repository structure**:
- GitHub: https://github.com/PlaceBasedCarbonCalculator/build/ (main analysis)
- Website: https://www.carbon.place (interactive tools)
- Data page: https://www.carbon.place/data (bulk downloads)
- Manual: https://www.carbon.place/manual (methods documentation)
- We can adopt: GitHub repo (workflow scripts) + GitHub Pages (Quarto book) + Zenodo (archived data)

**Flowchart strategy** (Figure 1):
- Orange boxes = input datasets (Tables 1 & 2)
- Dashed borders = adjusted for boundaries/population
- Blue boxes = intermediate datasets
- Green boxes = major outputs
- Purple boxes = visualizations
- Could inspire our workflow diagram

**Pop-up reports** (Figure 8):
- Dwelling changes graph (simple bar chart)
- Community photo (demographic icons)
- Makes existing open data more accessible
- We could create: LSOA/hexagon reports showing accessibility by mode, temporal change, comparison to regional average

---

## Notes

This paper is highly relevant because:

1. **Most similar web tool**: Interactive maps + bulk data + open-source pipeline (closest to our intended output)
2. **Validation section**: Multiple scatter plots with R², RMSE, p-values (strong model for our validation approach)
3. **Two-tier methodology**: Use local data when available, model when not (parallel to our GTFS vs non-GTFS approach)
4. **Honest limitations**: "Not designed to predict...", "underestimates...", "no directly comparable..." (model for acknowledging GTFS quality issues)
5. **Reproducible pipeline**: R + targets, 300+ stages, GitHub (same technical approach we use)

The **synthetic population approach** (IPF matching LCFS to Census) is similar to activity-based travel demand (Mahfouz et al., 2025) but different from our cumulative opportunities method. However, the **validation strategy** is directly applicable: scatter plots, R², RMSE, multiple cross-checks.

The **3D dasymetric mapping** with custom building stock (LIDAR + OSM) shows advanced visualization, but we can adopt simpler approach (2D choropleth maps for accessibility grades).

The **grading system** (A+ to F−, percentile bands) is excellent for non-technical communication. We could grade hexagons/LSOAs by accessibility (A+ = best-served areas with high frequency transit + short travel times, F− = underserved periphery).

The **future scenarios** (downscaling national PLEF to neighborhood level) parallels our potential work on service improvement scenarios or climate action plan targets.

The **update frequency** (every 6 months) shows commitment to maintaining tool beyond initial publication. We should state: "Workflow can be re-run annually as new GTFS releases published."

The **pop-up reports** (Figure 8: graphs + demographic icons) demonstrate how to make data accessible without technical expertise. We could create similar reports: LSOA clicked → show accessibility by mode, temporal change, demographic profile, comparison to city average.

The **boundary adjustment methods** (merged/split/complex LSOAs) provide detailed guidance for handling geographic changes over time. We face similar issues with GTFS service area changes year-to-year.

The **limitation on flights** (LCFS only 3 months, doesn't distinguish short/long-haul) shows honest acknowledgment of data constraints. We should similarly acknowledge GTFS quality varies, 2024 data has specific issues in certain cities.
