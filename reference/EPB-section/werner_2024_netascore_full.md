# Werner et al. (2024) - NetAScore: An open and extendible software for segment-scale bikeability and walkability

## Full Text Transcription

---

**Urban Data/Code**

EPB: Urban Analytics and City Science
2024, Vol. 0(0) 1–10
© The Author(s) 2024

Article reuse guidelines: sagepub.com/journals-permissions
DOI: 10.1177/23998083241293177
journals.sagepub.com/home/epb

---

# NetAScore: An open and extendible software for segment-scale bikeability and walkability

**Christian Werner, Robin Wendel, Dana Kaziyeva, Petra Stutz, Lucas van der Meer, Lea Effertz, Bernhard Zagel and Martin Loidl**

Paris Lodron University Salzburg, Austria

## Abstract

Systematic and reproducible analyses of walkability and bikeability are crucial for efficient and effective interventions to promote active mobility. Previous methods for segment-based walkability and bikeability are limited in applicability due to high data requirements, a constrained set of aspects considered, or are not openly available and adjustable. The lack of transparency, limited reproducibility, and the high effort required to re-implement customized and extended variants of such methods inhibit wider application and retard knowledge gain. The open source software NetAScore aims to fill this gap. It is based on open and widely available data, provides default mode profiles for modeling utilitarian bikeability and walkability, and is designed for customization. General applicability and suitability of the software and its underlying models were shown in two evaluation studies. Source code and documentation are available on GitHub and via doi.org/10.5281/zenodo.7695369.

**Keywords**
Bikeability, walkability, infrastructure suitability, level of service, open source software

---

## Introduction

Provision of adequate infrastructure is a prerequisite to facilitate and promote active mobility. Despite the increasing necessity to shift towards sustainable modes of transport, resources for implementing interventions are limited. Consequently, methods for analysis, monitoring and planning support should aim at improving efficiency while ensuring effectiveness of interventions. They should be applicable in a spatially inclusive and comprehensive way, without the need for time-consuming manual field work. While various approaches to capture bikeability and walkability have been proposed, including area-based and accessibility assessments (see Castañon and Ribeiro, 2021; Hasan et al., 2021; Kellstedt et al., 2021), we focus on the elementary, fine-grained level of road segment suitability. However, availability of data-driven models that assess infrastructure suitability for walking and cycling on segment scale is limited. For bikeability, besides others, methods such as LTS (Mekuria et al., 2012), BLOS (Highway Capacity Manual, 2010), or BikeScore (Redfin Corporation) were proposed. The methods by Bartzokas-Tsiompras et al. (2023); Koo et al. (2022) and Guzman et al. (2022) are examples for walkability assessments on segment scale. Detailed reviews are available for walkability (Hasan et al., 2021) and bikeability (Castañon and Ribeiro, 2021; Kellstedt et al., 2021). Still, present models bear limitations that restrain wider application: They either regard a minimum subset of indicators (e.g., Sorton and Walsh, 1994), depend on very specific and scarce input data (e.g., Highway Capacity Manual, 2010), require substantial manual effort (e.g., Hagen and Rynning, 2021), or are closed-source (e.g., Redfin Corporation, n.d). Especially the lack of transparency, limited adjustability of model parameters, and missing options to extend and further customize the models are barriers. Future research is required to address the individual and purpose-specific characteristics of bikeability and walkability to support inclusivity of our transport system. Therefore, openness, adjustability, and extendibility of models are crucial.

With this paper, we introduce NetAScore, an open source software for automated computation of segment-scale bikeability and walkability from open and widely available data sets. It targets several limitations of previous methods, supporting advances in open science within the domains of Urban Analytics, City Science, and Mobility. Results can inform assessment approaches that include accessibility or area-based metrics. By utilizing configuration files, general settings as well as model parameters can be customized, documented and shared. The software design also allows for individual extensions—that is, adding specific data sets and further indicators.

---

## Method

NetAScore uses data from OpenStreetMap by default but allows for additional data sets to be added if available. The model derives indicators (such as cycling infrastructure, speed limit, and greenness) from input data which are then combined into a joint suitability index per road segment. In standard configuration it computes an index for bikeability following Werner et al. (2024a) and for walkability based on Stutz et al. (2024). The foundational concept of an indicator-based assessment goes back to Loidl and Zagel (2014). The software is implemented in Python and relies on PostgreSQL for storing and processing (spatial) data. A Docker image is available that includes all required components. In the following subsections we describe data, workflow and implementation in more detail. For more information regarding the bikeability and walkability assessment methodology as well as indicator selection and default model parameters please refer to the respective papers: Werner et al. (2024a) for bikeability, and Stutz et al. (2024) for walkability.

### Data

NetAScore relies on a spatial graph representation of the transport network as essential input. It consists of nodes representing intersections, and edges which model the road segments linking intersections. Both are georeferenced to enable spatial operations. Using additional data layers, the software enriches the graph with information on spatial context. The present version of NetAScore uses edges of the graph as reference unit for assessment and index computation. The edges of the input network are expected to bear attributes that describe the type of infrastructure and its characteristics including access restrictions per mode.

The default, widely available, and most comprehensive data source for NetAScore is OpenStreetMap. Besides providing the graph representation of the transport network including geometric and descriptive edge attributes, it contains additional data layers such as building footprints, green space, and water bodies. The software is designed for extendibility to further network data sets. For use within Austria we implemented support for the Austrian authoritative road data set GIP.¹

For network graphs that do not contain elevation per node (e.g., OpenStreetMap), NetAScore derives it from a digital elevation model (DEM) as optional input. We recommend the use of terrain models with a spatial resolution of 10 m or finer.

Data providing information on the spatial context of each network edge, such as green space, water bodies, building footprints, pedestrian crossings, facilities, and (traffic) noise polygons can optionally be added. All of these except traffic noise are extracted from OpenStreetMap by default. However, custom data sets can be specified as input if needed. Further data layers may be added through extensions to the source code.

### Workflow

The workflow consists of 5 main steps which are shown in Figure 1.

First, network data is imported from local files or by querying OpenStreetMap data using the Overpass Turbo API.² If available and desired, optional data layers such as DEM and noise polygons are imported.

In the second step the network is preprocessed. The actions taken depend on the type of input dataset. For OpenStreetMap relevant features and attributes that represent the road network are retrieved followed by topological cleaning. During cleaning, intersections are corrected based on spatial proximity and attribute coherence of adjacent edges (i.e., overlapping intersections are merged). Input edges are split at intersections if needed to form a routable graph (while considering tunnels, bridges, and stacked layers) and dangling indoor links (e.g., partially mapped paths within buildings) are removed.

The next step computes indicator values for each edge based on all input data available. Results of this step serve as an abstraction layer from input data, maintaining common semantics across different input networks. Thus, their structure and attribute values are harmonized. In this step, access restrictions are assigned per transport mode and the indicators shown in Table 1 are computed for each edge. This step is again specific per network type. For OpenStreetMap most indicators are derived from (a combination of) OSM attributes. Greenness, water, buildings, facilities and crossings are computed through spatial joins with additional OSM layers. Gradient and noise depend on provision of respective input data sets which are then spatially joined with the road network. Spatial buffers are generated around road segment center line geometries for joining additional data layers. By default, buffer sizes range from 10 to 30 m to capture the road space with its immediate surroundings (10 m) or to further include the close environment (30 m). Details on how indicators are derived from input data can be found in the implementation code at sql/templates/osm_attributes.sql.j2.

---

## Figure 1. Workflow overview.

| import data | → | preprocess network | → | derive indicators | → | compute index | → | export data |
|-------------|---|-------------------|---|-------------------|---|---------------|---|-------------|
| • network dataset | | • filter features | | • add spatial context | | • assign numerical indicator values | | • output assessed network to file |
| • optional inputs | | • topological cleaning | | • assess attributes | | • compute joint index | | • nodes and edges |

---

## Table 1. Indicators derived from input data.

| Indicator | Value |
|-----------|-------|
| road category | primary, secondary, residential, service, calmed, non-motorized, path |
| bicycle infrastructure | bicycle way, mixed way, bicycle road, cyclestreet, bicycle lane, bus lane, shared lane, undefined, no |
| pedestrian infrastructure | pedestrian area, pedestrian way, mixed way, stairs, sidewalk, no |
| max speed | speed limit for motorized traffic |
| number of lanes | lane count of the road |
| gradient | steepness of the segment |
| pavement | asphalt, gravel, soft, cobble |
| stairs | presence of stairs (binary) |
| width | road width (or width of separate bicycle / pedestrian path) |
| designated route | whether it is part of a designated bicycle route (international, national, regional, local, unknown, no) |
| greenness | share of green space within 30 m buffer |
| water | presence of water bodies within 30 m buffer (binary) |
| noise | length-weighted average (traffic) noise level |
| buildings | share of building area within 20 m buffer |
| facilities | facilities per 100 m within 30 m buffer |
| crossings | pedestrian crossings per 100 m within 10 m buffer |

---

Index computation for each mode takes place in the next step. For this, raw numerical and categorical indicator values are first mapped to numerical values within the continuous unit interval [0.1]. These values represent the anticipated suitability associated with specific values of a single indicator, where 0.0 refers to unsuitable and 1.0 to very suitable infrastructure. Numerical indicator values are then combined into a joint, continuous suitability index per mode, computed as a weighted average. Unavailable indicators are omitted. The parametrization (i.e., default weights) is detailed on in the respective papers for walkability (Stutz et al., 2024) and bikeability (Werner et al., 2024a). To give a brief example, the bikeability index attributes the highest weight to road category, followed by the type of available bicycle infrastructure. Speed limit, gradient, road surface, and designated routes have equal contribution. For handling specific indicator combinations differently (i.e., to overwrite index values or indicator weights based on certain value combinations), custom value overrides can be defined. An exemplary override is defined for steep gravel sections as outlined in the definition of the bikeability model in Werner et al. (2024a). Resulting index values are continuous, ranging from 0.0 (lowest suitability) to 1.0 (highest suitability). As the step of index computation contains the core model logic, it is essential that all of its parameters can be customized as outlined in the Parametrization section.

The last step of the workflow it to export the assessed network including the computed index values and indicators.

### Parametrization

A key feature of NetAScore is its flexible parametrization. Besides enabling workflow settings to be stored and documented for better reproducibility, the focus lies on the definition of model parameters. All weights and numerical indicator value mappings are defined at one place, forming the reproducible, transparent, and sharable definition of mode profiles. Two default mode profiles are currently included in NetAScore: a parameter set for bikeability in examples/profile_bike.yml and one for walkability in examples/profile_walk.yml. These aim at generically describing infrastructure suitability for utilitarian cycling and walking.

### Implementation

The implementation of NetAScore is based on Python for workflow automation. It relies on a PostgreSQL database with the PostGIS extension for data storage and for (spatial) operations to compute indicators and the compound indices. Figure 2 provides an overview of the software architecture. To streamline the setup and use of NetAScore, we provide a containerized version as Docker image. With a docker compose configuration available, the full setup including a PostgreSQL database can be obtained and executed with one single command.

The software design and processing sequence follow the steps outlined in the Workflow section, with the import step subdivided into network (OSM), and optional file imports. All input and output files of NetAScore are stored in a data directory. The settings for controlling the automated workflow are defined in a settings file which is structured according to the processing steps outlined before. For a full documentation on available options please refer to the latest documentation on GitHub. The mode profile files defining model parameters are referenced from the settings file. This allows sharing reusable definitions of mode profiles as well as referencing the same profile definitions from various settings files. Examples are provided in the examples directory.

For ease of use, NetAScore can generate basic results for bikeability and walkability for city-scale areas of interest based on a place name as the only input. OpenStreetMap data is then queried using Overpass Turbo. However, elevation and consequently gradient will not be computed in such cases due to missing DEM input. GeoTIFF-based DEMs can manually be added and referenced in the settings file to enable gradient computation. The same applies to input data sets for optional data layers provided in GeoPackage format.

When working with a large area of interest (e.g., country-scale), OpenStreetMap data should be manually downloaded before in form of preprocessed subsets in OSM PBF or XML format, for example, from Geofabrik.³ This file can then be set as input in the settings file.

As NetAScore uses spatial operations for joining data layers, coordinate reference systems (CRS) need to be properly set in input files and defined in the settings file. If running the software based on OSM queries, it determines the appropriate UTM zone from the centroid of the given area of interest. All reprojections necessary are then handled by the automated workflow. In the current version (v1.1.0), only metric CRS are supported and will yield proper results.

---

## Figure 2. System overview.

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│  ┌─────────────┐                        ┌──────────────────┐   │
│  │ input files │────────┐               │     storage      │   │
│  └─────────────┘        │               └────────┬─────────┘   │
│  ┌─────────────┐        │                        │             │
│  │ output files│←───────┤                        ↓             │
│  └─────────────┘        │               ┌──────────────────┐   │
│  ┌─────────────┐        │               │ (geo-) processing│   │
│  │ settings file│───────┤               └──────────────────┘   │
│  └─────────────┘        │                        ↑             │
│  ┌─────────────┐        ↓               ┌────────┴─────────┐   │
│  │mode profile │───→┌────────────┐      │ spatial database │   │
│  │   files     │    │program logic│←───→│                  │   │
│  └─────────────┘    └────────────┘      └──────────────────┘   │
│       data directory      NetAScore                            │
└─────────────────────────────────────────────────────────────────┘
```

---

Workflow outputs are stored in a single GeoPackage file that contains the layers edge and node. Due to topological correction and preparation of a routable graph, the OSM id is not unique for edges. Therefore, edge_id is added as primary key. Column names with suffixes _ft and _tf refer to forward and backward direction along an edge. Computed index values are stored in index_name_ft and index_name_tf. The column index_name_robustness provides the sum of weights for all indicators that were available for the given edge. If activated in the settings file, index_name_explanation contains information on the influence of individual indicators.

More details, including a full list of dependencies, available settings, command line options, and a quick start guide are provided at github.com/plus-mobilitylab/netascore.

---

## Applicability and examples

Applicability of the NetAScore software and general suitability of the default models for bikeability and walkability were shown by Werner et al. (2024a) and Stutz et al. (2024). The walkability and bikeability indices were also successfully used as impedance in routing applications, which form the core of pedestrian and bicycle flow models (Kaziyeva et al., 2021, 2023). Figure 3 presents exemplary results for segment-based bikeability and walkability processed with v1.1.0 (Werner et al., 2024b). NetAScore output files for several areas of interest are provided online (Werner, 2024).

---

## Figure 3. Exemplary results for bikeability and walkability (Salzburg, Austria).

[Figure shows maps of Salzburg with bikeability (top row) and walkability (bottom row) indices displayed on road segments, with reference OSM basemap. Index classification ranges from ≤0.2 (red) to ≤1.0 (blue).]

Map data © OpenStreetMap contributors; Basemap: OSM/Carto

---

## Discussion and conclusions

The NetAScore software implements an automated workflow for assessing infrastructure suitability for active mobility on segment level. It provides default mode profiles for bikeability and walkability which were tested through evaluation studies. Core features encompass the flexibility, reproducibility, adaptability, and extensibility of the software which fill major gaps identified by Kellstedt et al. (2021). The use of OpenStreetMap data enables transferability of the method to various areas of interest. All of these features are important to allow for customized definitions of suitability which may depend on location, trip purpose, and individual requirements—for example, of most vulnerable road users. The software also sets a conceptual and technological foundation for interdisciplinary research to advance models, which was identified as important future direction by Hasan et al. (2021). We therefore encourage experimentation with different definitions of bikeability and walkability to represent more diverse perceptions of infrastructure suitability. This can contribute to achieving a more inclusive transport infrastructure. In contrast to previous approaches, NetAScore focuses on openness, transparency, and reproducibility combined with the use of open and widely available data. It creates the foundation for sharing customized and purpose-specific definitions of bikeability that can benefit the whole community in active mobility research.

Due to the lack of appropriate data, the software currently does not assess intersections. As these can be important for assessing overall route suitability, future research, and implementation should focus on filling this gap. For many practical applications the segment-based indices should be input to advanced assessment methods that consider network connectivity and accessibility.

Despite current limitations, researchers, planners, and the general public can benefit from the use of NetAScore through streamlining processes and providing well-targeted interventions that can better address inclusivity.

---

## Acknowledgments

We thank everyone who provided feedback, tested applications that utilize outputs of NetAScore and who contributed to the development of NetAScore. Special thanks to all participants of our evaluation studies for walkability and bikeability.

## Declaration of conflicting interests

The author(s) declared no potential conflicts of interest with respect to the research, authorship, and/or publication of this article.

## Funding

The author(s) disclosed receipt of the following financial support for the research, authorship, and/or publication of this article: This work was partly supported by Furthermore, funding of the following recent research projects supported the development of bikeability and walkability concepts as well as code development: SINUS (BMK, FFG No. 874070), POSITIM (BMK, FFG No. 873353) and On-Demand II (BMK and BMAW, FFG No. 880996).

## ORCID iDs

Christian Werner https://orcid.org/0000-0001-9406-9284
Dana Kaziyeva https://orcid.org/0000-0001-9616-009X

## Data availability statement

The latest version of the NetAScore software, its source code, as well as full documentation are available on GitHub and via doi.org/10.5281/zenodo.7695369. Exemplary data sets are available via doi.org/10.5281/zenodo.10886961

## Supplemental Material

Supplemental material for this article is available online.

## Notes

1. https://gip.gv.at/en/index.html.
2. https://overpass-turbo.eu.
3. https://download.geofabrik.de/.

---

## References

Bartzokas-Tsiompras A, Bakogiannis E and Nikitas A (2023) Global microscale walkability ratings and rankings: a novel composite indicator for 59 European city centres. *Journal of Transport Geography* 111: 103645. DOI: 10.1016/j.jtrangeo.2023.

Castañon UN and Ribeiro PJG (2021) Bikeability and emerging phenomena in cycling: exploratory analysis and review. *Sustainability* 13(4): 2394. DOI: 10.3390/su13042394.

Guzman LA, Arellana J and Castro WF (2022) Desirable streets for pedestrians: using a street-level index to assess walkability. *Transportation Research Part D: Transport and Environment* 111: 103462. DOI: 10.1016/j.trd.2022.103462.

Hagen OH and Rynning MK (2021) Promoting cycling through urban planning and development: a qualitative assessment of bikeability. *Urban, Planning and Transport Research* 9(1): 276–305. DOI: 10.1080/21650020.2021.1938195.

Hasan MM, Oh JS and Kwigizile V (2021) Exploring the trend of walkability measures by applying hierarchical clustering technique. *Journal of Transport & Health* 22: 101241. DOI: 10.1016/j.jth.2021.101241.

Highway Capacity Manual (2010) *Transportation research board of the national academies*. Washington, DC. Highway Capacity Manual.

Kaziyeva D, Loidl M and Wallentin G (2021) Simulating spatio-temporal patterns of bicycle flows with an agent-based model. *ISPRS International Journal of Geo-Information* 10(2): 88. DOI: 10.3390/ijgi10020088.

Kaziyeva D, Stutz P, Wallentin G, et al. (2023) Large-scale agent-based simulation model of pedestrian traffic flows. *Computers, Environment and Urban Systems* 105: 102021. DOI: 10.1016/j.compenvurbsys.2023.102021.

Kellstedt DK, Spengler JO, Foster M, et al. (2021) A scoping review of bikeability assessment methods. *Journal of Community Health* 46(1): 211–224. DOI: 10.1007/s10900-020-00846-4.

Koo BW, Guhathakurta S and Botchwey N (2022) Development and validation of automated microscale walkability audit method. *Health & Place* 73: 102733. DOI: 10.1016/j.healthplace.2021.102733.

Loidl M and Zagel B (2014) Assessing bicycle safety in multiple networks with different data models. *GI-Forum, Salzburg* 2: 144–154.

Mekuria M, Furth P and Nixon H (2012) *Low-Stress Bicycling and Network Connectivity*. San Jose, CA: Mineta Transportation Institute Publications.

Redfin Corporation (nd) Bike score methodology. https://www.walkscore.com/bike-score-methodology.shtml.

Sorton A and Walsh T (1994) Bicycle stress level as a tool to evaluate urban and suburban bicycle compatibility. *Transportation Research Record* 1438: 7–17.

Stutz P, Kaziyeva D, Traun C, et al. (2024) Indicator-based assessment model for walkable road networks. DOI: 10.5281/zenodo.10965969.

Werner C (2024) NetAScore examples. DOI: 10.5281/zenodo.10886962.

Werner C, van der Meer L, Kaziyeva D, et al. (2024a) Bikeability of road segments: an open, adjustable and extendible model. *Journal of Cycling and Micromobility Research* 2: 100040. DOI: 10.1016/j.jcmr.2024.100040.

Werner C, Wendel R, Kaziyeva D, et al. (2024b) NetAScore v1.1.0. Zenodo. DOI: 10.5281/zenodo.10888399.

---

## Author Biographies

**Christian Werner** is a PhD researcher at the Department of Geoinformatics, University of Salzburg. With an origin in digital media application development and design, he graduated in Applied Geoinformatics with a master thesis on geostatistical assessment of cyclist stress detected from physiological measurements. His research revolves around infrastructure suitability for active modes, morphology and spatial configuration of transport networks, and resulting systemic effects on sustainable mobility. He is interested in the development of methods to assess and optimize the interconnection between active mobility and public transport.

**Robin Wendel** is a geographer and geo-information scientist at Z_GIS, specializing in active mobility projects that utilize street network and environmental data for routing purposes. He is extensively involved in data management and modeling, having transitioned his workflows to spatially enabled databases for more efficient processing. With proficiency in server management, web development, and web mapping, Robin is experienced in addressing complex spatial challenges. His interest lies in exploring how technology can influence behavior changes towards more sustainable modes of transportation.

**Dana Kaziyeva** was a scientific staff member of the Mobility Lab research group at the University of Salzburg, who now works for the consulting and software company Triply. She studied ecology and geoinformatics in her Bachelor and Master programs. Her interests are in transport modelling and understanding human behaviour with the focus on bicycling and pedestrian mobility. Currently, her PhD topic is focused on spatial simulation of traffic flows using an agent-based modelling approach and GIS. In her every-day research activities, she is engaged with data management, analysis, and visualisation activities.

**Petra Stutz** is a scientific staff member at the Department of Geoinformatics, Z_GIS. She holds a Bachelor's degree in Geography and a Master's degree in Applied Geoinformatics from the University of Salzburg. She currently works for a distance learning program for GIS professionals. Previously, she was associated with the Mobility Research Lab, where she specialized in data analysis, conceptualizing healthy routing algorithms, and walkability research. Her main focus is on using GIS technology to promote active mobility and sustainable transportation solutions.

**Lucas van der Meer** is an early-career PhD researcher. He holds a bachelor in Environmental & Infrastructure Planning from the University of Groningen, and a combined master in Geospatial Technologies from the universities of Lisbon, Castellon, and Münster. He is particularly interested in the application of geospatial data science to address socio-technical challenges regarding sustainable mobility, transport accessibility and livable cities. Lucas is an advocate for reproducible science and has authored multiple open-source software packages.

**Lea Effertz** is a scientific staff member in the Mobility Lab research group at the University of Salzburg. She completed her Bachelor in Digitalisation-Innovation-Society (BSc.), wrote her bachelor thesis on the effects of mobility infrastructure on mode choice in a university context and is currently studying Applied Geoinformatics at the University of Salzburg. In her research she is currently interested in the effects of the suitability of mobility infrastructure for active modes, as well as assessing the differences between sustainability indicators set by governmental institutions.

**Dr. Bernhard Zagel** is senior scientist and division head at the Department of Geoinformatics at the University of Salzburg, Austria. He holds academic degrees in Geography and Geoinformatics and is senior advisor of the mobility research group at the department. His research focuses on the intersection between geographic information science and mobility. He is interested in the geospatial dimensions of transportation and the implications of human mobility and accessibility for sustainable transportation. His main approach to questions of mobility and sustainability is the development and application of GIS and spatial analysis techniques to extract information from mobility and geospatial data.

**Dr. Martin Loidl** is head of the Mobility Lab research group at the University of Salzburg. He has degrees in geography (with a major in planning) and geoinformatics. His PhD in applied geoinformatics revolved around spatial models of bicycling safety threats. In his research, Martin integrates domain expertise from various fields, in order to gain a better understanding of complex mobility systems. In this context, he is especially interested in sustainable mobility and the interrelation between the physical as well as social environment and mobility behavior.

---

**Corresponding author:**
Christian Werner, Department of Geoinformatics, University of Salzburg, Schillerstraße 30, Salzburg 5020, Austria.
Email: christian.werner@plus.ac.at
