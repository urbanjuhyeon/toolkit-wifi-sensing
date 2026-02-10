# The Walkable Accessibility Score (WAS): A spatially granular open-source measure of walkability for the continental US from 1997 to 2019

**Authors**: Kevin Credit1, Irene Farah2, Emily Talen3, Luc Anselin3 and Hassan Ghomrawi4

**Affiliations**:
1. National Centre for Geocomputation, Maynooth University, Maynooth, Ireland
2. Department of Urban & Regional Planning, University of Illinois Urbana-Champaign, Urbana-Champaign, USA
3. Social Sciences Division, University of Chicago, Chicago, USA
4. Heersink School of Medicine, University of Alabama at Birmingham, Birmingham, USA

**Journal**: EPB: Urban Analytics and City Science, 2025, Vol. 0(0) 1–13

**DOI**: 10.1177/23998083251377116

**Section**: Special Issue: Data/Code Products from the GISRUK Community

**Corresponding author**: Kevin Credit, National Centre for Geocomputation, Maynooth University, 2.21 Iontas Building, Maynooth, County Kildare W23 F2H6, Ireland. Email: Kevin.Credit@mu.ie

Data Availability Statement included at the end of the article

---

## Abstract

This paper describes a straightforward method for calculating an open-source Walkable Accessibility Score (WAS) that measures walkability at the block group scale based on walking distance to business establishments, schools, and parks. Exploratory analysis of the WAS reveals high concentrations of walkable accessibility in the centres of the densest and/or largest cities. Our optimised specification (decay = 0.008, upper = 800, k = 30) performs very well, achieving a Spearman rank correlation of 0.912 with proprietary Walk Score® values (for 2011). We provided pre-calculated data for each year from 1997 to 2019 and Python code for calculating the WAS at the project's GitHub repository. The method is particularly useful in that it uses simple Euclidean distance calculations, and thus can be run at scale on a laptop or personal computer.

**Keywords**: walkability, spatial analysis, accessibility, access score, POI data

---

## Introduction

Measuring walkability – the ability to access everyday services and amenities comfortably by foot – and its relationship to health, equity, the environment, and economic development has long been of interest to urban planners, urban designers, and researchers (Jacobs, 1961). This largely stems from the fact that urban development in the 20th-century – particularly in North America – focused almost exclusively on creating land use patterns and built environments that were conducive to widespread and easy travel by automobile. Unfortunately, this auto-orientation has produced numerous concomitant negative externalities for urban areas, including increased air pollution and greenhouse gas emissions (Fang et al., 2015; Frank et al., 2006), higher rates of obesity and low physical activity (De Nazelle et al., 2011; Lindström, 2008), and lack of access to employment opportunities (Kain, 1968; Kawabata, 2003; Lee et al., 2018; Ong and Houston, 2002).

Many of these negative externalities arise because the physical layout of the city structures people's transportation choices, life opportunities, and outcomes through proximity to various necessities and amenities. In a completely auto-oriented environment, lack of regular use of an automobile significantly restricts an individual's ability to reach the daily necessities and opportunities of life (Hägerstrand, 1970). A large body of research has measured the negative effects of disparities in access to fresh food and grocery stores (Beaulac et al., 2009; Wrigley et al., 2002), healthcare (Kwan, 2013; Saxon and Snow, 2020; Shi et al., 2005; Starfield et al., 2005), childcare (Van Ham and Mulder, 2005), green and blue space (Jarosz, 2022; White et al., 2021), and jobs (Andersson et al., 2018; Clampet-Lundquist and Massey 2008) that is a feature of most North American cities.

Widespread acknowledgement of the benefits of walkability (and dissatisfaction with auto-oriented sprawl) has fuelled a growing interest – both inside and outside of academia – in measuring walkable neighbourhoods, including recently popularised concepts such as the '15-min city' (Ewing and Cervero, 2010; Moreno et al., 2021; Talen and Koschinsky, 2013). This is often focused on accessibility metrics, including the 'gravity'-based access score, the floating catchment area (FCA) approach (and extensions), and the rational agent access model (Isard, 1960; Luo, 2004; Saxon and Snow, 2020; Wang and Luo, 2005; Luo and Qi, 2009; Wan et al., 2012). A number of useful open-source packages and resources aimed at measuring walkability have recently been created (Pereira and Herszenhut, 2023; Saxon et al., 2020). However, there is also interest in metrics that incorporate the pedestrian experience of walking (Harvey, 2022). For example, one particular methodological focus has been on the use of street level imagery to assess walkability (Wang et al., 2024). Studies link GIS and 3D virtual environments to provide a more pedestrian-focused measure of walkability (Ki et al., 2023). Audits using Google Street View images found that high-quality pedestrian infrastructure had a significant impact on urban walkability and accessibility (Koo et al., 2023).

However, while there is widespread interest in walkability, and the academic literature on walkability measurement and effect is robust, the fact remains that for many professional practitioners, members of the public, and researchers interested in studying walkability, employing current methods is beyond the scope of their available data and/or technical capabilities. The most well-known walkability measures, such as Walk Score® (https://www.walkscore.com/), a tool that estimates walkability based on the proximity of amenities to a given location, have been developed and provided by commercial entities. As Figure 1 shows, Walk Score® continues to enjoy widespread use among academics, despite concerns over the lack of purpose fit for many research questions (Brown et al., 2023; Frank et al., 2021). For proprietary reasons, the specific configuration of this metric is not made directly available to the public, although some information can be gleaned from the Walk Score® patent and methodology documents (Lerner et al., 2008; Walk Score, 2011). While some researchers have used the general principles of gravity-based accessibility and available insights from Walk Score® to develop walkability measures tailored to specific contexts (Zhou and Homma, 2022), there is a need for a direct assessment of Walk Score® data alongside various combinations of methodological parameters (e.g. distance decay functions and amenity weights). Such an analysis would clarify the exact features that Walk Score® (and similar metrics) captures and, perhaps more importantly, explore ways to make walkable accessibility methods more open-sourced, customisable for user-specific needs, and ultimately improved.

The purpose of this paper is to outline a flexible, open-source methodology for computing a Walkable Accessibility Score (WAS) – similar to the commercially available Walk Score® – that allows researchers to empirically operationalise walkability concepts. We then apply this method to create a comprehensive measure of walkability at the block group scale for the continental United States for every year from 1997 to 2019 and examine interesting spatial patterns and trends in the data. Ultimately, the goal of this project is to provide historical data and reproducible code as an open resource for academics, planners, and members of the public to use to study relationships and better understand their own neighbourhoods. The code to operationalise this method and a link to download the full set of aggregated WAS values at the block group level for the continental US from 1997 to 2019 are available at the project's GitHub repository.

---

## Methodology

Spatial accessibility metrics can generally be divided into two broad types: the floating catchment area (FCA) method and its various extensions (Luo, 2004; Saxon and Snow, 2020; Wang and Luo, 2005), and the gravity-based 'access score' (Isard, 1960). In both, the data are structured as demand units (i.e. where the population lives, often administrative areal units) and supply sites (i.e. the facilities where services are provided, often points of interest of some type), and the goal is to aggregate the accessibility from each demand unit to nearby supply sites. This means that the resulting aggregate measure of accessibility is ultimately a feature of the demand units rather than the supply sites.

Generally, the FCA family of methods considers the ratio of supply to demand and is thus most useful in contexts where limited or differential supply is a concern, for example, physician availability. However, in the walkability application this makes less sense; proximity to many nearby retail businesses improves the walkability of every nearby demand unit no matter the size of the total demand in the area. For this reason, we conceptualise walkability as a function purely of the amount of nearby supply sites using the 'access score' or 'gravity potential' method (Isard, 1960).

As shown in equation (1), the access score (a) for a given demand unit i (Census block groups, in this case) is simply the count of nearby supply sites j (out of a total k) discounted by some distance decay function g(dij) within a maximum distance threshold, and multiplied by an amenity weight w, that is some measure of the relative importance of each supply site:

$$a_i = \sum_j w_j g(d_{ij})$$ (1)

In developing a walkable accessibility score (WAS) for this study, we selected relevant walkable amenity types and adopted the general form of a logistic-based distance decay function, drawing from established literature (Cerin et al., 2007; Lee and Moudon, 2006; Lovasi et al., 2008; Vale and Pereira, 2017). In general, proximity to businesses that serve basic needs (such as grocery stores), retail shops, schools, parks, and food services tend to incentivise walking, and thus were included (Talen and Jeong, 2018). Table 1 shows the types of amenities we used in the paper, along with their associated North American Industrial Classification System (NAICS) codes and data sources. More information on these amenities is provided in Appendix A.1.

**Table 1.** Amenity types, NAICS codes, and data sources used in the calculation of the walkable accessibility score (WAS).

| Category | Amenities | NAICS | Source | Years |
|----------|-----------|-------|--------|-------|
| Basic needs | Grocery and liquor | 4451, 4453 | InfoUSA (Data Axle, 2024) | 1997–2019 |
| | Drug stores | 4461 | InfoUSA (Data Axle, 2024) | 1997–2019 |
| General amenities | Shopping (e.g. furniture, electronics, clothing) | 4421, 4431, 4481, 4482, 4483, 4511, 4531, 4532, 4539, 4523 | InfoUSA (Data Axle, 2024) | 1997–2019 |
| | Banks | 5221 | InfoUSA (Data Axle, 2024) | 1997–2019 |
| | Bookstores | 451211 | InfoUSA (Data Axle, 2024) | 1997–2019 |
| | Schools | NA | GreatSchools USA (GreatSchools.org, 2025) | 2011 |
| | Parks | NA | ArcGIS Online - USA Parks (ESRI, 2021) | 2021 |
| Food services | Accommodation and food services | 72 | InfoUSA (Data Axle, 2024) | 1997–2019 |
| | Bakeries | 311811 | InfoUSA (Data Axle, 2024) | 1997–2019 |

While the importance of varying amenity weights has been highlighted both in the Walk Score® methodology and in the literature (Brown et al., 2023; Lerner et al., 2008; Walk Score, 2011; Zhou and Homma, 2022), the choice of weights is often arbitrary (based on the needs of a particular user or context), so for this paper's primary comparison, we weighted all amenity types equally. We nevertheless added code to allow users to weight amenities according to their needs, with the default weighting being equal to 1. To preserve computational efficiency – and thus enhance the usability of the code for small-scale and non-enterprise users – we calculated distances between demand units and supply sites using Euclidean distance.

With the general form of the distance decay function, amenities, weights, and distance metric chosen, two remaining features need to be specified, which form the basis for the paper's analysis. The first is the choice of k-nearest amenities to sum over. In this paper, we run 93 tests to determine the optimal k value, computing the WAS for all multiples of five between 5 and 155, which allow us to assess the impact of the choice of k on the resulting score. Second, the specific parameters for the logistic distance decay function must be determined. The specific form of the logistic distance decay function g(dij) used here, shown in equation (2), was informed by the literature and the Walk Score® documentation (Lerner et al., 2008; Vale and Pereira, 2017; Walk Score, 2011):

$$g(d_{ij}) = 1 - \frac{1}{1 + e^{(\frac{upper}{180}) - (decay \times t_{ij})}}$$ (2)

In particular, the decay parameter, which influences the slope of the function, is set to 0.008 based on the Walk Score® methodology document (2011). tij is the travel time between block group i and amenities j, which is a direct transformation of the distance dij into seconds, assuming a 5 kph walking speed. The upper component of the equation relates to the 'intercept' of the logistic function. In this case, the value of upper corresponds very roughly to the midpoint (0.5 weight) in metres, as shown in Figure 2 for the three values we tested in this paper: 800, 1600, and 2400. The specification of upper also influences the minimum (<1% weight) and maximum (>1% weight) thresholds of the logistic decay function, so it is perhaps more easily thought of as the parameter that controls the 'upper' threshold of the function, beyond which amenities do not influence the accessibility metric.

---

## Results

The goal of the analysis is to test 93 total combinations of the k and upper parameters, calculated according to equations (1) and (2), against the 2011 'Street Smart' Walk Score®, to see which parameter combination best matches the Walk Score® data. The demand units for the test are the 2015 US block group centroids (for the 48 contiguous States), and the supply sites are the (equally weighted) amenities listed in Table 1 (see Appendix A.2 for a note about the comparison). As shown in Figure 3, we calculated the WAS for 93 combinations of k (every multiple of five between 5 and 155) and upper values (800, 1600, 2400) for the 48 contiguous states at the block group level, computing the Spearman rank correlation with the Street Smart Walk Score® data each time.

In the end, summing over the nearest 30 amenities with an upper value of 800 (1600 m decay threshold) provided a correlation of 0.911566, which is surprisingly large, especially given the fact that we used a simple Euclidean distance measure. The performance of our Euclidean distance-based metric is especially noteworthy given the difficulty in computing street network distances to large numbers of amenities at scale. Thus, these results show that for some purposes, using computational resources to extract street network distances is overkill, since the correlation with WalkScore® that we can achieve using Euclidean distance is already very high. In essence, this means that a user can calculate the WAS using this approach for hundreds of thousands of demand units and a large k on their laptop with a relatively simple piece of open-source code.

With the parameters for computing a high-performing open-source walkable accessibility score (WAS) identified (upper = 800, k = 30), we then used those to compute the WAS at the block group scale for the contiguous US for all years (1997-2019) for which we have relevant data available on amenities (i.e. InfoUSA). The measure ranges from 0 (no specified amenities within roughly 1600 m of the block group centroid) to 30 (all 30 of the nearest amenities are located within around 100 m of the block group centroid); the observed maximum value across the time span is 29.641. The full pre-computed dataset from 1997 to 2019 is available for download (as a CSV or shapefile) on the project's GitHub. Initial exploratory analysis of the data indicates that high values of the WAS using these parameters are generally concentrated in the centres of the country's densest and/or largest cities (with a few exceptions), as shown in Figure 4 and described in Appendix A.3.

---

## Conclusions and future directions

Beyond the ability to provide the aggregated WAS dataset as an open resource for researchers and the public, these data also offer a variety of interesting avenues for future research that we are just beginning to explore. Perhaps most fundamentally, further analysis of any systematic deviations between WAS (calculated using the parameters specified in this paper) and Street Smart Walk Score® is needed to further improve the fit of our open-source measure (while maintaining the computational efficiency of Euclidean distance). While 0.912 is a very high correlation, it is possible that further parameter tuning, including specifying amenity weights and including features of street network design (such as intersection density and average block length), might provide an even better fit. Certainly, the use of Euclidean distance, while computationally efficient, does not fully capture real-world pedestrian travel patterns, such as barriers or street network complexity, and thus it is possible that our measure may indicate 'high walkability' in areas with high levels of business establishment density that we would not typically associate with walkable urban environments from a conceptual or experiential perspective (e.g. a suburban shopping centre or mall). Also, while our method allows for flexible weighting of amenities and distance decay functions, different populations may have distinct needs and preferences that are not explicitly accounted for in the default specification. In our comparison, the uniform weighting of amenities may not reflect the varying importance of different destinations in different contexts.

Interestingly, our preliminary investigations that include the street network design variables intersection density and average block length – which are often identified as components of the Walk Score® methodology (Brown et al., 2023; Frank et al., 2021; Lerner et al., 2008; Walk Score, 2011) – do not appear to improve the correlation between WAS and Street Smart Walk Score®. Additionally, the inclusion of these street network design variables adds considerable complexity and computation time to the calculation of the WAS for the entire US (due to the need to query street networks). However, more work is needed to confirm whether these – or other – features might improve the performance of the open-source WAS in comparison to Street Smart Walk Score®.

Beyond that, there is also a need to conduct external validation of the WAS with more dynamic measures of walking behaviour, for example, footfall data. It is very likely that the true benchmark for the WAS should be some objective measure of walking behaviour (and/or satisfaction), rather than Walk Score®. As many have argued, despite its popularity, the proprietary Walk Score® may not actually capture the conceptual essence of walkability – or real walking behaviour – very well (Brown et al., 2023; Frank et al., 2021). This is a significant problem when we are not able to fully access the methodology used for calculating a given accessibility measure, as we have no way to modify or tweak it. However, given the open nature of the WAS methodology presented here – and the flexibility inherent in the code – any changes necessary to better match footfall data or other measures of walking behaviour can easily be incorporated and shared.

Finally, these data – as both dependent and independent variables – offer a number of interesting opportunities to examine important urban relationships, including the relationship between socio-economic factors and walkability, the causal impact of infrastructure investments on walkability, and spatio-temporal changes in walkability over time. In particular, an examination of the relationships between the WAS and specific urban retail typologies, gentrification, and density – and how these relationships evolve over time – would be quite interesting to conduct.

---

## ORCID iDs

Kevin Credit: https://orcid.org/0000-0002-3320-4670
Emily Talen: https://orcid.org/0000-0001-5539-9512

---

## Funding

The author(s) disclosed receipt of the following financial support for the research, authorship, and/or publication of this article: This work was funded, in part, under the National Institutes of Health (NIH) project number 5R01AR078342-03.

---

## Declaration of conflicting interests

The author(s) declared no potential conflicts of interest with respect to the research, authorship, and/or publication of this article.

---

## Data Availability Statement

Data is available at https://github.com/kcredit/Walkable-Accessibility-Score as part of the Walkable Accessibility Score project (Credit and Farah, n.d.).

---

## Notes

1. All code and calculations conducted in Python v.3.9.6. Specific packages used can be found on the GitHub repository for the project.
2. The 'Street Smart' version of Walk Score® incorporates network distance rather than straight-line (Euclidean) distance, accounting for actual walking paths and barriers.
3. n = 169,003 non-zero values.
4. In the Toy District of downtown Los Angeles, CA in 2001.

---

## References

[Full reference list from pages 10-12 of the original document]

---

## Author biographies

**Kevin Credit** is an Assistant Professor at the National Centre for Geocomputation at Maynooth University. His recent work uses quantitative approaches and large open-source datasets to look at topics such as the development of spatially explicit causal machine learning models, the impact of transit construction on carbon emissions, and the relationship between the built environment and commuting by mode.

**Irene Farah** is a Postdoctoral Research Associate of Urban and Regional Planning at the University of Illinois Urbana-Champaign. Using a wide array of methods, her research aims to shed light on the complex relationships between urban development, street economies, and organisational power to reflect on uneven power dynamics within cities and to visibilise populations that are often misunderstood and over simplified.

**Emily Talen** is Professor of Urbanism at the University of Chicago. Her research is devoted to urban design and the relationship between the built environment and social equity. Her books include: New Urbanism and American Planning, Design for Diversity, Urban Design Reclaimed, City Rules, and Retrofitting Sprawl: Addressing 70 Years of Failed Urban Form. She is the recipient of a Guggenheim Fellowship (2014-15), and is a Fellow of the American Institute of Certified Planners.

**Luc Anselin** is the Stein-Freiler Distinguished Service Professor of Sociology and the College at the University of Chicago. He is the developer of the SpaceStat and GeoDa software packages for spatial data analysis. He was elected Fellow of the Regional Science Association International in 2004 and was awarded their Walter Isard Prize in 2005 and William Alonso Memorial Prize in 2006. He was elected to the National Academy of Sciences in 2008 and the American Academy of Arts and Sciences in 2011.

**Hassan Ghomrawi** is an Associate Professor and Inaugural Vice Chair for Research and Innovation for the Department of Orthopaedic Surgery, as well as Associate Director for the Comprehensive Arthritis, Musculoskeletal, Bone and Autoimmunity Center (CAMBAC) at the University of Alabama-Birmingham. He is a surgical outcomes researcher and health economist with expertise in the use of algorithms and wearable technology to improve appropriateness of surgical care, decision-making and cost effectiveness of surgical intervention and medical devices.

---

## Appendix A

### A.1. Amenity data used

The specific amenities chosen for this analysis were based on the categorisation used in the published Walk Score® methodology (Walk Score, 2011). In terms of data sources, most of the amenity data come from InfoUSA – also known as Data Axle – which is a proprietary source of business establishment data that collects information on business locations, industrial classification, sales volume, size, and other characteristics (Data Axle, 2024). We collected school locations (from 2011) from GreatSchools.org (2025), which is a non-profit organisation that collects and provides information on school location and quality across the US. We also included the parks data (for 2021) from ESRI's ArcGIS Online open data portal (ESRI, 2021).

### A.2. A note on the comparison between WAS and Street Smart Walk Score®

It is important to note here that Walk Score® data are provided at a multi-scalar geography; for example, in dense urban areas the demand units are relatively small grid cells, while in less dense suburban areas they are (for example) Census tract centroids. For ease of interpretability and ability to match with other datasets, we systematically ran this paper's tests (and final dataset) at the block group scale only. However, given the flexibility of the approach outlined in this paper, any set of demand units and supply sites can be used.

### A.3. Exploratory analysis of the WAS from 1997 to 2019

Figure 4 indicates that 32 of the top 50 average WAS values from 1997 to 2019 by block group are located in Manhattan, NY (and one in Queens). The other cities appearing in top 50 are: San Francisco, CA (5), Los Angeles, CA (3), Boston, MA (2), Seattle, WA (2), Philadelphia, PA (1), Portland, OR (1), Glendale, CA (1), Coral Gables, FL (1), and Santa Fe, NM (1). In terms of the absolute change in WAS over this time span, the block groups with the biggest increases tend to be in suburban or exurban portions of large and/or fast-growing metropolitan regions, such as Las Vegas, NV, Columbus, OH, Chicago, IL, Phoenix, AZ, and Miami, FL. Perhaps unsurprisingly – because the WAS essentially reflects business establishment density – many of the biggest decreases show up in rural and disinvested urban areas across the Rust Belt and the rural South, including block groups in places like Glasgow, KY, Huntsville, AL, Oxford, AL, Detroit, MI, and Live Oak, FL.
