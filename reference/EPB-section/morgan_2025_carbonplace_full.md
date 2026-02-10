# Carbon & Place: Data and tools to understand the spatial variation in carbon footprints

**Author**: Malcolm Morgan

**Journal**: EPB: Urban Analytics and City Science, 2025, Vol. 0(0) 1–17

**DOI**: 10.1177/23998083251401613

**Type**: Open Source Software - Web tools and data for neighborhood-level carbon footprints

---

## Abstract

Carbon & Place (https://www.carbon.place) is an ongoing research project to produce a free family of web tools intended to explain the spatial variation in per-capita carbon footprints across Great Britain and how they can be reduced. The tools present results via interactive maps using GIS data, small area statistics, surveys, and models to aid planners, policymakers, and communities in understanding their climate impact. Local people can benefit from disaggregated analysis as it can be more personally relevant and account for local circumstances and needs. This paper provides an overview of the project, its open-source website, and analysis pipeline, as well as reporting on its progress to date and future work.

---

## Keywords

housing, transport networks, geodemographics, carbon footprint, synthetic population

---

## Introduction

### Problem Definition

**Challenge**: Neighborhood-scale carbon footprints are far less studied than national/regional or individual/household scales (Heinonen et al., 2020)

**Why this matters**:
- Neighborhood characteristics significantly affect parts of carbon footprint (building properties, travel patterns) (Marsden et al., 2020)
- Place-based solutions more effective at achieving decarbonisation goals (Lai et al., 2025; Middlemiss et al., 2024)
- Local governments on front line of delivering decarbonisation policy (Bedford et al., 2023; McMillan et al., 2024)

**Current gap**:
- Many papers establish relationship between spatial characteristics (urbanity) and carbon footprints
- Few attempts to produce neighborhood-level carbon footprints for nations or regions (Dawkins et al., 2024; Jones and Kammen, 2014; Morgan et al., 2021)
- Gap between understanding that spatial characteristics are important and creation of usable carbon footprint datasets

### Carbon & Place Solution

**What it is**: Free open-source web tools (https://www.carbon.place) exploring spatial variation in per-capita consumption-based carbon footprints across Great Britain

**Scope expansion from earlier work**:
1. More detail on selected topics with multiple tools
2. Includes Scotland and Wales (not just England)
3. Historical change (2010–present)
4. Explores future scenarios

**Project timeline**: 2024–2028

**Outputs**:
- Open-source reproducible analysis pipeline
- Web tools with interactive maps
- Open data (published or soon to be)

---

## Methodology

### Fundamental Challenge

**Problem**: Calculating consumption-based carbon footprint of a neighborhood is difficult because:
1. **Broad scope**: Everybody has a carbon footprint, everything contributes → impossibly broad scope
2. **Data limitations**: UK has many small area datasets, but insufficient data to know everything about everyone (privacy + practical reasons)

**Solution**: Two-tier approach
1. **When local data available**: Use neighborhood-specific data to calculate parts of carbon footprint (e.g., domestic gas/electricity consumption)
2. **When data unavailable**: Resort to national surveys of household consumption + construct sub-samples representative of each neighborhood

**Output unit**: Average per-capita consumption carbon footprint for each **Lower Super Output Area (LSOA)** in Great Britain for each year since 2010

**LSOA characteristics**: Small areas designed for Census, typically 40-250 households

---

## Input Data

### Small Area Statistics (Table 1)

**High geographical resolution datasets** (used to measure activity/characteristics directly at neighborhood scale):

**Boundaries and geographies**:
- OA/LSOA/MSOA for 2011/2021 (ONS, 2024a)
- Wards, parishes, local authority (Digimap, 2014)
- Scottish data zones 2011/2022
- Postcodes

**Spatial data**:
- Ordnance Survey open data (Ordnance Survey, 2014)
- Ordnance Survey points of interest (Ordnance Survey, 2024)
- OpenStreetMap (Geofabrik, 2021)
- LIDAR digital terrain/surface maps: England (Environment Agency, 2024), Wales (Welsh Government, 2024), Scotland (Scottish Government, 2024a)

**Census and demographics**:
- Census 2011/2021 (multiple datasets) (ONS, 2011)
- 2011/2022 LSOA area classifications (ONS, 2018)
- Mid-year population estimates (ONS, 2024b; National Records of Scotland, 2021)

**Housing and energy**:
- Council tax: England/Wales (VOA, 2024), Scotland (Scottish Government, 2024b)
- Energy performance certificates (MHCLG, 2024; Energy Savings Trust, 2024)
- Gas and electricity consumption LSOA (England/Wales) (DESNZ, 2024)
- Income (MSOA) 2012–2020 (England/Wales) (ONS, 2023a)
- House prices and transactions (England/Wales) (O'Brien, 2024)

**Transport**:
- Propensity to cycle tool (Goodman et al., 2019)
- Public transport frequency (FOE, 2023; Morgan and Philips, 2023)
- Vehicle registrations (DFT, 2024)

**Land ownership**:
- Land ownership by UK/overseas companies (Land Registry, 2022)
- INSPIRE freehold polygons (Land Registry, 2024)

### National/Aggregate Data (Table 2)

**Used to establish general consumption patterns when local data unavailable**:

- UK consumption-based accounts (ONS, 2023b)
- Emissions factors 2010–present (BEIS, 2022a)
- **Living costs and food survey** (ONS, 2024c) - **KEY DATASET**
- **Understanding society** (Institute for Social and Economic Research, 2024)
- National travel survey (DfT, 2023a)
- Anonymised MOT tests (Cairns et al., 2017; DfT, 2023b)
- UK flights and emissions 1990–2021 (Morgan et al., 2025)

---

## Analysis Pipeline

### Technical Framework

**Programming language**: R (R Core Team, 2025)

**Reproducibility framework**: targets (Landau, 2021) - dynamic make-like function-oriented pipeline toolkit

**Repository**: GitHub (https://github.com/PlaceBasedCarbonCalculator/build/)

**Complexity**: Over **300 stages** in analysis pipeline

**Update frequency**: Comparable workflow will update outputs each year as new input data becomes available

**Data lag**: Many input datasets published 2–3 year time lag; several affected by COVID-19 pandemic → larger than usual delay for most recent comprehensive analysis year

**Workflow overview**: Figure 1 provides highly simplified overview (see paper for detailed flowchart)

### Adjusting for Different Boundaries, Boundary Changes, and Population Change

**Common unit of analysis**: 2021 LSOA (or Data Zone in Scotland)

**All datasets adjusted** via:
- **Aggregation**: Summarizing individual point data (e.g., building EPCs) or postcode data using weighted sums
  - Example: Most common housing type for each LSOA by aggregating EPCs
  - Point intersection to assign data to right LSOA
- **Disaggregation**: Splitting coarser data into finer units
- **Transformation**: Converting between different boundary systems

**Transformation details**:

**Fortunately**: Most LSOAs in England/Wales did not change borders between 2011 and 2021 Censuses

**Changes that occurred**:
1. **Complex changes** (6 LSOAs): Small adjustments (Figure 2 example: 12 houses out of hundreds moved, ~1% of population)
   - Solution: One-to-one pairing between precursor and successor LSOAs (introduces small errors, likely smaller than other uncertainties)

2. **Merged LSOAs**: Simple to account for
   - Add pre-2021 data to get values for new LSOAs
   - Use population-weighted mean for historical averages (e.g., average age)

3. **Split LSOAs**: Most common (due to population growth), most complex
   - **Three metrics used**:
     - Number of households in 2011 and 2021 (Census)
     - Number of adults in each year (ONS mid-year population estimate, 2011 boundaries)
     - Number of dwellings in each year (Valuation Office Agency, 2021 boundaries)
   - **Assumption**: Number of households proportional to dwellings + linear interpolation of adults per household between 2011 and 2021
   - **Process**: Estimate households for each year → use ratio to split data (e.g., electricity consumption) between new LSOAs

**Scotland**: Most 2011 Data Zones replaced in 2022 Census → more complex transformation

**Importance of accurate population estimates**: Under/over estimation of population significantly distorts emissions calculations, gives misleading impression of where emissions rising or falling (Morgan et al., 2022)

### Calculating Parts of Carbon Footprint When Local Data Available

**Examples**: Domestic gas and electricity consumption

**Method**:
1. Use long-time series small area statistics (Table 1)
2. Subject to boundary transformations (see above)
3. Multiply consumption (kWh gas/electric) by published carbon intensities for each year (BEIS, 2022b)
4. Divide total emissions by mid-year LSOA population → per-person carbon footprints

**Surface transport emissions**:
- Mix of small area data (car ownership, average mileage in some years)
- Combined with disaggregated data
- Model spatial variation and emissions rates of vehicles in each LSOA
- Public transport modeled in less detail (small part of total emissions, minor difference to results)

### Calculating Parts of Carbon Footprint When Local Data Unavailable

**Examples**: Food, goods, services

**Method**: Synthetic population approach (Morgan, 2025; Wu et al., 2022)

**Assumption**: Socio-demographic and geodemographic consumption patterns observed in survey data (e.g., strong correlation between income and consumption, Owen and Barrett 2020) are best predictors of local consumption patterns

**Key survey**: **Living Costs and Food Survey (LCFS)**
- Two years used
- 12,000 households across 34 COICOP (Classification of Individual Consumption According to Purpose) categories (ONS, 2024c)
- COICOP categories match UK national consumption-based carbon accounts
- National carbon emissions distributed to LSOAs in proportion to household spending in each area

**Synthetic Population Construction**:

**Purpose**: Ascertain which subset of LCFS best represents each LSOA

**Method**: Iterative Proportional Fitting (IPF)
- R package: mipfp
- Created from 2021/22 Censuses

**Five main variables** (Table 3):
1. **Tenure**: Owned outright; owned with mortgage; social rent; private rent/rent free
2. **Household composition**: 11 categories (one person >=66; one person <66; couple without children; couple with dependent children; couple with non-dependent children; lone parent; lone parent with non-dependent children; family >=66; other with children; other without children; other including >=66 or students)
3. **Number of cars & vans**: 0; 1; 2; 3 or more
4. **Household size**: 1; 2; 3; 4 or more
5. **Output area classification**: 21 categories (rural-urban fringe; affluent rural; rural growth areas; larger towns and cities; university towns and cities; older farming communities; sparse English and Welsh countryside; ageing coastal living; seaside living; Scottish countryside; ethnically diverse metropolitan living; London cosmopolitan; manufacturing legacy; mining legacy; service economy; Scottish industrial legacy; country living; Northern Ireland countryside; prosperous semi-rural; prosperous towns; industrial and multi-ethnic; urban living; city periphery; expanded areas)

**Two additional intermediate variables** (helped differentiate households when other data missing):
- Accommodation Type
- Household Composition (6 Variables)

**Multivariate tables** (Table 4) used as input for IPF:
- 14 different multivariate combinations of variables
- Coverage ranges from 58.0% (Household composition 15 variables × Accommodation type) to 100% (several combinations)
- ONS excludes LSOAs where tables would be disclosive → some LSOAs only have partial data

**IPF seeding**: Multivariate national population distribution → reduces creation of impossible/unlikely households (e.g., couple in one-person household)

**Income weighting**:
- Sixth variable: Household income
- Normal distribution created from average income + confidence intervals (ONS, 2023a)
- Weight selection to ensure households within 99% confidence intervals for each LSOA

**Matching process**:
- Maximize similarity score
- Each pair of values weighted by how similar (e.g., Detached to Semi-Detached = 0.8)
- **56.9% of households**: Perfect match across all six variables
- **Only 2.2% of households**: Match score less than 95% (indicating single small compromise made)
- **Lowest score**: 80% (affects just one of 24.6 million households)

### Flights

**Challenge**: Significant part of some people's carbon footprint, but difficult to account for

**Problems**:
- No local datasets record how much people fly
- National datasets (National Travel Survey) do poor job capturing flights (infrequent trips often missed) (Wadud et al., 2024)
- Official emissions calculations misleading:
  - Standard practice: Only report flights leaving country (not returns)
  - Only CO2 emissions (not CO2 equivalent)
  - Incompatible with household consumption emissions (should account for total impact of all flights)

**Solution**: More detailed passenger origin-destination data (Morgan et al., 2025)

**Metric**: Total number of flights in past 12 months (not spending, due to LCFS brief 3-month period)

**LCFS categories**: Domestic vs international flights (distinguished)
- **Limitation**: Does NOT distinguish short-haul vs long-haul (significant omission from emissions perspective)

---

## Validation

### Challenge

No directly comparable small area emissions statistics exist to compare against

### Internal Consistency Checks

**Approach**: When national emissions downscaled to LSOAs, check sum of all LSOAs matches national total

### Synthetic Population Validation

**Figure 3: Income distribution**
- Synthetic population vs observed average household income for MSOAs (England/Wales, 2020)
- **R² = 0.96** (strong correlation)
- **Limitation**: Tends to underestimate incomes in wealthiest areas (shortage of high-income households in LCFS)

**Figure 4: Household characteristics**
- Observed (Census 2021) vs modeled (Synthetic Population) number of households in each LSOA
- Each point = unique combination of LSOA × household composition × tenure × number of cars
- **R² = 0.96**, **RMSE = 3.7**
- Strong correlation demonstrates IPF algorithm effectively reconstructs Census
- Small disagreements expected (ONS adds random error for privacy protection)

**Under-represented groups**: Students, care home residents, prisoners less likely to be accurately modeled (ongoing research)

**Figure 5: Gas and electricity bills**
- Estimated average annual household bills (Synthetic Population) vs meter readings (2021)
- **Average bills**: £1,197 (synthetic) vs £1,253 (observed) - almost perfect match
- **Correlation**: Weak but statistically significant (p < 0.001) positive correlation across LSOAs
- **Unfair test**: Synthetic Population not designed to predict domestic energy use, lacks relevant variables (housing type, size)
- **Note**: Comparison data only provided kWh, had to make price assumptions for unit rates and standing charges

**Figure 6: Other variables NOT used to constrain Synthetic Population**
- **Average rooms per household**: R² = 0.72, RMSE = 1.46 (strong correlation)
  - Note: Synthetic based on LCFS 2018/19 self-reported; Census 2021 used VOA official data
- **Employment status**: Four common types (employee R²=0.19 RMSE=13.36, self-employed R²=0.1 RMSE=5.85, unemployed R²=0.16 RMSE=3.13, retired R²=0.15 RMSE=30.13)
- **Ethnicity**: Three common groups (white R²=0.7 RMSE=13.87, Asian R²=0.43 RMSE=5.53, black R²=0.69 RMSE=8.2)
- **Rural/urban**: Percentage of households from rural or urban areas
- **All statistically significant** (p < 0.001)

**Conclusion**: High degree of collinearity between geodemographic characteristics supports hypothesis that synthetic populations can identify spatial distribution of carbon footprints

---

## Results

### Website

**URL**: https://www.carbon.place

**Primary function**: Provide access to analysis and data in format accessible to non-technical users

**Key difference from typical open science projects**: Visualization and communication are integral parts of process (not just data)

**Update frequency**: Every 6 months with new features and updated data until at least end of EDRC (Energy Demand Research Centre) in 2028

### Technical Implementation

**Key technologies**:
- **Maplibre** (Maplibre, 2024)
- **Tippecanoe** (Fisher, 2024)
- **PMtiles** (Protomaps, 2024)

### 3D Building Stock Model

**Custom 2m terrain and surface model**:
- Built using open LIDAR data (England: Environment Agency, Wales: Welsh Government, Scotland: Scottish Government)
- Combined with OS and OSM building outlines
- National 3D building stock model

**Building outlines**:
- OSM: More detailed than OS Open Data, but limited coverage
- Segmented with Land Registry INSPIRE polygons
- Helps split large buildings (e.g., row of terraced homes represented by single polygon)

### Dasymetric Mapping (Figure 7)

**Benefits**:
- Highlights that data refers to buildings/occupants (not areas)
- Aids navigation by making roads and buildings more visible

**Example**: London (Stratford looking towards City)
- Neighborhood per-capita carbon footprints shown in 3D
- Blue (below average) to red (above average)
- Buildings colored by emissions grade

**Grading system**:
- A+ to F− (corresponds to percentile bands)
- National median between C/D+
- A+/F− = best/worst 1% of neighborhoods

### Map Layers and Reports

**Main neighborhood maps** supplemented with:
- Optional map layers (e.g., points for individual building EPCs)
- Pop-up reports (Figure 8) when clicking neighborhood

**Report examples**:
- **Dwelling changes graph** (Figure 8 top): Shows changes in number of dwellings by building type (2020-present)
  - Data from Valuation Office Agency, rounded to nearest 10
- **Community photo** (Figure 8 bottom): Demographic data visualized as icons showing mix of people
  - Based on 2021 Census
  - Illustrates household composition, socio-economic classification (NS-SEC), ethnicity

### Multiple Tools

**Structure**: Broken into multiple tools focusing on different topics
- Transport and Accessibility
- Retrofit
- Land Ownership
- (Others)

**Common backend**: All tools share common analysis pipeline

### Bulk Data

**Data page**: https://www.carbon.place/data

**Provided**:
- Finalized outputs
- Experimental outputs from Beta tools (work in progress, subject to revision)

**Additional information**:
- Website manual: https://www.carbon.place/manual
- GitHub repositories: https://github.com/PlaceBasedCarbonCalculator

---

## Future Scenarios

**Ultimate goal**: Produce local decarbonisation scenarios for each LSOA in Great Britain

**Approach**: Downscale Positive Low Energy Futures (PLEF) scenarios (Brand et al., 2022)

**PLEF**: Range of national scenarios for UK to achieve net-zero by 2050

**Local scenarios will**:
- Be consistent with PLEF
- Recognize pre-existing differences between neighborhoods
- Account for how differences affect speed and method neighborhoods achieve net-zero

**Outputs**:
- What changes need to occur (neighborhood scale)
- When they need to be finished
- Whether neighborhood currently on-track to achieve net-zero

**Use cases**: Communities, planners, policymakers to design, deliver, and evaluate net-zero policies

**Work builds on**: Place and Futures themes in Energy Demand Research Centre

---

## Limitations and Future Work

### Acknowledged Limitations

**Synthetic Population**:
- Under-represented groups (students, care home residents, prisoners) less accurately modeled
- High-income households underestimated (shortage in LCFS)
- Not designed to predict domestic energy use (lacks housing type, size variables)
- Older LCFS versions included housing variables, but ONS removed from current/future versions

**Flights**:
- LCFS only covers 3 months (brief period for infrequent trips)
- Does NOT distinguish short-haul vs long-haul (significant for emissions)

**Data lag**:
- 2–3 year publication lag for many datasets
- COVID-19 pandemic affected several datasets
- Larger than usual delay for most recent comprehensive analysis year

**Validation**:
- No directly comparable small area emissions statistics
- Relies on internal consistency and cross-checks
- Cannot validate against ground truth neighborhood carbon footprints

### Ongoing Research

- How to best distribute survey respondents
- Address under-represented groups
- Improve income distribution modeling for wealthiest areas

---

## Data Availability Statement

**Website**: https://www.carbon.place

**GitHub code**: https://github.com/PlaceBasedCarbonCalculator

**Data**: Available via website and GitHub repos

**Long-term archiving**: UK Data Service (at end of project)

**Input data**:
- Openly licensed: https://github.com/PlaceBasedCarbonCalculator/inputdata
- Restrictive license: How to acquire described at https://github.com/PlaceBasedCarbonCalculator/inputdatasecure

---

## Funding

The author(s) disclosed receipt of the following financial support for the research, authorship, and/or publication of this article: the authors gratefully acknowledge support from UK Research and Innovation through the Centre for Research into Energy Demand Solutions; grant reference number EP/R 035288/1 and Energy Demand Research Centre; grant reference number EP/Y010078/1.

---

## Declaration of Conflicting Interests

The author(s) declared no potential conflicts of interest with respect to the research, authorship, and/or publication of this article.

---

## ORCID iD

Malcolm Morgan: https://orcid.org/0000-0002-9488-9183

---

## References

[Full references section from pages 14-17 of the PDF - complete list verbatim as provided in the paper]

Bedford T, Catney P and Robinson Z (2023) Going Down the local: the challenges of place-based net zero governance. Journal of the British Academy 11: 125–156.

BEIS (2022a) Final UK greenhouse gas emissions national statistics: 1990 to 2020. https://www.gov.uk/government/statistics/final-uk-greenhouse-gas-emissions-national-statistics-1990-to-2022 (accessed 19 11 25)

BEIS (2022b) Government conversion factors for company reporting of greenhouse gas emissions. https://www.gov.uk/government/collections/government-conversion-factors-for-company-reporting (accessed 8 16 22).

Brand C, Anable J and Marsden G (2022) The role of energy demand reduction in achieving net-zero in the UK: transport and mobility. In: ECEEE 2022 Summer Study proceedings, June 2022, Hyeres, France. https://www.researchgate.net/publication/360189100_The_role_of_energy_demand_reduction_in_achieving_net-zero_in_the_UK_Transport_and_mobility

Büchs M and Schnepf SV (2013) Who emits most? Associations between socio-economic factors and UK households' home energy, transport, indirect and total CO2 emissions. Ecological Economics 90: 114–123.

Cairns S, Anable J, Catterton T, et al. (2017) Motoring along: the lives of cars seen through licensing and test data. RAC Foundation. https://www.racfoundation.org/research/environment/motoring-along-the-lives-of-cars-seen-through-licensing-and-test-data

Chen R, Zhang R and Han H (2021) Where has carbon footprint research gone? Ecological Indicators 120: 106882.

Dawkins E, Rahmati-Abkenar M, Axelsson K, et al. (2024) The carbon footprints of consumption of goods and services in Sweden at municipal and postcode level and policy interventions. Sustainable Production and Consumption 52: 63–79.

DESNZ (2024) Sub-national gas consumption data. DESNZ. https://www.gov.uk/government/collections/sub-national-gas-consumption-data

DfT (2023a) National Travel Survey. DfT.

DfT (2023b) Anonymised MOT Tests and Results. DfT. https://www.data.gov.uk/dataset/e3939ef8-30c7-4ca8-9c7c-ad9475cc9b2f/anonymised-mot-tests-and-results (accessed 3.29.23).

DFT (2024) Vehicle Licensing Statistics Data Tables. DfT. https://www.gov.uk/government/statistical-data-sets/vehicle-licensing-statistics-data-tables (accessed 11.20.24).

Digimap (2014) Digimap help. https://digimap.edina.ac.uk/webhelp/digimapsupport/about.htm (accessed 8 26 14).

Energy Savings Trust (2024) Scottish energy performance certificate register. https://www.scottishepcregister.org.uk/CustomerFacingPortal/DataExtract (accessed 11 20 24).

Environment Agency (2024) National LIDAR programme. https://www.data.gov.uk/dataset/f0db0249-f17b-4036-9e65-309148c97ce4/national-lidar-programme

Fisher E (2024) Tippecanoe. https://github.com/felt/tippecanoe

FOE (2023) How Britain's bus services have drastically declined. https://policy.friendsoftheearth.uk/insight/how-britains-bus-services-have-drastically-declined (accessed 11 28 23).

Geofabrik (2021) Europe. https://download.geofabrik.de/europe.html

Goodman A, Rojas IF, Woodcock J, et al. (2019) Scenarios of cycling to school in England, and associated health and carbon impacts: application of the 'Propensity to Cycle Tool'. Journal of Transport & Health 12: 263–278.

Heinonen J, Ottelin J, Ala-Mantila S, et al. (2020) Spatial consumption-based carbon footprint assessments - a review of recent developments in the field. Journal of Cleaner Production 256: 120335.

Institute for Social and Economic Research (2024). Understanding Society. Institute for Social and Economic Research.

Jones C and Kammen DM (2014) Spatial distribution of U.S. household carbon footprints reveals suburbanization undermines greenhouse gas benefits of urban population density. Environmental Science & Technology 48: 895–902.

Lai H-L, Devine-Wright P, Hamilton J, et al. (2025) A place-based, just transition framework can guide industrial decarbonisation with a social licence. Energy Research & Social Science 121: 103967.

Land Registry (2022) UK companies that own property in England and Wales. https://www.gov.uk/guidance/hm-land-registry-uk-companies-that-own-property-in-england-and-wales (accessed 6.1.24).

Land Registry (2024) INSPIRE index polygons spatial data. https://www.gov.uk/guidance/inspire-index-polygons-spatial-data

Landau W (2021) The targets R package: a dynamic make-like function-oriented pipeline toolkit for reproducibility and high-performance computing. Journal of Open Source Software 6: 2959.

Maplibre (2024) MapLibre GL JS. https://github.com/maplibre/maplibre-gl-js

Marsden G, Anderson K, Büscher M, et al. (2020) Place-Based Solutions for Transport Decarbonisation, Submission to the Department for Transport's Consultation on the Transport Decarbonisation Plan. Leeds.

McMillan E, Barnes J, Nolden C, et al. (2024) Local, place-based governance for net zero: a review and research agenda. Journal of the British Academy 12. doi: 10.5871/jba/012.a47

MHCLG (2024) Energy performance of buildings data: England and Wales. https://epc.opendatacommunities.org/ (accessed 11 20 24).

Middlemiss L, Snell C, Theminimulle S, et al. (2024) Place-based and people-centred: principles for a socially inclusive net zero transition. Geo: Geography and Environment 11: e00157.

Minx J, Baiocchi G, Wiedmann T, et al. (2013) Carbon footprints of cities and other human settlements in the UK. Environmental Research Letters 8: 035039.

Moran D, Kanemoto K, Jiborn M, et al. (2018) Carbon footprints of 13,000 cities. Environmental Research Letters 13: 064041.

Morgan M. (2025) A synthetic population dataset for estimating small area household consumption and emissions in England and Wales. In: GISRUK 2025, 23-25 Apr 2025, Bristol, UK. https://eprints.whiterose.ac.uk/id/eprint/229962/

Morgan M. and Philips I. (2023) Long-time series, small-area statistics for car ownership and level of public transport service. In: 2023 UTSG Conference: papers & extended abstracts. UTSG 55th Annual Conference, 10-12 Jul 2023, Cardiff, UK. Universities' Transport Study Group (UTSG) https://eprints.whiterose.ac.uk/id/eprint/220131/

Morgan M, Anable J and Lucas K (2021) A place-based carbon calculator for England. In: 9th annual GIS research UK conference (GISRUK), Cardiff, 13th-16th April 2021, 1–5.

Morgan M, Morton C, Monsuur F, et al. (2022) Understanding Change in Car Use Over Time (UnCCUT): End of Project Report. Leeds. https://decarbon8.org.uk/wp-content/uploads/sites/59/2023/01/Understanding-Change-in-Car-Use-over-Time-Morgan-et-al-2022.pdf

Morgan M, Wadud Z and Cairns S (2025) Can rail reduce British aviation emissions? Transportation Research Part D: Transport and Environment 138: 104513.

National Records of Scotland (2021) Mid-2020 small area population estimates for 2011 data zones. https://www.nrscotland.gov.uk/statistics-and-data/statistics/statistics-by-theme/population/population-estimates/small-area-population-estimates-2011-data-zone-based/mid-2020

ONS (2011) 2011 census data on nomis. https://www.nomisweb.co.uk/census/2011 (accessed 5 15 20).

ONS (2018) About the area classifications. https://www.ons.gov.uk/methodology/geography/geographicalproducts/areaclassifications/2011areaclassifications/abouttheareaclassifications (accessed 4 20 20).

ONS (2023a) Income estimates for small areas, England and Wales statistical bulletins. https://www.ons.gov.uk/peoplepopulationandcommunity/personalandhouseholdfinances/incomeandwealth/bulletins/smallareamodelbasedincomeestimates/previousreleases (accessed 11 20 24).

ONS (2023b) UK environmental accounts: 2023. https://www.ons.gov.uk/economy/environmentalaccounts/bulletins/ukenvironmentalaccounts/2023

ONS (2024a). Open geography portal. https://geoportal.statistics.gov.uk/

ONS (2024b) Lower layer super output area population estimates. https://www.ons.gov.uk/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/lowersuperoutputareamidyearpopulationestimatesnationalstatistics (accessed 11 20 24).

ONS (2024c) Living Costs and Food Survey. [data series]. 4th Release. UK Data Service. SN: 2000028, https://doi.org/10.5255/UKDA-Series-2000028

Ordnance Survey (2014) OS OpenData products. https://www.ordnancesurvey.co.uk/business-and-government/products/opendata-products-grid.html (accessed 8 26 14).

Ordnance Survey (2024) Points of interest. https://www.ordnancesurvey.co.uk/products/points-of-interest (accessed 11 20 24).

Ottelin J, Heinonen J, Nässén J, et al. (2019) Household carbon footprint patterns by the degree of urbanisation in Europe. Environmental Research Letters 14: 1. doi: 10.1088/1748-9326/ab443d

Owen A and Barrett J (2020) Reducing inequality resulting from UK low-carbon policy. Climate Policy 20: 1193–1208.

O'Brien O (2024) Dwelling ages and prices. CDRC. https://data.cdrc.ac.uk/dataset/dwelling-ages-and-prices (accessed 11 20 24).

Pandey D, Agrawal M and Pandey JS (2011) Carbon footprint: current methods of estimation. Environmental Monitoring and Assessment 178: 135–160.

Protomaps (2024) PMTiles. https://github.com/protomaps/PMTiles

R Core Team (2025) R: A Language and Environment for Statistical Computing. Vienna: R Foundation for Statistical Computing. Available at: https://www.R-project.org.

Scottish Government (2024a) Scottish remote sensing portal. https://remotesensingdata.gov.scot/data#/list (accessed 11 20 24).

Scottish Government (2024b) Dwellings by council tax band detailed. https://statistics.gov.scot/data/dwellings-by-council-tax-band-detailed-current-geographic-boundaries (accessed 11 20 24).

Steen-Olsen K, Wood R and Hertwich EG (2016) The carbon footprint of Norwegian household consumption 1999–2012. Journal of Industrial Ecology 20: 582–592.

VOA (2024) Council Tax: stock of properties. https://www.gov.uk/government/statistics/council-tax-stock-of-properties-2024 (accessed 11 20 24).

Wadud Z, Adeel M and Anable J (2024) Understanding the large role of long-distance travel in carbon emissions from passenger travel. Nature Energy 9: 1129. Available at: https://doi.org/10.1038/s41560-024-01561-3

Weber CL and Matthews HS (2008) Quantifying the global and distributional aspects of American household carbon footprint. Ecological Economics 66: 379–391.

Welsh Government (2024) LiDAR viewer. https://datamap.gov.wales/maps/lidar-viewer/ (accessed 11 20 24).

Wiedenhofer D, Guan D, Liu Z, et al. (2017) Unequal household carbon footprints in China. Nature Climate Change 7: 75–80.

Wu G, Heppenstall A, Meier P, et al. (2022) A synthetic population dataset for estimating small area health and socio-economic outcomes in Great Britain. Scientific Data 9: 1–11.

---

## Author Biography

**Dr Malcolm Morgan** is a Senior Research Fellow in Transport and Spatial Analysis at the University of Leeds, Institute for Transport Studies. His research focuses on the spatial distribution of energy use and carbon emissions, with a particular focus on transport and housing. He works on understanding both why energy use changes between neighbourhoods and whether this is due to choice or circumstances. His research often emphasizes producing practical tools to aid in policymaking such as, Propensity to Cycle Tool (www.pct.bike), Place-Based Carbon Calculator (www.carbon.place), Cycling Infrastructure Prioritisation Toolkit (www.cyipt.bike). He mostly uses quantitative approaches focusing on open source GIS and big data analysis and visualization.
