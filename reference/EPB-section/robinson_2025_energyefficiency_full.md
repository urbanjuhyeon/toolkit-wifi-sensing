# A spatial typology of energy (in)efficiency in the private rental sector in England and Wales using Energy Performance Certificates

**Authors**: Caitlin Robinson, Ed Atkins, Tom Cantellow, Meixu Chen, Lenka Hasova and Alex Singleton

**Journal**: EPB: Urban Analytics and City Science, 2025, Vol. 52(9) 2316–2325

**DOI**: 10.1177/23998083251377128

**Type**: Open Source Software - K-means clustering classification of energy inefficiency in private rentals

---

## Abstract

Like many countries globally, the private rental sector in England and Wales contains some of the lowest quality and energy inefficient properties, despite being home to some of the most vulnerable households. We present a new data product that classifies small areas based on the energy (in)efficiency characteristics of private rental properties. Newly available Energy Performance Certificate (EPC) data enables us to analyse detailed energy and housing characteristics for 3.9 million private rentals (∼78.8% of total sector), the most comprehensive dataset of its kind, using k-means clustering. Demographic datasets allow us to explore wider socio-spatial inequalities, and uncertainties associated with granular – but at-times incomplete – EPC data. The classification can be used to evidence how inefficiency is spatially concentrated and fragmented, with a diverse range of energy and housing conditions shaping the everyday lives of tenants.

---

## Keywords

energy efficiency, private renting, housing inequality, Energy Performance Certificates, k-means clustering

---

## Introduction

Energy efficiency is an integral part of a person's right to a high-quality ambient environment – conditions that allow them to be comfortable, well, and to thrive. It shapes how much energy must be consumed to adequately heat or cool the home (Kerr et al., 2017; Robinson and Williams 2024). Efficiency is a mechanism for tackling some of society's most pressing challenges, including climate mitigation and adaptation, inequality, and rising energy and living costs (Atkins 2023; Lewis et al., 2020); however, access to good quality housing is highly uneven.

Economic marginalisation, energy insecurity, and housing access are entangled. Without careful thought, policy or technical change can lead to new – or consolidate already-entrenched – patterns of inequity. Housing and energy inequalities are not uniform – variegated between populations and geographies (Carley et al., 2018; Middlemiss 2022) – and the most precarious in society often rely on the lowest-quality housing (Sunikka-Blank and Galvin, 2021).

These dynamics are especially apparent in the private rental sector (Sharma and Samarin, 2022; Robinson et al., 2025). In England and Wales, 5.0 million people rent privately (20.3%), up from 3.9 million in 2011 (ONS 2022a). Since the 2008 Global Financial Crisis, the sector has grown rapidly (Fields and Uffer 2016). Driven by intergenerational and wealth inequalities, and austerity, the private rental sector is increasingly relied upon by some of the most energy vulnerable communities (Ambrose 2015; Petrova and Prodromidou 2019). Private renters are also amongst the lowest earners on average, and spend a higher proportion of income on housing (DLUHC 2023), but quality and efficiency are typically poor (Ambrose 2015).

Detailed understanding of the socio-spatial distribution of efficiency across the private rental sector has been lacking, due in part to a lack of high-resolution energy data (Robinson, 2022; Webborn and Oreszczyn 2019). In this paper we present a data product that addresses this gap, specifically a neighbourhood classification of inefficiency in the private rental sector in England and Wales, derived from analysis of new property-scale Energy Performance Certificates (EPCs). The new detailed evidence from the classification could be used in policy and practice to promote safer healthier living environments whilst meeting climate change targets.

---

## Data and Methods

### Data

EPC data appended to Unique Property Reference Numbers – unique identifiers for every address – offers detailed insights into housing characteristics previously impossible to achieve using open-source data (Buyuklieva et al., 2024; Cantellow 2023; Ward et al., 2024). To derive our classification, data is compiled for **3.9 million private rental properties**, selecting certificates issued between **September 2012 and September 2022** (ODC, 2022). The dataset accounts for **∼78.8% of properties in the sector**, due to missingness explained further in Mapping Uncertainty section. Data is most complete for private rentals because a new certificate must be obtained every decade, unlike owner-occupied properties. Important critiques have been levelled at EPC data. They offer estimated rather than actual energy usage, whilst multiple assessors can evaluate the same property and produce different assessments (EAC, 2021; Jenkins et al., 2017; Pasichnyi et al., 2019). However, the certificates remain a widely understood and detailed measure, underpinning government targets (NEA, 2020).

EPC include aggregate scores for efficiency and consumption, as well as physical attributes and efficiency characteristics. Efficiency ratings are estimated between A-G, with A being most efficient (Table 1). Our variables relate to the most intensive energy services – space and water heating.

**Table 1. Variables selected from EPC data**

| Variable | Description | Relationship with efficiency |
|----------|-------------|------------------------------|
| Private rental properties | Private rental properties | Neutral |
| No mains gas | Without mains gas connection | Negative |
| Pre-1900 | Built prior to 1900 | Negative |
| D or below | EPC rating of D, E, F or G | Negative |
| F or below | EPC rating of F or G | Negative |
| Terrace | One of a row of similar houses joined together | Neutral |
| House or bungalow | - | Neutral |
| Flat or maisonette | - | Neutral |
| Inefficient hot water | Efficiency of hot water rated poor or very poor | Negative |
| Inefficient walls | Efficiency of walls rated poor or very poor | Negative |
| Inefficient mains heating | Efficiency of mains heating rated poor or very poor | Negative |

*Note: Variables are provided as a proportion of total private rental properties in Census (Office for National Statistics, 2017) in each OA*

### Spatial Aggregation

EPC property data is aggregated as counts to **Output Areas (OA)** (n = 188,871) to help overcome gaps in the dataset (ONS, 2022b.). OA contain between **40 and 250 households** – as demographically close as possible to street-level – reflecting the diverse built environment in the UK (Arribas-Bel and Fleischmann 2022). OA with less than five properties are removed, retaining **151,890 OA (∼80.4%)**. Proportions of privately rented properties in OA with various efficiency attributes are computed, comparing the EPC data proportionally to data for privately rented households from the 2021 Census. Variables are standardised using z-scores (Figure 1).

### K-means Clustering

K-means clustering is used to derive the classification. The approach is commonly applied when developing geodemographics, more recently to understand domestic energy inequalities (Chen et al., 2023). K-means iteratively relocates data points between a predefined set of k clusters. Each observation belongs to the cluster with the nearest mean. Clusters have a high degree of similarity within, and low degree of similarity between them (Morrisette and Chartier, 2013). We use a **MacQueen variation** that recalculates cluster centroids each time it iterates over a datapoint, until they converge (MacQueen 1967; Singleton and Longley 2009). Several diagnostics evaluate the final number of clusters: a between-cluster and within-cluster sum of squares statistic. We choose a **nine-cluster solution**, balancing detail with usability.

---

## Classification of Energy Inefficiency in the Private Rental Sector

The new classification of energy inefficiency in the private rental sector contains **nine clusters**, which are now described in turn based on their density, geography, and intensity of inefficiency. Full cluster descriptions and pen portraits are available at [https://ambient-vulnerability.co.uk/maps/clusters-of-energy-inefficiency-in-the-private-rental-sector-in-england-and-wales/]

Spatially, private rentals play a dominant role in cities, especially larger urban conurbations, as well as relatively remote rural areas where rentals are often linked to employment. The sector is highly localised, reflected in the range of cluster sizes – the largest contains 89,188 OA, and the smallest 806 OA. Three clusters have high average efficiency – Sparse energy efficiency (n = 89188), Energy efficient suburbs (n = 25240), and Diverse efficient pockets (n = 13393) – but the proportion of private rentals is low (Figure 2).

### Nine Clusters

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

**4. Dense electrified efficiency (n = 806)**
- **Smallest cluster type**
- **Highest proportion of private rentals**
- Flats typically rely on electricity rather than gas, making energy consumption more expensive (Robinson et al., 2019)
- Concentrate in large cities, especially redeveloped former industrial areas (Lee, 2022) (Figure 3)
- Although relatively efficient compared to other primarily urban cluster types, many rentals are rated D or below
- Consists of higher proportion of private rental households, with typically younger, full-time professionals or students

**5. Electrified terraces and flats (n = 4,223)**
- Similarly reliant on electricity
- High proportion of private rentals
- Spread across urban areas in a fragmented way

**6. Peripheral inefficient houses (n = 4,888)**
- Relatively high number of private rentals
- Efficiency typically low
- Access to the mains gas is high
- Concentrate on the outskirts of cities and towns, where many properties were built in a similar era
- Relatively deprived population and largest household sizes

**7. Peripheral inefficient flats and terraces (n = 10,721)**
- Relatively low number of moderately inefficient rentals with access to the gas network
- Properties typically houses or terraces with poor quality walls
- Concentrate on the outskirts of cities and towns

**8. Older intensely inefficient pockets (n = 2,512)**
- Least efficient urban cluster type
- Concentrated in cities and coastal communities (Atkins et al., 2025)
- OA typically have a high number of private rentals rated D or below
- Often houses or terraces built pre-1900

**9. Remote intense inefficiency (n = 919)**
- **Highest concentrations of properties rated F or below**
- Often off-gas houses built prior to 1900
- Highest proportion of rentals compared to other relatively rural clusters
- Most economically inactive population

### Socio-Demographic Profile

The Census 2021 provides insights into the socio-demographic makeup of clusters (Figure 4):

- **Dense electrified efficiency**: Higher proportion of private rental households, typically younger, full-time professionals or students
- **Remote intense inefficiency** and **Diverse efficient pockets**: Most economically inactive population
- **Sparse energy efficiency** and **Energy efficient suburbs**: Highest rate of families and children
- **Peripheral inefficient houses**: Relatively deprived population and largest household sizes

---

## Mapping Uncertainty

Data gaps, or 'deserts', mean certain populations or places are less well represented (D'Ignazio and Klein 2020), but a lack of information can also offer useful insights (Franklin 2022). Approximately **78% of private rentals with an EPC are recorded in the Census** (n = 5,023,530), but coverage is geographically uneven (Figure 5). Regionally, **Greater London has the highest (83.9%)** compared to the **West Midlands (71.4%)**. For individual OA, the greatest difference in count is **−355 and +813**.

A likely explanation for the higher number of private rentals in the Census is a lack of data for **Houses of Multiple Occupancy (HMOs)**, which are not required to have an EPC but appear in the Census (Atkins et al., 2025). Our classification is not able to account for this sub-sector that often has acute efficiency challenges (Cauvain and Bouzarovski 2016). Additionally, the Census was taken during COVID-19, impacting data quality for renters that temporarily relocated away from city centres (Rowe et al., 2022).

**Note on HMOs**: In England and Wales, there are an estimated 497,000 HMOs as of 2018 (House of Commons Library 2019). HMOs have five or more occupants who do not form a single household. HMOs are typically less expensive than other private rentals and are more likely to house vulnerable tenants.

---

## Applying the Classification in Policy and Practice

The data product can be used to illustrate the diverse range of housing conditions that shape the lives of private rental tenants in different parts of England and Wales. It contradicts the often arbitrary, 'one-size-fits-all' use of efficiency in policy and practice. Instead, swathes of cities are characterised by dense, inefficient rentals, whilst some remote rural communities also struggle to access high-quality housing in the sector. Challenges range from young private renters who lack access to the relatively affordable but carbon-intensive gas grid, to older privately rented properties requiring deep and expensive retrofit. This new understanding of inefficiency in the private rental sector could be beneficial to support policy and practice across sectors including housing, health, and climate change.

The classification does not identify a cluster achieving best practice. Yet **5.5% of OA (8,319 of 151,890 OA) are part of the three most inefficient clusters** (Remote intense inefficiency, Peripheral inefficient houses, and Older intensely inefficient pockets). In the context of limited public resources these areas might be a focus for targeted policies by local and national government (Moore 2017). However, efficiency measures may also incentivise landlords to increase rents, deepening precarity for tenants. In addition to place-based retrofit (Reames 2016), a universal approach is required to tackle systematic inefficiency in the private rental sector (Bouzarovski and Simcock, 2017).

---

## Data Availability Statement

To visualise and download the private rental energy inefficiency classification, or to replicate the analysis using code and underlying data, please visit: **https://github.com/CaitHRobinson/private-rental-efficiency**

Interactive map: **https://ambient-vulnerability.co.uk/maps/**

---

## Funding

The author(s) disclosed receipt of the following financial support for the research, authorship, and/or publication of this article: This work was supported by the Research England, UK Research and Innovation; MR/V021672/2.

---

## Declaration of Conflicting Interests

The author(s) declared no potential conflicts of interest with respect to the research, authorship, and/or publication of this article.

---

## ORCID iDs

- Caitlin Robinson: https://orcid.org/0000-0001-7653-359X
- Lenka Hasova: https://orcid.org/0000-0001-5888-0838
- Alex Singleton: https://orcid.org/0000-0002-2338-2334

---

## References

Ambrose AR (2015) Improving energy efficiency in private rented housing: why don't landlords act? Indoor and Built Environment 24(7): 913–924.

Arribas-Bel D and Fleischmann M (2022) Understanding (urban) spaces through form and function. Habitat International 128: 102641.

Atkins E (2023) A Just Energy Transition: Getting Decarbonisation Right in a Time of Crisis. Policy Press.

Atkins E, Robinson C and Cantellow T (2025) The salt fringe as an energy periphery: energy efficiency in the private rental sector of seaside towns in England and Wales. Geo: Geography and Environment 12(1): 70008.

Bouzarovski S and Simcock N (2017) Spatializing energy justice. Energy Policy 107: 640–648.

Buyuklieva B, Oleron-Evans T, Bailey N, et al. (2024) Variations in domestic energy efficiency by property, neighbourhood and local authority type: where are the largest challenges for the net-zero transition of the UK's residential stock? Frontiers in Sustainability 5: 1329034.

Cantellow T (2023) Retrofitting Rentals: exploring the energy efficiency of residential dwellings in Bristol. Policy Bristol. https://www.bristol.ac.uk/policybristol/policy-engagement-projects/retrofitting-rentals-bristol/

Carley S, Evans TP, Graff M, et al. (2018) A framework for evaluating geographic disparities in energy transition vulnerability. Nature Energy 3(8): 621–627.

Cauvain J and Bouzarovski S (2016) Energy vulnerability in multiple occupancy housing: a problem that policy forgot. People Place and Policy Online 10(1): 88–106.

Chen M, Singleton A and Robinson C (2023) Exploring energy deprivation across small areas in England and Wales (short paper). In: 12th International Conference on Geographic Information Science (GIScience 2023). Schloss-Dagstuhl-Leibniz Zentrum für Informatik.

D'ignazio C and Klein LF (2020) Data Feminism. MIT press.

Department for Levelling Up, Housing & Communities (DLUHC) (2023) English Housing Survey 2021 to 2022: private rented sector. https://www.gov.uk/government/statistics/english-housing-survey-2021-to-2022-private-rented-sector/english-housing-survey-2021-to-2022-private-rented-sector#profile-of-private-renters

Environmental Audit Committee (EAC) (2021) Net Zero impossible unless urgent action taken on energy efficiency this decade. https://committees.parliament.uk/committee/62/environmental-audit-committee/news/152918/net-zero-impossible-unless-urgent-action-taken-on-energy-efficiency-this-decade/

Fields D and Uffer S (2016) The financialisation of rental housing: a comparative analysis of New York City and Berlin. Urban Studies 53(7): 1486–1502.

Franklin R (2022) Quantitative methods I: reckoning with uncertainty. Progress in Human Geography 46(2): 689–697.

House of Commons Library (2019) Houses of multiple occupation (HMOs) England and Wales. https://commonslibrary.parliament.uk/research-briefings/sn00708/

Jenkins D, Simpson S and Peacock A (2017) Investigating the consistency and quality of EPC ratings and assessments. Energy 138: 480–489.

Kerr N, Gouldson A and Barrett J (2017) The rationale for energy efficiency policy: Assessing the recognition of the multiple benefits of energy efficiency retrofit policy. Energy Policy 106: 212–221.

Lee C (2022) The 'globalhood' as an urban district of the 21st-century city: the case of the St Vincent's Quarter, Sheffield. Geography 107(2): 97–106.

Lewis J, Hernandez D and Geronimus AT (2020) Energy efficiency as energy justice: addressing racial inequities through investments in people and places. Energy efficiency 13: 419–432.

MacQueen J (1967) Some methods for classification and analysis of multivariate observations. Proceedings of the fifth Berkeley symposium on mathematical statistics and probability 1(14): 281–297.

Middlemiss L (2022) Who is vulnerable to energy poverty in the Global North, and what is their experience? WIREs Energy and Environment 11(6): e455.

Moore T (2017) The convergence, divergence and changing geography of regulation in the UK's private rented sector. International Journal of Housing Policy 17(3): 444–456.

Morissette L and Chartier S (2013) The k-means clustering technique: General considerations and implementation in Mathematica. Tutorials in Quantitative Methods for Psychology 9(1): 15–24.

National Energy Action (NEA) (2020) Response to improving the energy performance of privately rented homes in England and Wales. National Energy Action (NEA).

Office for National Statistics (ONS) (2017) Major towns and cities (December 2015) Boundaries EW BCG. https://geoportal.statistics.gov.uk/

Office for National Statistics (ONS) (2022a) Housing, England and Wales: census 2021. https://www.ons.gov.uk/peoplepopulationandcommunity/housing/bulletins/housingenglandandwales/census2021

Office for National Statistics (ONS) (2022b.) Census 2021. https://www.ons.gov.uk/census

Open Data Communities (ODC) (2022) Energy performance of Buildings data: England and Wales. https://epc.opendatacommunities.org/

Pasichnyi O, Wallin J, Levihn F, et al. (2019) Energy performance certificates—new opportunities for data-enabled urban energy policy instruments? Energy Policy 127: 486–499.

Petrova S and Prodromidou A (2019) Everyday politics of austerity: Infrastructure and vulnerability in times of crisis. Environment and Planning C: Politics and Space 37(8): 1380–1399.

Reames TG (2016) Targeting energy justice: Exploring spatial, racial/ethnic and socioeconomic disparities in urban residential heating energy efficiency. Energy Policy 97: 549–558.

Robinson C (2022) Spatial approaches to energy poverty. In: Handbook of Spatial Analysis in the Social Sciences. Edward Elgar Publishing, 434–450.

Robinson C and Williams J (2024) Ambient vulnerability. Global Environmental Change 84: 102801.

Robinson C, Lindley S and Bouzarovski S (2019) The spatially varying components of vulnerability to energy poverty. Annals of the Association of American Geographers 109(4): 1188–1207.

Robinson C, Hasova L and Zhang L (2025) Uneven ambient futures: intersecting heat and housing trajectories in England and Wales. Transactions of the Institute of British Geographers 30: e12737.

Rowe F, Robinson C and Patias N (2022) Sensing global changes in local patterns of energy consumption in cities during the early stages of the COVID-19 pandemic. Cities 129: 103808.

Sharma M and Samarin M (2022) Rental tenure and rent burden: progress in interdisciplinary scholarship and pathways for geographical research. Geojournal 87(4): 3403–3421.

Singleton AD and Longley PA (2009) Creating open source geodemographics: Refining a national classification of census output areas for applications in higher education. Papers in Regional Science 88(3): 643–666.

Sunikka-Blank M and Galvin R (2021) Single parents in cold homes in Europe: how intersecting personal and national characteristics drive up the numbers of these vulnerable households. Energy Policy 150: 112134.

Ward C, Robinson C, Singleton A, et al. (2024) Spatial-temporal dynamics of gas consumption in England and Wales: assessing the residential sector using sequence analysis. Applied Spatial Analysis and Policy 17: 1–28.

Webborn E and Oreszczyn T (2019) Champion the energy data revolution. Nature Energy 4(8): 624–626.

---

## Author Biographies

**Caitlin Robinson** is a Senior Academic Fellow and Proleptic Lecturer at the University of Bristol. As a quantitative human geographer, Caitlin's research investigates the causes and consequences of different types of spatial inequality, with a particular interest in energy, infrastructure and climate.

**Ed Atkins** is a Reader in Geography at University of Bristol. Ed's research explores the topic of 'just transition', or how sustainability and/or decarbonisation policies can be made fairer and more inclusive.

**Tom Cantellow** is a researcher at the University of Bristol. Tom's research uses spatial quantitative methods to study a range of political and economic phenomena, such as elections, local economies, inequality, values, and political violence.

**Meixu Chen** is an Associate Professor (Specially Appointed) at East China University of Science and Technology. May's research uses new forms of data to represent and understand population characteristics and dynamics in neighbourhoods to assist urban policymaking.

**Lenka Hasova** is a Postdoctoral Research Associate at the University of Bristol. Lenka research focuses on geographic data science, in particular the application of spatial interaction models as networks.

**Alex Singleton** is a Professor of Geographic Information Science at the University of Liverpool. Alex's research investigates urban systems through Geographic Data Science, using open source data and tools.
