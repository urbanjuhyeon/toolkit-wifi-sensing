# Warehouse CITY – An open data product for evaluating warehouse land-use in Southern California

Urban Data/Code

EPB: Urban Analytics and City Science
2024, Vol. 0(0) 1–9
© The Author(s) 2024

DOI: 10.1177/23998083241262553

**Susan A Phillips**
Pitzer College, USA
Robert Redford Conservancy for Southern California Sustainability at Pitzer College, USA

**Michael C McCarthy**
Pitzer College, USA
Radical Research LLC, USA

## Abstract

Warehouse CITY is an open data product used to visualize and quantify the cumulative impact of warehouses within Southern California. Community groups, researchers, planners, and local agencies apply this open data product in project approval processes, research, lawsuits, and education. Warehouse CITY estimates the cumulative impacts of warehouse counts, acreage, building footprint, heavy-duty truck trips, diesel particulate matter emissions, oxides of nitrogen emissions, carbon dioxide emissions, and jobs. The Warehouse CITY open data product and dashboard is available as a website and at a GitHub repository.

**Keywords**
Decision support, environmental impact, GIS, warehouses, cumulative impact

**Corresponding author:**
Michael C McCarthy, Environmental Analysis, Pitzer college, 1020 N Mills Ave, Claremont, CA 91711, USA.
Email: mikem@radicalresearch.llc

Data Availability Statement included at the end of the article

---

## Introduction

Warehousing and distribution facilities are a rapidly growing land-use in the United States and are an integral node in the global supply chain. Modern warehouses are industrial scale buildings that can attract thousands of daily vehicle trips and hundreds of daily heavy-duty truck trips from ports, railyards, and airports. Southern California has the largest agglomeration of warehouses in the United States because of its proximity to the highest-volume containerized port complex in the United States; the Port of Los Angeles ranks as the largest containerized port in the United States, with 9.9 million twenty-foot equivalent units (TEUs) in 2022; the Port of Long Beach is the third busiest with 9.1 million TEUs (Workbook: Monthly Container Port TEUs, 2023). The increasing containerized trade into Southern California Ports created a commensurate need for warehouse space to process and redistribute the freight.

In the 1980s, economists identified the Inland Empire (parts of Riverside and San Bernardino counties), as the primary location for warehouses in Southern California due to proximity to the ports (45 miles or 72 km), the region's abundant and cheap land, and a traditionally undereducated population (Flanigan, 2009; Husing, 2004). Freight vehicles (trucks, ships, locomotives, and off-road cargo handling equipment) are responsible for more than half of the emissions of oxides of nitrogen (NOX) in Southern California which exacerbates the nation's worst ozone air quality and exposes residents in inland counties to higher concentrations of diesel particulate matter from heavy-duty drayage truck trips to inland warehouses (Bluffstone and Ouderkirk, 2007; DeSouza et al., 2022; Yuan, 2018a). Additional negative externalities include greenhouse gas emissions, noise, traffic, loss of open-space and wildlife/plant habitat, increased heat, water runoff from impervious surfaces, and obstructed viewsheds. Ongoing warehouse land-use in the Inland Empire is an ongoing Environmental Justice issue (Bergmann and Solomun, 2021; Lara, 2018; Marshall et al., 2014; Patterson, 2014; Yuan, 2018b).

The California Environmental Quality Act (CEQA) environmental review process requires that lead agencies consider "cumulative impacts" under Cal. Code Regs. tit. 14 § 15355, 15065, and 15130. Cumulative impacts refer to two or more individual effects which, when considered together, are considerable or which compound or increase other environmental impacts. CEQA mandates that adequate impacts analysis should include a "list of past, present, and probable future projects producing related or cumulative impacts, including, if necessary, those projects outside the control of the agency" Cal. Code Regs. tit. 14 § 15130.

While broad in scope, cumulative impact analysis is weak in practice—a problem caused by the inaccessibility of data related to the existing warehouse footprints, emissions, and pending projects. For most Inland Empire warehouse and distribution projects CEQA cumulative impact documents provide incomplete, neighborhood-scale analysis of limited projects within a few km of the proposed project. Such analyses omit the regional and area-wide assessment of the regional-scale nature of the traffic, greenhouse gas, air quality, and watershed impacts.

Academic studies on Southern California warehouses generally rely on two datasets—a proprietary CoStar dataset (2305, 2021; DeSouza et al., 2022; Yuan, 2018a) or U.S. census zip code business patterns data (Dablanc et al., 2014; Jaller et al., 2022), now provided as the county business patterns. The CoStar database has detailed information but is proprietary and therefore cannot be shared. The census zip code business patterns data provides indirect information on the number of businesses in each NAICS sector, but doesn't provide high spatial resolution, nor does it indicate the size of the buildings or their proximity to residential homes and schools. In addition, parcel and zoning codes vary between jurisdictions and counties, making cumulative analysis beyond the capacity of environmental organizations, neighborhood groups, and most agency staff.

The lack of accessible information on warehouse land-use prompted the development of Warehouse CITY (Cumulative Impact Tool for communitY), a dashboard to visualize and quantify the collective warehouse footprint and its environmental impact in Southern California. The goal of this tool is to help community organizations, public agencies, and developers understand and quantify the cumulative impacts of existing and planned warehouses. Since its development, community groups, researchers, planners, and local agencies have used the tool in project approval processes, advocacy, research, lawsuits, and education. Warehouse CITY was used for expert testimony in a county redistricting case (Inland Empire United et al., v. County of Riverside et al., 2023). In this case, the tool was used to illustrate expert testimony that County redistricting was inconsistent with the requirements for majority-minority district boundaries due to the disproportionate impact of warehouses on Latino communities within the County of Riverside. In another example, the tool is being used for CEQA policy guidance in Southern California by the local air district (SCAQMD, 2024). The air district is using the tool to identify areas of industrial growth since 2018 to adjust CEQA cumulative significance threshholds related to cancer risk in those communities.

More difficult to track are many uses of the tool related in individual warehouse project and policies in public hearings (Moratorium discussion related to industrial projects rezoning, 2024; Moreno Valley City Council - Regular Meeting - Apr 18, 2023 6:00 PM, 2023). Local environmental justice groups and residents report utilizing the tool to conduct their own project analyses, and to present cumulative impact numbers to elected officials. This is because the lead agencies often present incomplete lists in their cumulative impact analysis.

---

## Methods

The Warehouse CITY dashboard is an open data product derived through publicly available heterogeneous open data sets generated for each county in the region. The primary basis of the dataset is open assessor parcel data provided by Los Angeles, Riverside, and San Bernardino Counties. Supplemental datasets to characterize warehouse and distribution center land-uses create a unified data structure. The R programming language powers the open data product (R Core Team, 2021).

### Overview

Data acquisition and processing steps used to create the Warehouse CITY dataset are shown schematically in Supplemental Figure S1. Individual processing occurs for each county to munge and characterize warehouse uses. Processing steps are available as part of the GitHub repository (McCarthy and Phillips, 2023).

### Data sources

Parcel data are obtained from publicly available data on warehouses maintained by the counties of Riverside, San Bernardino, and Los Angeles. Parcel data from Orange County is not publicly available. Data from the County websites are provided "as is" and have multiple limitations in their use for this application.

- Riverside County Open Data (Open Data, 2023).
- San Bernardino County Open Data (Countywide Parcels, 2023).
- Los Angeles County Open Data (Assessor Parcels Data 2006 thru 2021, 2023).

Multiple non-open datasets substitute for a parcel dataset to identify warehouse and distribution centers in Orange County. One data set of potential warehouses was obtained via personal communications with staff at OC Public Works, which was a subset of the larger Southern California Association of Governments industrial use dataset. A second dataset was geocoded using address locations from South Coast Air Quality Management District Rule 2305 board package Appendix C (SCAQMD, 2021) based on CoStar data and Orange County parcel polygons (County of Orange, CA, 2023). These datasets are combined.

Supplementary data files enhance the dataset for individual columns or records unavailable in the primary datasets. Datasets used include the land-use assessor codes for San Bernardino County, a list of manually identified mini-storage units, and DataTree information on year built for San Bernardino County parcels.

Jurisdictional boundaries are based on 2022 TIGER/Line place data (U.S. Census Bureau, 2022) and California open data portal county boundaries (CA Geographic Boundaries - California Open Data, 2023).

Emissions factor pollution estimates for heavy-duty trucks (GVWR >8,500 pounds) are generated from a VMT weighted calculation of EMFAC2021 based on Southern California fleet specific data for 2022.

Finally, planned and approved warehouse parcel polygons are either (1) GIS data-entry from project descriptions in CEQANET documents for industrial developments in Southern California, or (2) processed publicly available datasets from individual jurisdictions (Fontana, Moreno Valley, and Menifee, for example). Full processing information for the planned and approved warehouse category is available at its own GitHub repository (McCarthy, 2023). Open data product geospatial data files are available in shapefile, geojson, and native R formats in the Warehouse CITY subdirectory of the GitHub repository (McCarthy and Phillips, 2023).

### Data processing

Data processing and visualization used the R programming language; key packages required include sf, tidyverse, shiny, leaflet, DT, and markdown (Cheng et al., 2021; Pebesma, 2018; Wickham et al., 2019; Xie, Cheng, et al., 2023b; Xie, cre et al., 2023a). Processing steps and code are available at the GitHub repository for existing projects (McCarthy and Phillips, 2023). Planned and approved (but not yet on tax roll) warehouse processing steps are in a separate repository (McCarthy, 2023).

After import, the first step was to identify warehouse and distribution center parcels and filter the datasets to only include those records. For Riverside County, we identify warehouse parcels based on parcel use codes including the words "warehouse" and "light industrial." For San Bernardino County, we include land-use types of warehouse, flex, light industry, and storage. Los Angeles County parcels include the land-use category of "Warehousing, Distribution, and Storage." "Open Storage" is excluded. A process diagram and parcel counts by processing step are available in Supplemental Figure S1 and Supplemental Table S1.

Warehouses over one acre (4046 m²) based on an average floor area ratio (FAR) of 0.55 are displayed. Data processing steps include common record information where available, including the assessor parcel number (APN), area, year built, class, county, place, and the spatial geometry of the polygon. Class is a county specific land-use classification; category indicates whether the warehouse exists or whether a parcel is not yet constructed.

### Calculation factors

Geospatial polygons indicate warehouse footprints for building boundaries. The footprint area is the basis for estimates of warehouse size, truck traffic, air quality emissions, jobs generated, and operational greenhouse gas emissions from trucks attracted to the warehouse. Each calculation is an average engineering estimate; the results chain input values which can propagate uncertainty. Supplemental Table S2 displays the default user options, and the min-max value allowed in Warehouse CITY v1.18 for each of the options.

Parcel areas as reported in the assessor databases include space for parking lots, loading bays, and setbacks. Applying the floor area ratio (FAR) estimates average building size relative to parcel size as shown in Supplemental equation S1.

Default truck trip estimates are based on South Coast Air Quality Management District indirect warehouse source rule requirements for warehouses greater than 100,000 sq. ft. without truck trip counts Rule 2305 (SCAQMD, 2021). The calculation does not include estimates of vehicle idling, nor does it include passenger cars, light- and medium-duty trucks associated with warehouses, nor the railyard and airport facilities that warehouses often redistribute goods to.

Default diesel PM (exhaust), NOx, and CO2 emissions are based on EMFAC2021 v1.0.2 annual emission factors for heavy-duty trucks (GVWR >8,500 lbs) for the 2022 fleet year for South Coast AQMD region. Diesel PM2.5 emissions are 0.0000364 pounds per mile. NOx emissions are 0.0041 pounds per mile. CO2 emissions are 2.44 pounds per mile. The default average truck trip distance is 38 miles based on 2021 San Bernardino Streetlight Data as provided by San Bernardino County Transportation Authority (personal communication, 2022).

---

## Results

### Dashboard description

The dashboard is composed of four main parts—(1) user interface, (2) summary table, (3) map, and (4) a detailed table as shown in Figure 1.

**Figure 1.** Annotated Warehouse CITY visual dashboard user interface.

The (1) user interface is composed of standard and advanced input options. The standard options are composed of spatio-temporal selections—jurisdictions, warehouse build years, and a radius selection slider for a great circle distance analysis. Advanced user input options change the summary statistics calculation inputs, allowing advanced users to input non-default values for each of the computed "calculation factors" shown in Table S1.

The (2) summary table provides a summary of warehouse counts, acreage, floor space, daily truck trips, air pollutant emissions, and jobs. The summary table output displays the "existing" or "planned and approved" categories. Warehouse values for the planned and approved category include under construction projects, approved projects, and projects still in planning phases. We treat future warehouses and current warehouses identically in terms of calculations—these are not projections of future year emissions.

The (3) map shows individual warehouse parcels for primary warehouse clusters in Southern California. Existing individual warehouse footprints are colored red. Planned and approved warehouses are colored purple. Approved and planned projects are often warehouse complexes including multiple individual warehouses; the display usually shows a total footprint. For example, the 40.4 million square foot World Logistics Center in Moreno Valley will include over 40 individual warehouse buildings when fully built out. Within the map, additional active layers are available as optional overlays, including a rail layer and a CalEnviroScreen impact score layer. Clicking on the map draws a circle (default 5 km radius) which automatically selects warehouses that intersect with that circle; the summary table updates to display selected warehouse summary statistics.

Finally, the (4) detailed table lists all selected warehouses and warehouse complexes, arranged by descending footprint size. The detailed table is sortable by each category and searchable by each category. The detailed table reflects jurisdiction and circle selection choices.

The Warehouse CITY open data product of existing and pending warehouses allows users to generate holistic numbers of past, present, and future projects as mandated by CEQA. Users of the open data product engage in advocacy, organizing, and legal challenges by generating geospatial information about cumulative impacts in a reproducible, inclusive, and free data framework. The tool usually only hosts a few users at a time and has not resulted in any heavy-traffic issues. The ability to maintain updated lists of the current and pending warehouses by re-acquiring the parcel datasets and adding new projects is the most time-consuming part of the back-end process. This is slowly being operationalized through time. For now, this process requires continual vigilance due to the rapidity with which warehouse expansion occurs in our region.

In developing the tool, we learned a few key lessons. First, the tool greatly benefited from an internal peer review completed by subject matter experts at a local air quality district and an environmental consultant. They helped to improve the emissions calculations, described the lack of idling emissions, and suggested the advanced input options to allow user control in calculating emissions estimates. These specifically help when providing comment to public agencies who question the input assumptions, as the public agency has the option to input their own localized knowledge of FAR, truck trip lengths, or truck trip ratio estimates for a specified subset of the data. A second lesson was the importance of including export options for tables and figures, which is key for off-line public testimony and data sharing. A third lesson was the effectiveness of including political districts as a selection option to enhance the experience of state elected officials in examining warehouse growth in their districts. Finally, tracking planned and approved projects across jurisdictions provides effective information that is not otherwise readily available in any other free or accessible service.

---

## Concluding remarks

This paper summarizes the key features of the Warehouse CITY tool. The value in framing and creating this open data tool is to encourage conversations and decision-making using the best available data that is transparent and reproducible. Hundreds of individual jurisdictions in Southern California make decisions about individual warehouse projects. We hope this tool reframes the local and regional vision for right-sizing warehouse development in the metropolitan areas most impacted by warehouse land-use.

---

## Acknowledgments

We would like to thank our collaborators in the community and the students at Pitzer College who helped in developing this data product, especially Graham Brady. We would also thank our internal and external peer reviewers who made helpful comments in the development of this open data product.

## Declaration of conflicting interests

Authors have no conflicting financial interests in this work. Authors declare a nonfinancial interest due to our involvement in advocacy and litigation regarding warehousing and environmental justice issues.

## Funding

The author(s) received no financial support for the research, authorship, and/or publication of this article.

## ORCID iDs

Susan A. Phillips https://orcid.org/0000-0002-6193-8444
Michael C McCarthy https://orcid.org/0000-0003-4222-681X

## Data availability statement

The datasets generated during and/or analyzed during the current study are available from the corresponding author, from the website, and from the publicly accessible gitHub repository.

## Supplemental Material

Supplemental material for this article is available online.

---

## References

Assessor Parcels Data 2006 thru 2021 (2023). Available at: https://data.lacounty.gov/datasets/assessor-parcels-data-2006-thru-2021/explore

Bergmann R and Solomun S (2021) Diesel death zones in the amazon empire: environmental justice in algorithmically mediated work. AoIR Selected Papers of Internet Research 2021: AoIR2021. DOI: 10.5210/spir.v2021i0.12144.

Bluffstone RA and Ouderkirk B (2007) Warehouses, trucks, and PM2.5: human health and Logistics industry growth in the eastern inland Empire. Contemporary Economic Policy 25(1): 79–91.

CA Geographic Boundaries - California Open Data (2023). Available at: https://data.ca.gov/dataset/ca-geographic-boundaries

Cheng J, Sievert C, Chang W, et al. (2021) htmltools: tools for HTML. Manual, Available at: https://CRAN.R-project.org/package=htmltools

County of Orange (2023). CA. Available at: https://data-ocpw.opendata.arcgis.com/

Countywide Parcels (2023). Available at: https://open.sbcounty.gov/datasets/countywide-parcels/about

Dablanc L, Ogilvie S and Goodchild A (2014) Logistics sprawl: differential warehousing development patterns in Los Angeles, California, and Seattle, Washington. Transportation Research Record: Journal of the Transportation Research Board 2410(1): 105–112.

deSouza PN, Ballare S and Niemeier DA (2022) The environmental and traffic impacts of warehouses in southern California. Journal of Transport Geography 104: 103440.

Flanigan J (2009) Smile southern California, you're the center of the universe: the economy and people of a global region. In: Smile Southern California, You're the Center of the Universe. Redwood City: Stanford University Press. Available at: https://www.degruyter.com/document/doi/10.1515/9781503626546/html

Husing J (2004) Logistics and distribution: an answer to regional upward mobility. In: Report by Economics and Politics Inc. For SCAG. Los Angeles: SCAG.

Inland Empire United, et al., v. County of Riverside, et al. (2023) CVRI2202423.

Jaller M, Zhang X and Qian X (2022) Distribution facilities in California: a dynamic landscape and equity considerations. Journal of Transport and Land Use 15: 2022.

Lara JD (2018) Inland Shift: Race, Space, and Capital in Southern California. Berkeley: University of California Press.

Marshall JD, Swor KR and Nguyen NP (2014) Prioritizing environmental justice and equality: diesel emissions in southern California. Environmental Science and Technology 48(7): 4063–4068.

McCarthy M (2023) PlannedWarehouses. R. Available at: https://github.com/RadicalResearchLLC/PlannedWarehouses

McCarthy M and Phillips S (2023) WarehouseCITY. R. Available at: https://github.com/RadicalResearchLLC/WarehouseMap

Moratorium discussion related to industrial projects rezoning (2024). Perris, Available at: https://www.cityofperris.org/home/showpublisheddocument/17962/638442136693730000

Moreno Valley City Council - Regular Meeting - Apr 18, 2023 6:00 PM (2023). Available at: http://morenovalleyca.iqm2.com/Citizens/FileOpen.aspx?Type=14&ID=2495&Inline=True

Open Data (2023). Available at: https://gis2.rivco.org/

Patterson T (2014) From acorns to warehouses: historical political economy of southern California's inland Empire. Available at: https://www.routledge.com/From-Acorns-to-Warehouses-Historical-Political-Economy-of-Southern-Californias/Patterson/p/book/9781629580395

Pebesma E (2018) Simple features for R: standardized support for spatial vector data. The RUSI Journal 10(1): 439.

R Core Team (2021) R: A Language and Environment for Statistical Computing. Vienna, Austria: manual. Available at: https://www.R-project.org/

SCAQMD (2021) Rule 2305 - indirect warehouse source rule Governing Board Package. Available at: https://www.aqmd.gov/docs/default-source/Agendas/Governing-Board/2021/2021-May7-027.pdf?sfvrsn=10

SCAQMD (2024) Cumulative impacts for air toxics for CEQA projects. Available at: http://www.aqmd.gov/docs/default-source/ceqa/documents/wgm-5-20240320-final.pdf?sfvrsn=14

U.S. Census Bureau (2022) TIGER/Line Shapefiles. Suitland: U.S. Census Bureau.

Wickham H, Averick M, Bryan J, et al. (2019) Welcome to the tidyverse. Journal of Open Source Software 4(43): 1686.

Workbook: Monthly Container Port TEUs (2023). Available at: https://explore.dot.gov/views/MonthlyContainerPortTEUs/TEUs?%3AisGuestRedirectFromVizportal=y&%3Aembed=y

Xie Y, Allaire JJ, Horner J, et al. (2023a) markdown: render Markdown with 'commonmark'. Available at: https://cran.r-project.org/web/packages/markdown/index.html

Xie Y, Cheng J, Tan X, et al. (2023b) DT: a wrapper of the JavaScript library 'DataTables. Available at: https://cran.r-project.org/web/packages/DT/index.html

Yuan Q (2018a) Environmental justice in warehousing location: state of the art. Journal of Planning Literature 33(3): 287–298.

Yuan Q (2018b) Mega freight generators in my backyard: a longitudinal study of environmental justice in warehousing location. Land Use Policy 76: 130–143.

---

## Author biographies

**Susan Phillips** is a professor of environmental analysis and director of the Robert Redford Conservancy for Southern California Sustainability at Pitzer College. She is interested in participatory research and pedagogy, community-led strategies for equitable development, nature-based solutions to climate change, theories of violence and inequality, anarchic social forms, and intersections between urban history, material life, and the built environment. Phillips has studied gangs, graffiti, and the US prison system since 1990. Phillips received her Ph.D. in anthropology in 1998 from UCLA and is author of three books: Wallbangin: Graffiti and Gangs in L.A. (Chicago, 1999), Operation Fly Trap: Gangs, Drugs, and the Law (Chicago, 2012), and The City Beneath: A Century of Los Angeles Graffiti (Yale, 2019). Phillips has received numerous grants, including two Getty fellowships, a Soros Justice Media Fellowship, a short-term Huntington research fellowship, and a Harry Frank Guggenheim research grant for the study of violence.

**Michael McCarthy** is the sole proprietor at the environmental consulting firm Radical Research, LLC, an Adjunct Professor of Environmental Analysis at Pitzer College and Vice-chair of Riverside Neighbors Opposing Warehouses. Dr. McCarthy has 25 years of experience as an atmospheric scientist, 20 years of experience as an environmental consultant, and a little over a year of experience as a community activist and professor. His atmospheric science expertise includes near-road pollution gradients, health-risk assessments, spatio-temporal variability, source apportionment, emissions characterization, climate change, air toxics, isotopic compositions, and warehouse land-uses. Current research interests focus on applying statistical and geospatial visualization methods to quantify and characterize air quality issues surrounding goods movement.
