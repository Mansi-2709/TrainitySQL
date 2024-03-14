use Project3;
WITH user_events AS (
    SELECT
        u.user_id,
        e.event_name,
        e.occurred_at
    FROM
        users u
        LEFT JOIN events e ON u.user_id = e.user_id
    UNION
    SELECT
        u.user_id,
        'sent_weekly_digest' AS `action`,
        ee.occurred_at
    FROM
        users u
        LEFT JOIN emailEvents ee ON u.user_id = ee.user_id
)
SELECT
    user_id,
    WEEK(occurred_at) AS week_number,
    COUNT(*) AS engagement_count
FROM
    user_events
WHERE
    occurred_at IS NOT NULL
GROUP BY
    user_id,
    week_number
ORDER BY
    user_id,
    week_number;
    
   WITH user_registration_month AS (
    SELECT
        user_id,
        activated_at AS registration_date
    FROM
        users
    GROUP BY
        user_id
) 

SELECT
    EXTRACT(YEAR FROM registration_date) AS registration_year,
    EXTRACT(MONTH FROM registration_date) AS registration_month,
    COUNT(DISTINCT user_id) AS new_user_count
FROM
    user_registration_month
GROUP BY
    registration_year,
    registration_month
ORDER BY
    registration_year,
    registration_month;
    
    WITH user_cohort AS (
    SELECT
        user_id,
        WEEK(activated_at) AS signup_week
    FROM
        users
    GROUP BY
        user_id
),

weekly_activity AS (
    SELECT
        uc.user_id,
        uc.signup_week,
        WEEK(e.occurred_at) AS activity_week
    FROM
        user_cohort uc
        JOIN `events` e ON uc.user_id = e.user_id
)

SELECT
    ua.signup_week,
    activity_week,
    COUNT(DISTINCT ua.user_id) AS active_users,
    COUNT(DISTINCT uc.user_id) AS total_users,
    COUNT(DISTINCT ua.user_id) * 100.0 / COUNT(DISTINCT uc.user_id) AS retention_percentage
FROM
    user_cohort uc
    LEFT JOIN weekly_activity ua ON uc.user_id = ua.user_id AND uc.signup_week = ua.signup_week
GROUP BY
    signup_week,
    activity_week
ORDER BY
    signup_week,
    activity_week;
    
    WITH user_device_week AS (
    SELECT
        u.user_id,
        e.device,
        WEEK(e.occurred_at) AS week_start,
        COUNT(*) AS event_count
    FROM
        users u
        JOIN events e ON u.user_id = e.user_id
    GROUP BY
        u.user_id,
        e.device,
        week_start
)

SELECT
    device,
    week_start,
    SUM(event_count) AS total_events
FROM
    user_device_week
GROUP BY
    device,
    week_start
ORDER BY
    device,
    week_start;
    
    WITH email_engagement AS (
    SELECT
        ee.user_id,
        COUNT(*) AS email_event_count
    FROM
        emailEvents ee
    GROUP BY
        ee.user_id
),

unique_users_engaged AS (
    SELECT
        COUNT(DISTINCT user_id) AS unique_users_count
    FROM
        email_engagement
),

average_engagement_per_user AS (
    SELECT
        AVG(email_event_count) AS avg_engagement_per_user
    FROM
        email_engagement
)

SELECT
    COALESCE(ue.unique_users_count, 0) AS unique_users_count,
    COALESCE(aeu.avg_engagement_per_user, 0) AS avg_engagement_per_user
FROM
    unique_users_engaged ue
    CROSS JOIN average_engagement_per_user aeu;
    