# A reproducible pipeline for activity-based travel demand generation in England

**Authors**: Hussein Mahfouz, Sam F. Greenbury, Bowen Zhang, Stuart Lynn and Tao Cheng

**Journal**: EPB: Urban Analytics and City Science, 2025, Vol. 52(9) 2326–2339

**DOI**: 10.1177/23998083251379620

**Type**: Open Source Software - Pipeline for activity-based travel demand generation

---

## Summary

This paper presents an open-source modular pipeline for generating activity-based travel demand datasets for agent-based transport models (AgBMs) in any region of England. The problem: AgBMs require synthetic populations with detailed daily activity schedules (what, when, where, how for each activity), but existing tools are either proprietary or difficult to adapt. The solution: A three-stage pipeline that (1) enriches Synthetic Population Catalyst (SPC) individuals with activity schedules via statistical matching to National Travel Survey (NTS) data, (2) assigns primary locations (work/education) using constrained optimization to match census commuting flows, and (3) assigns secondary locations using space-time prisms (PAM library). Outputs are MATSim-compatible. The pipeline is **configurable** (users can tune travel time tolerances, optimization weights, distance decay parameters) and includes **self-consistency checks** (NTS distribution comparisons, census flow validation with R²/MAE/RMSE, spatial diagnostic maps). Demonstrated on Leeds, UK. This is **scholarly infrastructure** rather than novel methodology—the value is reproducibility and accessibility for researchers who need AgBM inputs without spending time on data preparation.

---

## Key Contributions

1. **First generalizable open-source pipeline**: For activity-based travel demand generation in England (Hörl and Balac 2021 exists for France but requires codebase familiarity)
2. **Modular three-stage architecture**: (a) Activity scheduling, (b) Primary location assignment, (c) Secondary location assignment
3. **Enriches SPC with travel demand**: Takes static population (households, demographics, home locations) → adds activity schedules + locations + modes
4. **Two-stage household-preserving matching**: Household-level matching (8 variables, iterative relaxation) → Individual-level matching (sex, age)
5. **Constrained optimization for work commuting**: Minimizes divergence from census OD matrices while respecting individual travel time constraints
6. **Configurable parameters**: Users can tune 10+ parameters (NTS region, travel time tolerance, optimization weights, distance decay) via config file
7. **Self-consistency validation framework**: NTS distribution checks + census flow validation (R², MAE, RMSE) + spatial diagnostic maps
8. **MATSim-compatible outputs**: Ready for downstream agent-based simulation platforms

---

## Problem Definition

**AgBM requirements**: Synthetic populations with complete daily activity diaries
- What activities (work, education, shopping, etc.)
- When (start time, duration)
- Where (specific geographic locations)
- How (travel mode)

**Current bottleneck**:
- Literature exists on methods, but few **open-source tools**
- Only existing: Hörl and Balac (2021) for France (requires codebase expertise to adapt)
- Data preparation is time-consuming bottleneck preventing AgBM adoption

**Gap this work fills**: Reproducible pipeline for **any region in England** with minimal user effort

---

## Methodology

### Three-Stage Pipeline

#### Stage 1: Activity Scheduling (Statistical Matching)

**Input**:
- Synthetic Population Catalyst (SPC): Individuals + households + demographics + home locations
- National Travel Survey (NTS): Daily activity schedules from sample population

**Two-step matching** (preserves household trip dependencies):

**Step 1 - Household level**:
- Match SPC households to NTS households using 8 variables (Table 2):
  - No. of adults, children, pensioners (numerical, FIXED)
  - No. of cars (numerical)
  - Rural/urban classification, employment status, household income, type of tenancy (categorical)
- Iterative relaxation: Start with all 8 variables, remove least important until ≥5 matches found
- Randomly select one NTS household from match pool

**Step 2 - Individual level**:
- Match each SPC individual to unique NTS individual in matched household
- Unconstrained statistical matching (Namazi-Rad et al., 2017)
- Nearest neighbor search on sex + age category
- Without replacement (ensures all household members get unique matches)

**Output**: Each SPC individual has activity schedule (trip sequence, purposes, distances, modes, durations) from NTS respondent

**Why statistical matching?**
- Mature, proven method
- Handles household-level constraints (unlike deep learning approaches)
- Bayesian networks perform similarly (Sallard and Balaç 2023) but statistical matching simpler
- Deep generative models (Koushik et al. 2023, Shone and Hillel 2025) don't yet handle household interactions

#### Stage 2: Primary Location Assignment (Work & Education)

**Goal**: Assign work and education activities to specific zones

**Approach**: Constrained optimization to match census commuting flows while respecting individual travel times

**Steps**:

1. **Calculate travel time matrix** (OA or MSOA level):
   - Ideally: Use routing engine
   - Fallback: Estimate from Euclidean distance + mode speeds, adjust for network distance:

   $$d_{network} = d_{euclidean} \cdot (1 + (\lambda - 1) \cdot e^{-\delta \cdot d_{euclidean}})$$

   - λ = 1.56 (Minkowski coefficient), δ = decay factor (configurable)

2. **Identify feasible zones**:
   - Compare reported travel time (from NTS schedule) to travel time matrix
   - Shortlist zones reachable within tolerance (e.g., 30 min ± 20% = 24-36 min)

3. **Select zone**:
   - **Education**: Probabilistically based on total facility area (kindergartens/schools/universities by age)
   - **Work**: Optimization problem (see below)

4. **Select specific facility** within chosen zone (from OSM POI data)

**Work assignment optimization** (different from education because census OD matrix available):

**Variables**: $x_{iod}$ = binary (individual i from origin o assigned to destination d?)

**Objective**: Minimize weighted sum of
- (a) Sum of deviations between assigned flows and census flows
- (b) Maximum deviation across all OD pairs

$$\min \left( \alpha \sum_{o,d} \left| \frac{\sum_i x_{iod}}{N_o} - \frac{F_{od}}{N_o} \right| + \beta \max_{o,d} \left| \frac{\sum_i x_{iod}}{N_o} - \frac{F_{od}}{N_o} \right| \right)$$

where:
- $F_{od}$ = census flow from origin o to destination d
- $N_o$ = normalization factor ($T_o$ if using percentages, else 1)
- α, β = configurable weights

**Constraints**:
- Each individual assigned to exactly one destination: $\sum_d x_{iod} = 1$
- Binary assignment: $x_{iod} \in \{0, 1\}$
- Feasibility: $x_{iod} \leq Z_{od}$ (only feasible zones based on travel time)

**Why optimization for work?**
- Work trips longer than education (Figure 3)
- Work accounts for higher proportion of total travel (Figure 4)
- High-fidelity census OD matrices available (ground truth)

#### Stage 3: Secondary Location Assignment (Discretionary Activities)

**Goal**: Assign shopping, visiting, escort, etc. to locations

**Approach**: Space-time prisms (Hägerstrand 1970) using PAM library (Shone et al. 2024)

**Method**:
- Use primary locations (work/education/home) as "anchors"
- For each secondary activity, create choice set based on:
  1. **Leg ratio**: Travel time from previous / travel time to next (compare to NTS reported ratio)
  2. **Diversion factor**: Deviation from straight line between anchor activities
  3. **Zone attraction**: Number of facilities in zone
- Select zone from choice set
- Select specific facility within zone

**Why space-time prisms?**
- Minimal data requirements (vs. choice models or Bayesian networks)
- Reproduces distance distributions from reference data
- Provides "preliminary results that can be refined in agent-based simulations"

---

## Data Requirements

| Dataset | Purpose | Details |
|---------|---------|---------|
| **Synthetic Population Catalyst (SPC)** | Core input | Individuals + households + demographics + home locations for all of England |
| **National Travel Survey (NTS)** | Activity schedules | Daily trip sequences, purposes, distances, durations, modes + demographics (requires UK Data Service account) |
| **OSM POI data** | Location assignment | Kindergartens, schools, universities, workplaces, shops, etc. |
| **Travel time matrices** | Primary location | OA or MSOA level, by mode (routing engine preferred, else estimated) |
| **Census commuting matrices** | Work assignment constraint | OD flows at OA or MSOA level |

---

## Configuration and Validation

### Configurable Parameters (Table 3)

**Activity scheduling**:
- `nts_region`: Select NTS region to match study area
- `required_columns`, `optional_columns`: Define variables for strict/relaxed matching

**Primary location**:
- `tolerance_work`, `tolerance_edu`: Travel time tolerance (e.g., ±30%)
- `detour_factor`, `decay_rate`: Calibrate Euclidean → network distance conversion
- `weight_max_dev`, `weight_total_dev`: Optimization objective weights (α, β)

**Secondary location**:
- `visit_probability_power`: Distance decay exponent in gravity model

### Validation Framework

**1. NTS distribution consistency** (Appendix B: Figures 3-5):
- Trip purpose distribution (education, escort, home, medical, other, shop, visit, work)
- Trip mode distribution (bike, car, car_passenger, motorcycle, pt, taxi, walk)
- Trip length distribution by activity type
- Activity sequence patterns (h→w→h, h→sh→h, h→o→h, etc.)

**2. Census commuting flow validation**:
- Global goodness-of-fit: R², MAE, RMSE
- Spatial diagnostic maps (Appendix C: Figures 6-7):
  - Census count, AcBM count, AcBM - Census (difference map)
  - Absolute map flow differences: $G_o = \sum_d |T_{od} - F_{od}|$
  - Percentage differences: $q_o = \sum_d \left( \frac{T_{od} - F_{od}}{\sum_{o,d} F_{od}} \right)$
- Helps identify spatial patterns of over/under-prediction

**Purpose of validation**:
- NOT final validation (parameters optimal for one region may not work for another)
- Tool to help users **calibrate** pipeline for their specific study area
- Ensures pipeline "functioning correctly" and "plausibly reproduces input distributions"

---

## Case Study: Leeds, UK

**Outputs** (Appendix B):
- Trip purpose: Close match to NTS (home 43%, work 11%, other 16%, shop 9%)
- Trip mode: Car dominates (~50% NTS, ~50% AcBM), walk ~8%, pt ~7%
- Trip distance distributions: Reproduce NTS patterns by activity type
- Activity sequences: Top patterns h→w→h (19%), h→o→h (14%), h→sh→h (12%)

**Census commuting validation** (Appendix C):
- Spatial maps show assignment matches census flows well
- Some over/under-prediction in specific origin zones (diagnostic maps help identify)

---

## Technical Specifications

### Platform
- **Language**: Python
- **Dependencies**: SPC, NTS, OSM POI, PAM library (Shone et al. 2024)
- **Outputs**: MATSim-compatible activity plans

### Repository
- **GitHub**: https://github.com/Urban-Analytics-Technology-Platform/acbm/tree/main
- **Documentation**: Detailed parameter guide in code repository
- **Data instructions**: https://github.com/Urban-Analytics-Technology-Platform/acbm/tree/main/data/external#data-sources

### Modular Design
- Stage 1: Activity scheduling (statistical matching)
- Stage 2: Primary location (constrained optimization)
- Stage 3: Secondary location (space-time prisms)
- Each stage can be replaced/extended with alternative methods

---

## Strengths and Limitations

### Strengths

1. **Generalizable**: Works for any region in England (not tied to specific study area)
2. **Configurable**: 10+ parameters allow calibration to local conditions
3. **Transparent**: Uses established methods (statistical matching, constrained optimization, space-time prisms)
4. **Modular**: Each stage can be replaced with alternative methods
5. **Validated**: Self-consistency checks against NTS and census
6. **Accessible**: Detailed documentation, no novel methods requiring expertise
7. **Production-ready**: MATSim-compatible outputs

### Limitations

**1. England-specific data dependencies**:
- SPC (England only)
- NTS (requires UK Data Service account)
- Census commuting matrices (England/Wales)
- Would require adaptation for other countries

**2. Established methods (not cutting-edge)**:
- Statistical matching (vs. Bayesian networks or deep learning)
- Space-time prisms (vs. choice models)
- Trade-off: Accessibility and reproducibility over novelty

**3. Validation challenge**:
- "Optimal parameters for one region may not be suitable for another"
- Validation on Leeds doesn't guarantee performance elsewhere
- Users must calibrate for their study area

**4. Indirect validation**:
- Validates against NTS (survey data, not observed behavior)
- Census commuting (ground truth) only for work trips
- No validation against actual GPS traces or smart card data

**5. Static travel times**:
- Travel time matrix is static (no time-of-day variation or congestion)
- Could create multiple matrices for different times (future work)

---

## Future Directions

### Methodological Extensions
1. **Alternative activity generation**: Integrate Bayesian networks (Joubert and De Waal 2020) or deep generative models (Shone and Hillel 2025)
2. **Refined primary location**: Neural spatial interaction models (Zachos et al. 2024)
3. **Refined secondary location**: Relaxation-discretization algorithm (Hörl and Axhausen 2023)
4. **Time-of-day travel times**: Multiple matrices for peak/off-peak periods

### Generalization
1. **Other countries**: Adapt to different synthetic population tools and travel surveys
2. **Multi-day schedules**: Current = single day, extend to weekly patterns
3. **Joint household decisions**: Explicit modeling of household activity coordination

---

## Relevance to Our Project

### Methodological Parallels
1. **Workflow documentation as contribution**: They document pipeline (not novel algorithm), similar to our R5R workflow
2. **Modular architecture**: Three stages (activity → primary → secondary) parallels our workflow (GTFS → OSM → R5R → accessibility)
3. **Configurable parameters**: Users tune to local conditions (we could do same for threshold choices, decay functions)
4. **Validation framework**: Self-consistency checks + external validation (NTS, census) parallels our GTFS quality checks + validation routes
5. **Open-source infrastructure**: GitHub + detailed documentation enables reproducibility

### Key Differences
- **Purpose**: Generate AgBM inputs (activity schedules); we calculate accessibility metrics
- **Domain**: Transport demand modeling; we measure accessibility outcomes
- **Temporal scope**: Single time point (activity schedules for one day); we do longitudinal analysis (2021-2024)
- **Geographic scale**: England (national pipeline); we focus on Korean cities

### Lessons for Our Manuscript

**"Scholarly infrastructure" framing**:
- Arribas-Bel et al. (2021): Open Data Products + Open Source Software
- This paper: "Piece of scholarly infrastructure... reproducible pipeline... lowering barrier for AgBM"
- We can use: "Reproducible workflow for longitudinal multimodal accessibility measurement"

**Modular workflow documentation**:
- Figure 1: Simplified overview (3 boxes: SPC → Activity scheduling → Location assignment → AcBM)
- Figure 2: Detailed workflow (Appendix A, shows all datasets and processing steps)
- We could structure: Simple workflow diagram + detailed methods appendix

**Configuration emphasis**:
- Table 3: "Examples of key configurable parameters" with Purpose column
- Explicitly states: "Users directed to documentation in code repository"
- We could document: GTFS quality thresholds, temporal aggregation choices, threshold parameters

**Validation strategy**:
- Honest about limitations: "Validation for single study area would not generalize"
- Purpose of checks: "Ensure pipeline functioning correctly" not "final validation"
- We can use: GTFS quality checks + validation routes as "self-consistency" not "ground truth validation"

**Two-tier validation** (internal + external):
- Internal: NTS distribution checks (reproduces input data?)
- External: Census commuting flows (matches ground truth?)
- We could do: Internal (GTFS consistency, route validation) + External (compare to existing studies)

**Spatial diagnostic maps**:
- Figures 6-7: Show observed, predicted, and difference maps
- Helps users identify where model over/under-predicts
- We could show: Accessibility maps for different cities, temporal change maps, car vs transit comparison maps

**Limitation honesty**:
- "While the pipeline intentionally uses more established methods..."
- "Key challenge... validation performed for single study area would not necessarily generalize"
- "Provides preliminary results that can be refined in agent-based simulations"
- We can acknowledge: GTFS quality varies, threshold choices arbitrary, accessibility ≠ usage

**Future work specificity**:
- Lists concrete extensions (Bayesian networks, neural spatial interaction, relaxation-discretization)
- Cites specific papers for each extension
- We could list: Other service types, other countries, temporal decomposition methods

---

## Notes

This paper is highly relevant because:

1. **Similar contribution type**: Workflow documentation as scholarly infrastructure (not novel algorithm)
2. **Modular pipeline**: Three stages with configurable parameters (parallels our GTFS → R5R → accessibility workflow)
3. **Validation framework**: Self-consistency checks + external validation (we need similar for GTFS quality)
4. **England-wide generalizability**: Works for any region (we could claim "any GTFS region")
5. **Configuration file approach**: Users tune parameters to local conditions (we could do for thresholds)

The **two-stage matching** (household → individual) to preserve dependencies could inform how we think about aggregating accessibility (individual trip times → representative values → household accessibility).

The **constrained optimization** for work location (match census OD while respecting individual travel times) is similar to our challenge of matching observed patterns while maintaining methodological consistency.

The **spatial diagnostic maps** (observed vs predicted, difference map) provide excellent model for our accessibility visualizations (2021 vs 2024, car vs transit, difference maps).

The **"scholarly infrastructure"** framing (Arribas-Bel et al. 2021) is exactly what EPB Urban Data/Code accepts—this paper is a strong model for positioning our work.
