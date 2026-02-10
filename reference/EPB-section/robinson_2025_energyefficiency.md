# A spatial typology of energy (in)efficiency in the private rental sector in England and Wales using Energy Performance Certificates

**Authors**: Caitlin Robinson, Ed Atkins, Tom Cantellow, Meixu Chen, Lenka Hasova and Alex Singleton

**Journal**: EPB: Urban Analytics and City Science, 2025, Vol. 52(9) 2316–2325

**DOI**: 10.1177/23998083251377128

**Type**: Open Source Software - K-means clustering classification of energy inefficiency in private rentals

---

## Summary

This paper presents a geodemographic classification of energy inefficiency in England and Wales's private rental sector using Energy Performance Certificate (EPC) data. The classification analyzes **3.9 million private rental properties** (~78.8% of the sector) using k-means clustering to create **9 clusters at Output Area (OA) level** (n=151,890 OA, ~80.4% retained). Variables include EPC ratings, mains gas connection, building age, property type, and wall/heating/hot water efficiency. The resulting typology reveals spatial concentration and fragmentation of inefficiency, ranging from "Dense electrified efficiency" (n=806, smallest cluster, highest rental proportion, urban, electricity-dependent) to "Remote intense inefficiency" (n=919, highest F or below ratings, rural, off-gas, pre-1900 properties). The classification enables targeted policy interventions while highlighting that 5.5% of OA (8,319) fall into the three most inefficient clusters. The work addresses a critical data gap by leveraging newly available property-level energy data to understand socio-spatial inequalities in housing quality. Interactive map and reproducible code available at GitHub.

---

## Key Contributions

1. **First comprehensive spatial classification**: Of energy inefficiency in private rental sector for England and Wales using property-level EPC data
2. **Large-scale analysis**: 3.9 million properties (~78.8% of private rental sector), most comprehensive dataset of its kind
3. **Nine-cluster typology**: Created using k-means clustering (MacQueen variation) at Output Area level (151,890 OA)
4. **Socio-spatial characterization**: Links energy efficiency patterns to demographic profiles (age, household composition, economic activity, deprivation)
5. **Uncertainty mapping**: Explicitly addresses data gaps and incompleteness (HMOs missing, COVID-19 census impacts)
6. **Interactive visualization**: Public-facing web map for exploring clusters (https://ambient-vulnerability.co.uk/maps/)
7. **Open-source reproducibility**: GitHub repository with code and data (https://github.com/CaitHRobinson/private-rental-efficiency)
8. **Policy-relevant insights**: Identifies 5.5% of OA (8,319) in three most inefficient clusters for targeted intervention

---

## Problem Definition

**Challenge**: Understanding socio-spatial distribution of energy efficiency in private rental sector

**Context**:
- 5.0 million people rent privately in England and Wales (20.3%), up from 3.9 million in 2011
- Sector growth driven by 2008 Global Financial Crisis, intergenerational wealth inequalities, austerity
- Private renters among lowest earners, spend higher proportion of income on housing
- Quality and efficiency typically poor (Ambrose 2015)
- Most energy vulnerable communities increasingly rely on private rentals (Petrova and Prodromidou 2019)

**Data gap**:
- Lack of high-resolution energy data prevented detailed understanding (Robinson, 2022; Webborn and Oreszczyn 2019)
- Newly available EPC data appended to Unique Property Reference Numbers enables property-level analysis

**Gap this work fills**: Neighborhood classification of inefficiency using comprehensive EPC data to evidence spatial concentration and fragmentation

---

## Methodology

### Data Source: Energy Performance Certificates (EPC)

**Dataset**:
- **3.9 million private rental properties** (∼78.8% of total sector)
- Certificates issued **September 2012 - September 2022**
- Appended to Unique Property Reference Numbers (UPRNs) - unique identifiers for every address
- Data source: Open Data Communities (ODC, 2022)

**EPC characteristics**:
- Efficiency ratings A-G (A = most efficient)
- Include aggregate scores for efficiency and consumption
- Physical attributes and efficiency characteristics
- Estimated rather than actual energy usage (limitation)
- Multiple assessors can produce different assessments (limitation)
- Widely understood measure underpinning government targets (NEA, 2020)

**Coverage**:
- Most complete for private rentals (new certificate required every decade, unlike owner-occupied)
- Approximately 78% of private rentals with EPC recorded in Census 2021 (n = 5,023,530)
- Geographic unevenness: Greater London 83.9% vs West Midlands 71.4%

### Variables

**11 variables from EPC** (Table 1):

1. **Private rental properties** (neutral)
2. **No mains gas** - without mains gas connection (negative)
3. **Pre-1900** - built prior to 1900 (negative)
4. **D or below** - EPC rating of D, E, F or G (negative)
5. **F or below** - EPC rating of F or G (negative)
6. **Terrace** - one of a row of similar houses joined together (neutral)
7. **House or bungalow** (neutral)
8. **Flat or maisonette** (neutral)
9. **Inefficient hot water** - efficiency rated poor or very poor (negative)
10. **Inefficient walls** - efficiency rated poor or very poor (negative)
11. **Inefficient mains heating** - efficiency rated poor or very poor (negative)

**Variables relate to most intensive energy services**: space and water heating

### Spatial Aggregation

**Output Areas (OA)** (ONS, 2022b):
- n = 188,871 total OA
- **40-250 households** per OA (as demographically close as possible to street-level)
- Reflects diverse built environment in UK (Arribas-Bel and Fleischmann 2022)

**Processing**:
- Remove OA with less than five properties
- Retain **151,890 OA (∼80.4%)**
- Compute proportions of privately rented properties in OA with various efficiency attributes
- Compare EPC data proportionally to 2021 Census data for privately rented households
- Standardize variables using **z-scores**

### K-means Clustering

**Algorithm**:
- **MacQueen variation** (MacQueen 1967; Singleton and Longley 2009)
- Recalculates cluster centroids each time it iterates over a datapoint, until convergence
- Commonly applied for geodemographics (Chen et al., 2023)

**Process**:
- Iteratively relocates data points between predefined set of k clusters
- Each observation belongs to cluster with nearest mean
- High degree of similarity within clusters, low degree between them (Morrisette and Chartier, 2013)

**Cluster selection**:
- Diagnostics: between-cluster and within-cluster sum of squares statistic
- **Nine-cluster solution** chosen, balancing detail with usability

---

## Nine Clusters

**Range**: Largest cluster 89,188 OA, smallest 806 OA

### High Efficiency Clusters (Low Rental Proportion)

**1. Sparse energy efficiency (n = 89,188)**
- Largest cluster
- High average efficiency
- Low proportion of private rentals
- Highest rate of families and children

**2. Energy efficient suburbs (n = 25,240)**
- High average efficiency
- Low proportion of private rentals
- Highest rate of families and children

**3. Diverse efficient pockets (n = 13,393)**
- High average efficiency
- Low proportion of private rentals
- Most economically inactive population

### Urban Electrified Clusters

**4. Dense electrified efficiency (n = 806)**
- **Smallest cluster type**
- **Highest proportion of private rentals**
- Flats typically rely on electricity rather than gas (more expensive energy consumption)
- Concentrate in large cities, especially redeveloped former industrial areas
- Many rentals rated D or below despite relative efficiency
- Younger, full-time professionals or students
- Location: Urban centers, former industrial redevelopments

**5. Electrified terraces and flats (n = 4,223)**
- Similarly reliant on electricity
- High proportion of private rentals
- Spread across urban areas in fragmented way
- Location: Urban areas, dispersed

### Peripheral Inefficient Clusters

**6. Peripheral inefficient houses (n = 4,888)**
- Relatively high number of private rentals
- Efficiency typically low
- Access to mains gas is high
- Relatively deprived population
- Largest household sizes
- Location: Outskirts of cities and towns, similar-era construction

**7. Peripheral inefficient flats and terraces (n = 10,721)**
- Relatively low number of moderately inefficient rentals
- Access to gas network
- Properties typically houses or terraces with poor quality walls
- Location: Outskirts of cities and towns

### Most Inefficient Clusters

**8. Older intensely inefficient pockets (n = 2,512)**
- Least efficient urban cluster type
- High number of private rentals rated D or below
- Often houses or terraces built pre-1900
- Location: Cities and coastal communities

**9. Remote intense inefficiency (n = 919)**
- **Highest concentrations of properties rated F or below**
- Often off-gas houses built prior to 1900
- Highest proportion of rentals compared to other relatively rural clusters
- Most economically inactive population
- Location: Rural areas, off-gas

---

## Socio-Demographic Profile

**Census 2021 insights** (Figure 4):

- **Tenure**: Dense electrified efficiency has highest rate of private rental households
- **Age**: Dense electrified efficiency has younger population (20-39); Sparse/Energy efficient suburbs have more children
- **Household composition**: Peripheral inefficient houses have largest household sizes (5-7 persons)
- **Economic activity**: Remote intense inefficiency and Diverse efficient pockets have most economically inactive population
- **Deprivation**: Peripheral inefficient houses have relatively deprived population (high deprivation points)
- **Employment**: Dense electrified efficiency has full-time professionals or students

---

## Data Gaps and Uncertainty

### Missing Properties: Houses of Multiple Occupancy (HMOs)

**Problem**:
- Estimated **497,000 HMOs** in England and Wales as of 2018 (House of Commons Library 2019)
- HMOs have 5+ occupants who do not form single household
- **Not required to have EPC** but appear in Census 2021
- Typically less expensive than other private rentals, more likely to house vulnerable tenants

**Impact on classification**:
- Cannot account for sub-sector with often acute efficiency challenges (Cauvain and Bouzarovski 2016)
- Explains higher number of private rentals in Census vs EPC data

### COVID-19 Census Effects

- Census 2021 taken during pandemic
- Impacted data quality for renters who temporarily relocated away from city centres (Rowe et al., 2022)

### Geographic Unevenness

**Regional coverage variation**:
- Greater London: 83.9% coverage
- West Midlands: 71.4% coverage

**OA-level differences**:
- Greatest difference: **−355 to +813** properties between EPC and Census counts
- Red shading in Figure 5 shows areas with higher number of private rentals in EPC compared to Census

---

## Data Availability

### Repository
- **GitHub**: https://github.com/CaitHRobinson/private-rental-efficiency
- **Contents**: Code and underlying data to replicate analysis

### Interactive Visualization
- **Web map**: https://ambient-vulnerability.co.uk/maps/
- Visualize and download classification
- Full cluster descriptions and pen portraits available

---

## Policy Applications

### Spatial Targeting

**5.5% of OA (8,319 of 151,890) in three most inefficient clusters**:
1. Remote intense inefficiency
2. Peripheral inefficient houses
3. Older intensely inefficient pockets

**Recommendation**: These areas might be focus for targeted policies by local and national government in context of limited public resources (Moore 2017)

### Diverse Challenges

Classification contradicts "one-size-fits-all" approach to efficiency policy:

- **Urban young renters**: Lack access to relatively affordable but carbon-intensive gas grid (Dense electrified efficiency)
- **Older properties**: Require deep and expensive retrofit (Older inefficient pockets, Remote intense inefficiency)
- **Peripheral suburbs**: Gas-connected but inefficient (Peripheral inefficient houses/flats)
- **Rural off-gas**: Highest F or below ratings, pre-1900 construction (Remote intense inefficiency)

### Policy Tension

**Place-based retrofit** (Reames 2016):
- Targeted interventions for most inefficient clusters
- Risk: Efficiency measures may incentivize landlords to increase rents, deepening precarity for tenants

**Universal approach** (Bouzarovski and Simcock, 2017):
- Required to tackle systematic inefficiency in private rental sector
- Addresses root causes beyond spatial targeting

---

## Validation and Limitations

### Strengths

1. **Most comprehensive dataset**: 3.9 million properties (~78.8% of sector), property-level detail
2. **Spatial granularity**: Output Area level (40-250 households), close to street-level
3. **Socio-spatial linkage**: Combines energy efficiency with demographic profiles from Census 2021
4. **Transparency on uncertainty**: Explicitly maps data gaps (Figure 5), discusses HMO missingness
5. **Open-source reproducibility**: GitHub repository with code and data
6. **Policy-relevant**: Identifies spatial targets for intervention, acknowledges policy tensions
7. **Interactive visualization**: Public-facing web map for accessibility

### Limitations

**1. Data quality and coverage**:
- EPC estimated rather than actual energy usage
- Multiple assessors can produce different assessments (EAC, 2021; Jenkins et al., 2017)
- ~78.8% coverage of sector (missingness issues)
- HMOs not included (497,000 estimated properties)
- COVID-19 impacts on Census 2021 data

**2. Temporal snapshot**:
- September 2012 - September 2022 (10-year period)
- Does not capture recent changes or current state
- Certificates required every decade for rentals

**3. Geographic unevenness**:
- Coverage varies regionally (Greater London 83.9% vs West Midlands 71.4%)
- OA-level differences range from −355 to +813 properties

**4. Classification method**:
- K-means assumes spherical clusters (may not reflect complex spatial patterns)
- Nine-cluster solution balances detail vs usability (arbitrary choice)
- No cluster achieves "best practice" (limitation for benchmarking)

**5. Policy application complexity**:
- Efficiency improvements may increase rents (gentrification risk)
- Place-based targeting may miss universal issues
- Classification shows what exists, not what should be done

---

## Future Directions

### Methodological Extensions

1. **Temporal updates**: Refresh classification as new EPC data becomes available (every 1-2 years)
2. **HMO integration**: If future policy requires EPCs for HMOs, incorporate this vulnerable sub-sector
3. **Alternative clustering**: Test hierarchical clustering, DBSCAN, or other algorithms for comparison
4. **Machine learning**: Explore classification trees to understand variable importance
5. **Validation**: Compare against actual energy consumption data where available

### Data Integration

1. **Energy consumption**: Link to smart meter data for actual usage validation
2. **Health outcomes**: Explore relationships with cold-related illness, respiratory conditions
3. **Retrofit tracking**: Monitor changes in EPC ratings over time, evaluate policy impacts
4. **Rental prices**: Analyze relationship between efficiency and affordability

### Policy Research

1. **Intervention evaluation**: Track which clusters receive targeted policies, assess outcomes
2. **Gentrification monitoring**: Study whether efficiency improvements lead to rent increases
3. **Equity analysis**: Compare vulnerability (Rawlsian framework) to efficiency distribution
4. **Cost-benefit analysis**: Model retrofit costs vs energy savings by cluster type

### Geographic Extension

1. **Scotland and Northern Ireland**: Extend classification to entire UK (data permitting)
2. **Other tenure types**: Apply method to social housing, owner-occupied sectors
3. **International comparison**: Adapt framework to other countries with EPC-equivalent data (e.g., EU countries)

---

## Relevance to Our Project

### Methodological Parallels

1. **Geodemographic classification**: K-means clustering to create spatial typology (similar to accessibility classifications)
2. **Open-source reproducibility**: GitHub repository with code and data (model for our workflow documentation)
3. **Output Area aggregation**: Small-area geography (40-250 households) similar to our hexagon grid approach
4. **Uncertainty mapping**: Explicitly addresses data gaps and incompleteness (parallel to our GTFS quality issues)
5. **Interactive visualization**: Public-facing web map (similar to our potential GitHub Pages deployment)

### Key Differences

- **Domain**: Energy efficiency in housing; we measure accessibility to services
- **Temporal scope**: 10-year period (2012-2022) collapsed into single classification; we do year-by-year longitudinal analysis
- **Data source**: Energy Performance Certificates; we use GTFS and R5R routing
- **Primary method**: K-means clustering; we calculate cumulative opportunities
- **Policy focus**: Targeted retrofit interventions; we measure transport accessibility changes

### Lessons for Our Manuscript

**Data gap framing**:
- "Detailed understanding... has been lacking, due in part to a lack of high-resolution energy data"
- We can use: "Longitudinal multimodal accessibility measurement has been constrained by lack of documented workflows for GTFS processing and temporal comparison"

**Limitation transparency**:
- Explicit "Mapping Uncertainty" section with Figure 5 showing data gaps
- Acknowledges HMO missingness (~497,000 properties), COVID-19 census impacts
- States coverage honestly: "~78.8% of total sector"
- We can adopt similar honesty: "GTFS quality varies across regions and years; 2024 data issues in specific cities documented in Appendix X"

**Classification presentation**:
- Radial charts (Figure 2) show cluster centers for all variables (z-scores)
- Multi-panel city maps (Figure 3) show spatial distribution across 21 major cities
- Could inspire our multi-panel comparisons: 2021 vs 2024, car vs transit, different cities

**Socio-demographic linkage**:
- Figure 4 shows boxplots of demographic variables by cluster (tenure, household composition, age, deprivation)
- Links energy efficiency patterns to social vulnerability
- We could link accessibility patterns to demographic profiles (elderly population, low-income households, etc.)

**Policy application section**:
- Separate "Applying the classification in policy and practice" section
- Identifies 5.5% of OA in most inefficient clusters (specific, actionable number)
- Acknowledges tension: "efficiency measures may also incentivise landlords to increase rents"
- We can use: "Accessibility improvements may benefit some populations while displacing others" (equity framing)

**Cluster naming strategy**:
- Descriptive names capturing key characteristics: "Dense electrified efficiency", "Remote intense inefficiency"
- Each name conveys density + energy source + efficiency level
- We could name accessibility clusters similarly: "High-choice urban core", "Car-dependent suburban fringe", etc.

**Range statistics**:
- "Largest cluster 89,188 OA, smallest 806 OA" (shows heterogeneity)
- We can report: "Accessibility ranges from X min (best-served areas) to Y min (underserved periphery)"

**Interactive map as boundary object**:
- Web map enables stakeholder exploration without technical expertise
- GitHub repository for researchers/practitioners who want to replicate or extend
- We can provide both: Interactive GitHub Pages book + downloadable workflow scripts

**Data product framing**:
- "We present a data product that addresses this gap"
- Not "we developed a novel algorithm" but "we created useful classification from newly available data"
- We can use: "We present a documented workflow that enables longitudinal multimodal accessibility measurement"

**Repository structure**:
- GitHub repo with code and underlying data
- Interactive map separate from code repository (ambient-vulnerability.co.uk domain)
- We can structure: GitHub repo (workflow scripts) + GitHub Pages (Quarto book documentation) + Zenodo (archived dataset)

---

## Notes

This paper is relevant because:

1. **Open Data Product**: Classification of 3.9M properties using newly available EPC data (similar to our workflow leveraging GTFS data)
2. **Spatial typology**: K-means clustering to create 9-cluster classification (could inform accessibility classifications)
3. **Limitation transparency**: Explicit "Mapping Uncertainty" section, honest about data gaps (model for our GTFS quality discussion)
4. **Policy targeting**: Identifies 5.5% of OA in most inefficient clusters for intervention (actionable, specific)
5. **Socio-spatial analysis**: Links energy efficiency to demographic profiles (could inspire linking accessibility to social vulnerability)

The **Output Area aggregation** (40-250 households) is similar scale to our hexagon grid approach. The **radial charts** (Figure 2) showing cluster centers could inspire visualization of accessibility cluster characteristics.

The **interactive web map** (ambient-vulnerability.co.uk) separate from GitHub repository shows effective strategy for public engagement + research reproducibility (we can adopt similar dual-platform approach).

The **policy tension acknowledgment** ("efficiency measures may incentivize landlords to increase rents") shows honest engagement with unintended consequences (we should acknowledge accessibility improvements may accelerate gentrification or displacement).

The **cluster size heterogeneity** (largest 89,188 OA, smallest 806 OA) demonstrates that spatial patterns are not uniform—some conditions are widespread, others concentrated (relevant for understanding accessibility inequality distributions).

The **data gap discussion** (HMOs, COVID-19 census) provides model for how to acknowledge incompleteness without undermining contribution (we can adopt for GTFS quality issues, 2024 data problems).
