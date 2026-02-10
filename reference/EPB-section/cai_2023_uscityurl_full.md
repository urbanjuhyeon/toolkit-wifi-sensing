# Cai et al. (2023) - Local data at a national scale: Introducing a dataset of official municipal websites in the United States for text-based analytics

## Full Text Transcription

---

**Urban Data/Code**

EPB: Urban Analytics and City Science
2023, Vol. 50(7) 1988–1993
© The Author(s) 2023

Article reuse guidelines: sagepub.com/journals-permissions
DOI: 10.1177/23998083231190961
journals.sagepub.com/home/epb

---

# Local data at a national scale: Introducing a dataset of official municipal websites in the United States for text-based analytics

**Meng Cai**
School of Planning, Design and Construction, Michigan State University, East Lansing, MI, USA; Department of Civil and Environmental Engineering, Technical University of Darmstadt, Darmstadt, Germany

**Huiqing Huang**
School of Planning, Design and Construction, Michigan State University, East Lansing, MI, USA

**Travis Decaminada**
Department of City and Regional Planning, University of Pennsylvania, Philadelphia, PA, USA

## Abstract

Municipal websites serve as central platforms for local governments to share information with the public. They offer authoritative, up-to-date, and free access for researchers to collect city-level data. However, until now, a comprehensive and accurate database of municipal web addresses did not exist. Here, we introduce a complete and manually verified dataset containing information on whether a municipality has an official website and, if so, what its web address is, of all 19,518 municipalities in the United States. With this dataset, researchers can easily conduct systematic searches on municipal official websites for self-defined keywords. The search results are well-suited for text-based analytics. This new data source benefits urban scholars who struggle to access high-quality local data for nationwide studies and contributes to narrowing the data gap.

**Keywords**
Municipal websites, local governments, city-level data, text mining, official web addresses

---

## Introduction

Accessing accountable and timely data has been an essential, albeit daunting, task for urban scholars. Data at the city level is crucial for understanding urban processes and determining development trends; however, it is scattered across different agencies and not easily accessible (Manley and Dennett, 2019; Von Radecki and Dieguez, 2022). Though many cities have started to host open data portals, these portals often do not have comparable measures and only exist for a few high-profile large cities (Bischof et al., 2015; Matheus and Janssen, 2020; Zhu and Freeman, 2019). Traditional methods of data collection (e.g., interviews, surveys, and observations) are expensive and time-consuming, and thus overly costly or not practical for studies at large scales (Caughy et al., 2001; Groves et al., 2011; Gubrium and Holstein, 2001). As a result, studies at the local level are often limited in scope.

Using municipal websites as a data source could potentially narrow the data gap for large-scale studies and benefit scholars across disciplines. With the recent advances in technologies, scholars in various fields are calling for innovations in research methodologies and explorations of new data sources (Druckman and Donohue, 2020; Ilieva and McPhearson, 2018; Salganik, 2018). Unstructured text, such as social media posts and web content, has proven to be a valuable source to bridge the data gap (Cai, 2021; Yao and Wang, 2020; Zheng et al., 2014). As a main channel for local governments to disseminate information and engage with the public, municipal websites offer a large amount of authoritative material, such as official reports, planning documents, event listings, and regulations. These resources cover a variety of topics and may not be available through conventional data sources. In addition, municipal websites are updated regularly, which can be particularly useful for tracking changes over time.

However, a publicly accessible, comprehensive, and accurate database of municipal websites did not exist. Our chat/search with artificial intelligence-powered tools, ChatGPT and Microsoft Bing, confirmed that no such database was available. City organizations usually only have limited information about their member cities with restricted access. For example, the United States Conference of Mayors sells 1,400 cities' contact information for 2,500 USD (The United States Conference of Mayors, 2017). In addition, relying solely on search engine queries may not yield reliable information. By using a combination of automated Google searches and manual validation, we found that 45% of the web addresses obtained through search engine queries required correction.

In the spirit of open science, we introduce here a complete dataset that includes information on whether a municipality has an official website and, if so, what its web address is. This dataset covers all 19,518 municipalities in the United States, including both large cities and small towns. A municipality in this paper is defined as a legally bounded entity with a local government, which is equivalent to an incorporated place in the U.S. Census. Each entry of municipal web address was manually validated by two researchers who have expertise in urban and regional studies. Along with the dataset, we also provide instructions with ready-to-use Python code that can systematically search municipal websites for keywords. This novel resource provides researchers in city science with easy access to a wealth of authoritative and up-to-date local data for systematic text-based analytics at the U.S. national scale.

---

## Description of the dataset

The dataset is in the format of comma-separated values. As shown in the snapshot of the dataset (Figure 1), it has five columns: GEOID, MUNICIPALITY, STATE, WEBSITE_AVAILABLE, and WEBSITE_URL.

- GEOID: A unique identifier for each municipality to connect with geographic and demographic data from the U.S. Census.
- MUNICIPALITY: Municipality name.
- STATE: State name.
- WEBSITE_AVAILABLE: If an official website for a city is available or not: 1 means available and 0 means not available.
- WEBSITE_URL: The Uniform Resource Locator, that is, the web address, of a city.

---

## Figure 1. Snapshot of the dataset.

| | GEOID | MUNICIPALITY | STATE | WEBSITE_AVAILABLE | WEBSITE_URL |
|---|-------|--------------|-------|-------------------|-------------|
| 0 | 1600000US3651000 | New York | New York | 1 | https://www.nyc.gov/ |
| 1 | 1600000US0644000 | Los Angeles | California | 1 | https://www.lacity.org/ |
| 2 | 1600000US1714000 | Chicago | Illinois | 1 | https://www.chicago.gov/ |
| 3 | 1600000US4835000 | Houston | Texas | 1 | http://www.houstontx.gov/ |
| 4 | 1600000US0455000 | Phoenix | Arizona | 1 | https://www.phoenix.gov/ |

---

## Figure 2. Municipalities in the United States with and without official websites.

[Figure shows a map of the continental United States with municipalities plotted as points. Municipalities with websites shown in dark color, municipalities without websites shown in light color. Note: The dataset includes municipalities in Hawaii and Alaska, which are not shown on this map.]

---

The municipalities covered in this dataset were derived from the 2020 U.S. Census results distributed by IPUMS (Manson et al., 2021) (Figure 2). We utilized Google Custom Search API to automatically gather the web links of each municipality based on a keyword search comprising the city name, the state name, and the "official website." Then, to verify the accuracy of the returned links, we manually examined each link.

Websites were assessed via three criteria. First, the city and state names are correct. Second, the website is the official one managed by a local government. We do not count Wikipedia, Twitter, and Facebook pages as official websites. Third, we made sure that a web address is associated with an official website at the root level. For example, if a link included an additional subdirectory such as https://lacity.gov/government, we corrected it to the root level URL of www.lacity.gov. When we believed that an entry of web address was not accurate, we manually searched again and found the right one. In total, we corrected 8,863 web addresses obtained by Google search. 180 man-hours were spent manually verifying the data. In cases when a municipality does not have an official website, the entry is left blank.

As of September 2022, 13,724 out of 19,518 municipalities (70%) have an official website. Notably, all the municipalities without official websites have populations below 6,000.

---

## How to use this dataset

The dataset is publicly available at https://github.com/caimeng2/UScityURL under a Creative Commons Attribution 4.0 International License (CC BY 4.0). Anyone is allowed to adapt, modify, and distribute this work with proper citation.

Using Google Custom Search API with this dataset allows researchers to systematically search self-defined keywords on municipal websites. The returned search results pinpoint where a certain topic is being discussed and can be used for further text-based analysis. For instance, researchers can search for smart city-related terms on official websites to determine which cities are actively engaged in smart city discussions and which topics are being covered. By repeating this search regularly, researchers can create a timeline and monitor its prevalence over time (Cai, 2023). Detailed instructions on how to use this dataset, including ready-to-use Python code and an example, are available in the dataset repository https://github.com/caimeng2/UScityURL/blob/master/how_to_use_tutorial.ipynb.

It is important to note that this dataset has its limitations. Though we strive to achieve the highest accuracy and completeness when verifying and compiling data, a municipality may update its web address or create a website after we conducted the search. So, some of the information in our dataset may be outdated. In addition, our instructions on how to use this dataset focus solely on how to search and gather text from official websites. However, non-textual information such as images on municipal websites could also be a valuable resource, which remains an area for future exploration.

---

## Concluding remarks

In this paper, we introduce a complete and manually verified dataset that includes information on whether a municipality has an official website and, if so, what its web address is, of all 19,518 municipalities in the United States. This dataset offers researchers easy access to authoritative, timely, and freely available text data on a wide range of topics. It can be used in conjunction with other data sources, such as the census, American Community Survey, and geospatial files. Researchers can utilize the provided code to conduct systematic searches of specific topics and monitor them over time. The search results are well-suited for text-based analytics. It is worth noting that while automated extraction of content from publicly accessible websites for non-commercial purposes is legal in the United States, it must be carried out in a responsible manner. Researchers should refrain from text mining of websites that block automatic data harvesting. We anticipate that this dataset would be particularly useful for scholars in the fields of urban and regional planning, public policy, community engagement, and city development who employ computational methods, such as natural language processing techniques, to conduct studies at a national scale.

---

## Declaration of conflicting interests

The author(s) declared no potential conflicts of interest with respect to the research, authorship, and/or publication of this article.

## Funding

The author(s) received no financial support for the research, authorship, and/or publication of this article.

## ORCID iD

Meng Cai https://orcid.org/0000-0002-8318-572X

## Data Availability Statement

The data is available at https://github.com/caimeng2/UScityURL. This paper uses IPUMS NHGIS data (Manson et al., 2021). The full dataset and documentation can be downloaded from https://www.nhgis.org/.

---

## References

Bischof S, Martin C, Polleres A, et al. (2015) Collecting, integrating, enriching and republishing open city data as linked data. In: *The Semantic Web - ISWC 2015* (eds Arenas M, Corcho O, Simperl E, et al.), pp. 57–75. Lecture Notes in Computer Science. Cham: Springer International Publishing. DOI: 10.1007/978-3-319-25010-6_4

Cai M (2021) Natural language processing for urban research: a systematic review. *Heliyon* 7(3): e06322. DOI: 10.1016/j.heliyon.2021.e06322

Cai M (2023) Smart City Tracker: a living archive of smart city prevalence. Hawaii: Zenodo. Available at: https://caimeng2.github.io/SmartCityTracker/. DOI: 10.5281/zenodo.7670784

Caughy MO, O'Campo PJ and Patterson J (2001) A brief observational measure for urban neighborhoods. *Health & Place* 7(3): 225–236. DOI: 10.1016/S1353-8292(01)00012-0

Druckman D and Donohue W (2020) Innovations in social science methodologies: an overview. *American behavioral scientist*: SAGE Publications Inc. DOI: 10.1177/0002764219859623

Groves RM, Fowler Floyd J Jr, Couper MP, et al. (2011) *Survey Methodology*. New Jersey: John Wiley & Sons. Available at: https://books.google.de/books?id=ctow8zWdyFgC&printsec=frontcover&source=gbs_ge_summary_r&cad=0#v=onepage&q&f=false

Gubrium JF and Holstein JA (2001) *Handbook of Interview Research: Context and Method*. Cham: Sage Publications.

Ilieva RT and McPhearson T (2018) Social-media data for urban sustainability. *Nature Sustainability* 1(10): 10. DOI: 10.1038/s41893-018-0153-6

Manley E and Dennett A (2019) New forms of data for understanding urban activity in developing countries. *Applied Spatial Analysis and Policy* 12(1): 45–70. DOI: 10.1007/s12061-018-9264-8

Manson S, Schroeder J, Van Riper D, et al. (2021) *IPUMS National Historical Geographic Information System*. Minneapolis, MN: IPUMS. Available at: DOI: 10.18128/D050.V16.0

Matheus R and Janssen M (2020) A systematic literature study to unravel transparency enabled by open government data: the window theory. *Public Performance and Management Review* 43(3). 503–534. DOI: 10.1080/15309576.2019.1691025

Salganik M (2018) *Bit by Bit: Social Research in the Digital Age*. Open review edition. Princeton, NJ: Princeton University Press. Available at: https://www.bitbybitbook.com/en/preface/

The United States Conference of Mayors. (2017) Mayors data extract. *The United States Conference of Mayors*: Washington, DC. Available at: https://www.usmayors.org/product/mayors-data-extract/

Von Radecki A and Dieguez L (2022) *Data Strategies for a common good-oriented urban development*. Berlin: International Smart Cities Network. Available at: https://www.smart-city-dialog.de/wp-content/uploads/2022/01/Publication-Data-Strategies-for-Common-Good-oriented-Urban-Development-Int.pdf

Yao F and Wang Y (2020) Tracking urban geo-topics based on dynamic topic model. *Computers, Environment and Urban Systems* 79(12): 101419. DOI: 10.1016/j.compenvurbsys.2019.101419

Zheng Y, Capra L, Wolfson O, et al. (2014) Urban computing: concepts, methodologies, and applications. *ACM Transactions on Intelligent Systems and Technology* 5(3): 1–55. DOI: 10.1145/2629592

Zhu X and Freeman MA (2019) An evaluation of U.S. municipal open data portals: a user interaction framework. *Journal of the Association for Information Science and Technology* 70(1): 27–37. DOI: 10.1002/asi.24081

---

## Author Biographies

**Meng Cai** is a PhD candidate in urban and regional planning at Michigan State University. She works as a research associate in the Institute of Transport Planning and Traffic Engineering at the Technical University of Darmstadt. Her research interests lie in the intersection of urban sustainability, transformative technologies, and computational methods.

**Huiqing Huang** is a geographer, urban planner, and Python programmer. He received a Master of urban and regional planning from Michigan State University. He is currently working as a data engineer in an autonomous vehicle high-definition map company. He is passionate to apply urban planning theory to solve practical problems with the aid of geocomputation.

**Travis Decaminada** is a doctoral student at the University of Pennsylvania, Weitzman School of Design. Travis holds both a B.S. in geography from Eastern Michigan University as well as a master's degree in urban and regional planning from Michigan State University. Travis' research interests center around the interface between technology, transportation, and nature – working on novel means to limit biodiversity loss on American roads. Perhaps expectedly, when Travis is not reading or writing he can often be found playing city-building video games, or pestering his cats.

---

**Corresponding author:**
Meng Cai, School of Planning, Design and Construction, Michigan State University, 552 W Circle Dr, East Lansing, MI 48824, USA.
Email: caimeng2@msu.edu

Data Availability Statement included at the end of the article
