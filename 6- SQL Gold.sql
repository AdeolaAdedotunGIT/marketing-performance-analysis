USE MadreTalentsGroup;
GO

USE MadreTalentsGroup;

-- ============================================================
-- GOLD LAYER: STAR SCHEMA
-- Three dimension tables and four fact tables.
-- All data sourced from Silver layer only.
-- Surrogate keys generated using IDENTITY(1,1).
-- Natural keys retained alongside surrogate keys for traceability.
-- ============================================================


-- ============================================================
-- DIMENSION 1: dim_talent
-- One row per talent. 45 rows total.
-- Source: Silver.talent_profiles
-- ============================================================

IF OBJECT_ID('Gold.dim_talent', 'U') IS NOT NULL
DROP TABLE Gold.dim_talent
GO

CREATE TABLE Gold.dim_talent (
    talent_key          INT             NOT NULL IDENTITY(1,1) PRIMARY KEY,
    talent_id           NVARCHAR(10)    NOT NULL,
    talent_name         NVARCHAR(MAX)   NULL,
    talent_category     NVARCHAR(50)    NULL,
    tier                NVARCHAR(20)    NULL,
    primary_platform    NVARCHAR(50)    NULL,
    total_followers     INT             NULL,
    engagement_rate     DECIMAL(5,2)    NULL,
    niche_category      NVARCHAR(MAX)   NULL,
    signed_date         DATE            NULL,
    region              NVARCHAR(50)    NULL,
    active_status       NVARCHAR(10)    NULL
);
GO

INSERT INTO Gold.dim_talent (
    talent_id,
    talent_name,
    talent_category,
    tier,
    primary_platform,
    total_followers,
    engagement_rate,
    niche_category,
    signed_date,
    region,
    active_status
)
SELECT
    talent_id,
    talent_name,
    talent_category,
    tier,
    primary_platform,
    total_followers,
    engagement_rate,
    niche_category,
    signed_date,
    region,
    active_status
FROM Silver.talent_profiles;

-- Validate
SELECT COUNT(*) AS dim_talent_count
FROM Gold.dim_talent;
-- Expected: 45

SELECT TOP 5 * FROM Gold.dim_talent;
-- Confirm talent_key is auto-incrementing from 1

GO


-- ============================================================
-- DIMENSION 2: dim_date
-- One row per calendar date January 1 to April 30 2026.
-- 120 rows total. Generated, no Silver source.
-- ============================================================

IF OBJECT_ID('Gold.dim_date', 'U') IS NOT NULL
DROP TABLE Gold.dim_date
GO

CREATE TABLE Gold.dim_date (
    date_key            INT             NOT NULL PRIMARY KEY,
    full_date           DATE            NOT NULL,
    day_number          INT             NOT NULL,
    month_number        INT             NOT NULL,
    month_name          NVARCHAR(20)    NOT NULL,
    quarter             INT             NOT NULL,
    year_number         INT             NOT NULL,
    is_crisis_month     BIT             NOT NULL
);
GO

-- Generate one row per date from 2026-01-01 to 2026-04-30
-- Using a recursive CTE to produce the date sequence
WITH date_sequence AS (
    SELECT CAST('2026-01-01' AS DATE) AS full_date
    UNION ALL
    SELECT DATEADD(DAY, 1, full_date)
    FROM date_sequence
    WHERE full_date < '2026-04-30'
)
INSERT INTO Gold.dim_date (
    date_key,
    full_date,
    day_number,
    month_number,
    month_name,
    quarter,
    year_number,
    is_crisis_month
)
SELECT
    -- date_key in YYYYMMDD format
    CAST(FORMAT(full_date, 'yyyyMMdd') AS INT),

    full_date,

    DAY(full_date),

    MONTH(full_date),

    DATENAME(MONTH, full_date),

    DATEPART(QUARTER, full_date),

    YEAR(full_date),

    -- April is the crisis month
    CASE WHEN MONTH(full_date) = 4 THEN 1 ELSE 0 END

FROM date_sequence
OPTION (MAXRECURSION 200);

-- Validate
SELECT COUNT(*) AS dim_date_count
FROM Gold.dim_date;
-- Expected: 120

SELECT * FROM Gold.dim_date
WHERE is_crisis_month = 1;
-- Expected: 30 rows, all April dates

GO


-- ============================================================
-- DIMENSION 3: dim_channel
-- One row per acquisition channel. 5 rows total.
-- Hardcoded with spend reference values.
-- ============================================================

IF OBJECT_ID('Gold.dim_channel', 'U') IS NOT NULL
DROP TABLE Gold.dim_channel
GO

CREATE TABLE Gold.dim_channel (
    channel_key         INT             NOT NULL IDENTITY(1,1) PRIMARY KEY,
    channel_name        NVARCHAR(50)    NOT NULL,
    total_spend_cad     DECIMAL(10,2)   NULL,
    monthly_spend_cad   DECIMAL(10,2)   NULL
);
GO

INSERT INTO Gold.dim_channel (
    channel_name,
    total_spend_cad,
    monthly_spend_cad
)
VALUES
    -- Meta spend comes from Silver.meta_campaign_performance
    -- summed across all four months
    ('Meta Ads',
        (SELECT SUM(spend_cad) FROM Silver.meta_campaign_performance),
        (SELECT SUM(spend_cad) / 4.0 FROM Silver.meta_campaign_performance)),

    -- Google spend comes from Silver.google_ads_performance
    -- summed across all four months
    ('Google Ads',
        (SELECT SUM(spend_cad) FROM Silver.google_ads_performance),
        (SELECT SUM(spend_cad) / 4.0 FROM Silver.google_ads_performance)),

    -- Email spend is a fixed scalar: $3,200 per month x 4 months
    ('Email Campaign',  12800.00,   3200.00),

    -- Direct and Referral have no paid spend
    ('Direct',          0.00,       0.00),
    ('Referral',        0.00,       0.00);

-- Validate
SELECT * FROM Gold.dim_channel;
-- Expected: 5 rows, Meta and Google spend populated from Silver

GO


-- ============================================================
-- FACT 1: fact_deals
-- One row per deal stage record. 342 rows total.
-- Source: Silver.deal_pipeline joined to Gold.dim_talent
-- and Gold.dim_channel for surrogate keys.
-- ============================================================

IF OBJECT_ID('Gold.fact_deals', 'U') IS NOT NULL
DROP TABLE Gold.fact_deals
GO

CREATE TABLE Gold.fact_deals (
    deal_key            INT             NOT NULL IDENTITY(1,1) PRIMARY KEY,
    deal_id             NVARCHAR(15)    NOT NULL,
    talent_key          INT             NULL,
    channel_key         INT             NULL,
    date_key            INT             NULL,
    deal_stage          NVARCHAR(50)    NULL,
    stage_entry_date    DATE            NULL,
    stage_exit_date     DATE            NULL,
    deal_value          DECIMAL(10,2)   NULL,
    acquisition_channel NVARCHAR(50)    NULL,
    inquiry_date        DATE            NULL,
    close_date          DATE            NULL,
    closed_status       NVARCHAR(20)    NULL,
    sales_cycle_days    INT             NULL,
    agency_commission   DECIMAL(10,2)   NULL,
    is_won              BIT             NOT NULL,
    month_number        INT             NULL
);
GO

INSERT INTO Gold.fact_deals (
    deal_id,
    talent_key,
    channel_key,
    date_key,
    deal_stage,
    stage_entry_date,
    stage_exit_date,
    deal_value,
    acquisition_channel,
    inquiry_date,
    close_date,
    closed_status,
    sales_cycle_days,
    agency_commission,
    is_won,
    month_number
)
SELECT
    dp.deal_id,

    -- Lookup surrogate key from dim_talent
    dt.talent_key,

    -- Lookup surrogate key from dim_channel
    dc.channel_key,

    -- Lookup surrogate key from dim_date using close_date
    -- NULL for open pipeline records with no close_date
    dd.date_key,

    dp.deal_stage,
    dp.stage_entry_date,
    dp.stage_exit_date,
    dp.deal_value,
    dp.acquisition_channel,
    dp.inquiry_date,
    dp.close_date,
    dp.closed_status,
    dp.sales_cycle_days,
    dp.agency_commission,

    -- Derive is_won flag
    CASE WHEN dp.closed_status = 'Won' THEN 1 ELSE 0 END,

    -- Derive month_number from close_date
    MONTH(dp.close_date)

FROM Silver.deal_pipeline dp

-- Join to dim_talent to get talent_key
LEFT JOIN Gold.dim_talent dt
    ON dp.talent_id = dt.talent_id

-- Join to dim_channel to get channel_key
LEFT JOIN Gold.dim_channel dc
    ON dp.acquisition_channel = dc.channel_name

-- Join to dim_date to get date_key
-- Left join because open pipeline records have no close_date
LEFT JOIN Gold.dim_date dd
    ON CAST(FORMAT(dp.close_date, 'yyyyMMdd') AS INT) = dd.date_key;

-- Validate
SELECT COUNT(*) AS fact_deals_count
FROM Gold.fact_deals;
-- Expected: 342

SELECT
    month_number,
    COUNT(*) AS won_deals
FROM Gold.fact_deals
WHERE is_won = 1
GROUP BY month_number
ORDER BY month_number;
-- Expected: 1=22, 2=22, 3=22, 4=14

SELECT COUNT(*) AS unmatched_talent_keys
FROM Gold.fact_deals
WHERE talent_key IS NULL;
-- Expected: 0

SELECT COUNT(*) AS unmatched_channel_keys
FROM Gold.fact_deals
WHERE channel_key IS NULL;
-- Expected: 0

GO


-- ============================================================
-- FACT 2: fact_meta_spend
-- One row per ad set per day. 2160 rows total.
-- Source: Silver.meta_campaign_performance
-- joined to Gold.dim_talent and Gold.dim_date.
-- ============================================================

IF OBJECT_ID('Gold.fact_meta_spend', 'U') IS NOT NULL
DROP TABLE Gold.fact_meta_spend
GO

CREATE TABLE Gold.fact_meta_spend (
    meta_spend_key          INT             NOT NULL IDENTITY(1,1) PRIMARY KEY,
    meta_row_id             NVARCHAR(20)    NOT NULL,
    talent_key              INT             NULL,
    date_key                INT             NULL,
    campaign_id             NVARCHAR(20)    NULL,
    ad_set_id               NVARCHAR(20)    NULL,
    campaign_objective      NVARCHAR(50)    NULL,
    spend_cad               DECIMAL(10,2)   NULL,
    impressions             INT             NULL,
    reach                   INT             NULL,
    clicks                  INT             NULL,
    follower_change         INT             NULL,
    landing_page_sessions   INT             NULL,
    page_inquiries          INT             NULL,
    traffic_type            NVARCHAR(20)    NULL,
    month_number            INT             NULL
);
GO

INSERT INTO Gold.fact_meta_spend (
    meta_row_id,
    talent_key,
    date_key,
    campaign_id,
    ad_set_id,
    campaign_objective,
    spend_cad,
    impressions,
    reach,
    clicks,
    follower_change,
    landing_page_sessions,
    page_inquiries,
    traffic_type,
    month_number
)
SELECT
    mc.meta_row_id,

    dt.talent_key,

    dd.date_key,

    mc.campaign_id,
    mc.ad_set_id,
    mc.campaign_objective,
    mc.spend_cad,
    mc.impressions,
    mc.reach,
    mc.clicks,
    mc.follower_change,
    mc.landing_page_sessions,
    mc.page_inquiries,
    mc.traffic_type,

    MONTH(mc.record_date)

FROM Silver.meta_campaign_performance mc

LEFT JOIN Gold.dim_talent dt
    ON mc.talent_id = dt.talent_id

LEFT JOIN Gold.dim_date dd
    ON CAST(FORMAT(mc.record_date, 'yyyyMMdd') AS INT) = dd.date_key;

-- Validate
SELECT COUNT(*) AS fact_meta_spend_count
FROM Gold.fact_meta_spend;
-- Expected: 2160

SELECT COUNT(*) AS unmatched_talent_keys
FROM Gold.fact_meta_spend
WHERE talent_key IS NULL;
-- Expected: 0

SELECT
    month_number,
    SUM(spend_cad) AS total_spend
FROM Gold.fact_meta_spend
GROUP BY month_number
ORDER BY month_number;
-- Note the monthly spend totals, should be approximately 45000 per month

GO


-- ============================================================
-- FACT 3: fact_google_spend
-- One row per campaign per day. 480 rows total.
-- Source: Silver.google_ads_performance
-- No talent_id. Joins to dim_date only.
-- ============================================================

IF OBJECT_ID('Gold.fact_google_spend', 'U') IS NOT NULL
DROP TABLE Gold.fact_google_spend
GO

CREATE TABLE Gold.fact_google_spend (
    google_spend_key        INT             NOT NULL IDENTITY(1,1) PRIMARY KEY,
    google_row_id           NVARCHAR(20)    NOT NULL,
    date_key                INT             NULL,
    campaign_id             NVARCHAR(20)    NULL,
    campaign_name           NVARCHAR(MAX)   NULL,
    spend_cad               DECIMAL(10,2)   NULL,
    impressions             INT             NULL,
    clicks                  INT             NULL,
    avg_cpc_cad             DECIMAL(8,2)    NULL,
    conversions             INT             NULL,
    conversion_rate         DECIMAL(5,2)    NULL,
    quality_score_avg       DECIMAL(4,1)    NULL,
    landing_page_sessions   INT             NULL,
    month_number            INT             NULL
);
GO

INSERT INTO Gold.fact_google_spend (
    google_row_id,
    date_key,
    campaign_id,
    campaign_name,
    spend_cad,
    impressions,
    clicks,
    avg_cpc_cad,
    conversions,
    conversion_rate,
    quality_score_avg,
    landing_page_sessions,
    month_number
)
SELECT
    ga.google_row_id,

    dd.date_key,

    ga.campaign_id,
    ga.campaign_name,
    ga.spend_cad,
    ga.impressions,
    ga.clicks,
    ga.avg_cpc_cad,
    ga.conversions,
    ga.conversion_rate,
    ga.quality_score_avg,
    ga.landing_page_sessions,

    MONTH(ga.record_date)

FROM Silver.google_ads_performance ga

LEFT JOIN Gold.dim_date dd
    ON CAST(FORMAT(ga.record_date, 'yyyyMMdd') AS INT) = dd.date_key;

-- Validate
SELECT COUNT(*) AS fact_google_spend_count
FROM Gold.fact_google_spend;
-- Expected: 480

SELECT
    month_number,
    SUM(spend_cad) AS total_spend
FROM Gold.fact_google_spend
GROUP BY month_number
ORDER BY month_number;
-- Note the monthly spend totals

GO


-- ============================================================
-- FACT 4: fact_email_events
-- One row per email event per contact. 1965 rows total.
-- Source: Silver.email_campaign_performance
-- joined to Gold.dim_talent and Gold.dim_date.
-- ============================================================

IF OBJECT_ID('Gold.fact_email_events', 'U') IS NOT NULL
DROP TABLE Gold.fact_email_events
GO

CREATE TABLE Gold.fact_email_events (
    email_key               INT             NOT NULL IDENTITY(1,1) PRIMARY KEY,
    email_event_id          NVARCHAR(20)    NOT NULL,
    talent_key              INT             NULL,
    date_key                INT             NULL,
    campaign_email_id       NVARCHAR(20)    NULL,
    contact_id              NVARCHAR(10)    NULL,
    event_type              NVARCHAR(20)    NULL,
    event_timestamp         DATETIME2       NULL,
    talent_tier_featured    NVARCHAR(20)    NULL,
    converted_to_inquiry    NVARCHAR(5)     NULL,
    inquiry_deal_id         NVARCHAR(15)    NULL,
    month_number            INT             NULL,
    is_converted            BIT             NOT NULL
);
GO

INSERT INTO Gold.fact_email_events (
    email_event_id,
    talent_key,
    date_key,
    campaign_email_id,
    contact_id,
    event_type,
    event_timestamp,
    talent_tier_featured,
    converted_to_inquiry,
    inquiry_deal_id,
    month_number,
    is_converted
)
SELECT
    ec.email_event_id,

    dt.talent_key,

    dd.date_key,

    ec.campaign_email_id,
    ec.contact_id,
    ec.event_type,
    ec.event_timestamp,
    ec.talent_tier_featured,
    ec.converted_to_inquiry,
    ec.inquiry_deal_id,

    MONTH(ec.send_date),

    CASE WHEN ec.converted_to_inquiry = 'Yes' THEN 1 ELSE 0 END

FROM Silver.email_campaign_performance ec

LEFT JOIN Gold.dim_talent dt
    ON ec.talent_id = dt.talent_id

LEFT JOIN Gold.dim_date dd
    ON CAST(FORMAT(ec.send_date, 'yyyyMMdd') AS INT) = dd.date_key;

-- Validate
SELECT COUNT(*) AS fact_email_events_count
FROM Gold.fact_email_events;
-- Expected: 1965

SELECT COUNT(*) AS unmatched_talent_keys
FROM Gold.fact_email_events
WHERE talent_key IS NULL;
-- Expected: 0

SELECT
    month_number,
    COUNT(*)                            AS total_events,
    SUM(CAST(is_converted AS INT))      AS total_conversions
FROM Gold.fact_email_events
GROUP BY month_number
ORDER BY month_number;
-- Note conversion counts by month
GO


-- ============================================================
-- FINAL GOLD LAYER ROW COUNT SUMMARY
-- ============================================================

SELECT 'dim_talent'         AS table_name, COUNT(*) AS row_count FROM Gold.dim_talent
UNION ALL
SELECT 'dim_date'           AS table_name, COUNT(*) AS row_count FROM Gold.dim_date
UNION ALL
SELECT 'dim_channel'        AS table_name, COUNT(*) AS row_count FROM Gold.dim_channel
UNION ALL
SELECT 'fact_deals'         AS table_name, COUNT(*) AS row_count FROM Gold.fact_deals
UNION ALL
SELECT 'fact_meta_spend'    AS table_name, COUNT(*) AS row_count FROM Gold.fact_meta_spend
UNION ALL
SELECT 'fact_google_spend'  AS table_name, COUNT(*) AS row_count FROM Gold.fact_google_spend
UNION ALL
SELECT 'fact_email_events'  AS table_name, COUNT(*) AS row_count FROM Gold.fact_email_events;

-- Expected:
-- dim_talent          45
-- dim_date           120
-- dim_channel          5
-- fact_deals         342
-- fact_meta_spend   2160
-- fact_google_spend  480
-- fact_email_events 1965