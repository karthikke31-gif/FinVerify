-- Task 1: Onboarding Funnel Conversion

WITH funnel AS (
    SELECT
        COUNT(DISTINCT user_id) AS total_users,
        COUNT(DISTINCT CASE WHEN stage_name = 'phone_verified'
            THEN user_id END) AS phone_verified,
        COUNT(DISTINCT CASE WHEN stage_name = 'profile_completed'
            THEN user_id END) AS profile_completed,
        COUNT(DISTINCT CASE WHEN stage_name = 'kyc_submitted'
            THEN user_id END) AS kyc_submitted,
        COUNT(DISTINCT CASE WHEN stage_name = 'account_activated'
            THEN user_id END) AS account_activated
    FROM user_onboarding_events
    WHERE event_timestamp >= '2026-04-01'
      AND event_timestamp < '2026-05-01'
)
SELECT
    total_users,
    phone_verified,
    profile_completed,
    ROUND(profile_completed * 100.0 / NULLIF(phone_verified, 0), 2)
        AS profile_completion_rate,
    kyc_submitted,
    ROUND(kyc_submitted * 100.0 / NULLIF(profile_completed, 0), 2)
        AS kyc_submission_rate,
    account_activated,
    ROUND(account_activated * 100.0 / NULLIF(kyc_submitted, 0), 2)
        AS activation_rate
FROM funnel;
