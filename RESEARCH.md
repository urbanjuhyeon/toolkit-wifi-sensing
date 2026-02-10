# WiFi Sensing Toolkit for Urban Studies

## 개요

DIY WiFi 센서를 활용한 비동력 교통(보행자, 자전거) 측정 toolkit.
2022년 학위논문(thesis-measuring-public-life)을 기반으로 재정리.

## 연구 배경

- Array of Things (시카고), S-DoT (서울) 등 도시 센싱 프로젝트 확산
- WiFi 패킷의 MAC 주소를 활용해 보행자 이동 추적 가능
- IoT 기반 도시 센싱의 민주화 (전문가 영역 → 누구나 가능)

## Contribution

- **End-to-end toolkit**: 센서 제작 → 데이터 수집 → 전처리 → 메트릭 산출
- **5-metric 프레임워크**: Location, Count, Track, Identity, Activities
- **Reproducible**: Quarto Book + 코드 + 샘플 데이터
- **Time-flag로서의 가치**: WiFi 센싱 방법론의 체계적 정리 (randomization 전환기 기록)

## 타겟 저널

**EPB Urban Data/Code section** (~3,000 words)
- ODP/OSS 형태로 공개 후 DOI 등록 필요

### 섹션 적합성 (2026-01-21 재검토)

**핵심 질문**: "Workflow documentation이 OSS로 인정받을 수 있는가?"

**EPB 가이드의 OSS 정의**:
> "Open source software is made up of **structured collections of computer code** released under open licenses that enable their users to **perform operations in a generalisable way** that allows for **easy repurposing** from the original context"

**판단 근거**:

| 요소 | 이 toolkit | 평가 |
|------|-----------|------|
| Structured code | scripts/ + qmd 내장 코드 | ✅ 충족 필요 |
| Generalisable | 다른 센서/환경에 적용 가능 | ✅ |
| Easy repurposing | 샘플 데이터 + 문서화 | ✅ |

**게재된 유사 사례** (패키지 아닌 toolkit 형태):

| 논문 | artifact | PyPI/CRAN? |
|------|----------|-----------|
| GHSCI | Python scripts + Jupyter + docs | ❌ |
| Mahfouz | Python pipeline on GitHub | ❌ |
| BikeNodePlanner | PyQGIS scripts | ❌ |

→ **"패키지가 아니면 안 된다"는 규칙 없음**

**이 toolkit의 차별점**:
- 하드웨어 component 포함 (센서 제작) — 다른 EPB 논문에 없음
- End-to-end (센서 → 수집 → 처리 → 메트릭) — full stack

**결론**:
- Scope fit: ✅ OSS toolkit + ODP (샘플 데이터)
- Contribution: "documented workflow as scholarly infrastructure"
- **핵심 조건**: scripts/에 재사용 가능한 코드가 충분해야 함

### Reference 논문 (2026-01-19 정리)

**Tier 1: 핵심 참고 (workflow 형태, 일반 제출)**

| 논문 | 형태 | GISRUK? | 참고할 점 |
|------|------|---------|----------|
| **GHSCI** (Higgs et al., 2025) | toolkit + Jupyter + docs | ❌ | 가장 유사. "multiple usage modes", 교육적 접근 |
| **Mahfouz** (2025) | reproducible pipeline | ❌ | "scholarly infrastructure" 프레임, 모듈식 파이프라인 |
| **BikeNodePlanner** (Vybornova et al., 2025) | modular workflow | ❌ | 8단계 명확 구분, YAML config |
| **Deakin** (2025) | Python + cookbook | ❌ | Methods appendix + Cookbook appendix 분리 |

**Tier 2: 주제 유사성 (모빌리티/센싱)**

| 논문 | 주제 | 참고할 점 |
|------|------|----------|
| **spanishoddata** (Kotov et al., 2026) | 모바일 OD 데이터 | 재현성 gap 지적, 효율적 형식 (DuckDB/Parquet) |
| **poorthuis_activityspaces** (2024) | 소셜미디어 activity spaces | privacy/bias 솔직히 논의 |
| **RoadUserPathways** (Kaths, 2024) | 궤적 클러스터링 | 센싱 → 패턴 추출, 5개 case study |

**Tier 3: GISRUK Special Issue (퀄리티 참고용)**

| 논문 | 형태 | 참고할 점 |
|------|------|----------|
| **MAP** (Nelson et al., 2025) | Jupyter notebooks + sample data | 모듈식 파이프라인 (A-F), 정의/형평성 프레임워크 |
| **Carbon & Place** (Morgan, 2025) | 웹 도구 + R pipeline | 다중 검증 전략 (R², RMSE), 한계 투명성 |
| **WAS** (Credit et al., 2025) | ODP + OSS 결합 | 매개변수 그리드서치, 벤치마킹 (Walk Score) |

※ GISRUK이 맥락적 이점 있을 수 있지만, Tier 1 논문들이 일반 제출로 게재됨 → workflow 형태 가능

**프레이밍 참고**

| 논문 | 배울 점 |
|------|---------|
| **jtstats** (Botta et al., 2025) | "analysis-ready" 강조 |
| **spnaf** (Ha et al., 2025) | "first R package for..." gap 명시 |
| **tscluster** (Tosanwumi et al., 2025) | Case study = demonstration, not deep analysis |
| **Robinson** (2025) | 한계 명시적 섹션, uncertainty mapping |

**Primary Role Model: GHSCI + Mahfouz**
- 패키지가 아닌 toolkit + documentation 형태
- 일반 제출로 게재됨
- "scholarly infrastructure" 프레임

**참고 파일 위치**: `reference/EPB-section/`

## 폴더 구조

```
toolkit-wifi-sensing/
├── docs/                # Quarto Book
│   ├── 1-introduction.qmd
│   ├── 2-*.qmd          # Part II: 센서 제작
│   ├── 3-*.qmd          # Part III: 데이터 수집/전처리
│   ├── 4-*.qmd          # Part IV: 메트릭
│   ├── 5-casestudy.qmd  # Part V: 사례연구
│   └── 6-conclusion.qmd # Part VI: 결론
├── scripts/             # R 코드
├── data/sample/         # 샘플 데이터
├── manuscript/          # EPB 제출용 원고
└── reference/           # EPB 섹션 참고자료
```

## MAC Randomization 대응 (2026-01-19 정리)

### 현실 인정
- 2014년 iOS 8, 2017년 Android O부터 기본 적용
- 기존 WiFi 센싱의 핵심 가정(고유 MAC = 고유 기기)이 무너짐

### 프레이밍 전략
1. **한계 솔직히 인정**: "WiFi sensing has known limitations due to MAC randomization"
2. **그럼에도 가치 있는 상황**:
   - Controlled environment (캠퍼스, 이벤트, 등록된 기기)
   - 공공 WiFi 인프라와 연계 (SSID 기반)
   - Counting with coefficient
3. **Time-flag로서의 의미**: 방법론 자체를 체계적으로 정리하고 기록
4. **미래 방향 제시**: De-randomization + privacy-preserving 연구로의 연결

### Privacy Considerations
- **한국**: SHA256 등 익명화 처리 시 법적 문제 없음
- **EU GDPR**: Article 89 연구 예외 + 익명화 데이터는 적용 제외
- **toolkit에서**: source_address 익명화 방법 제공

### 최신 연구 동향 (참고용)
- Fingerprinting + Clustering: ~96% 정확도 (controlled)
- De-randomization: 70-80% (실제 환경)
- Bleach Framework (2024): 시간+내용 기반 MAC association
- RFFI (2025): 하드웨어 고유 특성 활용

---

## Case Study 방향 (2026-01-19 정리)

### 기존 thesis 접근의 문제
- Huff model: 센싱 없이도 가능
- Rhythm: 기존 WiFi sensing 연구에서 이미 다룸
- → "WiFi 센싱이 아니면 할 수 없는 것"이 아니었음

### EP-B Urban Data/Code의 Case Study 특성
- 새로운 연구 발견을 요구하지 않음
- "이 도구로 이런 분석이 가능하다"를 시연하면 됨
- 유사 논문들: NetAScore (Salzburg), spnaf (Columbus), spanishoddata (Valencia/Madrid)

---

## Manuscript 구조 (2026-02-10 brainstorming 반영)

### Word count 규칙 (이전 제출 경험)
- 총 word count = 본문 + (Figure 수 × 250~500) ≤ 3,000
- Figure의 sub-part도 별도 카운트
- abstract, tables, equations, references 포함
- **Supplementary Material** 활용 가능 (review 대상이지만 word count 미포함)

### Manuscript 전략 (2026-02-10 확정)

**핵심 인식**:
- UNIST 캠퍼스만으로는 Location/Count/Track은 강하지만 Identity/Activities가 약함
- 캠퍼스 Activities("학생이 기숙사에 머문다")는 urban analytics가 아님
- EPB는 "Urban Analytics and City Science" — 상권 사이트가 최소 1개 필요
- abstract/cover letter에서 "campus tutorial + commercial district case study"가 훨씬 강함

**구조: Campus에서 메트릭을 가르치고, 상권에서 적용을 보여준다**

### Figure 구성

**Main manuscript (3~4개 × 250 = 750~1,000 words → 본문 ~2,000~2,250 words)**

| Fig | 내용 | 데이터 | 상태 |
|-----|------|--------|------|
| Fig 1 | Toolkit overview + Five Metrics Framework | 개념도 | ver3 거의 완성 |
| Fig 2 | Count + Track | UNIST campus | 기존 결과 조합 |
| Fig 3 | Activities (걷고싶은거리 체류/통과) | 울산대 상권 | **우선 작업** |
| Fig 4 | Identity (버스/주차장 이용객) — 가능하면 | 구영리 상권 | Plan B: UNIST Identity |

**Supplementary Material**
- Localization error + GPS ground truth 검증 (UNIST)
- Randomization 비율 변화 + 보정 방법
- Identity 상세 (UNIST One-time vs Regular)
- 상세 deployment 정보

### 본문 구조 (~2,000 words)

```
1. Introduction (~500 words)
   - WiFi sensing의 잠재력 (public life studies 연결)
   - Gap: end-to-end toolkit 부재 + randomization 전환기
   - 이 paper의 기여

2. The Toolkit (~500 words, Fig 1)
   - 전체 파이프라인 텍스트 (hardware → capture → process → metrics)
   - Five metrics framework 소개
   - Repository, DOI, 접근 방법

3. Demonstration (~600 words, Fig 2-3 또는 Fig 2-4)
   - UNIST campus: 5개 메트릭 tutorial (Fig 2: Count + Track 대표)
   - 울산대 상권: Activities — 걷고싶은거리 체류/통과 (Fig 3)
   - (가능하면) 구영리: Identity (Fig 4)
   - campus = tutorial, commercial district = urban application

4. Limitations (~250 words)
   - MAC randomization 솔직한 인정 + 보정 방법 (see Supplementary)
   - Privacy considerations

5. Conclusion (~150 words)
   - Time-flag + scholarly infrastructure
```

세부 코드 설명은 ❌ → "see online documentation"

### 작업 순서 (2026-02-10 확정)

**지금 바로 시작:**
1. **Fig 3 (울산대 상권 Activities)** — `data/sample_casestudy/` 데이터에 4-6-activities.qmd 코드 적용
   - 걷고싶은거리 센서 vs 나머지 센서의 stay rate 비교
   - 이것만 되면 manuscript 제출 가능한 최소 구성 완성

**그 다음:**
2. Fig 4 (구영리 Identity) — 데이터 확보되면 시도, 안 되면 UNIST Identity로 대체
3. Fig 2 (UNIST Count+Track) — 기존 그림 조합
4. Manuscript 본문 작성 (AI 초안 + 다듬기)
5. Supplementary Material

**막히면 즉시 전환:**
- 울산대 데이터 문제 → UNIST Activities로 대체하고 manuscript 진행
- 구영리 불가 → UNIST Identity 사용 (이미 결과 있음)
- **어떤 경우든 manuscript는 쓴다**

---

## 종합 진단 (2026-01-19)

### 리스크

- "workflow" 형태가 EP-B Urban Data/Code 일반 제출로 받아들여질지 불확실
- GISRUK Special Issue 논문들(MAP, Carbon & Place, WAS)은 기준이 다를 수 있음
- tracking-access-change도 같은 리스크로 Editorial Decision 대기 중
- 둘 다 reject되면 다른 곳에 내기 어려움

## 스토아적 관점 (2026-01-21)

**통제할 수 있는 것**:
- 코드의 충실도
- 문서화의 품질
- 한계의 솔직한 인정
- 제출 여부

**통제할 수 없는 것**:
- Editor의 판단
- Reviewer의 취향
- 게재 여부

**"좋은 시도"의 정의**:
- ❌ 성공이 보장된 시도 (그런 건 없음)
- ✅ 합리적 근거가 있고, 통제 가능한 부분을 충실히 한 시도

**이 시도는 터무니없는가?**
- ❌ CEUS에 이 포맷으로 내는 건 터무니없음
- ✅ EPB Urban Data/Code는 **이런 것을 위해 만들어진 섹션**
- ✅ 유사 사례(GHSCI, Mahfouz)가 일반 제출로 게재됨

**결론**: 코드를 충실히 채우면, 합리적인 시도다.

