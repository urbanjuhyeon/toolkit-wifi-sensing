# Overture Point of Interest data for the United Kingdom: A comprehensive, queryable open data product, validated against Geolytix supermarket data

**Patrick Ballantyne** - University of Liverpool, UK

**Cillian Berragan** - Consumer Data Research Centre (CDRC), UK

*EPB: Urban Analytics and City Science* 2024, Vol. 51(8) 1974–1980

DOI: 10.1177/23998083241263124

---

## Abstract

Point of Interest data that is globally available, open access and of good quality is sparse, despite being important inputs for research in a number of application areas. New data from the Overture Maps Foundation offers significant potential in this arena, but accessing the data relies on computational resources beyond the skillset and capacity of the average researcher. In this article, we provide a processed version of the Overture places (POI) dataset for the UK, in a fully queryable format, and provide accompanying code through which to explore the data, and generate other national subsets. In the article, we describe the construction and characteristics of this new open data product, before evaluating its quality in relation to ISO standards, through direct comparison with Geolytix supermarket data. This dataset can support new and important research projects in a variety of different thematic areas, and foster a network of researchers to further evaluate its advantages and limitations, through validation against other well-established datasets from domains external to retail.

**Keywords**: Point of interest, retail, overture, Geolytix

---

## Introduction

Point of Interest (POI) data is an invaluable source of information, acting as a key input to much of the research that has, and continues to be generated in urban analytics and city science. These data provide key locational attributes about a broad variety of social, environmental, and economic phenomena, including historical landmarks, parks, hospitals, and retailers, and have been vital sources of data for different applications, including health (Green et al., 2018; Hobbs et al., 2019), urban mobility (Graells-Garrido et al., 2021; Jay et al., 2022), retail, and location analysis (Ballantyne et al., 2022a), transportation (Credit, 2018; Owen et al., 2023), and many others.

However, a major challenge when working with POI data relates to the coverage and quality of these datasets (Ballantyne et al., 2022a; Zhang and Pfoser, 2019). By this we mean how much the chosen source(s) of POI data restricts the analyses to specific cities or regions (i.e. coverage), and the degree to which it meets well-established criteria of data quality.

Many POI datasets offer a high level of global coverage and availability, such as OpenStreetMap. However, there are issues when considering the coverage and completeness of OpenStreetMap at finer spatial resolutions. These issues become even more apparent in areas with less contributors, in less developed countries, and for economic activities like retail stores (Ballantyne et al., 2022a; Haklay, 2010; Mahabir et al., 2017; Zhang and Pfoser, 2019). Some POI datasets exist which fill this gap, provided by Ordnance Survey, Local Data Company and SafeGraph, but are often not open access or globally and nationally comprehensive (Ballantyne et al., 2022a; Dolega et al., 2021; Haklay, 2010). A useful framework for assessing the quality of these datasets was established in ISO 19157, which provides a mechanism through which formally assess the quality of spatial data, based on positional and thematic accuracy, completeness, logistical consistency, and usability (Fonte, 2017). As a result, there is a clear gap for POI data that can meet these ISO 19157 standards, providing a good quality, openly available source of POIs for the UK. In this article, we introduce readers to a new 'open data product' (Arribas-Bel et al., 2021), derived from the processed version of the Overture Maps places (POI) dataset (Overture Maps Foundation, 2023), which arguably provides a strong solution to many of these problems, and can facilitate groundbreaking urban analytics research in a number of different application areas.

---

## Data

The data was accessed through the Overture Maps Foundation which has developed a number of open data products including Buildings and Places. These have been developed through incorporation of data from multiple sources including Microsoft and Meta, resulting in data products that are available at global scales and contain detailed attributes (Overture Maps Foundation, 2023), including a source attribute which indicates whether each record is sourced from Microsoft or Meta. Users can access the data parquet files, a 'column-oriented data format … and modern alternative to CSV files' (Geoparquet, 2023), which offers greater disk saving, and facilitates more efficient querying (Hu et al., 2018). The parquet files can be queried directly from the cloud using Amazon Athena, Microsoft Synapse, or DuckDB, or downloaded locally. However, a specific challenge for urban analytics researchers and city scientists is that the majority will not have the data engineering or 'quantitative' skills (Arribas-Bel et al., 2021) to query these datasets from the cloud, and process the attributes in their nested JSON format. Furthermore, for those who want to download the files locally, they can be difficult to work with, as the full global places file is over 200 GB. Therefore, our aim is to provide a processed subset of the Overture places dataset for the UK, which bypasses these issues, and creates an open data product for use in research, which can be updated regularly as newer versions of Overture places become available, and bridges skills and knowledge gaps to open up this dataset to a much wider audience, as in Arribas-Bel et al. (2021).

Overture hosts all data through Amazon Web Services (AWS), which enables a number of query end points to be used to download data subsets. The Overture data schema includes a bounding box structure column to enable efficient spatial SQL queries. To query POI data for the UK, a spatial SQL query was constructed using the DuckDB SQL engine and the UK bounding box, based on EPSG:27700. This query downloaded a GeoPackage file containing all POIs within the UK bounding box, totalling 1.34 GB. This file was then clipped to the administrative boundaries of the United Kingdom, to exclude non-UK places that appeared within the bounding box query. As noted, many of the columns that provide metadata relating to POIs are represented in a nested JSON format (columns containing lists of lists), which are difficult to efficiently parse with traditional tabular data frame libraries. We therefore processed the following columns to ensure the data frame remained two-dimensional: *Names*, *Category*, *Address* and *Brand*. Following this processing, we spatially joined the 2021 census area geographies for England including Output Areas (OA), Lower layer Super Output Areas (LSOA), Middle layer Super Output Areas (MSOA), and the 2022 Local Authority Districts (LAD). For both Scotland and Northern Ireland, we spatially joined the 2011 Data Zone geographies. We also include the H3 (hexagons) addresses associated with each point for all resolutions between 1 and 9.

The resulting dataset is a 358 MB GeoParquet file, hosted as part of a DagsHub data repository. The repository contains the new open data product which can be downloaded using the link in the supplementary materials (Table i). A list of attributes for the data product can also be found in Table ii, and as a secondary output of this paper, an example workflow for how to extract Overture places for other study areas has also been produced (Table i). Python is the preferred language for utilising our resources, as it enables creation and maintenance of a virtual environment in which to easily replicate our analysis. By providing these workflows and hosting all the materials on DagsHub, this paper enables users to reproduce our analyses, through exploration of the materials stored within our streamlined reproducible research workflow, as in Paez (2021).

---

## Reliability analysis – retail brands

To assess the reliability of our Overture data product, we compared the Overture POIs with the Geolytix Supermarket Retail Points dataset (Geolytix, 2023), which is known to provide reliable information about supermarkets in the UK, through collecting the up-to-date store locations from the retailers themselves (Geolytix, 2023). On this basis, and the fact that this data is used in a wealth of published academic research (e.g. Ilyankou et al., 2023; Long et al., 2023), it was determined that the Geolytix data provides a useful 'ground-truth' dataset to validate against. Furthermore, given that Geolytix data is not globally available, and initial comparison with the Overture dataset revealed discrepancies in recording of spatial and non-spatial attributes, it was deemed that the Geolytix dataset represented a suitably independent source to validate against.

In particular, we examined how well Overture represents the Geolytix supermarket data, adopting the key data quality principles outlined in ISO 19157 to formally assess the quality of our new data product. In particular, drawing inspiration from Fonte (2017), we empirically measured the positional and thematic accuracy and completeness of the data product, through consideration of how accurate the POI coordinates were, the presence or absence of thematic tags (i.e. field values), the number of supermarkets absent from our data product, and any biases created by the sourcing of the POIs. The latter is interesting, given existing research into data product biases when derived from different mobile applications (e.g. Ballantyne et al., 2022b), as Overture Maps sources data from different providers including Meta and Microsoft. A detailed description of the methods used to assess the reliability of Overture places can be found in the Supplemental Material (S3).

Firstly, in terms of completeness, Table 1 shows that the Overture data aligns well with the Geolytix data, with small differences in the total representation of POIs between the three retailers (<5%). Table 1 also shows that there was a relatively low median distance (metres) between Overture points and their closest Geolytix point, evidencing a relatively high level of *positional accuracy*, where values less than 10 m are deemed as optimal (Fonte, 2017). This is an important attribute, as incorrect positioning of POI data can have dramatic implications for accessibility measurement (Graells-Garrido et al., 2021; Green et al., 2018), and urban boundary delineation (Ballantyne et al., 2022a).

**Table 1.** Completeness and positional accuracy of Overture data compared with Geolytix supermarket data.

| Retailer | Geolytix count | Overture count | Average distance between points (m) (positional accuracy) |
|----------|----------------|----------------|----------------------------------------------------------|
| Waitrose | 422 | 420 | 8.24 |
| Spar | 2339 | 2304 | 6.47 |
| Tesco | 2840 | 2753 | 6.17 |

In terms of the thematic accuracy of the category and brand information, as defined by Fonte (2017), a large proportion of the Overture POIs contained missing values for categories or brands, making filtering of the dataset to a specific retailer (e.g. Waitrose), slightly less simple. Table 2 displays the complexity of these issues, where different degrees of thematic accuracy are apparent when considering the source of the POI (Meta or Microsoft). This has strong implications for how Overture data can and should be used, especially for applications involving specific POI categories or brands. Whilst it is not impossible to extract a complete list of POIs for a retailer, through collective filtering of POI name, brand and categories to collect these features (see S4 of the Supplementary Material), users should be aware of the low level of thematic accuracy for POIs extracted from Microsoft. Furthermore, our analysis also demonstrates that Overture data, when using POIs sourced from Meta, offers good levels of category information, but is less thematically accurate when looking to identify brand information (e.g. Waitrose). Further reliability analysis is beyond the scope of this paper, but there is a clear need for further investigation into how well Overture places captures category and brand information for other non-retail POIs (e.g. GP practices, post offices), and how positionally accurate Overture POIs are when using other methods to assess this.

**Table 2.** Completeness and thematic accuracy of Overture compared with Geolytix supermarket data, describing how POIs sourced from different providers (e.g. Meta) exhibit differences in the completeness of the category_main and brand_name_value, when compared across the three retailers. Where values are NA, this indicates that no POIs for that retailer are supplied by Meta or Microsoft.

| Retailer | Field attribute completeness (%) | | | |
|----------|----------------------------------|---|---|---|
| | category_main | | brand_name_value | |
| | POIs sourced from Meta (sources_dataset) | POIs sourced from Microsoft (sources_dataset) | POIs sourced from Meta (sources_dataset) | POIs sourced from Microsoft (sources_dataset) |
| Waitrose | 100.00 | N/A | 76.67 | N/A |
| Spar | 99.82 | 0.00 | 88.37 | 0.00 |
| Tesco | 100.00 | N/A | 97.71 | N/A |

---

## Application – mapping supermarkets in the UK

To demonstrate how this dataset can be used, an example workflow has been presented which reads in our new open data product, filters to a specific brand of supermarket, and then maps the distribution of these nationally (Figure 1). The purpose of this workflow is to illustrate how easy it is to work with this dataset, and demonstrate our commitment to reproducible and replicable research (Paez, 2021). Example workflows have been presented for both the Python and R programming languages (Table i), which utilise preferred packages for data manipulation and mapping (e.g. arrow, geopandas).

[Figure 1. An example application, mapping Tesco stores across the UK. Map shows the United Kingdom from approximately 50°N to 60°N latitude and 8°W to 2°E longitude. Points are plotted showing Tesco store locations with different colors for different store types in the legend (names_value): Tesco, Tesco Esso Express, Tesco Express, Tesco Extra, Tesco Metro, Tesco Mobile, Tesco Superstore, Tesco Travel Money. The distribution shows dense clustering in urban areas, particularly in England, with sparser coverage in Scotland, Wales, and Northern Ireland.]

---

## Conclusion

This paper presents a new open data product, which represents a processed UK national subset of the Overture places database. This new data product opens up data from Overture to a wider audience, facilitating analysis of new dimensions of human geographical processes, as in Arribas-Bel (2021). The potential applications of this data product in a variety of different fields are highly significant (e.g. urban accessibility), given the evidence and considerations presented about the coverage and quality of this new data product of this new data product. Furthermore, we are committed to updating this data product every 6 months and hosting these updates as data products on the Consumer Data Research Centre, enabling users to benefit from updates and new POIs that become available from within the higher-level Overture database. At a time where the retail sector is undergoing significant transformations in response to the cost-of-living crisis, such data can provide invaluable insights about the characteristics and performance of the sector (Ballantyne et al., 2022a, 2022b; Dolega et al., 2021), which has historically been a challenge due to the availability of suitable retailer data.

However, there are inherent limitations to our data product, which have been illustrated through direct comparison with Geolytix data. Users need to be cautious about how they are using this data, especially when the POIs they are using are largely sourced from Microsoft. Furthermore, given the ambiguity of Overture Maps in how their data is assembled, there is scope for data quality assessments using external datasets whose licences forbid Overture from incorporation into Places (e.g. Ordnance Survey), incorporating alternative metrics for ISO criteria like positional accuracy, with the aim of adding further credibility to the quality assessment we present in this paper. However, limitations aside, it is our hope that by releasing this data into the open domain, a network of researchers will be fostered who can utilise this data for their own research questions, and critically evaluate how the Overture places database represents a variety of different social, economic, and environmental activities, through rigorous data quality assessments utilising established POI datasets in other (non-retail) domains.

---

## Acknowledgements

We would like to thank Geolytix for making the Supermarket Retail Points dataset openly available. We would also like to extend our thanks to the editor and three anonymous reviewers for their careful and considered feedback on the manuscript, and for providing an exciting outlet in which to publish open data products.

## Declaration of conflicting interests

The author(s) declared no potential conflicts of interest with respect to the research, authorship, and/or publication of this article.

## Funding

The author(s) received no financial support for the research, authorship, and/or publication of this article.

## ORCID iDs

Patrick Ballantyne https://orcid.org/0000-0001-8980-2912

Cillian Berragan https://orcid.org/0000-0003-2198-2245

## Data availability statement

This open data product is available to download from the Consumer Data Research Centre: https://data.cdrc.ac.uk/dataset/point-interest-data-united-kingdom. The version hosted on the CDRC is the most up-to-date version queried directly from Overture, and as such will vary from the statistics and figures presented in the paper. The DagsHub repository, which stores the features used as part of the anonymous peer review process (e.g. data product, code) is also available to view at: https://dagshub.com/cjber/overture-uk. This version of the open data product matches that discussed in the paper.

## Supplemental Material

Supplemental material for this article is available online.

---

## References

Arribas-Bel D, Green M, Rowe F, et al. (2021) Open data products-a framework for creating valuable analysis ready data. *Journal of Geographical Systems* 23: 497–514.

Ballantyne P, Singleton A, Dolega L, et al. (2022a) A framework for delineating the scale, extent and characteristics of American retail centre agglomerations. *Environment and Planning B: Urban Analytics and City Science* 49(3): 1112–1128.

Ballantyne P, Singleton A and Dolega L (2022b) Using unstable data from mobile phone applications to examine recent trajectories of retail centre recovery. *Urban Informatics* 1(1): 21.

Credit K (2018) Transit-oriented economic development: the impact of light rail on new business starts in the Phoenix, AZ Region, USA. *Urban Studies* 55(13): 2838–2862.

Dolega L, Reynolds J, Singleton A, et al. (2021) Beyond retail: new ways of classifying UK shopping and consumption spaces. *Environment and Planning B: Urban Analytics and City Science* 48(1): 132–150.

Fonte C (2017) Assessing VGI data quality. In: *Mapping and the Citizen Sensor*. London: Ubiquity Press, 137–163. Available at: https://www.ubiquitypress.com/site/chapters/10.5334/bbf.g/ (Accessed 02 02 2024).

Geolytix (2023) *Supermarket Retail Points*. London: Geolytix. Available at: https://geolytix.com/blog/supermarket-retail-points/ (Accessed 16 10 2023).

Geoparquet (2023) *Geoparquet*. Available at: https://geoparquet.org/ (Accessed 01 02 2024).

Graells-Garrido E, Serra-Burriel F, Rowe F, et al. (2021) A city of cities: measuring how 15-minutes urban accessibility shapes human mobility in Barcelona. *PLoS One* 16(5): e0250080.

Green MA, Daras K, Davies A, et al. (2018) Developing an openly accessible multi-dimensional small area index of 'access to healthy assets and hazards' for great Britain, 2016. *Health & Place* 54: 11–19.

Haklay M (2010) How good is volunteered geographical information? a comparative study of OpenStreetMap and ordnance survey datasets. *Environment and Planning B: Planning and Design* 37(4): 682–703.

Hobbs M, Griffiths C, Green MA, et al. (2019) Examining longitudinal associations between the recreational physical activity environment, change in body mass index, and obesity by age in 8864 Yorkshire health study participants. *Social Science & Medicine* 227: 76–83.

Hu F, Xu M, Yang J, et al. (2018) Evaluating the open source data containers for handling big geospatial raster data. *ISPRS International Journal of Geo-Information* 7(4): 144.

Ilyankou I, Newing A and Hood N (2023) Supermarket store locations as a proxy for neighbourhood health, wellbeing, and wealth. *Sustainability* 15(15): 11641.

Jay J, Heykoop F, Hwang L, et al. (2022) Use of smartphone mobility data to analyze city park visits during the COVID-19 pandemic. *Landscape and Urban Planning* 228: 104554.

Long A, Carney F and Kandt J (2023) Who is returning to public transport for non-work trips after COVID-19? Evidence from older citizens' smart cards in the UK's second largest city region. *Journal of Transport Geography* 107: 103529.

Mahabir R, Stefanidis A, Croitoru A, et al. (2017) Authoritative and volunteered geographical information in a developing country: a comparative case study of road datasets in Nairobi, Kenya. *ISPRS International Journal of Geo-Information* 6(1): 24.

Overture Maps Foundation (2023) *Overture Maps Foundation Releases Its First World-Wide Open Map Dataset*. Sunnyvale, CA: Overture Maps Foundation. Available at: https://overturemaps.org/overture-maps-foundation-releases-first-world-wide-open-map-dataset/ (Accessed 16 10 2023).

Owen D, Arribas-Bel D and Rowe F (2023) Tracking the transit divide: a multilevel modelling approach of urban inequalities and train ridership disparities in Chicago. *Sustainability* 15(11): 8821.

Páez A (2021) Open spatial sciences: an introduction. *Journal of Geographical Systems* 23(4): 467–476.

Zhang L and Pfoser D (2019) Using OpenStreetMap point-of-interest data to model urban change — a feasibility study. *PLoS One* 14(2): e0212606.

---

## Author biographies

**Patrick Ballantyne** is a Postdoctoral Research Associate in Geographic Data Science. His research sits at the boundary between the computational and social sciences, and is broadly interested in retail geographies, consumer behaviour, spatial inequality and urban indicators.

**Cillian Berragan** is a Machine Learning and Data Engineer for the Consumer Data Research Centre. His research focuses on applying Geographic Information Science and Natural Language Processing to explore interesting research questions.
