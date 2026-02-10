# BikeNodePlanner: A data-driven decision support tool for bicycle node network planning

**Authors**: Anastassia Vybornova1,2, Ane Rahbek Vierø2,3, Kirsten Krogh Hansen4 and Michael Szell2,5

**Affiliations**:
1. Copenhagen Center for Social Data Science (SODAS), University of Copenhagen, Denmark
2. NEtwoRks, Data, & Society (NERDS), IT University of Copenhagen, Denmark
3. Department of People and Technology, Roskilde University, Roskilde, Denmark
4. Dansk Kyst- og Naturturisme (DKNT), Aabybro, Denmark
5. Complexity Science Hub Vienna, Vienna, Austria

**Journal**: EPB: Urban Analytics and City Science, 2025, Vol. 52(7) 1771–1780

**DOI**: 10.1177/23998083251355999

**Section**: Urban Data/Code

**Corresponding author**: Anastassia Vybornova, Copenhagen Center for Social Data Science (SODAS), University of Copenhagen, Øster Farimagsgade 5A, 1353 Copenhagen, Denmark. Email: anvy@itu.dk

Data Availability Statement included at the end of the article

---

## Links to GitHub repositories

- Main repository: https://www.github.com/anastassiavybornova/bike-node-planner (in the manuscript anonymized for submission, we refer to a snapshot of this repository that has been uploaded to Zenodo at: doi.org/10.5281/zenodo.14536130).
- Data for Denmark: https://www.github.com/anastassiavybornova/bike-node-planner-data-denmark (in the manuscript anonymized for submission, we refer to a snapshot of this repository that has been uploaded to Zenodo at: doi.org/10.5281/ zenodo.14536147).

---

## Abstract

A bicycle node network is a wayfinding system targeted at recreational cyclists, consisting of numbered signposts placed alongside already existing infrastructure. Bicycle node networks are becoming increasingly popular as they encourage sustainable tourism and rural cycling, while also being flexible and cost-effective to implement. However, the lack of a formalized methodology and data-driven tools for the planning of such networks is a hindrance to their adaptation on a larger scale. To address this need, we present the BikeNodePlanner: A fully open-source decision support tool, consisting of modular Python scripts to be run in the free and open-source geographic information system QGIS. The BikeNodePlanner allows the user to evaluate and compare bicycle node network plans through a wide range of metrics, such as land use, proximity to points of interest, and elevation across the network. The BikeNodePlanner provides data-driven decision support for bicycle node network planning and can hence be of great use for regional planning, cycling tourism, and the promotion of rural cycling.

**Keywords**: bicycle node networks, cycling tourism, rural cycling

---

## Bicycle node networks: Motivation, definition, and implementation

Recreational cycling is not only an enjoyable way to explore an area but also helps to popularize cycling among people who do not normally get around by bike, as a nudge to integrate cycling in one's everyday mobility (Boyer, 2018; Deenihan et al., 2013; Park et al., 2011). Cycling tourism can also decrease mass tourism's burden on environment and climate (Kamb et al., 2021; Kim and Michael Hall, 2022). To promote both recreational cycling and cycling tourism, local governments are increasingly interested in implementing bicycle node networks as a flexible and cost-effective measure. Although bicycle node networks are usually marketed for recreational cycling, they can also boost everyday cycling in rural areas (Deenihan et al., 2013; Schmidt et al., 2024).

A bicycle node network is a navigation system tailored to (daytrip) cyclist needs. Seen on a map, the network consists of a set of numbered locations (network nodes) that are connected by roads and paths (network edges) suitable for recreational cycling; and seen from a bicycle, the network consists of signposts placed at each of the nodes (Figure 1). The signposts direct the cyclist toward the neighboring nodes on the network. This network layout enables cyclists to plan their routes with maximum flexibility, according to individual needs and preferences. In contrast to many traditional long-haul cycling routes that usually only go from A to B, it allows for a variety of round trips and adjustable trip lengths.

Implementing a bicycle node network is done by installing signposts for cyclist wayfinding. It does thus not necessarily require upgrades to the road infrastructure, which makes it potentially much cheaper to implement than, for example, a network of protected bicycle paths. However, a necessary condition for a good quality bicycle node network is to include only road infrastructure that is suitable for recreational cycling. In addition, the bicycle node network should offer a variation of recreational experiences; provide access to services and amenities along the way; and finally, be safe and well-connected (DKNT, 2024). Hence, to plan such a network for an entire region—with millions of potential ways to place the nodes, and numerous constraining conditions—is a complicated logical puzzle. Solving this puzzle manually requires a large amount of human power and can be greatly facilitated by data-driven computational methods.

---

## Previous work on bicycle node network planning

The first bicycle node network was implemented in Belgium in the 1990s (DKNT, 2021a). The concept has since been popularized in several other countries, such as the Netherlands, Luxembourg, France, and Germany (Nederland Fietsland, 2023; NodeMapp, 2024; Province De Luxembourg, 2024), and is currently being implemented in Denmark (Caspersen and Præstholm, 2019; DKNT, 2024). However, there is very little research on bicycle node networks or recreational cycling networks, which is in line with the fact that rural cycling, in contrast to urban cycling, in general remains heavily understudied (Kircher et al., 2022; McAndrews et al., 2018; Scappini et al., 2022; Vierø and Szell, 2024). Most literature on cycling tourism and recreational cycling focuses on organizational management or developing attractions and facilities, and only addresses the network design problem through general guidelines (Aschauer et al., 2021; Caspersen and Præstholm, 2019; DKNT, 2021b; Weston et al., 2012; Wirsenius et al., 2021). Meanwhile, most literature on data-driven approaches to bicycle network planning is oriented toward adding protected bicycle infrastructure in urban environments for everyday cycling (Caggiani et al., 2019; Mauttone et al., 2017; Olmos et al., 2020; Ospina et al., 2022; Steinacker et al., 2022; Szell et al., 2022). Therefore, up to this date, bicycle node network planning remains a mostly manual process, which requires substantial resources from planners and policy-makers.

Only very few studies have so far aimed to develop methods specifically for recreational cycling or for bicycle node networks. One line of approaches uses mathematical multi-criteria optimization (Giovannini et al., 2017; Malucelli et al., 2015; Vansteenwegen et al., 2011; Zhu, 2022; Černá et al., 2014). Several other studies have documented multi-criteria planning heuristics using desktop GIS (Derek and Sikora, 2019; Scappini et al., 2022). While these studies are an important first step toward the popularization of bicycle node networks, they are not reproducible in their setup and therefore not directly applicable in planning or policy-making. Moreover, the studies do not consider network structure, which is a crucial factor for bicycle node network design. To the best of our knowledge, no data-driven decision support tools for bicycle node network planning are available. To address this need, we present the BikeNodePlanner.

---

## Introducing the BikeNodePlanner

The BikeNodePlanner is a fully open-source, reproducible PyQGIS tool for decision support in bicycle node network planning, designed for users with minimal experience using GIS software. The tool has been developed in collaboration with Dansk Kyst- og Naturturisme (DKNT) as part of a larger effort to implement a nationwide bicycle node network in Denmark (DKNT, 2021a), but can be applied to any study area in the world. The BikeNodePlanner takes as input (1) a design proposal for a bicycle node network (a spatial data set with network edges and nodes); and (2) additional, user-curated geospatial data on the study area (e.g., land use, location of amenities, and elevation). Based on this data, the BikeNodePlanner evaluates the design proposal based on best-practice design criteria for bicycle node networks, as synthesized by DKNT in their recently published handbook on bicycle node network planning (DKNT, 2024). The design criteria and the corresponding BikeNodePlanner evaluation steps are summarized in Table 1. Each design criterion corresponds to one customizable evaluation step in the BikeNodePlanner. The results can be explored interactively in QGIS. The BikeNodePlanner highlights areas where the network might need to be adjusted, allowing planners to verify whether the network proposal fits the guidelines, and highlighting areas where adjustments might be necessary. In Figure 2, we illustrate the main features of the BikeNodePlanner by example of results for the Fyn and Islands (Funen) region of Denmark. Fyn and Islands is also the first location in Denmark where the node network will be implemented at scale. An exploration of these results and their role for decision-making support is given in the Supplementary Information (SI). A detailed user guide with feature documentation and data specifications is available in the tool's GitHub repository: github.com/anastassiavybornova/bike-node-planner.

---

## Table 1. Overview of BikeNodePlanner features, following the bicycle node network planning guidelines by DKNT (DKNT, 2024).

| Attribute | Relevance | Quantification | BikeNodePlanner | Figure |
|-----------|-----------|----------------|-----------------|--------|
| Edge length | To allow for shorter recreational cycling trips and variation in possible routes | Ideal length: 1 – 5 km; maximum length: 10 km, for dead-ends, maximum length: 3 km | Shows edge lengths according to user-defined length thresholds | Figure 2a |
| Loop length | To allow for shorter recreational cycling trips and variation in possible routes | Ideal length for loops (shortest possible roundtrips): 8 – 20 km | Shows loop lengths according to user-defined length thresholds | Figure 2b |
| Disconnected components | The network should not have any disconnected components | Count | Identifies and shows separately all disconnected components | Figure 2c |
| Accessibility of facilities | Necessary facilities such as water, restrooms, and places to buy food should be easily accessible from the network | Toilets: Every 10 km; picnic areas: Every 5 km. Default distance threshold for reachable facilities: 100 m | For a user-defined maximum distance, shows all facilities that are within vs. outside of network reach | Figure 2d |
| Accessibility of services | The network should be well-connected to services such as camping sites and hotels to ensure easy access to overnight accommodation for people on multi-day trips | Default distance threshold for reachable services: 750 m | For a user-defined maximum distance, shows all services that are within vs. outside of network reach | Figure 2d |
| Variation in points of interest (POIs) | The network should connect to important POIs: Tourist destinations and locations of high recreational value | Default distance threshold for reachable POIs: 1500 m | For a user-defined maximum distance, shows all points of interest that are within vs. outside of network reach | Figure 2d |
| Variation in landscape | A guiding principle for the network planning is to ensure as much variation as possible. One element of variation is to route the network through many different types of landscapes and land use | – | For a user-defined maximum distance, and for each landscape (polygon) layer, shows all parts of the network that run through vs. outside of the layer | Figure 2e |
| Elevation | It is recommended not to include stretches with too steep slopes. In case of steeper slopes, they should be clearly marked when advertising the network | Slopes should not exceed 6% | For user-defined elevation thresholds, shows elevation for all network edges, separately highlighting edges that exceed the maximum slope threshold | Figure 2f |

---

## Workflow overview

Here, we provide a brief overview of the BikeNodePlanner, as illustrated in Figure 3. First, the user installs QGIS and additionally required Python libraries. Next, the evaluation is customized by filling out the configuration files and generating input data. All input data except the network itself is fully optional, so the BikeNodePlanner can be run independently of evaluation data availability. Now, the user can conduct a step-by-step evaluation of the input network by running the corresponding Python scripts from the QGIS Python console:

0. Verify that input data has been correctly provided.
1. Visualize input network and study area extent.
2. Evaluate network access with point and polygon data, with user-defined distance buffers.
3. Evaluate network slope, with a user-defined classification.
4. Evaluate network structure and display disconnected components.
5. Evaluate network edge lengths, with a user-defined classification.
6. Evaluate network loop lengths, with a user-defined classification.
7. Generate summary plots (incl. statistics) of all evaluation steps.
8. Export map visualizations of all evaluation steps.

All evaluation layers visualized by the BikeNodePlanner are also stored locally in .gpkg format. The modular nature of the tool, the detailed step-by-step instructions, and the documentation enhance accessibility for users without a programming or GIS software background, while maintaining a high degree of customizability.

---

## Conclusion

The BikeNodePlanner addresses the need for a decision support tool for bicycle node network planning that is open-source, customizable, and reproducible. As the first tool of its kind, it incorporates best-practice design criteria for bicycle node network planning (DKNT, 2024), including the structural characteristics of the network. Moreover, the BikeNodePlanner can help identify missing links in existing infrastructure, and therefore can be used to prioritize local improvements to bicycle infrastructure. Although iterative editing (live feedback with continuously updated evaluation results) has not yet been implemented, the tool provides a valuable source of information for planners and policy-makers. Future work—beyond the localized application of the BikeNodePlanner for selected use cases—could tackle the challenge of data-driven generation of design proposals for regional bicycle node networks; and focus on increasing network accessibility by public transport. Overall, the BikeNodePlanner is a major first step toward the consolidation of a systematic approach to bicycle node network planning. More broadly, our work contributes to the popularization of bicycle node networks, and to fostering sustainable cycling tourism and rural cycling.

---

## Reproducibility and technical specifications

The BikeNodePlanner has been developed on MacOS, and tested on both MacOS and Windows. All code is open-source and available under https://github.com/anastassiavybornova/bike-node-planner. By following the instructions provided on GitHub for data set preparation, the user can run the BikeNodePlanner workflow for any location. For Denmark, all data and code necessary to produce and preprocess the input data is available under github.com/anastassiavybornova/bike-node-planner-data-denmark.

---

## Acknowledgments

The authors would like to thank Clement Sebastiao, Trivik Verma, and all colleagues from DKNT, DCT, Folkersma, Septima, NIRAS, Faxe Kommune, and GeoFyn who contributed to this work with helpful feedback, ideas, and comments. We acknowledge support by the Danish Ministry of Transport (grant number: CP21-033).

---

## ORCID iDs

Anastassia Vybornova: https://orcid.org/0000-0001-6915-2561
Ane Rahbek Vierø: https://orcid.org/0000-0002-2404-7271
Michael Szell: https://orcid.org/0000-0003-3022-2483

---

## Declaration of conflicting interests

The author(s) declared no potential conflicts of interest with respect to the research, authorship, and/or publication of this article.

---

## Funding

The author(s) disclosed receipt of the following financial support for the research, authorship, and/or publication of this article: This work was support by the Danish Ministry of Transport, grant number: CP21-033.

---

## Data Availability Statement

Data sets analyzed in this study are available online at https://github.com/anastassiavybornova/bike-node-planner-data-denmark

---

## Notes

1. Danish Coast and Nature Tourism.
2. For Denmark, automated input data generation is available under github.com/anastassiavybornova/bike-node-planner-data-denmark. For all other study areas, input data must be provided manually; detailed data specifications are available in the BikeNodePlanner documentation (see README Step 3: Prepare your data).

---

## References

Aschauer F, Gauster J, Hartwig L, et al. (2021). Guidelines for sustainable bicycle tourism. Technical report, Universität für Bodenkultur Wien, Publisher: Zenodo Version Number: Version 1.1. https://zenodo.org/record/4812801

Boyer R (2018) Recreational bicycling as a "gateway" to utility bicycling: the case of Charlotte, NC. International Journal of Sustainable Transportation 12(6): 407–415. DOI: 10.1080/15568318.2017.1382622. https://www.sciencedirect.com/org/science/article/abs/pii/S1556831822001812

Caggiani L, Camporeale R, Binetti M, et al. (2019) An urban bikeway network design model for inclusive and equitable transport policies. Transportation Research Procedia 37: 59–66. DOI: 10.1016/j.trpro.2018.12.166. https://www.sciencedirect.com/science/article/pii/S2352146518305210

Caspersen O and Præstholm S. (2019) Rekreative stier og ruter - Erfaringer fra Tyskland, Holland, Schweiz, UK og Irland. Technical report, BARK Rådgivning A/S, Copenhagen.

Černá A, Černý J, Malucelli F, et al. (2014) Designing optimal routes for cycle-tourists. Transportation Research Procedia 3: 856–865. DOI: 10.1016/j.trpro.2014.10.064. URL. https://linkinghub.elsevier.com/retrieve/pii/S2352146514002270

Deenihan G, Caulfield B and O'Dwyer D (2013) Measuring the success of the great western greenway in Ireland. Tourism Management Perspectives 7: 73–82, URL. DOI: 10.1016/j.tmp.2013.03.004. https://www.sciencedirect.com/science/article/pii/S221197361300024X

Derek J and Sikora M (2019) Bicycle route planning using multiple criteria GIS analysis. In: 2019 International Conference on Software, Telecommunications and Computer Networks (SoftCOM), Pages 1–5, Split, Croatia, Sept. IEEE. DOI: 10.23919/SOFTCOM.2019.8903800. https://ieeexplore.ieee.org/document/8903800/

DKNT (2021a) Bedre vilkår for cykelturismen i danmark. Technical report, Dansk Kyst- og Naturturisme, URL. https://www.kystognaturturisme.dk/cykelknudepunkter

DKNT (2021b) Studie af rekreative netværk i fire europæiske lande. Technical report, Dansk Kyst- og Naturturisme.

DKNT (2024) Metodehåndbog - kommunal kvalificering af Danmarks rekreative cykelnetværk. Fra planlægningsnetværk til digital visning. Technical report, Dansk Kyst- og Naturturisme, Aabybro, URL. https://www.kystognaturturisme.dk/sites/kystognaturturisme.com/files/2024-05/Metodeh%C3%A5ndbog_bind2_web2.pdf

Giovannini A, Malucelli F and Nonato M (2017) Cycle-tourist network design. Transportation Research Procedia 22: 154–163. DOI: 10.1016/j.trpro.2017.03.022. URL. https://www.sciencedirect.com/science/article/pii/S2352146517301576

Kamb A, Lundberg E, Larsson J, et al. (2021) Potentials for reducing climate impact from tourism transport behavior. Journal of Sustainable Tourism 29(8): 1365–1382. DOI: 10.1080/09669582.2020.1855436.

Kim MJ and Michael Hall C (2022) Does active transport create a win-win situation for environmental and human health? The moderating effect of leisure and tourism activity. Journal of Hospitality and Tourism Management 52: 487–498. DOI: 10.1016/j.jhtm.2022.08.007. URL. https://www.sciencedirect.com/science/article/pii/S1447677022001516

Kircher K, Forward S and Wallén Warner H (2022) Cycling in rural areas : an overview of national and international literature. Statens väg- och transportforskningsinstitut, URL. https://urn.kb.se/resolve?urn=urn:nbn:se:vti:diva-18557

Malucelli F, Giovannini A and Nonato M (2015) Designing single origin-destination itineraries for several classes of cycle-tourists. Transportation Research Procedia 10: 413–422. DOI: 10.1016/j.trpro.2015.09.091. URL. https://www.sciencedirect.com/science/article/pii/S2352146515002781

Mauttone A, Mercadante G, Rabaza M, et al. (2017) Bicycle network design: model and solution algorithm. Transportation Research Procedia 27: 969–976. DOI: 10.1016/j.trpro.2017.12.119. URL. https://www.sciencedirect.com/science/article/pii/S2352146517310165

McAndrews C, Tabatabaie S and Litt JS (2018) Motivations and strategies for bicycle planning in rural, suburban, and low-density communities: the need for new best practices. Journal of the American Planning Association 84(2): 99–111. DOI: 10.1080/01944363.2018.1438849.

Nederland Fietsland (2023). Knooppuntroutes, URL. https://www.nederlandfietsland.nl/knooppuntroutes/

NodeMapp (2024) Cycling and hiking with nodes. URL. https://www.nodemapp.com/en

Olmos LE, Tadeo MS, Vlachogiannis D, et al. (2020) A data science framework for planning the growth of bicycle infrastructures. Transportation Research Part C: Emerging Technologies 115: 102640. DOI: 10.1016/j.trc.2020.102640. URL. https://linkinghub.elsevier.com/retrieve/pii/S0968090X19306436

Ospina JP, Duque JC, Botero-Fernandez V, et al. (2022) The maximal covering bicycle network design problem. Transportation Research Part A: Policy and Practice 159: 222–236. DOI: 10.1016/j.tra.2022.02.004. URL. https://www.sciencedirect.com/science/article/pii/S0965856422000325

Park H, Lee YJ, Shin HC, et al. (2011) Analyzing the time frame for the transition from leisure-cyclist to commuter-cyclist. Transportation 38(2): 305–319. DOI: 10.1007/s11116-010-9299-4.

Province de Luxembourg (2024) The node-to-node cycling network. URL. https://www.province.luxembourg.be/pointsnoeuds/cycling-node-network

Scappini B, Zucca V, Meloni I, et al. (2022) The regional cycle network of Sardinia: upgrading the accessibility of rural areas through a comprehensive island-wide cycle network. European Transport Research Review 14(1): 10. DOI: 10.1186/s12544-022-00533-6.

Schmidt T, Top Klein-Wengel T, Christiansen LB, et al. (2024) Identifying the potential for increasing cycling in Denmark: factors associated with short-distance and long-distance commuter cycling. Journal of Transport & Health 38: 101870. DOI: 10.1016/j.jth.2024.101870. URL. https://www.sciencedirect.com/science/article/pii/S2214140524001166

Steinacker C, Storch D-M, Timme M, et al. (2022) Demand-driven design of bicycle infrastructure networks for improved urban bikeability. Nature Computational Science 2: 1–10. DOI: 10.1038/s43588-022-00318-w. URL. https://www.nature.com/articles/s43588-022-00318-w

Szell M, Mimar S, Perlman T, et al. (2022) Growing urban bicycle networks. Scientific Reports 12(1): 6765, DOI: 10.1038/s41598-022-10783-y. URL. https://www.nature.com/articles/s41598-022-10783-y

Vansteenwegen P, Souffriau W and Oudheusden DV (2011) The orienteering problem: a survey. European Journal of Operational Research 209(1): 1–10. DOI: 10.1016/j.ejor.2010.03.045. URL. https://www.sciencedirect.com/science/article/pii/S0377221710002973

Vierø AR and Szell M (2024) Network analysis of the Danish bicycle infrastructure: bikeability across urban-rural divides, arXiv:2412.06083 [physics]. https://arxiv.org/abs/2412.06083

Weston R, Davies N, Lumsdon L, et al. (2012) The European Cycle Route Network EuroVelo - Challenges and Opportunities for Sustainable Tourism. European Parliament. https://www.europarl.europa.eu/thinktank/en/document/IPOL-TRAN_ET(2012)474569

Wirsenius P, Liljehov A, Petterson M, et al. (2021) Cykelleder för rekreation och turism. Technical Report 175, Trafikverket. https://www.diva-portal.org/smash/record.jsf?pid=diva2%3A1613574&dswid=-660

Zhu S (2022) Multi-objective route planning problem for cycle-tourists. Transportation Letters 14(3): 298–306. DOI: 10.1080/19427867.2020.1860355.

---

## Author biographies

**Anastassia Vybornova** is a postdoctoral researcher in Urban Data Science at the Copenhagen Center for Social Data Science (SODAS) at the University of Copenhagen and at the NEtwoRks, Data, and Society (NERDS) research group at the IT University of Copenhagen. Her current work focuses on sustainable mobility and the spatiality of social networks.

**Ane Rahbek Vierø** is a researcher at the Department for People and Technology at the University of Roskilde (RUC). Ane's expertise lies in GIS & Spatial Data, as well as mobility, cycling infrastructure and urban planning. Her current research focuses on large-scale bicycle network analysis, accessibility, and transport equity.

**Kirsten Krogh Hansen** is a consultant at Dansk Kyst- og Naturturisme (DKNT). Kirsten works at the intersection of nature conservation, experiences, health and tourism. She focuses on how nature prioritization, dissemination and sustainability perspectives can help create an important foundation for local development. At DKNT, Kirsten also spearheads the development of Denmark's upcoming cycle node network.

**Michael Szell** is an Associate Professor at at the NEtwoRks, Data, and Society (NERDS) research group at the IT University of Copenhagen. Michael is researching sustainable mobility and bicycle networks through network analysis, data science, and data visualization.
