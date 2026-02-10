# Huck (2025) - The QGIS Polygon Divider: Polygon partition into an irregular equal area grid

## Full Text Transcription

---

**Special Issue: Data/Code Products from the GISRUK Community**

**Urban Data/Code**

EPB: Urban Analytics and City Science
2025, Vol. 0(0) 1–9
© The Author(s) 2025

Article reuse guidelines: sagepub.com/journals-permissions
DOI: 10.1177/23998083251378340
journals.sagepub.com/home/epb

---

# The QGIS Polygon Divider: Polygon partition into an irregular equal area grid

**Jonathan Huck**^1
MCGIS, Department of Geography, The University of Manchester, UK

## Abstract

The QGIS 'Polygon Divider' plugin solves the problem of partitioning an arbitrarily complex polygon into an irregular grid of equal area rectangles, which has a range of applications for city science and GIS more broadly. This is achieved by the iterative partition of the polygon using cutlines that are located using Brent's method, which is an efficient optimisation algorithm. At the time of release, this was the only tool with such functionality in a major GIS platform, though the functionality has since been replicated.

**Keywords**
GIScience (geographical information science), spatial data, spatial representation

---

## Introduction

Polygon partitioning (i.e. subdivision based on some geometric criteria) is a popular topic in computational geometry, with common examples including triangulation (partitioning into triangles) and monotonic decomposition (partitioning into a set of monotonic polygons) (De Berg et al., 2008). This research presents an algorithm to partition an arbitrarily complex polygon into an irregular grid of equal area rectangles (i.e. '*equipartition*' into an irregular rectangular grid). The user can specify either the desired cell area, or the desired number of cells, which simply comprises partitioning into cells of size $A/n$, where $A$ is the area of the polygon. In the context of city science, this is particularly useful where the desired size of the divisions is smaller than available small area geographies, where the phenomena being studied does not relate to population demographics (e.g. urban heat island effect), or in settings where administrative divisions are not available (e.g. informal settlements).

Equipartition is an active area of research, though is rarely discussed in the context of city science or GIS applications. Existing applications in the literature are limited to the partition of convex polygons (e.g. Armaselu and Daescu, 2015; Guàrdia and Hurtado, 2005); or require that the partitions are connected to the polygon boundary (as in slicing a pizza; e.g. Abrahamsen and Rasmussen, 2025; Blagojević and Ziegler, 2014). Neither of these limitations are acceptable for GIS or city science applications. An alternative approach for equipartition into an irregular grid uses a point placement algorithm called 'Lloyd's Relaxation' (Deussen, 2009). This method constructs Voronoi polygons around a set of random points within the polygon, and then iteratively optimises the point locations to equalise the polygon areas (Campillo et al., 2024). However, the reliance on Voronoi polygons means that the polygon boundary is not preserved, as can be seen in Wood (2022), which again is unacceptable for most GIS applications.

At the time that the plugin was created, this functionality was not available in any major GIS software or library. A similar solution for polygon partition subdivision based on cutline optimisation using Brent's method had previously been implemented for ArcView 3.x by William Huber, but this also required that partitions are connected to the polygon boundary (as in slicing a loaf of bread). This tool is no longer available, though a description of the approach in an online forum provided the basis for the approach taken here (Huber, 2011). Since the release of the QGIS plugin, a similar tool has been added to ArcGIS Pro, but the documentation gives no explanation of the algorithm (ESRI, 2024).

---

## Algorithm description

The plugin can be installed from the official QGIS plugin repository using the QGIS Plugin Manager. To operate the plugin, the user simply uses the dialogue to set the input and output files, desired target area or number of divisions, cut direction (left to right, top to bottom, right to left, and bottom to top), tolerance (how close each polygon can be to the desired area), rotation (of the grid axes relative to the polygon), and whether 'offcuts' should be divided and absorbed into the partitions or left as a separate polygon. For example, if a user required to divide a polygon of 104 m² into subdivisions of 25 m², then the result could be either 4 polygons of 26 m² (where the 'Absorb Offcuts' checkbox is checked), or 4 polygons of 25 m² plus one 'offcut' of 4 m² (where it is unchecked). The user dialogue is shown in Figure 1.

---

## Figure 1. The dialogue window for the QGIS Polygon Divider Plugin.

[Figure shows a dialog window with the following elements:
- Title: "Polygon Divider"
- Input Layer: dropdown showing "gulu"
- Output File: text field showing "gulu_divided.gpkg" with browse button
- Target Area (in CRS Units): radio button selected, value "100000000"
- Number of Divisions: radio button unselected, value "20"
- Cut Direction: dropdown showing "left to right"
- Tolerance: text field showing "0.1"
- Clockwise rotation (in degrees): spinner showing "45.0000"
- Absorb Offcuts: checkbox checked
- Cancel and OK buttons]

---

The proposed method requires that the input polygon(s) must be projected using a two-dimensional Cartesian (x, y) coordinate reference system. The plugin attempts to detect geographical coordinate systems in the input layer and raises an error if one is found. Prior to the operation, all polygons in the input layer are placed into a queue, with any multi-polygons first separated and added to the queue individually. The polygons are then drawn from the queue in turn for partition, the first step of which is to take a 'slice' along one axis, the area of which is a multiplier of the target area ($n \cdot \alpha$, where $\alpha$ is the desired area and $n$ is the multiplier). In the second step, that 'slice' is then divided into $n$ polygons of area $\alpha$, which are appended to the output dataset. This method is operationalised using the algorithm illustrated in Figure 2.

---

## Figure 2. Diagram illustrating the algorithm.

[Figure shows a flowchart with the following structure:

Left side (main flow):
- INPUT POLYGON LAYER → SPLIT INTO SINGLE PARTS → NEXT POLYGON → ROTATION → SPLIT → OUTPUT PARTITION → APPEND TO OUTPUT → MORE POLYGONS? (YES loops back to NEXT POLYGON, NO proceeds to OUTPUT POLYGON LAYER)

Right side (Brent's Method subprocess):
- BRENT'S METHOD → IQI → SUCCESS? (YES → CHANGE DIRECTION which connects back to SPLIT, NO → SECANT) → SUCCESS? (YES → CHANGE DIRECTION, NO → BISECTION) → SUCCESS? (YES → dashed line to CHANGE DIRECTION, continues to) → INVERT ROTATION → OUTPUT POLYGON LAYER]

---

To achieve the above, the first task is to determine the target area of the initial 'slice'. The side length of a square of area $\alpha$ is calculated ($\sqrt{\alpha}$) and the area of a slice of this width cut from the specified side of the input polygon (as per the 'Cut Direction' option) is calculated. This value is then divided by $\alpha$ and rounded to the nearest whole number, which is the number of divisions ($n$) that should be included in the slice. A slice of area $n \cdot \alpha$ can then be split from the input polygon for further subdivision. The algorithm then proceeds along the slice perpendicular to the specified 'Cut Direction', cutting it $n - 1$ times into polygons of area $\alpha$, each of which is appended to the output dataset. This process is illustrated in Figure 3.

Equipartition is achieved by optimising the location of a *cutline* that is used to split the polygon. The optimisation technique is Brent's method (1971), which is a *function rooting* algorithm: for a given function $f(c)$, this method will approximate the value of $c$ such that $-\delta < f(c) < \delta$ (the function root), where $\delta$ is a threshold value (set by the user as *tolerance* in the dialogue). Brent's method is an improvement on an earlier method presented by Dekker (1969) and comprises three iterative approaches to function rooting, each of which provides a less efficient but more reliable fallback to the others if they fail. The first and most efficient approach in Brent's method is to use *inverse quadratic interpolation* (IQI) to find the function root by selecting three points on the function and calculating a 'sideways' Lagrange polynomial that passes through them. The polynomial is calculated 'sideways' (i.e. swapping x and y values in the Lagrange equations) so that it will intersect the x-axis at only one location. The x-intercept ($c$) is then located and the process is repeated to iteratively calculate new polynomials until the root is discovered.

However, the IQI method will fail if it encounters two equal values within its three points (e.g. $f(c_1) = f(c_2)$). In this case, the algorithm will fall back to the *secant* method, in which we construct a secant line between a pair of points on the function curve, one of which is on either side of 0 on the x-axis. $f(c)$ is then calculated, where $c$ is the location at which the secant line intersects the x-axis, and the point of the same sign is replaced with this new point. The process is then repeated until the root is discovered. However, the approach will fail if a secant line does not intersect the x-axis. In this case, the algorithm falls back to the *bisection* method, which is guaranteed to find the root, but is comparatively inefficient. This approach simply comprises selecting two points on the x-axis that enclose the root, bisecting the line between them at point $c$ and testing which pair of the resulting three points now enclose the root. This pair is then bisected in turn, and the process is repeated until the root is discovered. The algorithm returns to IQI and repeats the fallback process at each iteration, and the first iteration will always fall back to the *secant* or *bisection* only two points are initially defined. A more detailed explanation of this method, including further optimisations such as skipping the secant method when it is expected to fail, is beyond the scope of this manuscript, but the full details complete with a reference implementation is given in Brent (1971).

---

## Figure 3. An illustration of the approach to equipartition into an irregular rectangular grid, whereby (a) a large 'slice' is first extracted, and then (b) is further divided into polygons of the desired area (with the cut direction perpendicular to that in a).

[Figure shows two maps of what appears to be Gulu District, Uganda:

**Panel a**: Shows the district boundary with a gray shaded "slice" section on the left side of the polygon. A north arrow and scale bar (0, 10, 20 km) are shown.

**Panel b**: Shows the same district with the slice now divided into multiple equal-area rectangular sections (shown in pink/red), while the remaining polygon remains gray. Same north arrow and scale bar.]

---

To apply Brent's method to polygon subdivision, the function parameter ($c$) is a coordinate on the axis along which we are cutting (i.e. $x$ if cutting left-right and $y$ if cutting bottom-top). This coordinate is used to determine the position of a cutline that stretches across the bounding box of the input polygon perpendicular to the direction of cutting and is used to split the polygon using a standard geometric operator. The function is then defined as per equation (1).

$$f(c) = \alpha - \alpha_t \tag{1}$$

where $\alpha$ is the area of the polygon that was cut from the input polygon using the line defined by $c$, and $\alpha_t$ is the target area (such that $f(c) = 0$ where $\alpha = \alpha_t$). The creation of the cutline (cutting bottom to top) is illustrated in Figure 4(a). By applying the above process to each polygon in the input dataset, a polygon of arbitrary complexity can be equipartitioned into an irregular rectangular grid, as per Figure 4(b). The same operation with a 45° rotation applied is illustrated in Figure 4(c).

---

## Figure 4. (a) An illustration of the construction of a cutline moving from the bottom of the polygon. (b) The results of the QGIS Polygon Divider Plugin, equipartitioning the boundary of Gulu District (Uganda) into an irregular rectangular grid of 100,000 km² cells. (c) The results of the same division with a 45° rotation.

[Figure shows three maps:

**Panel a**: Diagram showing polygon with bounding box, a horizontal "Cutline" at position $c$ from the bottom, with the area below the cutline shaded gray.

**Panel b**: Map of Gulu District divided into an irregular grid of approximately equal-area rectangular cells (shown in pink/red), with north arrow and scale bar (0, 10, 20 km).

**Panel c**: Same district divided with a 45° rotation applied to the grid, creating diamond-shaped cells instead of rectangular ones. Same north arrow and scale bar.]

---

Brent's method is guaranteed to converge for functions that are computable within the interval of the two initial points (Brent, 2013). However, this condition is not necessarily met in the case of an arbitrarily complex polygon, as the relationship between the cutline coordinate and area can behave in a non-continuous manner in some geometries. One example of this can be illustrated by a horizontal cutline progressing downward from the top-left end of a 'W' shaped polygon (Figure 5). As the cutline passes the point in Figure 5(a), the area of the subdivision instantaneously increases (Figure 5(b)), resulting in a non-continuity in the function meaning that it does not intersect the x-axis, and hence has no root. This situation is resolved by simply changing the cut direction and resuming the partition operation, which allows the method to complete successfully.

---

## Figure 5. As the cutline moves from location $c = n$ (a) to location $c = n + 1$ (b), a discontinuity is created in the function $f$. The problem is resolved by simply changing the cut direction and resuming the operation.

[Figure shows two diagrams of a W-shaped polygon:

**Panel a**: Shows a W-shaped polygon with a horizontal cutline at position $c = n$. The "Cutline direction of travel" arrow points downward. The cutline is positioned just above the "peaks" of the W.

**Panel b**: Shows the same W-shaped polygon with the cutline moved to position $c = n + 1$, now below the peaks of the W. The area captured by the cutline has instantaneously increased as it passed the peaks, creating a discontinuity.]

---

The efficiency of this method is a composite of the cost of the function evaluation, which is $O(n)$; and the iteration complexity of Brent's method. In the worst case (i.e. where only bisection is used), this is $O\left(\log \frac{1}{\varepsilon}\right)$, where $\varepsilon$ is the specified tolerance. In practice, convergence is superlinear, with rate closer to $O\left(\log \log \frac{1}{\varepsilon}\right)$, although the asymptotic worst-case complexity remains $O\left(n \cdot \log \frac{1}{\varepsilon}\right)$. The convergence behaviour depends on the area function $f(c)$, which governs the relative use of IQI (order ≈1.84), secant (order ≈1.62), and bisection (order = 1.0).

---

## Conclusion

The algorithm was originally developed in support of a national methodology for litter monitoring in urban areas in Scotland (Zero Waste Scotland, 2018b), which is a legal requirement for UK duty bodies (e.g. local authorities) and statutory undertakers (e.g. railway operators) (UK Government, 1990; Zero Waste Scotland, 2018a). The software is used to partition all eligible land into 1000 m² zones, which are then classified and a subset selected for ongoing monitoring using a grading system (Zero Waste Scotland, 2018b). Other research applications of the algorithm in the urban planning literature includes analysis of transport accessibility (Wang et al., 2019), greenspace exposure (Labib et al., 2021), and urban habitat restoration (Boncourt et al., 2024). Given that the problem of polygon equipartition into an irregular grid is relatively fundamental to GIS, it has also found research applications beyond city science, including habitat diversity (Fernández-García et al., 2021), ecology (Huylenbroeck et al., 2021), and sustainable forestry planning (Picchio et al., 2020). Future developments will explore the potential to improve the efficiency of the algorithm, for example, through the use of alternative approaches to Brent's method (e.g. replacing IQI with using hyperbolic extrapolation, Bus and Dekker, 1975), or alternative approaches to function rooting (e.g. Ridders, 1979).

---

## Acknowledgements

The impetus for the creation of this tool came from my good friend Roy Ferguson. Financial support for the initial development of the plugin (for QGIS 2.x) was provided by *Zero Waste Scotland Ltd.* and for the upgrade to QGIS 3.x by *Deutsche Forestservice GmbH*. It has also been improved by feedback, suggestions, and contributions from other QGIS/GitHub users. The implementation of Brent's method is a modified version of that provided in the *pyroots* library, which is released under the BSD license (https://github.com/pmav99/pyroots). As described above, the approach taken in this software owes a great deal to the original idea and description provided by William Huber.

## ORCID iD

Jonathan Huck https://orcid.org/0000-0003-4295-3646

## Funding

The author(s) disclosed receipt of the following financial support for the research, authorship, and/or publication of this article: This work was supported by the Zero Waste Scotland Ltd; Deutsche Forestservice GmbH.

## Declaration of conflicting interests

The author(s) declared no potential conflicts of interest with respect to the research, authorship, and/or publication of this article.

## Data Availability Statement

The QGIS Polygon Divider is available for download in the QGIS Polygon Repository (https://plugins.qgis.org/plugins/Submission/). The source code is available on GitHub (https://github.com/jonnyhuck/RFCL-PolygonDivider) and issues (including suggestions and feature requests) can be raised at the same location.

---

## References

Abrahamsen M and Rasmussen NL (2025) Partitioning a polygon into small pieces. In: *Proceedings of the 2025 Annual ACM-SIAM Symposium on Discrete Algorithms (SODA)*. SIAM, 3562–3589.

Armaselu B and Daescu O (2015) Algorithms for fair partitioning of convex polygons. *Theoretical Computer Science* 607: 351–362.

Blagojević PV and Ziegler GM (2014) Convex equipartitions via equivariant obstruction theory. *Israel Journal of Mathematics* 200(1): 49–77.

Boncourt E, Bergès L, Alp M, et al. (2024) Riparian habitat connectivity restoration in an anthropized landscape: a multi-species approach based on landscape graph and soil bioengineering structures. *Environmental Management* 73(6): 1247–1264.

Brent RP (1971) An algorithm with guaranteed convergence for finding a zero of a function. *Computer Journal* 14(4): 422–425.

Brent RP (2013) *Algorithms for minimization without derivatives*. Courier Corporation.

Bus JC and Dekker TJ (1975) Two efficient algorithms with guaranteed convergence for finding a zero of a function. *ACM Transactions on Mathematical Software* 1(4): 330–345.

Campillo M, González-Lima MD and Uribe B (2024) An algorithmic approach to convex fair partitions of convex polygons. *MethodsX* 12: 102530.

de Berg M, Cheong O, van Kreveld M, et al. (2008) *Computational Geometry: Algorithms and Applications*. Springer.

Dekker TJ (1969) Finding a zero by means of successive linear interpolation. In: *Constructive Aspects of the Fundamental Theorem of Algebra 1*. Wiley-Interscience.

Deussen O (2009) Aesthetic placement of points using generalized lloyd relaxation. *CAe*. Citeseer: 123–128.

ESRI (2024) Subdivide polygon (data management). Available at: https://pro.arcgis.com/en/pro-app/latest/tool-reference/data-management/subdivide-polygon.htm

Fernández-García V, Marcos E, Fernández-Guisuraga JM, et al. (2021) Multiple endmember spectral mixture analysis (MESMA) applied to the study of habitat diversity in the fine-grained landscapes of the cantabrian Mountains. *Remote Sensing* 13(5): 979.

Guàrdia R and Hurtado F (2005) On the equipartition of plane convex bodies and convex polygons. *Journal of Geometry* 83: 32–45.

Huber WA (2011) Dividing polygon into specific sizes using ArcGIS desktop? Available at: https://gis.stackexchange.com/questions/5300/dividing-polygon-into-specific-sizes-using-arcgis-desktop/482706

Huylenbroeck L, Latte N, Lejeune P, et al. (2021) What factors shape spatial distribution of biomass in riparian forests? Insights from a LiDAR survey over a large area. *Forests* 12(3): 371.

Labib S, Huck JJ and Lindley S (2021) Modelling and mapping eye-level greenness visibility exposure using multi-source data at high spatial resolutions. *Science of the Total Environment* 755: 143050.

Picchio R, Latterini F, Mederski PS, et al. (2020) Applications of GIS-based software to improve the sustainability of a forwarding operation in central Italy. *Sustainability* 12(14): 5716.

Ridders C (1979) A new algorithm for computing a single root of a real continuous function. *IEEE Transactions on Circuits and Systems* 26(11): 979–980.

UK Government (1990) Environmental protection act 1990: section 89. Available at: https://www.legislation.gov.uk/ukpga/1990/43/section/89

Wang Z, Han Q and de Vries B (2019) Land use/land cover and accessibility: implications of the correlations for land use and transport planning. *Applied Spatial Analysis and Policy* 12: 923–940.

Wood J (2022) AVT: equalising regions. Available at: https://observablehq.com/@jwolondon/avtequalising

Zero Waste Scotland (2018a) Fulfilling duty 1: keeping land clear of litter and refuse. supporting advice for the code of practice on litter and refuse. Reportno. 1681397304, June 2018. Stirling, Zero Waste Scotland.

Zero Waste Scotland (2018b) Litter monitoring methodology: guidance for practitioners. Reportno. 1681397520. April 2018. Stirling, Zero Waste Scotland.

---

## Author biography

**Jonathan Huck** is Professor of Computational Geography at the University of Manchester. He maintains and contributes to a range of free and open source GIS software (including this one), and is currently a board member of OSGeo:UK. His primary research interests revolve around understanding uncertainty in GIS, which he applies to a range of topics including Landscape Ecology, Urban Segregation and Global Health.

---

**Corresponding author:**
Jonathan Huck, Department of Geography, The University of Manchester, Oxford Road, Manchester M13 9PL, UK.
Email: jonathan.huck@manchester.ac.uk
