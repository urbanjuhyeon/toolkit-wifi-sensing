# Ha et al. (2025) - Spnaf: An R package for analyzing and mapping the hotspots of flow datasets

## Full Text Transcription

---

**Urban Data/Code**

EPB: Urban Analytics and City Science
2025, Vol. 52(2) 509–517
© The Author(s) 2024

Article reuse guidelines: sagepub.com/journals-permissions
DOI: 10.1177/23998083241276021
journals.sagepub.com/home/epb

---

# Spnaf: An R package for analyzing and mapping the hotspots of flow datasets

**Hui Jeong Ha**
Western University, Canada

**Youngbin Lee**
Seoul National University, South Korea

**Kyusik Kim**
Florida State University, USA

**Sohyun Park**
George Mason University Korea, South Korea

**Jinhyung Lee**
Western University, Canada

## Abstract

This paper introduces {spnaf} (spatial network autocorrelation for flows), an R package designed for the hotspot analysis of flow (e.g., human mobility, transportation, and animal movement) datasets based on Berglund and Karlström's G index. We demonstrate the utility of the {spnaf} package through two example analyses by data forms: 1) bike-sharing trip patterns in Columbus, Ohio, USA, using polygon data, and 2) U.S. airports' passenger travel patterns, using point data. The {spnaf} is available for download from the Comprehensive R Archive Network (CRAN), which contains a vignette and sample data/code for immediate use. This package addresses limitations in existing spatial analysis packages and emphasizes its efficiency in detecting flow hotspots. It is highly applicable in various urban and geographic data science applications. {spnaf} is still in its early stages and we hope that interested readers can contribute to the development and enhancement of the package.

**Keywords**
Spatial autocorrelation, network autocorrelation, flow, hotspot, R, human mobility

---

## Introduction

This paper introduces an R package for identifying flow hotspots, applicable to human mobility, animal movement, and transportation flows. Despite the benefits of the hotspot analysis of flows as a part of Exploratory Spatial Data Analysis (ESDA), there is a lack of open-source codes or user-friendly programs for facilitating that process. For instance, despite a variety of ESDA tools in R such as {spdep} (Bivand et el., 2017), {geostan} (Donegan and Morris, 2022), and {rgeoda} (Anselin et al., 2021) for other kinds of spatial datasets (e.g., point, lattice), progress in developing open-source programs for reproducible flow data analysis and visualization has lagged. In response, we present {spnaf} (spatial network autocorrelation for flows) (https://cran.r-project.org/web/packages/spnaf/index.html). {spnaf} is an open-source R package that enables users to conduct hotspot analysis of flow by detecting statistically significant flow clusters based on Berglund and Karlström's Gij* index (1999). We acknowledge that {spnaf} is still in its early stages. We hope that this study encourages interested readers to contribute to the development and enhancement of the package.

---

## Background

### Berglund and Karlström's G statistic

The Gij* statistic used in {spnaf} to detect hotspots of flows stems from the work of Berglund and Karlström (1999) who developed Gij* statistic as an extension of Getis and Ord's G-statistic. It detects the spatial clustering of flows, enabling the identification of flow clusters at the local level within the context of neighboring flows based on network spatial weight matrices.

The Gij* values are utilized to identify flow clusters based on statistical significance. The computation of Gij* follows the formula presented in Equation (1) (Berglund and Karlström, 1999):

$$G_{ij}^* = \frac{\sum_{k,l} w_{ij,kl} r_{kl} - W_{ij} \bar{r}}{s \left\{ (t-1)S_1 - W_{ij}^2 / t-2 \right\}^{1/2}}$$

$$\bar{r} = \frac{1}{t-1} \sum_{kl, (k,l) \neq (i,j)} r_{kl}$$

$$s^2 = \frac{1}{t-2} \sum_{kl, (k,l) \neq (i,j)} (r_{kl} - \bar{r})^2$$

$$W_{ij} = \sum_{kl, (k,l) \neq (i,j)} w_{ij,kl}$$

$$S_1 = \sum_{kl, (k,l) \neq (i,j)} w_{ij,kl}^2$$

wij represents the spatial weight matrix, and t is the number of the origin-destination pairs, where i and j denote the origins and destinations, respectively, with k being the origin-constrained neighbors and l the destination-constrained neighbors. r denotes the flow volumes between each pair of origin-destination census blocks. A network spatial weight matrix W = [wij,kl] can be determined by the three options: 1) only neighbors of the origin are considered, 2) only neighbors of the destination are considered, and 3) neighbors of both the origin and the destination are considered.

### Previous studies of flow clusters

The application of ESDA to flow datasets has demonstrated its utility in examining the various mobility/movement datasets, including human migration (Chun, 2008; Lee et al., 2021), bike-sharing trips (Kim and Kim, 2020), and commodity flows (Chun et al., 2012). For instance, Lee et al. (2021) employed the Gij* to illustrate how the migration patterns of millennials in Seoul, Korea, diverged from those of other age groups. Chun et al. (2012) devised an interregional commodity flow model that accounted for spatial network autocorrelation effects after identifying statistical significance in Gij*, thereby ensuring the model's unbiased estimates. Kim and Kim (2020) applied Gij* to identify flow clusters of bike-sharing trips in urban areas. Their findings offered policy insights, suggesting potential enhancements for bike-sharing route maintenance and service improvements rooted in the local urban structures. Moreover, Tao and Thill (2020) introduced BiFlowLiSA, a local indicator of spatial association of bivariate flow data, which adapts the local bivariate Moran's I to the origin-destination paired network datasets, expanding flow-related ESDA methods.

---

## Working with {spnaf}: An overview

The {spnaf} package (designed for R version 3.5 or newer) requires several supporting packages: {deldir}, {dplyr}, {magrittr}, {sf}, {spdep}, {tidyr}, and {rlang}. The {spnaf} package includes the main function—**Gij.flow**, and four internal sub-functions—**Gstat**, **Boot**, **Resultlines**, and **SpatialWeights**.

To utilize the {spnaf} package, users need to import two types of files. Users should first import their flow data in the "data frame" class format with three required columns: 1) **oid** (origin id); 2) **did** (destination id); and 3) **n** (the magnitude of flow between an origin-destination pair). They should also import the corresponding polygon or point shapefile of a study area (e.g., boundaries of census blocks when these census blocks are considered as origins and destinations of flows or points of interest when these points are considered as origins and destinations). The shapefile needs to be imported in the "sf" class format using the {sf} package. This shapefile must include an **id** column, which is used as the origin id (i.e., oid) or destination id (i.e., did) in the first dataset (i.e., flow data in the "data frame" format).

Figure 1 illustrates the workflow of the {spnaf} package. The main function (**Gij.flow**) first calls the **SpatialWeights** function to calculate spatial weights using various spatial weight matrix options. The first option involves creating contiguity-based neighbors using the "Queen" method within the Gij.flow function (Getis and Aldstadt, 2004). The second and third options involve computing the spatial matrix based on distance, represented by "KNN" (k-nearest neighbors) and "fixed-distance" methods, respectively. The "KNN" option calculates an adaptive distance weight matrix, while the "fixed_distance" option computes a fixed-distance weight matrix. For the KNN method and the fixed distance method, the value for the k (the number of the nearest neighbors considered) and the d (the distance considered) need to be determined. The **SpatialWeights** function supports not only binary weight but also allows users to adopt the inverse distance weight matrix with "idw = TRUE" command. Additionally, the function provides an option to standardize neighbors' values using the row standardization method with "row_standardized = TRUE" command. By default, the Queen method with a binary weight and without row standardization is applied to create a spatial weight matrix.

Next, the **Gstat** function uses the results from **Spatialweights** and calculates Berglund and Karlström's Gij* based on the selected option of neighbor structure. This option determines how the origins and destinations of flows should be considered in terms of neighbor structure. The default value of the option is **t** (total). In this case, both origins' and destinations' adjacent polygons or points (specified by the **SpatialWeights** function) are considered as a default setting. The alternatives **o** and **d** consider "only the neighbors of the origin" and "only the neighbors of the destination," respectively.

Then, the **Boot** function validates the Gij* from **Gstat** through a bootstrapping technique. This method replicates samples n times to determine the statistical significance of the results. By default, samples are replicated 1,000 times. This bootstrapping procedure produces p-values for the Gij* statistics.

Following this, the **Resultlines** function generates an output in the list class format which contains a data frame consisting of **oid** (origin id), **did** (destination id), **n** (the volume of flows), **Gij** (Gij*), **pval** (p-value), along with an additional geometry column in the well-known text (WKT) form which includes line strings for visualizing the hotspot flows making it an sf class of the {sf} package.

Users have the flexibility to select their desired p-value. For example, a user might select a p-value of 0.05, with the default setting (1,000 times) of the bootstrapping procedure, to extract statistically significant flow hotspots. Through this, users can determine statistical significance of each Gij* value, thereby identifying statistically significant hotspot flows (flows with high values, surrounded by other flows of similar volumes).

---

## Figure 1. An overview of the {spnaf}'s workflow and functions.

```
                    Main Function
                      Gij.flow
                         ↓
                Internal Functions

Input ──────→ SpatialWeights ───→ Spatial weight matrix options
                                    • queen
data.frame                          • KNN           • inverse distance
(oid, did, and n)                   • fixed_distance   weight
                                                    • row standardized
The {sf} class          ↓
                                                          ↓
polygon shape file      Gstat ───→ Neighbor structure options
(id)                               • o
                                   • d
or                                 • t
                         ↓
point shape file (point) Boot ───→ The number of boot-strapping options
(id)                               • n
                         ↓
                    Resultlines ───→ Output
                                    data.frame (oid, did, n,
                                    Gij, and p-value) + shape
                                    (linestrings)
```

---

## Examples

### Polygon feature example: CoGo bike-sharing flows

The application of polygon features is demonstrated through the analysis of Columbus bike-sharing (CoGo) trips in the city of Columbus, Ohio, USA. The CoGo dataset (https://cogobikeshare.com/system-data) includes information about the origin and destination bike station of each trip from 2014 to 2023. We analyzed data from January through December 2019 before the COVID-19 pandemic, which encompasses 36,890 bike trips with 79 unique bike stations. We aggregated the individual trips at the census block level based on the locations of bike stations. This resulted in 1,416 origin-destination pairs, with a maximum bike-sharing trip volume of 1,453.

To test the effectiveness of this package in detecting flow hotspots for polygon features using CoGo bike-sharing data, we applied three different spatial weight matrices with inverse distance weights and the row standardization option: 1) the Queen method, 2) the KNN method with 10 nearest neighbors, and 3) the fixed distance with a 10 km radius. We considered both the origins and the destinations for the neighbors' structure. The results were selected with a 99% statistical significance. The example codes for these analyses are represented in Table 1.

---

## Table 1. Example codes by the spatial weight matrix methods.

| The spatial weight matrix method | Code |
|----------------------------------|------|
| The Queen method | `result<- Gij.flow (df, shape, idw = TRUE, row_standardize = TRUE)` |
|                  | `result_pval<-result<-result [[2]][result [[2]]$pval < 0.01,]` |
| The KNN method | `result<- Gij.flow (df, shape, method = "KNN," k = 10, idw = TRUE, row_standardize = TRUE)` |
|                | `result_pval<-result<-result [[2]][result [[2]]$pval < 0.01,]` |
| The fixed distance method | `result<- Gij.flow (df, shape, method = "fixed_distance," d = 10, idw = TRUE, row_standardize = TRUE)` |
|                           | `result_pval<-result<-result [[2]][result [[2]]$pval < 0.01,]` |

---

The results showed that among the 1,416 origin-destination pairs, the Queen method identified 13 origin-destination pairs as hotspots, the KNN method found 13 flow hotspots, and the fixed distance method detected 15 flow hotspots. On an Apple hexa-core M1 Pro CPU, operating at 3.6 GHz with 16 GB of RAM, the calculation of Gij* for 1,416 OD pairs was completed in 180 s.

Based on these results, we exported the outputs as a shapefile, including the line strings of the flow hotspots, to identify the geographical distribution of these flows. We used QGIS version 3.26 to visualize the shapefile outputs (Figure 2). The bike-sharing flow hotspots are generally concentrated around the downtown area of Columbus for all three methods. However, the specific locations vary depending on each spatial weight matrix.

---

## Figure 2. Spatial distribution of bike-sharing flow hotspots between each census block by the spatial weight matrices: a) the Queen contiguity method b) the KNN method (k = 10), and c) the fixed distance method (d = 10).

[Figure shows maps of Columbus, Ohio with census blocks and flow hotspots (red arrows) concentrated in downtown area. Three panels show results from different spatial weight methods.]

---

### Point feature example: US airport passengers travel patterns

The application of point features is demonstrated through the analysis of air passenger travel patterns across the mainland US. The air passengers travel data (Bureau of Transportation Statistics, 2024) includes information about passenger travel patterns between airports, represented as point features in the shapefile. We selected domestic flights within the mainland US for the period spanning to the first quarter of 2023, extracting only origin-destination pairs with over 1,000 passengers. This resulted in 396 origin-destination pairs, with the maximum travel volume being 19,955 passengers.

We applied similar processes to test the ability of the package to identify flow hotspots for point features as we did with polygon features. We used three different spatial weight matrices options with inverse distance weight and row standardization option: 1) the Queen contiguity method, 2) the KNN method with 10 nearest neighbors (k = 10), and 3) the fixed distance with a 200 km radius (d = 200). The results showed that among the 396 origin-destination pairs, the Queen method found only 3 flow hotspots, the KNN method found 5 flow hotspots, and the fixed distance method detected 4 flow hotspots (Table 2). On an Apple hexa-core M1 Pro CPU, operating at 3.6 GHz with 16 GB of RAM, the calculation of Gij* for 396 OD pairs was completed in 25 s.

---

## Table 2. The results of Gij* by the spatial weight matrices.

| Spatial weight matrix | Origin airport ID | Destination airport ID | Travel volume | Gij* | p-value |
|-----------------------|-------------------|------------------------|---------------|------|---------|
| The Queen contiguity method | ATL | BOS | 9,749 | 17.39 | 0.001 |
|  | BWI | MCO | 14,440 | 14.17 | 0.004 |
|  | CHS | LGA | 2,909 | 14.11 | 0.001 |
| The KNN method (k = 10) | ATL | BOS | 9,749 | 19.71 | 0.001 |
|  | BNA | FLL | 5,839 | 15.59 | 0.008 |
|  | BNA | LGA | 7,203 | 17.13 | 0.004 |
|  | BNA | MCO | 9,137 | 16.05 | 0.007 |
|  | CHS | LGA | 2,909 | 14.11 | 0.006 |
| The fixed distance method (d = 200) | ATL | AUS | 4,830 | 26.55 | 0.005 |
|  | ATL | BNA | 2,160 | 28.93 | 0.003 |
|  | ATL | BOS | 9,749 | 29.43 | 0.001 |
|  | BOS | ATL | 9,689 | 25.19 | 0.008 |

---

The geographical distribution of flow hotspots was predominantly concentrated along the East Coast, regardless of the spatial weight matrices employed (Figure 3). The Queen contiguity and the KNN spatial weight matrices exhibited similar patterns in the flow hotspots (Figures 3(b) and (c)). In contrast, the fixed distance-based method uniquely identified flow hotspots. For example, it detected flow hotspots from Hartsfield–Jackson Atlanta International Airport to Nashville International airport and Austin–Bergstrom International Airport, which did not appear in the KNN and Queen contiguity methods. (Figure 3(d)).

---

## Figure 3. Spatial distribution of air passengers' flow hotspots between the US airports by the spatial weight matrices: (a) the locations of airports in the mainland US, (b) the Queen contiguity method (c) the KNN method (k = 10), and (d) the fixed distance method (d = 200).

[Figure shows four maps of mainland US: (a) all airports as points, (b-d) flow hotspots shown as red arrows between airports, concentrated along East Coast.]

---

## Conclusion

The {spnaf} package (https://cran.r-project.org/web/packages/spnaf/index.html) enables the spatial analysis of flow data on human mobility (and animal movement), ranging from micro-scale (e.g., bike-sharing trips within a city) to macro-scale (e.g., air passenger travel patterns across the U.S.) movements, utilizing various spatial weight matrices regardless of the spatial data types. Over the past decade, we have witnessed a proliferation of data on human mobility (Miller et al., 2019). However, a deeper understanding of human mobility flows has been constrained by the lack of open-source tools capable of conducting cluster analysis of flows, while accommodating the size and complexity of datasets.

As the first R package specifically designed for hotspot analysis of flow datasets, {spnaf} overcomes these challenges. We demonstrated its effectiveness through an example analysis of bike-sharing trips in a mid-sized city in the US and an analysis of air passengers' travel volume across the US. These example analyses demonstrated that users can employ various spatial weight matrices based on the purpose of their analysis. The different options for spatial weight matrices enable user to conduct sensitivity analysis and consider the contextual relevance for their specific analysis, thereby enhancing interpretations. We also demonstrated that the {spnaf} is capable of handling large sizes of flow datasets on standard PCs and laptops. We hope that this package can empower researchers to address a wide array of research questions related to the flows of moving objects such as humans, animals, and vehicles in the realm of integrated movement science.

---

## Declaration of conflicting interests

The author(s) declared no potential conflicts of interest with respect to the research, authorship, and/or publication of this article.

## Funding

The author(s) disclosed receipt of the following financial support for the research, authorship, and/or publication of this article: This research was partially supported by the Faculty of Social Science at Western University and the National Research Foundation of Korea (NRF) grant funded by the Korea government (MSIT) (Grant No. RS-2022-00165821).

## ORCID iDs

Kyusik Kim https://orcid.org/0000-0003-3753-3196
Jinhyung Lee https://orcid.org/0000-0003-1859-3441

## Data availability statement

Data freely downloadable from CoGo, United States Bureau of Transportation Statistics, and United States Census.

---

## References

Anselin L, Li X and Koschinsky J (2021) GeoDa, from the desktop to an ecosystem for exploring spatial data. *Geographical Analysis* 54(3): 439–446.

Berglund S and Karlström A (1999) Identifying local spatial association in flow data. *Journal of Geographical Systems* 1(3): 219–236.

Bivand R, Bernat A, Carvalho M, et al. (2005) The spdep package. Available at: https://cran.r-project.org/web/packages/spdep/index.html.

Bureau of Transportation Statistics (2024) *Airline Origin and Destination Survey (DB1B)*. Washington, DC: U.S. Department of Transportation.

Chun Y (2008) Modeling network autocorrelation within migration flows by eigenvector spatial filtering. *Journal of Geographical Systems* 10(4): 317–344.

Chun Y, Kim H and Kim C (2012) Modeling interregional commodity flows with incorporating network autocorrelation in spatial interaction models: an application of the US interstate commodity flows. *Computers, Environment and Urban Systems* 36(6): 583–591.

Donegan C, Hughes AE and Lee SJC (2022) Colorectal cancer incidence, inequalities, and prevention priorities in urban Texas: surveillance study with the "surveil" software package. *JMIR Public Health and Surveillance* 8(8): e34589.

Getis A and Aldstadt J (2004) Constructing the Spatial Weights Matrix Using a Local Statistic. *Geographical analysis* 36(2): 90–104.

Kim H and Kim Y (2020) Space-time network analysis of public bicycle use and its visualization using spatial network autocorrelation. *Journal of the Korean Cartographic Association* 20(1): 93–106.

Lee Y, Park S, Kim K, et al. (2021) Discovering millennials' migration clusters in Seoul, South Korea: a local spatial network autocorrelation approach. *Findings* November. https://doi.org/10.32866/001c.29523.

Miller HJ, Dodge S, Miller J and Bohrer G (2019) Towards an integrated science of movement: converging research on animal movement ecology and human mobility science. *International Journal of Geographical Information Science*, 33(5): 855–876.

Tao R and Thill JC (2020) BiFlowLISA: measuring spatial association for bivariate flow data. *Computers, Environment and Urban Systems* 83: 101519.

---

## Author Biographies

**Hui Jeong (Hailyee) Ha** is a PhD student in the Department of Geography & Environment at Western University. Her research interests involve understanding human mobility patterns in space across time through the use of GIScience, spatial statistics, and big data analytics. She is also interested in developing new spatial analysis methods that integrate computer science, social physics, and statistics to provide decision-makers with new perspectives on urban challenges.

**Youngbin Lee** is a PhD student in the Department of Civil and Environmental Engineering at Seoul National University. He is broadly interested in analyzing cities using various data, including urban analytics, spatial analysis, and geo-visualization.

**Kyusik Kim** is a postdoctoral researcher in the Department of Geography at Florida State University. His research interests include social inequities in spatial access to opportunities, long-distance commutes, and older adults' travel behavior.

**Sohyun Park** is an Assistant Professor in Computational and Data Sciences at George Mason University Korea. Her research focuses on the ways in which movements of people and commodities across space are entangled with the local environment. She is also interested in exploring geospatial data via visualization methods.

**Jinhyung Lee** is an Assistant Professor in the Department of Geography & Environment at Western University. His research leverages geographic information science, big data analytics, spatial statistics, and time geography to study urban transportation. Specifically, he focuses on developing innovative analysis and modeling techniques to enhance our understanding of human mobility and accessibility in time across space. The overarching goal of his research is to provide insights for evidence-based, scientific transport planning and policy to promote sustainability and public health in the context of climate change and social justice within cities.

---

**Corresponding author:**
Jinhyung Lee, Department of Geography and Environment, Western University, 1151 Richmond St, London, ON N6A 3K7, Canada.
Email: jinhyung.lee@uwo.ca
