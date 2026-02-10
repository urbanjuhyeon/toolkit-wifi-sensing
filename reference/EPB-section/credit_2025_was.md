# The Walkable Accessibility Score (WAS): A spatially granular open-source measure of walkability for the continental US from 1997 to 2019

**Authors**: Kevin Credit, Irene Farah, Emily Talen, Luc Anselin and Hassan Ghomrawi

**Journal**: EPB: Urban Analytics and City Science, 2025, Vol. 0(0) 1–13

**DOI**: 10.1177/23998083251377116

**Type**: Open Data Product + Open Source Software - Walkability metric (Python)

---

## Summary

The Walkable Accessibility Score (WAS) is an open-source walkability metric that achieves 0.912 Spearman rank correlation with proprietary Walk Score® values using simple Euclidean distance calculations. The authors provide pre-calculated WAS data for the entire continental US at block group scale for every year from 1997 to 2019, plus reproducible Python code. The optimal specification (k=30 nearest amenities, upper=800m decay threshold, decay=0.008) uses gravity-based accessibility summing proximity to businesses, schools, and parks. The computational efficiency of Euclidean distance enables calculation on a laptop, making walkability analysis accessible to practitioners, academics, and the public without enterprise-level resources.

---

## Key Contributions

1. **Open-source alternative to Walk Score®**: First systematic comparison revealing that Euclidean distance achieves 0.91 correlation with Street Smart Walk Score®
2. **Computational efficiency**: Simple distance calculations enable continental-scale analysis on personal computers
3. **Historical longitudinal data**: Pre-calculated WAS for 1997-2019 (23 years) at block group level
4. **Reproducible methodology**: Complete Python code with customizable parameters (amenity weights, decay functions, k values)
5. **Empirical parameter optimization**: Tested 93 combinations of k (5-155 in steps of 5) and upper (800/1600/2400) to identify best fit
6. **Data accessibility**: GitHub repository with CSV/shapefile downloads and documentation

---

## Methodology

### Conceptual Framework

**Access score (gravity potential) approach** rather than FCA:
- FCA: Ratio of supply to demand (useful when supply is limited, e.g., physicians)
- Access score: Count of nearby supply discounted by distance decay (appropriate for walkability)

$$a_i = \sum_j w_j g(d_{ij})$$

Where:
- ai = accessibility score for demand unit i (block group)
- j = supply sites (amenities) out of total k
- wj = amenity weight (default = 1, equal weighting)
- g(dij) = distance decay function
- dij = Euclidean distance between i and j

### Distance Decay Function

**Logistic form** (based on Walk Score® methodology and literature):

$$g(d_{ij}) = 1 - \frac{1}{1 + e^{(\frac{upper}{180}) - (decay \times t_{ij})}}$$

Where:
- decay = 0.008 (from Walk Score® documentation)
- tij = travel time in seconds (distance dij ÷ 5 kph walking speed)
- upper = threshold parameter controlling decay range

**Parameter testing**:
- upper: 800, 1600, 2400 meters
- k: 5, 10, 15, ..., 155 (31 values × 3 upper values = 93 combinations)
- Best performance: upper=800, k=30 → ρ=0.911566 with Street Smart Walk Score®

---

## Data Sources

### Amenity Types (Table 1)

| Category | Amenities | Source | Years | NAICS |
|----------|-----------|--------|-------|-------|
| **Basic needs** | Grocery, liquor stores | InfoUSA | 1997-2019 | 4451, 4453 |
| | Drug stores | InfoUSA | 1997-2019 | 4461 |
| **General amenities** | Shopping (furniture, electronics, clothing) | InfoUSA | 1997-2019 | 4421, 4431, 4481-4483, 4511, 4531-4532, 4539, 4523 |
| | Banks | InfoUSA | 1997-2019 | 5221 |
| | Bookstores | InfoUSA | 1997-2019 | 451211 |
| | Schools | GreatSchools USA | 2011 | – |
| | Parks | ArcGIS Online | 2021 | – |
| **Food services** | Accommodation, food services | InfoUSA | 1997-2019 | 72 |
| | Bakeries | InfoUSA | 1997-2019 | 311811 |

### Demand Units
- **Geography**: Census block groups (2015 boundaries)
- **Coverage**: 48 contiguous US states
- **Non-zero values**: n = 169,003 block groups

---

## Results

### Parameter Optimization (Figure 3)

**Testing approach**: Spearman rank correlation with 2011 Street Smart Walk Score®

**Key findings**:
- upper=800 consistently outperforms 1600 and 2400
- Best k values: 25-40 (peak at k=30)
- ρ = 0.911566 at optimal specification (k=30, upper=800, decay=0.008)

**Interpretation**:
- upper=800 → ~1600m effective threshold (>1% weight)
- k=30 captures sufficient amenity diversity without overcounting
- Euclidean distance sufficient despite lacking network complexity

### Spatial Patterns (Figure 4, Appendix A.3)

**High WAS concentrations**:
- Manhattan, NY: 32 of top 50 block groups (1997-2019 average)
- Other top cities: San Francisco (5), Los Angeles (3), Boston (2), Seattle (2)

**Temporal changes**:
- Largest increases: Suburban/exurban areas of fast-growing metros (Las Vegas, Columbus, Phoenix, Miami)
- Largest decreases: Rural and disinvested urban areas (Rust Belt, rural South: Detroit, Glasgow KY, Huntsville AL)

**WAS range**:
- Minimum: 0 (no amenities within ~1600m)
- Theoretical maximum: 30 (all 30 nearest amenities within ~100m)
- Observed maximum: 29.641 (Toy District, downtown LA, 2001)

---

## Technical Specifications

### Software
- **Language**: Python 3.9.6
- **Distance metric**: Euclidean (computational efficiency)
- **Spatial units**: Block group centroids
- **Output formats**: CSV, Shapefile

### Computational Advantages
1. **No network routing required**: Euclidean distance vs network distance (0.91 correlation sufficient)
2. **Laptop-scale processing**: Hundreds of thousands of demand units processable on personal computers
3. **Scalability**: Continental US (48 states, 23 years) computed with modest resources

---

## Validation and Limitations

### Strengths
- **High correlation**: 0.912 with Walk Score® despite simpler methodology
- **Computational efficiency**: Enterprise-level analysis on consumer hardware
- **Transparency**: Full methodology disclosed, customizable parameters
- **Historical coverage**: 23 years of longitudinal data

### Limitations

**1. Euclidean distance simplification**:
- Does not account for pedestrian barriers (highways, water bodies, topography)
- May overestimate walkability in areas with street network complexity
- Could flag suburban shopping centers/malls as "high walkability" despite poor pedestrian experience

**2. Equal amenity weighting**:
- Default weights all amenity types equally (w=1)
- Different populations have varying needs (elderly, children, low-income)
- Context-specific weighting may be appropriate but arbitrary

**3. Street network design variables**:
- Intersection density and block length did NOT improve correlation with Walk Score®
- Adding network variables increases complexity and computation time
- Walk Score® may not actually rely on these features as much as claimed

**4. External validation needed**:
- Walk Score® itself may not capture true walkability or walking behavior
- Need validation against footfall data, pedestrian counts, or behavioral measures
- Proprietary benchmark limits ability to assess conceptual validity

**5. Data availability**:
- Schools: Only 2011 (GreatSchools)
- Parks: Only 2021 (ArcGIS Online)
- Temporal mismatch for non-InfoUSA amenities

---

## Future Directions

### Methodological Improvements
1. **Parameter tuning**: Further test amenity weights, decay functions
2. **Network integration**: Assess cost/benefit of network distance calculations
3. **Barrier identification**: Incorporate major pedestrian barriers (limited)
4. **Footfall validation**: Compare with actual walking behavior data

### Research Applications
1. **Socioeconomic relationships**: Walkability vs income, race, housing tenure
2. **Causal analysis**: Infrastructure investments → walkability changes
3. **Temporal dynamics**: Gentrification, retail typologies, density evolution
4. **Health outcomes**: Physical activity, obesity, chronic disease rates

---

## Data Availability

### GitHub Repository
- **URL**: github.com/kcredit/Walkable-Accessibility-Score
- **Pre-calculated data**: Block group WAS for 1997-2019 (CSV, shapefile)
- **Python code**: Full implementation with customization options
- **Documentation**: Data specifications, parameter descriptions, usage examples

---

## Relevance to Our Project

### Methodological Parallels
1. **Accessibility metrics**: Gravity-based approach similar to cumulative opportunities accessibility
2. **Parameter optimization**: Systematic testing of distance decay thresholds (like our 10min car / 30min transit)
3. **Computational efficiency**: Prioritizing scalability for large-scale analysis (entire US vs Korean cities)
4. **Open-source ethos**: Providing reproducible code and pre-calculated data
5. **Temporal coverage**: Longitudinal dataset enabling trend analysis (23 years vs our 4 years)

### Key Differences
- **Domain**: Walkability (pedestrian amenities) vs service accessibility (banks)
- **Distance metric**: Euclidean distance vs network-based routing (R5R)
- **Decay function**: Logistic decay vs travel time thresholds
- **Aggregation**: k-nearest weighted sum vs cumulative opportunities within threshold
- **Data source**: Business establishment database (InfoUSA) vs GTFS/OSM

### Lessons for Our Manuscript

**Validation strategy**:
1. **Benchmark comparison**: Compare against proprietary metric (Walk Score®) → We could compare against existing accessibility studies
2. **Parameter grid search**: Test 93 combinations systematically → Similar to our threshold sensitivity analysis
3. **Correlation metric**: Spearman rank correlation (appropriate for ordinal data)
4. **Honest limitations**: "0.912 is very high, but..." → Acknowledge what the metric does and doesn't capture

**Data product framing**:
1. **Pre-calculated datasets**: "Full dataset from 1997 to 2019 available for download" → We provide calculated accessibility metrics
2. **Code repository**: Complete implementation with clear documentation
3. **Reproducibility emphasis**: "Any set of demand units and supply sites can be used"
4. **User customization**: Default parameters but allow modification

**Computational efficiency narrative**:
1. **Scalability demonstration**: "Continental US on a laptop" validates methodological choices
2. **Tradeoff justification**: Euclidean distance achieves 0.91 correlation → computational cost of network distance not justified
3. **Accessibility to practitioners**: "Designed for users without enterprise resources"

**Longitudinal presentation**:
1. **Temporal patterns**: Figure 4 shows 1997-2019 average + change analysis
2. **Spatial concentration maps**: National overview + city close-ups
3. **Top performers**: Manhattan dominates (32/50 top blocks) → Similar to how Seoul dominates Korean accessibility

**Figure strategy**:
- Figure 1: Context (Walk Score® usage growth) → Could show GTFS/accessibility research growth
- Figure 2: Method visualization (decay functions) → Could visualize travel time thresholds
- Figure 3: Parameter optimization results → Similar to sensitivity analysis
- Figure 4: Spatial results (national map + city insets) → Similar to our multi-scale mapping

**Limitation honesty**:
- "Euclidean distance does not capture barriers" → We could say "GTFS quality issues affect some cities"
- "Equal weighting may not reflect varying importance" → Threshold choice affects coverage/choice tradeoffs
- "Walk Score® itself may not capture true walkability" → Acknowledge accessibility ≠ actual usage

---

## Notes

This paper is highly relevant because:

1. **Similar validation challenge**: No ground truth for walkability → compare to proprietary metric. We face similar issue with accessibility (no universal benchmark).

2. **Open-source alternative motivation**: Walk Score® is widely used but proprietary and inflexible → WAS provides transparent, customizable alternative. Parallels our motivation for documented GTFS/R5R workflow.

3. **Computational efficiency justification**: Euclidean achieves 0.91 correlation with network-based Walk Score® → justifies simpler method. Could inform our discussion of method tradeoffs.

4. **Parameter optimization approach**: Systematic grid search (93 combinations) to find optimal specification. Similar to threshold sensitivity analysis we might conduct.

5. **Longitudinal data product**: 23 years of pre-calculated values as research infrastructure. Parallels our 2021-2023 (or 2021-2024) dataset contribution.

The "equality-weighted amenities" default with customization option is a useful framing for handling arbitrary parameter choices—acknowledge the arbitrariness but provide sensible defaults.

The comparison showing street network variables DON'T improve correlation is interesting—sometimes adding complexity doesn't help. Could relate to our findings about GTFS quality issues.
