USE MadreTalentsGroup;
GO

-----------------------------------------------------------------------------------------------------------------
-- Row counts entering Duplicate layer
SELECT 'talent_profiles'           AS table_name, COUNT(*) AS row_count FROM Datatype.talent_profiles
UNION ALL
SELECT 'deal_pipeline'             AS table_name, COUNT(*) AS row_count FROM Datatype.deal_pipeline
UNION ALL
SELECT 'meta_campaign_performance' AS table_name, COUNT(*) AS row_count FROM Datatype.meta_campaign_performance
UNION ALL
SELECT 'google_ads_performance'    AS table_name, COUNT(*) AS row_count FROM Datatype.google_ads_performance
UNION ALL
SELECT 'email_campaign_performance'AS table_name, COUNT(*) AS row_count FROM Datatype.email_campaign_performance;
-----------------------------------------------------------------------------------------------------------------

-- ================================================
-- DUPLICATE CHECKS ACROSS ALL DATATYPE TABLES
-- ================================================

-- talent_profiles
-- Primary key: talent_id
SELECT 
    talent_id,
    COUNT(*) AS occurrence_count
FROM Datatype.talent_profiles
GROUP BY talent_id
HAVING COUNT(*) > 1;

-- deal_pipeline
-- Duplicate defined as: same deal_id and same stage_entry_date
SELECT 
    deal_id,
    stage_entry_date,
    COUNT(*) AS occurrence_count
FROM Datatype.deal_pipeline
GROUP BY deal_id, stage_entry_date
HAVING COUNT(*) > 1;
-- to check for deal pipleine
SELECT *
FROM Datatype.deal_pipeline
WHERE deal_id IN (
    'DL-2026-0001',
    'DL-2026-0012',
    'DL-2026-0018',
    'DL-2026-0008',
    'DL-2026-0010',
    'DL-2026-0017',
    'DL-2026-0038',
    'DL-2026-0039'
)
ORDER BY deal_id, stage_entry_date;



-- meta_campaign_performance
-- Primary key: meta_row_id
SELECT 
    meta_row_id,
    COUNT(*) AS occurrence_count
FROM Datatype.meta_campaign_performance
GROUP BY meta_row_id
HAVING COUNT(*) > 1;

-- google_ads_performance
-- Primary key: google_row_id
SELECT 
    google_row_id,
    COUNT(*) AS occurrence_count
FROM Datatype.google_ads_performance
GROUP BY google_row_id
HAVING COUNT(*) > 1;

-- email_campaign_performance
-- Primary key: email_event_id
SELECT 
    email_event_id,
    COUNT(*) AS occurrence_count
FROM Datatype.email_campaign_performance
GROUP BY email_event_id
HAVING COUNT(*) > 1;



-- ============================================================
-- talent_profiles
-- No duplicates found. Pass through from Datatype unchanged.
-- ============================================================

IF OBJECT_ID('Duplicate.talent_profiles', 'U') IS NOT NULL
DROP TABLE Duplicate.talent_profiles
GO

CREATE TABLE Duplicate.talent_profiles (
    talent_id           NVARCHAR(10)    NULL,
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

INSERT INTO Duplicate.talent_profiles
SELECT * FROM Datatype.talent_profiles;

SELECT COUNT(*) AS talent_profiles_count
FROM Duplicate.talent_profiles;
-- Expected: 45

GO

-- ============================================================
-- deal_pipeline
-- 8 exact duplicate pairs found via system sync double-fire.
-- Definition: same deal_id and same stage_entry_date.
-- Strategy: keep row_number = 1, exclude row_number = 2.
-- ============================================================

IF OBJECT_ID('Duplicate.deal_pipeline', 'U') IS NOT NULL
DROP TABLE Duplicate.deal_pipeline
GO

CREATE TABLE Duplicate.deal_pipeline (
    deal_id                 NVARCHAR(15)    NULL,
    talent_id               NVARCHAR(10)    NULL,
    brand_name              NVARCHAR(MAX)   NULL,
    deal_stage              NVARCHAR(50)    NULL,
    stage_entry_date        DATE            NULL,
    stage_exit_date         DATE            NULL,
    deal_value              DECIMAL(10,2)   NULL,
    acquisition_channel     NVARCHAR(50)    NULL,
    inquiry_date            DATE            NULL,
    close_date              DATE            NULL,
    closed_status           NVARCHAR(20)    NULL,
    sales_cycle_days        INT             NULL,
    agency_commission       DECIMAL(10,2)   NULL,
    brand_buyer_email       NVARCHAR(MAX)   NULL,
    consent_timestamp       DATETIME2       NULL
);
GO

WITH ranked_deals AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY deal_id, stage_entry_date
            ORDER BY deal_id
        ) AS row_num
    FROM Datatype.deal_pipeline
)
INSERT INTO Duplicate.deal_pipeline (
    deal_id,
    talent_id,
    brand_name,
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
    brand_buyer_email,
    consent_timestamp
)
SELECT
    deal_id,
    talent_id,
    brand_name,
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
    brand_buyer_email,
    consent_timestamp
FROM ranked_deals
WHERE row_num = 1;

-- Validate
SELECT COUNT(*) AS deal_pipeline_count
FROM Duplicate.deal_pipeline;
-- Expected: 342

SELECT
    deal_id,
    stage_entry_date,
    COUNT(*) AS occurrence_count
FROM Duplicate.deal_pipeline
GROUP BY deal_id, stage_entry_date
HAVING COUNT(*) > 1;
-- Expected: 0 rows

SELECT
    closed_status,
    COUNT(*) AS deal_count
FROM Duplicate.deal_pipeline
WHERE closed_status = 'Won'
GROUP BY closed_status;
-- Expected: 80

SELECT
    MONTH(close_date) AS month_number,
    COUNT(*) AS won_deals
FROM Duplicate.deal_pipeline
WHERE closed_status = 'Won'
GROUP BY MONTH(close_date)
ORDER BY month_number;
-- Expected: 1=22, 2=22, 3=22, 4=14

GO

-- ============================================================
-- meta_campaign_performance
-- No duplicates found. Pass through from Datatype unchanged.
-- ============================================================

IF OBJECT_ID('Duplicate.meta_campaign_performance', 'U') IS NOT NULL
DROP TABLE Duplicate.meta_campaign_performance
GO

CREATE TABLE Duplicate.meta_campaign_performance (
    meta_row_id             NVARCHAR(20)    NULL,
    campaign_id             NVARCHAR(20)    NULL,
    ad_set_id               NVARCHAR(20)    NULL,
    talent_id               NVARCHAR(10)    NULL,
    campaign_objective      NVARCHAR(50)    NULL,
    record_date             DATE            NULL,
    spend_cad               DECIMAL(10,2)   NULL,
    impressions             INT             NULL,
    reach                   INT             NULL,
    clicks                  INT             NULL,
    follower_change         INT             NULL,
    utm_source              NVARCHAR(50)    NULL,
    utm_medium              NVARCHAR(50)    NULL,
    utm_campaign            NVARCHAR(100)   NULL,
    traffic_type            NVARCHAR(20)    NULL,
    landing_page_sessions   INT             NULL,
    page_inquiries          INT             NULL
);
GO

INSERT INTO Duplicate.meta_campaign_performance
SELECT * FROM Datatype.meta_campaign_performance;

SELECT COUNT(*) AS meta_count
FROM Duplicate.meta_campaign_performance;
-- Expected: 2160

GO

-- ============================================================
-- google_ads_performance
-- No duplicates found. Pass through from Datatype unchanged.
-- ============================================================

IF OBJECT_ID('Duplicate.google_ads_performance', 'U') IS NOT NULL
DROP TABLE Duplicate.google_ads_performance
GO

CREATE TABLE Duplicate.google_ads_performance (
    google_row_id           NVARCHAR(20)    NULL,
    campaign_id             NVARCHAR(20)    NULL,
    campaign_name           NVARCHAR(MAX)   NULL,
    record_date             DATE            NULL,
    spend_cad               DECIMAL(10,2)   NULL,
    impressions             INT             NULL,
    clicks                  INT             NULL,
    avg_cpc_cad             DECIMAL(8,2)    NULL,
    conversions             INT             NULL,
    conversion_rate         DECIMAL(5,2)    NULL,
    utm_source              NVARCHAR(50)    NULL,
    utm_medium              NVARCHAR(50)    NULL,
    utm_campaign            NVARCHAR(100)   NULL,
    quality_score_avg       DECIMAL(4,1)    NULL,
    landing_page_sessions   INT             NULL
);
GO

INSERT INTO Duplicate.google_ads_performance
SELECT * FROM Datatype.google_ads_performance;

SELECT COUNT(*) AS google_count
FROM Duplicate.google_ads_performance;
-- Expected: 480

GO

-- ============================================================
-- email_campaign_performance
-- No duplicates found. Pass through from Datatype unchanged.
-- ============================================================

IF OBJECT_ID('Duplicate.email_campaign_performance', 'U') IS NOT NULL
DROP TABLE Duplicate.email_campaign_performance
GO

CREATE TABLE Duplicate.email_campaign_performance (
    email_event_id          NVARCHAR(20)    NULL,
    campaign_email_id       NVARCHAR(20)    NULL,
    contact_id              NVARCHAR(10)    NULL,
    talent_id               NVARCHAR(10)    NULL,
    send_date               DATE            NULL,
    event_type              NVARCHAR(20)    NULL,
    event_timestamp         DATETIME2       NULL,
    consent_timestamp       DATETIME2       NULL,
    email_subject_line      NVARCHAR(MAX)   NULL,
    talent_tier_featured    NVARCHAR(20)    NULL,
    converted_to_inquiry    NVARCHAR(5)     NULL,
    inquiry_deal_id         NVARCHAR(15)    NULL,
    utm_source              NVARCHAR(50)    NULL,
    utm_medium              NVARCHAR(50)    NULL
);
GO

INSERT INTO Duplicate.email_campaign_performance
SELECT * FROM Datatype.email_campaign_performance;

SELECT COUNT(*) AS email_count
FROM Duplicate.email_campaign_performance;
-- Expected: 1965

GO