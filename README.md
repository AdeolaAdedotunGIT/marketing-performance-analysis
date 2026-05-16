# marketing-performance-analysis
End-to-end marketing performance analysis for a talent representation agency. Medallion pipeline (Bronze to Gold), SQL Server, Power BI. Identified $97K budget misallocation driving a 36% deal closure decline.
# Madre Talent Group — Marketing Performance Analysis

**Role:** Data Analyst & BI Developer  
**Period:** January – April 2026  
**Stack:** Azure SQL · SQL Server · Power BI · Python · GitHub

---

## The Business Problem

A Canadian talent representation agency managing 45 talents across music, comedy, and digital content saw deal closures drop from 22 per month to 14 in April 2026, a 36% decline. Leadership attributed it to market disruption. The data told a different story.

---

## What I Built

An end-to-end analytics pipeline from five raw data sources to a Power BI dashboard that identified exactly where the budget was going and why deals were falling.

**Data sources:**
- Deal pipeline (HubSpot export)
- Meta Ads campaign performance
- Google Ads campaign performance
- Email campaign performance
- Talent profiles

**Pipeline architecture:**

Bronze → Pre-Silver → Silver → Gold

Each layer documented. Every transformation decision recorded in an Admin schema. Nothing deleted from Bronze.

---

## The Pipeline

**Bronze**
Raw ingestion. All five sources loaded as NVARCHAR to preserve source fidelity before any casting or transformation.

**Pre-Silver**
Dirty data handling before type casting:
- 13 acquisition channel variants standardised to 5 canonical values via lookup table
- Talent ID format mismatch corrected with LPAD normalisation (TLT1 → TLT001)
- Categorical fields standardised across all tables

**Silver**
Clean typed layer. Nulls filled with documented logic. 8 duplicate deal records identified using ROW_NUMBER with PARTITION BY deal_id, flagged in Admin schema, excluded from analysis. Correct won deal total: 80, not 88.

**Gold**
Star schema with surrogate keys:

| Table | Rows | Type |
|---|---|---|
| dim_talent | 45 | Dimension |
| dim_date | 120 | Dimension |
| dim_channel | 5 | Dimension |
| fact_deals | 342 | Fact |
| fact_meta_spend | 2,160 | Fact |
| fact_google_spend | 480 | Fact |
| fact_email_events | 1,965 | Fact |

---

## The Five Business Questions

1. What is the cost per acquisition by channel for closed deals?
2. Is spend allocation proportional to deal close rate by talent tier?
3. Is the April decline concentrated in a specific tier and channel or uniform?
4. What is the month-on-month email send volume trend and how does it correlate with email-sourced wins?
5. Which individual talents are generating positive ROI on Meta spend?

---

## Key Findings

**CAC by channel**
| Channel | CAC |
|---|---|
| Email Campaign | $355 |
| Google Ads | $4,005 |
| Meta Ads | $6,666 |

**Spend vs wins by talent tier**
| Tier | Meta Spend % | Won Deals % |
|---|---|---|
| Top-Tier | 66.3% | 26.3% |
| Mid-Tier | 32.4% | 73.8% |

**April decline**
Not market-wide. Concentrated in Top-Tier talent combined with Meta Ads. Mid-Tier email performance held flat across all four months. In April, 12 of 14 closed deals came through email.

**Email efficiency**
Send volume dropped 55% between January and March while email-sourced won deals stayed flat. The cheapest channel was being cut while the most expensive was being scaled.

**Talent ROI**
4 of 9 Top-Tier talents were below Meta spend breakeven. The highest performing talent in the dataset was a Mid-Tier creator with a commission-to-spend ROI of 6.65.

---

## Recommendation

1. Reallocate minimum 40% of Top-Tier Meta budget to Mid-Tier campaigns
2. Increase email budget by the equivalent of one underperforming Google Ads campaign
3. Rebuild talent showcase pages to lead with engagement rate, not follower count

Projected outcome: deal closures return to 20 or more per month by June 2026.

---

## What Went Wrong and How I Handled It

**Dirty acquisition channel data**
Source data contained 13 variants of 5 canonical values. Built a lookup table in Pre-Silver rather than a CASE WHEN chain for auditability and easier maintenance.

**Talent ID mismatch**
Email data used a shortened ID format (TLT1) that did not match the standard format (TLT001) used across all other sources. Caught during referential integrity check before any joins were built. Fixed with LPAD normalisation in Pre-Silver. Would have caused 20% data loss silently.

**Duplicate deal records**
8 duplicate rows in the deal pipeline inflated the won deal count from 80 to 88. Identified using ROW_NUMBER with PARTITION BY. Flagged in Admin schema, not deleted from Bronze.

**Email correlation story broke**
Original plan was to show correlation between email send volume and email won deals. Email won deals were flat at 9 every month regardless of send volume. Switched to indexed line charts (January baseline = 100) which produced a stronger finding: the channel being cut was converting at a stable rate while volume was being reduced.

---

## Analyst

**Adeola Adedotun**  
Data Analyst & BI Developer  
workwithadeolaadedotun@gmail.com  
+2347035986984
Available for remote contracts and project engagements globally
