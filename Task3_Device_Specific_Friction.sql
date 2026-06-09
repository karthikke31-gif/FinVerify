-- Task 3: Device-Specific Friction

WITH stage_times AS (
    SELECT
        u.user_id,
        u.device_os,
        MIN(CASE
            WHEN uoe.stage_name = 'profile_completed'
            THEN uoe.event_timestamp
        END) AS profile_completed_time,
        MIN(CASE
            WHEN uoe.stage_name = 'kyc_submitted'
            THEN uoe.event_timestamp
        END) AS kyc_submitted_time
    FROM users u
    INNER JOIN user_onboarding_events uoe
        ON u.user_id = uoe.user_id
    WHERE u.signup_date >= CURRENT_DATE - INTERVAL '14 DAY'
    GROUP BY u.user_id, u.device_os
)
SELECT
    device_os,
    ROUND(
        AVG(
            EXTRACT(EPOCH FROM (
                kyc_submitted_time - profile_completed_time
            ))
        ),
        2
    ) AS avg_time_seconds
FROM stage_times
WHERE profile_completed_time IS NOT NULL
  AND kyc_submitted_time IS NOT NULL
GROUP BY device_os
ORDER BY avg_time_seconds DESC;
