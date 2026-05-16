USE MadreTalentsGroup;



------------------------------------------------------------------------------------------------
-- Talent Profiles
-- ================

SELECT * FROM Bronze.talent_profiles

SELECT COUNT(*) FROM Bronze.talent_profiles
SELECT DISTINCT talent_category FROM Bronze.talent_profiles
SELECT DISTINCT tier FROM Bronze.talent_profiles
SELECT DISTINCT region FROM Bronze.talent_profiles
SELECT DISTINCT active_status FROM Bronze.talent_profiles

SELECT * FROM Bronze.talent_profiles
SELECT * FROM Datatype.talent_profiles
----------------------------------------------------------
IF OBJECT_ID ('Datatype.talent_profiles', 'U') IS NOT NULL 
DROP TABLE Datatype.talent_profiles
GO

    CREATE TABLE Datatype.talent_profiles (
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
----------------------------------------------------------
SELECT * FROM Bronze.talent_profiles
SELECT * FROM Datatype.talent_profiles



TRUNCATE TABLE Datatype.talent_profiles;

INSERT INTO Datatype.talent_profiles (
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
    TRY_CAST(TRIM(talent_id) AS NVARCHAR(10)),

    TRY_CAST(TRIM(talent_name) AS NVARCHAR(MAX)),

    TRY_CAST(
        CASE 
            WHEN UPPER(TRIM(talent_category)) = 'MUSICIAN'        THEN 'Musician'
            WHEN UPPER(TRIM(talent_category)) = 'COMEDIAN'        THEN 'Comedian'
            WHEN UPPER(TRIM(talent_category)) = 'DIGITAL CREATOR' THEN 'Digital Creator'
            ELSE TRIM(talent_category)
        END
    AS NVARCHAR(50)),

    TRY_CAST(TRIM(tier) AS NVARCHAR(20)),

    TRY_CAST(TRIM(primary_platform) AS NVARCHAR(50)),

    TRY_CAST(TRIM(total_followers) AS INT),

    TRY_CAST(TRIM(engagement_rate) AS DECIMAL(5,2)),

    TRY_CAST(TRIM(niche_category) AS NVARCHAR(MAX)),

    CASE
        WHEN TRIM(signed_date) LIKE '[0-9][0-9]-[A-Z][a-z][a-z]-[0-9][0-9][0-9][0-9]'
            THEN TRY_CONVERT(DATE, TRIM(signed_date), 106)
        ELSE TRY_CAST(TRIM(signed_date) AS DATE)
    END,

    TRY_CAST(
        CASE
            WHEN UPPER(TRIM(region)) = 'CANADA'
                THEN 'Canada'
            WHEN UPPER(TRIM(region)) IN (
                'CANADA-US CROSSOVER',
                'CANADA - US CROSSOVER',
                'CANADA-US CROSSOVER '
            )
                THEN 'Canada-US Crossover'
            WHEN UPPER(TRIM(region)) IN (
                'CANADA-UK EMERGING',
                'CANADA-UK EMERGING ',
                'CANADA - UK EMERGING'
            )
                THEN 'Canada-UK Emerging'
            ELSE TRIM(region)
        END
    AS NVARCHAR(50)),

    TRY_CAST(TRIM(active_status) AS NVARCHAR(10))

FROM Bronze.talent_profiles;



SELECT COUNT(*) FROM Bronze.talent_profiles;


-- Validate
SELECT COUNT(*) AS talent_profiles_datatype_count 
FROM Datatype.talent_profiles;
-- Expected: 45

SELECT DISTINCT talent_category FROM Datatype.talent_profiles;
-- Expected: Musician, Comedian, Digital Creator

SELECT DISTINCT tier FROM Datatype.talent_profiles;
-- Expected: Top-Tier, Mid-Tier, Emerging

SELECT DISTINCT region FROM Datatype.talent_profiles;
-- Expected: Canada, Canada-US Crossover, Canada-UK Emerging

SELECT * FROM Datatype.talent_profiles 
WHERE TRY_CAST(signed_date AS DATE) IS NULL;
-- Expected: 0 rows, confirms all dates cast successfully

GO





------------------------------------------------------------------------------------------------

-- Deal Pipeline
-- ==============


SELECT * FROM Bronze.deal_pipeline

SELECT COUNT(*) FROM Bronze.talent_profiles
SELECT DISTINCT talent_category FROM Bronze.talent_profiles
SELECT DISTINCT tier FROM Bronze.talent_profiles
SELECT DISTINCT region FROM Bronze.talent_profiles
SELECT DISTINCT active_status FROM Bronze.talent_profiles

SELECT * FROM Bronze.talent_profiles
SELECT * FROM Datatype.talent_profiles

----------------------------------------------------------
IF OBJECT_ID ('Datatype.deal_pipeline', 'U') IS NOT NULL
DROP TABLE Datatype.deal_pipeline
GO

    CREATE TABLE Datatype.deal_pipeline (
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
----------------------------------------------------------

TRUNCATE TABLE Datatype.deal_pipeline;

INSERT INTO Datatype.deal_pipeline (
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
    TRIM(deal_id),

    TRIM(talent_id),

    TRIM(brand_name),

    TRIM(deal_stage),

    TRY_CAST(TRIM(stage_entry_date) AS DATE),

    TRY_CAST(TRIM(stage_exit_date) AS DATE),

    TRY_CAST(TRIM(deal_value) AS DECIMAL(10,2)),

    -- Standardise acquisition_channel to canonical values
    CASE
        WHEN UPPER(TRIM(acquisition_channel)) IN (
            'META ADS', 'META', 'FACEBOOK ADS', 'FACEBOOK'
        )                                               THEN 'Meta Ads'
        WHEN UPPER(TRIM(acquisition_channel)) IN (
            'GOOGLE ADS', 'GOOGLE'
        )                                               THEN 'Google Ads'
        WHEN UPPER(TRIM(acquisition_channel)) IN (
            'EMAIL CAMPAIGN', 'EMAIL', 'EMAIL CAMPAIGNS'
        )                                               THEN 'Email Campaign'
        WHEN UPPER(TRIM(acquisition_channel)) = 'DIRECT'    THEN 'Direct'
        WHEN UPPER(TRIM(acquisition_channel)) = 'REFERRAL'  THEN 'Referral'
        ELSE TRIM(acquisition_channel)
    END,

    TRY_CAST(TRIM(inquiry_date) AS DATE),

    TRY_CAST(TRIM(close_date) AS DATE),

    TRIM(closed_status),

    TRY_CAST(TRIM(sales_cycle_days) AS INT),

    TRY_CAST(TRIM(agency_commission) AS DECIMAL(10,2)),

    LOWER(TRIM(brand_buyer_email)),

    TRY_CAST(TRIM(consent_timestamp) AS DATETIME2)

FROM Bronze.deal_pipeline;

-- Validate
SELECT COUNT(*) AS deal_pipeline_datatype_count 
FROM Datatype.deal_pipeline;
-- Expected: 350

SELECT DISTINCT acquisition_channel FROM Datatype.deal_pipeline;
-- Expected: Meta Ads, Google Ads, Email Campaign, Direct, Referral only

SELECT COUNT(*) AS failed_deal_value_cast
FROM Datatype.deal_pipeline
WHERE deal_value IS NULL AND 
      (SELECT deal_value FROM Bronze.deal_pipeline b 
       WHERE b.deal_id = Datatype.deal_pipeline.deal_id) IS NOT NULL;
-- Expected: only intentional nulls from early stage records

GO


------------------------------------------------------------------------------------------------

-- Meta Campaign Performance
-- =========================

SELECT * FROM Bronze.meta_campaign_performance
SELECT * FROM Datatype.meta_campaign_performance


SELECT COUNT(*) FROM Bronze.talent_profiles
SELECT DISTINCT talent_category FROM Bronze.talent_profiles
SELECT DISTINCT tier FROM Bronze.talent_profiles
SELECT DISTINCT region FROM Bronze.talent_profiles
SELECT DISTINCT active_status FROM Bronze.talent_profiles

SELECT * FROM Bronze.talent_profiles
SELECT * FROM Datatype.talent_profiles
----------------------------------------------------------
IF OBJECT_ID ('Datatype.meta_campaign_performance', 'U') IS NOT NULL
DROP TABLE Datatype.meta_campaign_performance
GO

    CREATE TABLE Datatype.meta_campaign_performance (
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
----------------------------------------------------------

TRUNCATE TABLE Datatype.meta_campaign_performance;

INSERT INTO Datatype.meta_campaign_performance (
    meta_row_id,
    campaign_id,
    ad_set_id,
    talent_id,
    campaign_objective,
    record_date,
    spend_cad,
    impressions,
    reach,
    clicks,
    follower_change,
    utm_source,
    utm_medium,
    utm_campaign,
    traffic_type,
    landing_page_sessions,
    page_inquiries
)
SELECT
    TRY_CAST(TRIM(meta_row_id) AS NVARCHAR(20)),
    TRY_CAST(TRIM(campaign_id) AS NVARCHAR(20)),
    TRY_CAST(TRIM(ad_set_id) AS NVARCHAR(20)),
    TRY_CAST(TRIM(talent_id) AS NVARCHAR(10)),

    TRY_CAST(
        CASE
            WHEN UPPER(TRIM(campaign_objective)) IN ('REACH')                       THEN 'Reach'
            WHEN UPPER(TRIM(campaign_objective)) IN ('FOLLOWER GROWTH','FOLLOWER_GROWTH') THEN 'Follower Growth'
            WHEN UPPER(TRIM(campaign_objective)) IN ('ENGAGEMENT')                  THEN 'Engagement'
            WHEN UPPER(TRIM(campaign_objective)) IN ('TRAFFIC')                     THEN 'Traffic'
            WHEN UPPER(TRIM(campaign_objective)) IN ('CONVERSIONS')                 THEN 'Conversions'
            ELSE TRIM(campaign_objective)
        END
    AS NVARCHAR(50)),

    TRY_CAST(TRIM(record_date) AS DATE),
    TRY_CAST(TRIM(spend_cad) AS DECIMAL(10,2)),
    TRY_CAST(TRIM(impressions) AS INT),
    TRY_CAST(TRIM(reach) AS INT),
    TRY_CAST(TRIM(clicks) AS INT),
    TRY_CAST(TRIM(follower_change) AS INT),

    NULLIF(NULLIF(TRIM(utm_source), ''), 'NULL'),
    NULLIF(NULLIF(TRIM(utm_medium), ''), 'NULL'),
    NULLIF(NULLIF(TRIM(utm_campaign), ''), 'NULL'),

    TRY_CAST(TRIM(traffic_type) AS NVARCHAR(20)),
    TRY_CAST(TRIM(landing_page_sessions) AS INT),
    TRY_CAST(TRIM(page_inquiries) AS INT)

FROM Bronze.meta_campaign_performance;

SELECT COUNT(*) AS meta_datatype_count
FROM Datatype.meta_campaign_performance;
-- Expected: 2160

SELECT DISTINCT campaign_objective
FROM Datatype.meta_campaign_performance;
-- Expected: Reach, Follower Growth, Engagement, Traffic, Conversions only

SELECT COUNT(*) AS string_null_remaining
FROM Datatype.meta_campaign_performance
WHERE utm_source = 'NULL'
   OR utm_medium = 'NULL'
   OR utm_campaign = 'NULL';
-- Expected: 0

-- Validate
SELECT COUNT(*) AS meta_datatype_count 
FROM Datatype.meta_campaign_performance;
-- Expected: 2160

SELECT DISTINCT campaign_objective 
FROM Datatype.meta_campaign_performance;
-- Expected: Reach, Follower Growth, Engagement, Traffic, Conversions only

SELECT COUNT(*) AS zero_spend_rows
FROM Datatype.meta_campaign_performance
WHERE spend_cad = 0;
-- Note the count, these are valid records not errors

GO


------------------------------------------------------------------------------------------------


-- Google Ads Performance
-- ====================== 

SELECT * FROM Bronze.google_ads_performance
SELECT * FROM Datatype.google_ads_performance


SELECT COUNT(*) FROM Bronze.google_ads_performance
SELECT DISTINCT campaign_name FROM Bronze.google_ads_performance

----------------------------------------------------------

IF OBJECT_ID ('Datatype.google_ads_performance', 'U') IS NOT NULL
DROP TABLE Datatype.google_ads_performance
GO

    CREATE TABLE Datatype.google_ads_performance (
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
----------------------------------------------------------

TRUNCATE TABLE Datatype.google_ads_performance;

INSERT INTO Datatype.google_ads_performance (
    google_row_id,
    campaign_id,
    campaign_name,
    record_date,
    spend_cad,
    impressions,
    clicks,
    avg_cpc_cad,
    conversions,
    conversion_rate,
    utm_source,
    utm_medium,
    utm_campaign,
    quality_score_avg,
    landing_page_sessions
)
SELECT
    TRY_CAST(TRIM(google_row_id) AS NVARCHAR(20)),

    TRY_CAST(TRIM(campaign_id) AS NVARCHAR(20)),

    CASE
        WHEN UPPER(TRIM(campaign_name)) IN (
            'BRAND PARTNERSHIP DISCOVERY',
            'BRAND PARTNERSHIP MANAGER DISCOVERY'
        )                                           THEN 'Brand Partnership Manager Discovery'
        WHEN UPPER(TRIM(campaign_name)) IN (
            'CREATOR SPONSORSHIP CA',
            'CREATOR SPONSORSHIP OPPORTUNITIES CANADA'
        )                                           THEN 'Creator Sponsorship Opportunities Canada'
        WHEN UPPER(TRIM(campaign_name)) IN (
            'INFLUENCER MARKETING AGENCY TORONTO',
            'INFLUENCER MKTG TORONTO'
        )                                           THEN 'Influencer Marketing Agency Toronto'
        WHEN UPPER(TRIM(campaign_name)) IN (
            'TALENT AGENCY BRAND DEALS',
            'TALENT AGENCY DEALS'
        )                                           THEN 'Talent Agency Brand Deals'
        ELSE TRIM(campaign_name)
    END,

    TRY_CAST(TRIM(record_date) AS DATE),

    TRY_CAST(TRIM(spend_cad) AS DECIMAL(10,2)),

    TRY_CAST(TRIM(impressions) AS INT),

    TRY_CAST(TRIM(clicks) AS INT),

    TRY_CAST(REPLACE(TRIM(avg_cpc_cad), '$', '') AS DECIMAL(8,2)),

    TRY_CAST(TRIM(conversions) AS INT),

    CASE
        WHEN TRY_CAST(TRIM(clicks) AS INT) = 0
          OR TRY_CAST(TRIM(clicks) AS INT) IS NULL  THEN 0
        ELSE TRY_CAST(
            (TRY_CAST(TRIM(conversions) AS DECIMAL(10,4))
             / TRY_CAST(TRIM(clicks) AS DECIMAL(10,4))) * 100
        AS DECIMAL(5,2))
    END,

    NULLIF(NULLIF(TRIM(utm_source), ''), 'NULL'),

    NULLIF(NULLIF(TRIM(utm_medium), ''), 'NULL'),

    NULLIF(NULLIF(TRIM(utm_campaign), ''), 'NULL'),

    TRY_CAST(TRIM(quality_score_avg) AS DECIMAL(4,1)),

    TRY_CAST(TRIM(landing_page_sessions) AS INT)

FROM Bronze.google_ads_performance;

SELECT COUNT(*) AS google_datatype_count
FROM Datatype.google_ads_performance;
-- Expected: 480

SELECT DISTINCT campaign_name
FROM Datatype.google_ads_performance;
-- Expected: 4 clean canonical values only

-- Validate
SELECT COUNT(*) AS google_datatype_count 
FROM Datatype.google_ads_performance;
-- Expected: 480

SELECT COUNT(*) AS dollar_symbol_failures
FROM Datatype.google_ads_performance
WHERE avg_cpc_cad IS NULL;
-- Should be very low, only rows where cast failed after stripping symbol

GO

------------------------------------------------------------------------------------------------

-- Email Campaign Performance
-- ==========================

-- ================

SELECT * FROM Bronze.email_campaign_performance
SELECT * FROM Datatype.email_campaign_performance


SELECT COUNT(*) FROM Bronze.talent_profiles
SELECT DISTINCT talent_category FROM Bronze.talent_profiles
SELECT DISTINCT tier FROM Bronze.talent_profiles
SELECT DISTINCT region FROM Bronze.talent_profiles
SELECT DISTINCT active_status FROM Bronze.talent_profiles

SELECT * FROM Bronze.talent_profiles
SELECT * FROM Datatype.talent_profiles
----------------------------------------------------------


IF OBJECT_ID ('Datatype.email_campaign_performance', 'U') IS NOT NULL
DROP TABLE Datatype.email_campaign_performance
GO

    CREATE TABLE Datatype.email_campaign_performance (
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
----------------------------------------------------------

TRUNCATE TABLE Datatype.email_campaign_performance;

INSERT INTO Datatype.email_campaign_performance (
    email_event_id,
    campaign_email_id,
    contact_id,
    talent_id,
    send_date,
    event_type,
    event_timestamp,
    consent_timestamp,
    email_subject_line,
    talent_tier_featured,
    converted_to_inquiry,
    inquiry_deal_id,
    utm_source,
    utm_medium
)
SELECT
    TRY_CAST(TRIM(email_event_id) AS NVARCHAR(20)),

    TRY_CAST(TRIM(campaign_email_id) AS NVARCHAR(20)),

    TRY_CAST(TRIM(contact_id) AS NVARCHAR(10)),

    CASE
        WHEN LEN(TRIM(talent_id)) = 4
            THEN 'TLT0' + '0' + SUBSTRING(TRIM(talent_id), 4, 1)
        WHEN LEN(TRIM(talent_id)) = 5
            THEN 'TLT0' + SUBSTRING(TRIM(talent_id), 4, 2)
        ELSE TRIM(talent_id)
    END,

    TRY_CAST(TRIM(send_date) AS DATE),

    CASE
        WHEN UPPER(TRIM(event_type)) = 'SENT'                  THEN 'Sent'
        WHEN UPPER(TRIM(event_type)) = 'OPENED'                THEN 'Opened'
        WHEN UPPER(TRIM(event_type)) IN ('CLICKED', 'CLICK')   THEN 'Clicked'
        WHEN UPPER(TRIM(event_type)) = 'CONVERTED'             THEN 'Converted'
        ELSE TRIM(event_type)
    END,

    TRY_CAST(TRIM(event_timestamp) AS DATETIME2),

    TRY_CAST(TRIM(consent_timestamp) AS DATETIME2),

    TRIM(email_subject_line),

    NULLIF(NULLIF(TRIM(talent_tier_featured), ''), 'NULL'),

    CASE
        WHEN UPPER(TRIM(converted_to_inquiry)) = 'YES'  THEN 'Yes'
        WHEN UPPER(TRIM(converted_to_inquiry)) = 'NO'   THEN 'No'
        ELSE TRIM(converted_to_inquiry)
    END,

    NULLIF(NULLIF(TRIM(inquiry_deal_id), ''), 'NULL'),

    NULLIF(NULLIF(TRIM(utm_source), ''), 'NULL'),

    NULLIF(NULLIF(TRIM(utm_medium), ''), 'NULL')

FROM Bronze.email_campaign_performance;

SELECT COUNT(*) AS email_datatype_count
FROM Datatype.email_campaign_performance;
-- Expected: 1965

SELECT DISTINCT event_type
FROM Datatype.email_campaign_performance;
-- Expected: Sent, Opened, Clicked, Converted only

SELECT DISTINCT converted_to_inquiry
FROM Datatype.email_campaign_performance;
-- Expected: Yes, No, NULL only

SELECT COUNT(*) AS lpad_check
FROM Datatype.email_campaign_performance
WHERE LEN(talent_id) < 6;
-- Expected: 0



SELECT DISTINCT talent_id
FROM Datatype.email_campaign_performance
WHERE talent_id LIKE 'TLT00%'
ORDER BY talent_id;
-- Confirm TLT001 through TLT009 all appear correctly padded

GO


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