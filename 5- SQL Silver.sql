USE MadreTalentsGroup;
GO
--------------------------------------------------------------------------------------------------------------------------
-- Confirm final row counts leaving Null_Handling
SELECT 'talent_profiles'            AS table_name, COUNT(*) AS row_count FROM Null_Handling.talent_profiles
UNION ALL
SELECT 'deal_pipeline'              AS table_name, COUNT(*) AS row_count FROM Null_Handling.deal_pipeline
UNION ALL
SELECT 'meta_campaign_performance'  AS table_name, COUNT(*) AS row_count FROM Null_Handling.meta_campaign_performance
UNION ALL
SELECT 'google_ads_performance'     AS table_name, COUNT(*) AS row_count FROM Null_Handling.google_ads_performance
UNION ALL
SELECT 'email_campaign_performance' AS table_name, COUNT(*) AS row_count FROM Null_Handling.email_campaign_performance;
--------------------------------------------------------------------------------------------------------------------------

USE MadreTalentsGroup;

-- ============================================================
-- SILVER LAYER: ALL FIVE TABLES
-- Final clean layer. No transformations applied here.
-- Data promoted directly from Null_Handling.
-- Row counts must match Null_Handling exactly.
-- ============================================================


-- ============================================================
-- talent_profiles
-- ============================================================

IF OBJECT_ID('Silver.talent_profiles', 'U') IS NOT NULL
DROP TABLE Silver.talent_profiles
GO

CREATE TABLE Silver.talent_profiles (
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

INSERT INTO Silver.talent_profiles
SELECT * FROM Null_Handling.talent_profiles;

-- Validate
SELECT COUNT(*) AS talent_profiles_silver_count
FROM Silver.talent_profiles;
-- Expected: 45

SELECT DISTINCT talent_category FROM Silver.talent_profiles;
-- Expected: Musician, Comedian, Digital Creator

SELECT DISTINCT tier FROM Silver.talent_profiles;
-- Expected: Top-Tier, Mid-Tier, Emerging

SELECT DISTINCT region FROM Silver.talent_profiles;
-- Expected: Canada, Canada-US Crossover, Canada-UK Emerging

SELECT * FROM Silver.talent_profiles
WHERE talent_id IS NULL;
-- Expected: 0 rows

GO


-- ============================================================
-- deal_pipeline
-- ============================================================

IF OBJECT_ID('Silver.deal_pipeline', 'U') IS NOT NULL
DROP TABLE Silver.deal_pipeline
GO

CREATE TABLE Silver.deal_pipeline (
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

INSERT INTO Silver.deal_pipeline
SELECT * FROM Null_Handling.deal_pipeline;

-- Validate
SELECT COUNT(*) AS deal_pipeline_silver_count
FROM Silver.deal_pipeline;
-- Expected: 342

SELECT DISTINCT acquisition_channel
FROM Silver.deal_pipeline;
-- Expected: Meta Ads, Google Ads, Email Campaign, Direct, Referral

SELECT DISTINCT closed_status
FROM Silver.deal_pipeline;
-- Expected: Won, Lost, NULL

SELECT
    MONTH(close_date)   AS month_number,
    COUNT(*)            AS won_deals
FROM Silver.deal_pipeline
WHERE closed_status = 'Won'
GROUP BY MONTH(close_date)
ORDER BY month_number;
-- Expected: 1=22, 2=22, 3=22, 4=14

SELECT COUNT(*) AS imputed_exit_dates
FROM Silver.deal_pipeline
WHERE stage_exit_date IS NULL
AND closed_status IS NOT NULL;
-- Expected: 0, confirms all 9 imputed records are correct

GO


-- ============================================================
-- meta_campaign_performance
-- ============================================================

IF OBJECT_ID('Silver.meta_campaign_performance', 'U') IS NOT NULL
DROP TABLE Silver.meta_campaign_performance
GO

CREATE TABLE Silver.meta_campaign_performance (
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

INSERT INTO Silver.meta_campaign_performance
SELECT * FROM Null_Handling.meta_campaign_performance;

-- Validate
SELECT COUNT(*) AS meta_silver_count
FROM Silver.meta_campaign_performance;
-- Expected: 2160

SELECT DISTINCT campaign_objective
FROM Silver.meta_campaign_performance;
-- Expected: Reach, Follower Growth, Engagement, Traffic, Conversions

SELECT COUNT(*) AS zero_spend_rows
FROM Silver.meta_campaign_performance
WHERE spend_cad = 0;
-- Note this count, valid records not errors

GO


-- ============================================================
-- google_ads_performance
-- ============================================================

IF OBJECT_ID('Silver.google_ads_performance', 'U') IS NOT NULL
DROP TABLE Silver.google_ads_performance
GO

CREATE TABLE Silver.google_ads_performance (
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

INSERT INTO Silver.google_ads_performance
SELECT * FROM Null_Handling.google_ads_performance;

-- Validate
SELECT COUNT(*) AS google_silver_count
FROM Silver.google_ads_performance;
-- Expected: 480

SELECT DISTINCT campaign_name
FROM Silver.google_ads_performance;
-- Expected: 4 canonical campaign names only

SELECT COUNT(*) AS utm_nulls
FROM Silver.google_ads_performance
WHERE utm_source IS NULL;
-- Expected: 49, structural nulls confirmed

GO


-- ============================================================
-- email_campaign_performance
-- ============================================================

IF OBJECT_ID('Silver.email_campaign_performance', 'U') IS NOT NULL
DROP TABLE Silver.email_campaign_performance
GO

CREATE TABLE Silver.email_campaign_performance (
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

INSERT INTO Silver.email_campaign_performance
SELECT * FROM Null_Handling.email_campaign_performance;

-- Validate
SELECT COUNT(*) AS email_silver_count
FROM Silver.email_campaign_performance;
-- Expected: 1965

SELECT DISTINCT event_type
FROM Silver.email_campaign_performance;
-- Expected: Sent, Opened, Clicked, Converted

SELECT DISTINCT converted_to_inquiry
FROM Silver.email_campaign_performance;
-- Expected: Yes, No, NULL

SELECT COUNT(*) AS lpad_check
FROM Silver.email_campaign_performance
WHERE LEN(talent_id) < 6;
-- Expected: 0

SELECT COUNT(*) AS tier_nulls
FROM Silver.email_campaign_performance
WHERE talent_tier_featured IS NULL;
-- Expected: 810, structural nulls from January records

GO


-- ============================================================
-- FINAL SILVER LAYER ROW COUNT SUMMARY
-- ============================================================

SELECT 'talent_profiles'            AS table_name, COUNT(*) AS silver_count FROM Silver.talent_profiles
UNION ALL
SELECT 'deal_pipeline'              AS table_name, COUNT(*) AS silver_count FROM Silver.deal_pipeline
UNION ALL
SELECT 'meta_campaign_performance'  AS table_name, COUNT(*) AS silver_count FROM Silver.meta_campaign_performance
UNION ALL
SELECT 'google_ads_performance'     AS table_name, COUNT(*) AS silver_count FROM Silver.google_ads_performance
UNION ALL
SELECT 'email_campaign_performance' AS table_name, COUNT(*) AS silver_count FROM Silver.email_campaign_performance;
-- Expected:
-- talent_profiles            45
-- deal_pipeline             342
-- meta_campaign_performance 2160
-- google_ads_performance     480
-- email_campaign_performance 1965