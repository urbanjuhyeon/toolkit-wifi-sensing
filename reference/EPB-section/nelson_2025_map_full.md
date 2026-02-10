# MAP: Mapping accessibility for ethically informed urban planning

**Authors**: Ruth Nelson, Martijn Warnier and Trivik Verma

**Journal**: EPB: Urban Analytics and City Science, 2025, Vol. 0(0) 1–9

**DOI**: 10.1177/23998083251387382

**Type**: Open Source Software - Python notebooks for spatial justice in accessibility analysis

---

## Abstract

Evaluating accessibility based on multiple notions of justice allows for a multi-perspective analysis of the trade-offs between the benefits and burdens associated with the provision of infrastructure. This presents a challenge due to a lack of metrics which operationalise multiple notions of justice for comparative purposes. It is further complicated by the reliance on General Transit Feed Specification (GTFS) data to do many kinds of accessibility analyses, which is often not freely available and accessible, especially in data scarce regions. This paper presents the MAP open-source software package that allows for the incorporation of multiple notions of justice in accessibility analysis. Firstly, MAP supports the development of an Urban Network Model based on open-access data. Secondly, using this model it enables the calculation of Neighbourhood Reach Centrality, a cumulative accessibility metric. Finally, it allows for the evaluation of accessibility based on three comparative metrics of spatial justice visualised through maps. For illustrative purposes, data sets from the City of Cape Town in South Africa are provided as a ready-to-use data-product. This software package offers an efficient method for incorporating spatial justice considerations into accessibility analysis offering the potential to be used as a boundary object within interdisciplinary teams of researchers, policy-analysts, transport engineers, and other stakeholders.

**Keywords**: accessibility, open-data, spatial justice, Cape Town, transport

---

## Introduction

Disparities in accessibility make it challenging for people to break out of a cycle of poverty, leading to the reproduction of disadvantage from one generation to the next. A person's accessibility can be understood as the social-economic opportunities they derive from their proximity to places such as employment, healthcare and educational facilities (Geurs and Van Wee, 2004). Ethical principles have historically been employed by philosophers to guide thinking about reshaping society towards more fair and equitable outcomes. Many ethical theories exist which define fairness differently. Over the last 10 years, there has been growing concern to operationalise different theories into metrics to evaluate equity of accessibility (i.e. Golub and Martens 2014; Lucas et al., 2016).

However, the operationalisation of different metrics has tended to be based on the adaption of existing high-level indices from economics, such as the Gini Index and they have rarely been designed so that different metrics, based on different notions of fairness, can be compared within a single comparative framework. The advantage of placing different metrics based on different notions of fairness, justice or equity into a single comparative framework is that it allows the stakeholder, researcher or policymaker to explicitly focus on fairness from different perspectives and to visualise and compare the trade-offs between them. Equity is a contested notion, without one singular definition, representing a balance between competing ethical principles (Peyton, 1994). While it may not be possible to achieve complete equity or equality in access due to the inherent limitations of urban growth, a fundamental purpose of urban policy is to guide efforts towards more equitable and just urban and transportation development (Delbosc, 2011; Litman, 2022). There is thus a need to include equity considerations within transportation appraisals, to support ethically informed decisions and enable debate amongst stakeholders.

In this paper, the MAP: Mapping Accessibility for Ethically Informed Urban Planning software package is described, which was developed initially to support research conducted by Nelson et al. (2025). The notebooks provided in the software package are written in Python and can be adapted to a researcher/stakeholder's own data for any context, but an example data set from Cape Town in South Africa is also made available for illustrative purposes. This package supports the creation of an urban network model (UNM) tailored towards specific urban regions. Such a tailored representative model links land use, transport and street networks into a large graph (see Figure 1(a)). Following this, it enables the calculation of Neighbourhood Reach Centrality, which is a cumulative accessibility metric that counts the number of opportunities reachable using different forms of transport within different time thresholds from each included neighbourhood (see Figure 1(b)). Finally, three metrics based on Egalitarian, Rawlsian and Utilitarian ideals are applied which allow for the evaluation of accessibility based on these principles (see Figure 1(c)). Whilst an Egalitarian approach prioritises policies which support equality, a Utilitarian perspective favours policies which maximise benefit for the greatest number of people (even at the cost of a minority) and a Rawlsian outlook supports policies that place an emphasis on the maximum benefit being derived for the most vulnerable (Fainstein and DeFilipp, 2016). These metrics are referred to as Equality Reach Gap, Rawls' Reach Gap and Utilitarian Reach Gap, as they focus on the difference between the existing and ideal access for a neighbourhood. The package could also be extended to include other conceptual notions of justice such as sufficientarianism (see Martens, 2016). The outcome of the package is a series of maps which visualise these metrics. These maps can be used as a boundary object within stakeholder engagement to integrate issues of spatial justice into the decision-making process. Boundary objects are artefacts, such as a map, image or narrative, which can be used to translate alternative viewpoints and initiate collaborations between divergent stakeholders (Star and Griesemer, 1989). Bridging different viewpoints and interests is necessary for future planning, which ultimately requires aligning different stakeholders in decision-making (Willems et al., 2022).

There are four main sections in this paper. The Data Requirements section contains an overview of the data requirements, followed by the Software Package Description which provides an explanation of the 4 different folders contained in the package. The Notebook Processes section maps the processes followed in each of the 6 example notebooks. Finally, the implications and use cases of the software package are considered within the Discussion.

---

## Data Requirements

This software package has been designed with specific sample data for illustrative purposes. The sample data contains datasets relating to the Metropolitan area of Cape Town in South Africa and can be accessed here. There are four data sets required, as described below. The exact structure of each data set can be found in the Metadata folder.

### Point of interest data

The land use data must be in point geometry format (i.e. shapefile/GeoJSON) and contain the points of interest that one is interested in calculating accessibility to. In the example data, places of employment are provided with the name of each type of place of employment and associated coordinates. Other examples of relevant points of interest are parks, healthcare and educational facilities.

### Transport data

For each transport mode, two separate files are required. The first file should be in shapefile/GeoJSON format and represent the routes of the transport network with columns for the names of the source station/stop, target station/stop, associated travel time for that route in minutes and line geometry. The second file should be in comma-separated values (csv) format, representing the stations or stops of the transport network. It would have columns for their associated names and x and y coordinates. For both files, it is important to ensure that the names of the stations/stops are unique and not duplicated. This can be verified in Python using the unique method and if they are not unique, a unique code should be assigned to each one. The example data sets contain data for both the MyCiti Bus Rapid Transit (BRT) and MetroRail train transportation networks in Cape Town.

MAP is specifically designed not to require General Transit Feed Specification (GTFS) data, as many countries do not have readily available transport data in this format. This allows for the utilisation of data in alternative formats, derived, for example, from official government sources, transport agencies, Google Routes API and OpenStreetMap. Google Routes API is a particularly useful resource for transport data, especially in relation to extracting travel times between stations/stops. If the user is in possession of GTFS data, for a specific transport mode, it can be simplified to the formats described in the previous paragraph by extracting the station/stop names, coordinates and average travel times. If a user aimed to model changing accessibility levels throughout the day based on GTFS data, multiple urban network models could be created using MAP from extracted travel times at different points in the day.

### Socio-economic data

The socio-economic data is linked to the neighbourhood administrative unit within a shapefile/GeoJSON file. The example data has columns for the name of each neighbourhood, total population, total population above 18, total population with a matric diploma (finished Grade 12), total employed population, population between the ages of 18 and 65, average income in Rands and polygon geometry.

---

## Software Package Description

The following section describes the four folders contained within the software package: the Metadata folder, Libraries folder, the Py folder and Notebooks folder, for which an overview is given in Figure S1 of the Supplemental Material (SM).

### Metadata folder

The Metadata folder contains two excel files. The first excel file is called Data Dictionaries and possesses data dictionaries which describe the contents, format and structure of each example dataset as well as the final vertices and edges created in the notebooks. Each data dictionary explains what each of the variables refers to in as well as the format of each variable, that is, string and float. The second excel file is called Notebook descriptions and contains a list of all example notebooks with a basic summary of their purpose.

### Py folder

This folder contains the spatial_justice.py file which possesses the Reach and Spatial Justice functions. This file is imported into the notebooks to calculate Neighbourhood Reach Centrality, Equality Reach Gap, Utilitarian Reach Gap and Rawls' Reach Gap.

### Libraries folder

This folder contains a markdown file with the list of Python packages which need to be installed prior to running the notebooks.

### Notebooks folder

This folder contains the Jupyter Notebooks containing Python code, for which there are three subfolders.

**Graph preparation.** This folder contains four example Jupyter Notebooks which have code for preparing the Urban Network Model. The Urban Network Model is essentially a large graph composed of a set of vertices and edges. The vertices possess coordinates representing the positions of street intersections, non-residential land use or transportation stops/stations. The edges, alternatively, represent the connections between the vertices, which are streets, transportation routes or a connection signifying an interchange between a street vertex and a land use or transportation vertex. Each edge is weighted by the time t it takes to traverse it by walking or public transport. Furthermore, we adopt a directed graph representation, meaning that all edges in the graph G have directionality.

**Reach calculations.** This is a folder which contains a Jupyter Notebook for calculating Neighbourhood Reach Centrality. Neighbourhood Reach Centrality is a cumulative accessibility metric which represents the number of opportunities, in this case, places of employment, that can be reached within a given time threshold T.

**Spatial justice calculations.** This contains the Jupyter notebook which calculates the Spatial Justice Metrics, which represent what the gap is between the existing and ideal Neighbourhood Reach Centrality for each neighbourhood based on interpretations of Egalitarian, Utilitarian and Rawlsian ethical principles.

---

## Notebook Processes

Whilst each notebook contains clear sections and comments describing what each line of code does, a broad overview of the processes followed in each notebook are summarised below, with an overview given in Figure S2 in the SM.

### Network A: Linking the road network and land use data

The purpose of Notebook A is to connect the land use data to street network data. The street network is downloaded from Open Street Map (OSM) in the form of a graph using the OSMnx library. The street network is converted into two GeoPanda DataFrames containing the edges and vertices. The land use data is loaded into the notebook as a GeoPanda DataFrame. The street vertices and land use vertices are concatenated into one DataFrame. Using the library SNKIT, each land use vertex is connected to the nearest street edge through the creation of a new connecting edge (labelled land use connectors) between the land use vertex and a newly created vertex on an existing street edge. Following this, both the edges and nodes are reduced to specific columns and given certain characteristics, to for example label each land use or street edge/vertex as such. The network is exported as edges and vertices in two separate shapefiles, which collectively are referred to as Network A.

### Notebook B: Linking the transport network/s

The overarching point of Notebook B is to link the transport vertices to Network A. The edges and vertices of Network A and the MyCiti BRT vertices are loaded into the notebook as DataFrames. Prior to connecting the BRT vertices to Network A, the land use connectors need to be separated from the streets so that the BRT vertices only connect to the nearest streets. The SNKIT library is used to link the BRT vertices to the street network through the creation of a connecting edge between each BRT vertex and a newly created vertex on an existing street edge. The previously separated edges and vertices are then rejoined with this network. The network is exported as edges and vertices in two separate shapefiles, which collectively are referred to as Network B. This notebook would be run for each transport network one needs to connect. In the case of the example data, it would be run twice to connect the BRT and Railway vertices.

### Notebook C: Concatenating the transport routes

The main purpose of Notebook C is to add the transportation routes to the edges from Notebook B. Prior to importing the Network B edges, the lengths of each edge are calculated in QGIS using the Field Calculator in the Attribute table. QGIS is an open-source Geographical Information Systems software. Although the lengths could be calculated in Python, it is more accurate in QGIS as it considers the curvature of the earth. The length of each edge is stored in a column called Length. The Network B edges and transport routes are loaded in as DataFrames and then concatenated together. A new column is added to the edge DataFrame called time-cost, and populated with the time it takes to traverse each edge through average walking time. Specific times are given to each connector edge, depending on whether it connects land use or transport to the street network.

### Notebook D: Creating two-way connector edges

The purpose of Notebook D is to create two-way edges for the connecting edges which were created in previous notebooks. The connecting edges are one-directional. They need to be two-directional as the final graph will be a directed graph representation, meaning that each edge has direction.

### Notebook E: Calculating Neighbourhood Reach Centrality

The purpose of Notebook E is to calculate the Neighbourhood Reach Centrality (NRC) for every single neighbourhood. The edges created in Notebook D, the vertices from Notebook C and the neighbourhood geometries are imported as separate DataFrames. The spatial_justice.py file is also imported.

The imported vertices are spatially joined with the neighbourhood geometries, to provide each vertex with the name of the neighbourhood in which it is positioned. The vertices and edges are transformed into a NetworkX graph. The target vertices are defined, which in the example are the employment vertices. The source vertices are defined as all vertices which are street vertices. The source vertices are grouped by neighbourhood, so that the NRC calculation is done from each neighbourhood, instead of each individual vertex, to enable the results to be linked to the socio-economic data.

The NRC values are calculated using the calculate_reach_centrality function imported from the py file. This function allows the counting of places of employment that can be reached within different overall time thresholds and a maximum walking time threshold. The NRC is calculated at 15, 30, 45 and 60 minutes for each neighbourhood. A new DataFrame is created with the reach values, socio-economic variable and geometries. The neighbourhood geometries are exported and saved.

### Notebook F: Spatial Justice Metrics

The purpose of Notebook F is to calculate Equality, Utilitarian and Rawls' Reach Gap. Each of these metrics operationalise three alternative ethical principles to evaluate accessibility at the neighbourhood scale (Nelson et al., 2025). The notebook encompasses a number of computational steps, which are summarised below.

- The neighbourhood geometries shapefile created in Notebook E and the spatial_justice.py file are imported.
- The socio-economic data is normalised between neighbourhoods to allow for relative comparisons between them.
- The equality, utility and rawls functions are imported from the spatial_justice.py file. These functions allow for the calculation of ideal access and the gap between the ideal and existing levels of access based on Egalitarian, Utilitarian and Rawlsian principles. In all three frameworks, a gap value of zero or greater indicates that a neighbourhood meets or exceeds the respective justice criterion. From an equality perspective, the ideal access for each neighbourhood is grounded in the principle of equality, which posits that all neighbourhoods should ideally have the same level of access to available opportunities (Nelson et al., 2025). Based on this framework, NRC is adjusted, by the equality function, so that each area is allocated an ideal level of accessibility equal to the average access. From a utilitarian perspective, access should be maximised for the neighbourhoods with the greatest populations (Nelson et al., 2025). Based on this, NRC is adjusted, by the utility function, to be proportional to the size of each neighbourhood's population. From a Rawlsian perspective, accessibility should be maximised for those who are most vulnerable (Fainstein, 2016: 263). Practically, this view holds that accessibility should be distributed in line with a neighbourhood's degree of vulnerability (Nelson et al., 2025). Access is reallocated proportionally, by the rawls function, to each area's vulnerability score. This score is a composite index and is a value between 0 and 1 based on the vul_score function which determines the average vulnerability level for each neighbourhood based on the included socio-economic indicators such as income, employment, and education levels.
- The final step involves visualising the results in maps for comparison.

---

## Discussion

The MAP software package presented in this paper aids in the operationalisation of metrics of spatial justice for comparative purposes to evaluate accessibility based on different notions of justice. The final outcome of the software package is a series of maps which visualise the evaluation of accessibility from different ethical perspectives at the neighbourhood scale, as shown in Figure 1(c). Whilst there are many software packages which allow for the calculation of accessibility, they are often based on GTFS data, of which many countries and transport agencies do not make readily available. There are limitations associated with open-access data, such as potential incompleteness or inaccuracies. However, when working in regions which are data scarce, they are a vital source of information.

This software package has the potential to enable justice considerations to be brought into processes of deliberation amongst different stakeholders within urban planning processes and facilitate new research projects, especially in regions with scarce data. The maps and insights generated by MAP can be utilised as a boundary object – a common reference point – to aid in the facilitation of integrating justice considerations into processes of stakeholder engagement and management. For future research, MAP can be adjusted to include additional metrics of spatial justice based on alternative ethical perspectives. It can also be utilised for educational purposes, to train the next generation of engineers and urban planners to incorporate equity into urban and transportation appraisals as a key consideration towards achieving the United Nations Sustainable Development Goals, particularly Goals 10 and 11.

---

## ORCID iD

Ruth Nelson: https://orcid.org/0000-0002-9474-2114

---

## Funding

The author(s) received no financial support for the research, authorship, and/or publication of this article.

---

## Declaration of conflicting interests

The author(s) declared no potential conflicts of interest with respect to the research, authorship, and/or publication of this article.

---

## Data Availability Statement

https://data.4tu.nl/datasets/c34ff74b-30ce-4ed2-9e45-1910ca3e3470

---

## Supplemental Material

Supplemental material for this article is available online.

---

## References

Delbosc A and Currie G (2011) The spatial context of transport disadvantage, social exclusion and well-being. *Journal of Transport Geography* 19: 1130–1137.

Fainstein S and DeFilipp J (2016) *Readings in Planning Theory*. 4th edition. Oxford: Wiley.

Geurs KT and Van Wee B (2004) Accessibility evaluation of land-use and transport strategies: review and research directions. *Journal of Transport Geography* 12: 127–140.

Golub A and Martens K (2014) Using principles of justice to assess the modal equity of regional transportation plans. *Journal of Transport Geography* 41: 10–20.

Litman T (2022) Evaluating transportation equity: guidance for incorporating distributional impacts in transport planning. *ITE* 92: 44–49.

Lucas K (2012) Transport and social exclusion: where are we now? Transport policy. *Transport Policy* 20: 105–113.

Martens K (2017) *Transport Justice: Designing Fair Transportation Systems*. New York: Routledge.

Nelson R, Warnier M and Verma T (2025) Ethically informed urban planning: measuring distributive spatial justice for neighbourhood accessibility.

Peyton Young H (1994) *Equity*. New Jersey: Princeton University Press.

Star S and Griesemer J (1989) Institutional ecology, 'Translations' and boundary objects: amateurs and professionals in Berkeley's museum of vertebrate zoology, 1907-39. *Social Studies of Science* 19: 387–420.

Willems JJ, van Popering-Verkerk J and van Eck L (2023) How boundary objects facilitate local climate adaptation networks: the cases of Amsterdam Rainproof and water sensitive Rotterdam. *Journal of Environmental Planning and Management* 66: 1513–1532.

---

## Author biographies

**Ruth Nelson** holds a PhD from the Delft University of Technology in the Netherlands specialised in urban inequalities and a Masters in Space Syntax from the University College London. Both her practice and research are embedded in system thinking approaches and evidence-based methods that draw on data science, digital technologies and AI, complex network science and urbanism. Her skills lie in linking data analysis and computational methods with decision making for urban planning and governance. Ruth is currently working as a data researcher for the City of Amsterdam to support policy making for mobility.

**Prof. dr. Martijn Warnier** is full Professor of Complex System Design at Delft University of Technology, the Netherlands. He holds a PhD degree in Computer Science from the Radboud University Nijmegen (2006). In his research Martijn studies complex emergent behavior in and of socio-technical systems, specifically of infrastructures such as power, transportation and ICT networks and the combination thereof. He employs multi-paradigm simulation modeling to study system aspects, such as robustness, resilience, efficiency and reliability and designs adaptive interventions that use self-organization techniques to improve the performance of a socio-technical system on these and other aspects such as empowerment, security and privacy of end-users.

**Trivik Verma** is a Professor of Just Urban Futures at Loughborough University, UK. His research focusses on cities, inequalities, and justice. He studies various challenges of urbanisation such as segregation, inequities in access and wellbeing, transport and energy poverty, and climate-related vulnerabilities. Although he is trained in computational methods like quantitative human geography, he uses any combination of methods that are useful for evidence-based research, participatory planning, and public engagement to identify pathways for just urban futures.
