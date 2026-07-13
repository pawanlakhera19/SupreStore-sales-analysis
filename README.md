# SuperStore Sales Performance Analysis

## Overview
An end-to-end Power BI dashboard analyzing sales, profit, and discount patterns across the Sample Superstore dataset (9,994 records, 2014–2017). The project covers data cleaning, data modeling, DAX measure creation- to uncover actionable business insights.

## Tools Used
- **Power BI Desktop** (Power Query, Data Modeling, DAX)
- Star-schema-style relationships with a dedicated Date Table for time intelligence
- Interactive slicers (Region, Category, Segment, Year) for cross-filtered analysis

## Data Preparation
- Cleaned raw CSV data in Power Query — fixed date formats, set correct data types (Postal Code as text, dates as Date type)
- Removed redundant columns (Row ID, Country — no variation across records)
- Created calculated columns: **Profit Margin %**, **Discount Bucket**, **Shipping Days**
- Built a dedicated **Date Table** using `CALENDAR()` with Year, Month, MonthNum, and Quarter columns, related to Order Date for accurate time intelligence
- Created DAX measures: Total Sales, Total Profit, Total Orders (DISTINCTCOUNT), Profit Margin %, YoY Growth %, Sales LY (using SAMEPERIODLASTYEAR)

## Dashboard Structure

**Page 1 —** KPI Cards (Total Sales, Total Profit, Total Orders, Profit Margin %), Monthly Sales Trend, Category-wise Sales & Profit, State-wise Sales Map, Segment-wise Sales Share (Donut), Region/Category/Segment/Year Slicers

**Page 2 —** Sub-Category Profit (with red/green conditional formatting), Discount vs Profit Scatter Chart, Top 10 Customers Table

---

## Deep-Dive Analysis (Category × Region × Sub-Category)

### 1. Furniture Category — Overall Margin: 2.49% (Sales: 742.00K | Profit: 18.45K)

**Region-wise breakdown:**

| Region | Sales | Profit | Margin % |
|---|---|---|---|
| Central | 163.80K | -2.87K | **-1.75%** |
| East | 208.29K | 3.05K | 1.46% |
| South | 117.30K | 6.77K | 5.77% |
| West | 252.61K | 11.50K | 4.55% |

**Sub-Category × Region breakdown:**

| Sub-Category | Central | East | South | West | Total |
|---|---|---|---|---|---|
| Tables | -3.6K | -11.0K | -4.6K | +1.5K | **-18K** |
| Bookcases | -2.0K | -1.2K | +1.3K | -1.6K | **-3K** |
| Furnishings | -3.9K | +5.9K | +3.4K | +7.6K | **13K** |
| Chairs | +6.6K | +9.4K | +6.6K | +4.0K | **27K** |

**Key Findings:**
- Furniture's weak overall margin (2.49%) is driven almost entirely by Tables (-18K loss company-wide). 61% of that loss (-11.0K) comes from the **East region alone**, while Tables is actually profitable in the West (+1.5K) — proving the product itself isn't the problem, regional discount practices are.
- **Central is the only region with a net negative Furniture margin** (-1.75%), caused by three sub-categories (Tables, Bookcases, Furnishings) all being unprofitable there simultaneously.
- **Chairs is the only sub-category profitable in all four regions** — the most dependable performer in this category.
- Scatter chart confirms a direct correlation: sub-categories with the highest average discount (~25%+, e.g., Tables) show the steepest losses.
- Two Furniture customers with meaningful sales showed negative profit — Tom Prescott (Sales 4,899.12 → Profit -621.94) and Caroline Jumper (Sales 6,267.19 → Profit -494.91) — reinforcing that the issue is discount depth, not customer behavior.

---

### 2. Office Supplies Category — Overall Margin: 17.04% (Sales: 719.05K | Profit: 122.49K)

**Region-wise breakdown:**

| Region | Sales | Profit | Margin % |
|---|---|---|---|
| Central | 167.03K | 8.88K | **5.32%** |
| East | 205.52K | 41.01K | 19.96% |
| South | 125.65K | 19.99K | 15.91% |
| West | 220.85K | 52.61K | **23.82%** |

**Sub-Category × Region breakdown (key sub-categories):**

| Sub-Category | Central | East | South | West | Total |
|---|---|---|---|---|---|
| Appliances | -2.6K | +8.4K | +4.1K | +8.3K | **18K** |
| Binders | -1.0K | +11.3K | +3.9K | +16.1K | **30K** |
| Paper | +7.0K | +9.0K | +5.9K | +12.1K | **34K** |
| Supplies | -0.7K | -1.2K | 0.0K | +0.6K | **-1K** |

**Key Findings:**
- Office Supplies maintains a healthy 17.04% overall margin, but **Central drags the average down to just 5.32%** — the lowest of all regions.
- This is driven specifically by **Appliances (-2.6K) and Binders (-1.0K) turning negative only in Central**, while both are strongly profitable everywhere else (Binders alone earns +16.1K in West).
- This mirrors the exact pattern seen in Furniture — **a recurring, systemic Central regional issue**, not an isolated product problem.
- **Paper and Binders together contribute over 50%** of total Office Supplies profit (34K + 30K of 122.49K total) — the category's two profit engines.
- **West is the top-performing region** (23.82% margin), led by strong Binders (+16.1K) and Paper (+12.1K) performance.
- Supplies is a minor, chronic underperformer (-1K total), negative in both Central and East — not urgent, but worth flagging.

---

### 3. Technology Category — Overall Margin: 17.40% (Sales: 836.15K | Profit: 145.45K)

**Region-wise breakdown:**

| Region | Sales | Profit | Margin % |
|---|---|---|---|
| Central | 170.42K | 33.70K | **19.77%** |
| East | 264.97K | 47.46K | 17.91% |
| South | 148.77K | 19.99K | **13.44%** |
| West | 251.99K | 44.30K | 17.58% |

**Sub-Category × Region breakdown:**

| Sub-Category | Central | East | South | West | Total |
|---|---|---|---|---|---|
| Machines | -1.5K | +6.9K | -1.4K | -0.6K | **~3K** |
| Accessories | +7.3K | +11.2K | +7.0K | +16.5K | **42K** |
| Phones | +12.3K | +12.3K | +10.8K | +9.1K | **45K** |
| Copiers | +15.6K | +17.0K | +3.7K | +19.3K | **56K** |

**Key Findings:**
- Technology is the company's **strongest-performing category** (17.40% margin overall).
- **Central performs best here (19.77% margin)** — the opposite pattern seen in Furniture and Office Supplies, where Central was the weakest region. This proves Central's underperformance is category-specific, not a blanket regional issue.
- **South is the weakest region for Technology** (13.44% margin), driven mainly by Copiers underperforming there (+3.7K vs. +15.6K–19.3K in every other region).
- **Machines is a recurring (but minor) loss-maker**, negative in 3 of 4 regions (Central, South, West), only profitable in East.
- Unlike Furniture, discount level does not appear to drive Technology's losses — most sub-categories remain profitable across a wide discount range, suggesting Machines' underperformance is more product-specific than pricing-driven.
- Notable outlier: Grant Thornton (Central) recorded -3,839.99 profit on 7,999.98 in sales — the single largest individual customer loss found across the entire analysis.

---

## Cross-Category Summary

| Category | Margin | Weakest Region | Root Cause |
|---|---|---|---|
| Furniture | 2.49% | Central (-1.75%) | Tables (especially East) + heavy discounting |
| Office Supplies | 17.04% | Central (5.32%) | Appliances & Binders negative only in Central |
| Technology | 17.40% | South (13.44%) | Copiers underperforming in South |

**Biggest overall insight:** Central consistently underperforms in Furniture and Office Supplies but is actually the *best* region for Technology. This shows the business problem is **category-specific execution** (most likely discount/pricing policy on big-ticket furniture and office items in Central), rather than a general regional weakness.

## Recommendations
1. Cap discounts on Tables specifically in the East region — the single largest driver of Furniture's poor margin.
2. Audit Central's pricing/discount policy for Furniture and Office Supplies specifically, since the same region performs strongly in Technology.
3. Investigate why Copiers underperform in the South relative to every other region.
4. Monitor Machines' pricing — it is the only Technology sub-category that's unprofitable in most regions.
5. Flag high-sales/negative-profit customers (e.g., Sean Miller, Grant Thornton) for account-level discount review.

## What I Learned
- Sales volume does not equal profitability — some of the highest-revenue customers and regions were actually loss-making once discounting was factored in.
- Regional patterns are category-specific — the same region (Central) can be a company's best performer in one product line and worst in another.
- Real analytical insight comes from slicing data across multiple dimensions (category, region, sub-category) rather than relying on a single aggregate view.

## How to Use
Clone or download this repository,
Open superstore.pbix in Power BI Desktop,
Use the slicers to filter any page.

## Repository Contents
superstore.pbix — Power BI dashboard file,
sample-superstore.csv — Source dataset,
superstore.Pdf - Dashboard page previews,
deep analysis.pdf- indepth analysis of salesstore- category-wise per region.


## Author
Pawan Kumar Lakhera Aspiring - Data Analyst | Power BI · SQL · Python #https://www.linkedin.com/in/pawan-lakhera-738429174/
