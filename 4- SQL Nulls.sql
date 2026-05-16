-- ================================================
-- NULL PROFILING ACROSS ALL DUPLICATE TABLES
-- ================================================

-- talent_profiles
SELECT
    SUM(CASE WHEN talent_id IS NULL THEN 1 ELSE 0 END)          AS talent_id_nulls,
    SUM(CASE WHEN talent_name IS NULL THEN 1 ELSE 0 END)        AS talent_name_nulls,
    SUM(CASE WHEN talent_category IS NULL THEN 1 ELSE 0 END)    AS talent_category_nulls,
    SUM(CASE WHEN tier IS NULL THEN 1 ELSE 0 END)               AS tier_nulls,
    SUM(CASE WHEN primary_platform IS NULL THEN 1 ELSE 0 END)   AS primary_platform_nulls,
    SUM(CASE WHEN total_followers IS NULL THEN 1 ELSE 0 END)    AS total_followers_nulls,
    SUM(CASE WHEN engagement_rate IS NULL THEN 1 ELSE 0 END)    AS engagement_rate_nulls,
    SUM(CASE WHEN niche_category IS NULL THEN 1 ELSE 0 END)     AS niche_category_nulls,
    SUM(CASE WHEN signed_date IS NULL THEN 1 ELSE 0 END)        AS signed_date_nulls,
    SUM(CASE WHEN region IS NULL THEN 1 ELSE 0 END)             AS region_nulls,
    SUM(CASE WHEN active_status IS NULL THEN 1 ELSE 0 END)      AS active_status_nulls
FROM Duplicate.talent_profiles;

-- deal_pipeline
SELECT
    SUM(CASE WHEN deal_id IS NULL THEN 1 ELSE 0 END)                AS deal_id_nulls,
    SUM(CASE WHEN talent_id IS NULL THEN 1 ELSE 0 END)              AS talent_id_nulls,
    SUM(CASE WHEN brand_name IS NULL THEN 1 ELSE 0 END)             AS brand_name_nulls,
    SUM(CASE WHEN deal_stage IS NULL THEN 1 ELSE 0 END)             AS deal_stage_nulls,
    SUM(CASE WHEN stage_entry_date IS NULL THEN 1 ELSE 0 END)       AS stage_entry_date_nulls,
    SUM(CASE WHEN stage_exit_date IS NULL THEN 1 ELSE 0 END)        AS stage_exit_date_nulls,
    SUM(CASE WHEN deal_value IS NULL THEN 1 ELSE 0 END)             AS deal_value_nulls,
    SUM(CASE WHEN acquisition_channel IS NULL THEN 1 ELSE 0 END)    AS acquisition_channel_nulls,
    SUM(CASE WHEN inquiry_date IS NULL THEN 1 ELSE 0 END)           AS inquiry_date_nulls,
    SUM(CASE WHEN close_date IS NULL THEN 1 ELSE 0 END)             AS close_date_nulls,
    SUM(CASE WHEN closed_status IS NULL THEN 1 ELSE 0 END)          AS closed_status_nulls,
    SUM(CASE WHEN sales_cycle_days IS NULL THEN 1 ELSE 0 END)       AS sales_cycle_days_nulls,
    SUM(CASE WHEN agency_commission IS NULL THEN 1 ELSE 0 END)      AS agency_commission_nulls,
    SUM(CASE WHEN brand_buyer_email IS NULL THEN 1 ELSE 0 END)      AS brand_buyer_email_nulls,
    SUM(CASE WHEN consent_timestamp IS NULL THEN 1 ELSE 0 END)      AS consent_timestamp_nulls
FROM Duplicate.deal_pipeline;

-- meta_campaign_performance
SELECT
    SUM(CASE WHEN meta_row_id IS NULL THEN 1 ELSE 0 END)            AS meta_row_id_nulls,
    SUM(CASE WHEN campaign_id IS NULL THEN 1 ELSE 0 END)            AS campaign_id_nulls,
    SUM(CASE WHEN ad_set_id IS NULL THEN 1 ELSE 0 END)              AS ad_set_id_nulls,
    SUM(CASE WHEN talent_id IS NULL THEN 1 ELSE 0 END)              AS talent_id_nulls,
    SUM(CASE WHEN campaign_objective IS NULL THEN 1 ELSE 0 END)     AS campaign_objective_nulls,
    SUM(CASE WHEN record_date IS NULL THEN 1 ELSE 0 END)            AS record_date_nulls,
    SUM(CASE WHEN spend_cad IS NULL THEN 1 ELSE 0 END)              AS spend_cad_nulls,
    SUM(CASE WHEN impressions IS NULL THEN 1 ELSE 0 END)            AS impressions_nulls,
    SUM(CASE WHEN reach IS NULL THEN 1 ELSE 0 END)                  AS reach_nulls,
    SUM(CASE WHEN clicks IS NULL THEN 1 ELSE 0 END)                 AS clicks_nulls,
    SUM(CASE WHEN follower_change IS NULL THEN 1 ELSE 0 END)        AS follower_change_nulls,
    SUM(CASE WHEN utm_source IS NULL THEN 1 ELSE 0 END)             AS utm_source_nulls,
    SUM(CASE WHEN utm_medium IS NULL THEN 1 ELSE 0 END)             AS utm_medium_nulls,
    SUM(CASE WHEN utm_campaign IS NULL THEN 1 ELSE 0 END)           AS utm_campaign_nulls,
    SUM(CASE WHEN traffic_type IS NULL THEN 1 ELSE 0 END)           AS traffic_type
    FROM Duplicate.meta_campaign_performance;

-- google_ads_performance
SELECT
    SUM(CASE WHEN google_row_id IS NULL THEN 1 ELSE 0 END)          AS google_row_id_nulls,
    SUM(CASE WHEN campaign_id IS NULL THEN 1 ELSE 0 END)            AS campaign_id_nulls,
    SUM(CASE WHEN campaign_name IS NULL THEN 1 ELSE 0 END)          AS campaign_name_nulls,
    SUM(CASE WHEN record_date IS NULL THEN 1 ELSE 0 END)            AS record_date_nulls,
    SUM(CASE WHEN spend_cad IS NULL THEN 1 ELSE 0 END)              AS spend_cad_nulls,
    SUM(CASE WHEN impressions IS NULL THEN 1 ELSE 0 END)            AS impressions_nulls,
    SUM(CASE WHEN clicks IS NULL THEN 1 ELSE 0 END)                 AS clicks_nulls,
    SUM(CASE WHEN avg_cpc_cad IS NULL THEN 1 ELSE 0 END)            AS avg_cpc_cad_nulls,
    SUM(CASE WHEN conversions IS NULL THEN 1 ELSE 0 END)            AS conversions_nulls,
    SUM(CASE WHEN conversion_rate IS NULL THEN 1 ELSE 0 END)        AS conversion_rate_nulls,
    SUM(CASE WHEN utm_source IS NULL THEN 1 ELSE 0 END)             AS utm_source_nulls,
    SUM(CASE WHEN utm_medium IS NULL THEN 1 ELSE 0 END)             AS utm_medium_nulls,
    SUM(CASE WHEN utm_campaign IS NULL THEN 1 ELSE 0 END)           AS utm_campaign_nulls,
    SUM(CASE WHEN quality_score_avg IS NULL THEN 1 ELSE 0 END)      AS quality_score_avg_nulls,
    SUM(CASE WHEN landing_page_sessions IS NULL THEN 1 ELSE 0 END)  AS landing_page_sessions_nulls
FROM Duplicate.google_ads_performance;

-- email_campaign_performance
SELECT
    SUM(CASE WHEN email_event_id IS NULL THEN 1 ELSE 0 END)         AS email_event_id_nulls,
    SUM(CASE WHEN campaign_email_id IS NULL THEN 1 ELSE 0 END)      AS campaign_email_id_nulls,
    SUM(CASE WHEN contact_id IS NULL THEN 1 ELSE 0 END)             AS contact_id_nulls,
    SUM(CASE WHEN talent_id IS NULL THEN 1 ELSE 0 END)              AS talent_id_nulls,
    SUM(CASE WHEN send_date IS NULL THEN 1 ELSE 0 END)              AS send_date_nulls,
    SUM(CASE WHEN event_type IS NULL THEN 1 ELSE 0 END)             AS event_type_nulls,
    SUM(CASE WHEN event_timestamp IS NULL THEN 1 ELSE 0 END)        AS event_timestamp_nulls,
    SUM(CASE WHEN consent_timestamp IS NULL THEN 1 ELSE 0 END)      AS consent_timestamp_nulls,
    SUM(CASE WHEN email_subject_line IS NULL THEN 1 ELSE 0 END)     AS email_subject_line_nulls,
    SUM(CASE WHEN talent_tier_featured IS NULL THEN 1 ELSE 0 END)   AS talent_tier_featured_nulls,
    SUM(CASE WHEN converted_to_inquiry IS NULL THEN 1 ELSE 0 END)   AS converted_to_inquiry_nulls,
    SUM(CASE WHEN inquiry_deal_id IS NULL THEN 1 ELSE 0 END)        AS inquiry_deal_id_nulls,
    SUM(CASE WHEN utm_source IS NULL THEN 1 ELSE 0 END)             AS utm_source_nulls,
    SUM(CASE WHEN utm_medium IS NULL THEN 1 ELSE 0 END)             AS utm_medium_nulls
FROM Duplicate.email_campaign_performance;


-----------------------------------------------------------------------------------------------------------------
-- Identify the 9 closed records missing stage_exit_date
SELECT
    deal_id,
    deal_stage,
    stage_exit_date,
    close_date,
    closed_status
FROM Duplicate.deal_pipeline
WHERE stage_exit_date IS NULL
AND closed_status IS NOT NULL;

-------------------------------------------------------------------------------------------------------------------
USE MadreTalentsGroup;

-- ============================================================
-- NULL HANDLING LAYER: ALL FIVE TABLES
-- ============================================================

-- ============================================================
-- talent_profiles
-- Zero nulls found. Pass through from Duplicate unchanged.
-- ============================================================

IF OBJECT_ID('Null_Handling.talent_profiles', 'U') IS NOT NULL
DROP TABLE Null_Handling.talent_profiles
GO

CREATE TABLE Null_Handling.talent_profiles (
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

INSERT INTO Null_Handling.talent_profiles
SELECT * FROM Duplicate.talent_profiles;

SELECT COUNT(*) AS talent_profiles_count
FROM Null_Handling.talent_profiles;
-- Expected: 45

GO

-- ============================================================
-- deal_pipeline
-- 141 nulls in stage_exit_date.
-- 132 are open pipeline records. Retained as structural.
-- 9 are Closed Lost records where automation failed.
-- Decision: impute stage_exit_date from close_date for those 9.
-- All other nulls retained as structural.
-- ============================================================

SELECT * FROM Duplicate.deal_pipeline

IF OBJECT_ID('Null_Handling.deal_pipeline', 'U') IS NOT NULL
DROP TABLE Null_Handling.deal_pipeline
GO

CREATE TABLE Null_Handling.deal_pipeline (
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

INSERT INTO Null_Handling.deal_pipeline (
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

    -- Impute stage_exit_date from close_date for the 9 Closed Lost
    -- records where automation failed to populate it.
    -- All other nulls are open pipeline records and are retained.
    CASE
        WHEN stage_exit_date IS NULL
         AND closed_status IS NOT NULL
            THEN close_date
        ELSE stage_exit_date
    END,

    deal_value,
    acquisition_channel,
    inquiry_date,
    close_date,
    closed_status,
    sales_cycle_days,
    agency_commission,
    brand_buyer_email,
    consent_timestamp

FROM Duplicate.deal_pipeline;

-- Validate
SELECT COUNT(*) AS deal_pipeline_count
FROM Null_Handling.deal_pipeline;
-- Expected: 342

-- Confirm the 9 imputed records now have stage_exit_date populated
SELECT
    deal_id,
    deal_stage,
    stage_exit_date,
    close_date,
    closed_status
FROM Null_Handling.deal_pipeline
WHERE deal_id IN (
    'DL-2026-0082','DL-2026-0098','DL-2026-0105',
    'DL-2026-0144','DL-2026-0156','DL-2026-0157',
    'DL-2026-0198','DL-2026-0199','DL-2026-0201'
);
-- Expected: stage_exit_date matches close_date for all 9

-- Confirm remaining stage_exit_date nulls are all open pipeline records
SELECT COUNT(*) AS remaining_stage_exit_nulls
FROM Null_Handling.deal_pipeline
WHERE stage_exit_date IS NULL;
-- Expected: 132

SELECT COUNT(*) AS open_records_check
FROM Null_Handling.deal_pipeline
WHERE stage_exit_date IS NULL
AND closed_status IS NULL;
-- Expected: same number as above confirming all remaining nulls
-- are open pipeline records with no closed_status

GO

-- ============================================================
-- meta_campaign_performance
-- utm_source: 430 nulls, structural, retained
-- utm_medium: 430 nulls, structural, retained
-- utm_campaign: 470 nulls, structural, retained
-- All nulls represent pre-February UTM attribution gap.
-- Pass through from Duplicate unchanged.
-- ============================================================

IF OBJECT_ID('Null_Handling.meta_campaign_performance', 'U') IS NOT NULL
DROP TABLE Null_Handling.meta_campaign_performance
GO

CREATE TABLE Null_Handling.meta_campaign_performance (
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

INSERT INTO Null_Handling.meta_campaign_performance
SELECT * FROM Duplicate.meta_campaign_performance;

SELECT COUNT(*) AS meta_count
FROM Null_Handling.meta_campaign_performance;
-- Expected: 2160

GO

-- ============================================================
-- google_ads_performance
-- utm_source: 49 nulls, structural, retained
-- utm_medium: 49 nulls, structural, retained
-- utm_campaign: 49 nulls, structural, retained
-- All nulls represent January auto-tagging gap.
-- Pass through from Duplicate unchanged.
-- ============================================================

IF OBJECT_ID('Null_Handling.google_ads_performance', 'U') IS NOT NULL
DROP TABLE Null_Handling.google_ads_performance
GO

CREATE TABLE Null_Handling.google_ads_performance (
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

INSERT INTO Null_Handling.google_ads_performance
SELECT * FROM Duplicate.google_ads_performance;

SELECT COUNT(*) AS google_count
FROM Null_Handling.google_ads_performance;
-- Expected: 480

GO

-- ============================================================
-- email_campaign_performance
-- talent_tier_featured: 810 nulls, structural, retained
--   January records predate the field existing in the template
-- inquiry_deal_id: 1953 nulls, structural, retained
--   Only Converted events carry a deal ID
-- utm_source: 295 nulls, structural, retained
-- utm_medium: 295 nulls, structural, retained
--   Pre-February attribution gap
-- Pass through from Duplicate unchanged.
-- ============================================================

IF OBJECT_ID('Null_Handling.email_campaign_performance', 'U') IS NOT NULL
DROP TABLE Null_Handling.email_campaign_performance
GO

CREATE TABLE Null_Handling.email_campaign_performance (
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

INSERT INTO Null_Handling.email_campaign_performance
SELECT * FROM Duplicate.email_campaign_performance;

SELECT COUNT(*) AS email_count
FROM Null_Handling.email_campaign_performance;
-- Expected: 1965

GO