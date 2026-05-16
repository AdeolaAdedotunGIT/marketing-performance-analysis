CREATE DATABASE MadreTalentsGroup;
USE MadreTalentsGroup;

-- ==========================
CREATE SCHEMA Bronze;
GO
CREATE SCHEMA Datatype;
GO
CREATE SCHEMA Duplicate;
GO
CREATE SCHEMA Null_Handling;
GO
CREATE SCHEMA Silver;
GO
CREATE SCHEMA Gold;
GO


-- ==========================
-- Talent Profiles
IF OBJECT_ID ('Bronze.talent_profiles', 'U') IS NOT NULL 
DROP TABLE Bronze.talent_profiles
GO

	CREATE TABLE Bronze.talent_profiles (
	    talent_id           NVARCHAR(MAX)   NULL,
        talent_name         NVARCHAR(MAX)   NULL,
        talent_category     NVARCHAR(MAX)   NULL,
        tier                NVARCHAR(MAX)   NULL,
        primary_platform    NVARCHAR(MAX)   NULL,
        total_followers     NVARCHAR(MAX)   NULL,
        engagement_rate     NVARCHAR(MAX)   NULL,
        niche_category      NVARCHAR(MAX)   NULL,
        signed_date         NVARCHAR(MAX)   NULL,
        region              NVARCHAR(MAX)   NULL,
        active_status       NVARCHAR(MAX)   NULL
	);

BULK INSERT Bronze.talent_profiles
    FROM 'C:\Users\ludeo\Documents\Data Analytics\Madre Talent Group\talent_profiles.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n',
        TABLOCK
    );
    GO



-- Deal Pipeline
IF OBJECT_ID ('Bronze.deal_pipeline', 'U') IS NOT NULL
DROP TABLE Bronze.deal_pipeline
GO

    CREATE TABLE Bronze.deal_pipeline (
        deal_id                 NVARCHAR(MAX)    NULL,
        talent_id               NVARCHAR(MAX)    NULL,
        brand_name              NVARCHAR(MAX)    NULL,
        deal_stage              NVARCHAR(MAX)    NULL,
        stage_entry_date        NVARCHAR(MAX)    NULL,
        stage_exit_date         NVARCHAR(MAX)    NULL,
        deal_value              NVARCHAR(MAX)    NULL,
        acquisition_channel     NVARCHAR(MAX)    NULL,
        inquiry_date            NVARCHAR(MAX)    NULL,
        close_date              NVARCHAR(MAX)    NULL,
        closed_status           NVARCHAR(MAX)    NULL,
        sales_cycle_days        NVARCHAR(MAX)    NULL,
        agency_commission       NVARCHAR(MAX)    NULL,
        brand_buyer_email       NVARCHAR(MAX)    NULL,
        consent_timestamp       NVARCHAR(MAX)    NULL
    );

BULK INSERT Bronze.deal_pipeline
    FROM 'C:\Users\ludeo\Documents\Data Analytics\Madre Talent Group\deal_pipeline.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n',
        TABLOCK
    );
GO

-- Meta Campaign Performance
IF OBJECT_ID ('Bronze.meta_campaign_performance', 'U') IS NOT NULL
DROP TABLE Bronze.meta_campaign_performance
GO

    CREATE TABLE Bronze.meta_campaign_performance (
        meta_row_id             NVARCHAR(MAX)    NULL,
        campaign_id             NVARCHAR(MAX)    NULL,
        ad_set_id               NVARCHAR(MAX)    NULL,
        talent_id               NVARCHAR(MAX)    NULL,
        campaign_objective      NVARCHAR(MAX)    NULL,
        record_date             NVARCHAR(MAX)    NULL,
        spend_cad               NVARCHAR(MAX)    NULL,
        impressions             NVARCHAR(MAX)    NULL,
        reach                   NVARCHAR(MAX)    NULL,
        clicks                  NVARCHAR(MAX)    NULL,
        follower_change         NVARCHAR(MAX)    NULL,
        utm_source              NVARCHAR(MAX)    NULL,
        utm_medium              NVARCHAR(MAX)    NULL,
        utm_campaign            NVARCHAR(MAX)    NULL,
        traffic_type            NVARCHAR(MAX)    NULL,
        landing_page_sessions   NVARCHAR(MAX)    NULL,
        page_inquiries          NVARCHAR(MAX)    NULL
    );

BULK INSERT Bronze.meta_campaign_performance
    FROM 'C:\Users\ludeo\Documents\Data Analytics\Madre Talent Group\meta_campaign_performance.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n',
        TABLOCK
    );
GO

-- Google Ads Performance
IF OBJECT_ID ('Bronze.google_ads_performance', 'U') IS NOT NULL
DROP TABLE Bronze.google_ads_performance
GO

    CREATE TABLE Bronze.google_ads_performance (
        google_row_id           NVARCHAR(MAX)    NULL,
        campaign_id             NVARCHAR(MAX)    NULL,
        campaign_name           NVARCHAR(MAX)    NULL,
        record_date             NVARCHAR(MAX)    NULL,
        spend_cad               NVARCHAR(MAX)    NULL,
        impressions             NVARCHAR(MAX)    NULL,
        clicks                  NVARCHAR(MAX)    NULL,
        avg_cpc_cad             NVARCHAR(MAX)    NULL,
        conversions             NVARCHAR(MAX)    NULL,
        conversion_rate         NVARCHAR(MAX)    NULL,
        utm_source              NVARCHAR(MAX)    NULL,
        utm_medium              NVARCHAR(MAX)    NULL,
        utm_campaign            NVARCHAR(MAX)    NULL,
        quality_score_avg       NVARCHAR(MAX)    NULL,
        landing_page_sessions   NVARCHAR(MAX)    NULL
    );

BULK INSERT Bronze.google_ads_performance
    FROM 'C:\Users\ludeo\Documents\Data Analytics\Madre Talent Group\google_ads_performance.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n',
        TABLOCK
    );
GO

-- Email Campaign Performance
IF OBJECT_ID ('Bronze.email_campaign_performance', 'U') IS NOT NULL
DROP TABLE Bronze.email_campaign_performance
GO

    CREATE TABLE Bronze.email_campaign_performance (
        email_event_id          NVARCHAR(MAX)    NULL,
        campaign_email_id       NVARCHAR(MAX)    NULL,
        contact_id              NVARCHAR(MAX)    NULL,
        talent_id               NVARCHAR(MAX)    NULL,
        send_date               NVARCHAR(MAX)    NULL,
        event_type              NVARCHAR(MAX)    NULL,
        event_timestamp         NVARCHAR(MAX)    NULL,
        consent_timestamp       NVARCHAR(MAX)    NULL,
        email_subject_line      NVARCHAR(MAX)    NULL,
        talent_tier_featured    NVARCHAR(MAX)    NULL,
        converted_to_inquiry    NVARCHAR(MAX)    NULL,
        inquiry_deal_id         NVARCHAR(MAX)    NULL,
        utm_source              NVARCHAR(MAX)    NULL,
        utm_medium              NVARCHAR(MAX)    NULL
    ); 

BULK INSERT Bronze.email_campaign_performance
    FROM 'C:\Users\ludeo\Documents\Data Analytics\Madre Talent Group\email_campaign_performance.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n',
        TABLOCK
    );
GO

