CREATE TABLE table_1 (
    id BIGINT PRIMARY KEY,
    activity_date DATE,
    game_activity_name VARCHAR,
    total_seconds INT,
    week_start_date DATE
);

CREATE TABLE table_2 (
    id BIGINT PRIMARY KEY,
    game_name VARCHAR,
    language VARCHAR,
    age INT,
    has_older_device_model BOOLEAN
);

ALTER TABLE table_1
ADD CONSTRAINT fk_table_1_table_2
FOREIGN KEY (id)
REFERENCES table_2(id);

INSERT INTO table_2 (id, game_name, language, age, has_older_device_model)
VALUES
    (1, 'Game A', 'English', 25, TRUE),
    (2, 'Game B', 'Spanish', 30, FALSE),
    (3, 'Game C', 'French', 22, TRUE);

INSERT INTO table_1 (id, activity_date, game_activity_name, total_seconds, week_start_date)
VALUES
    (1, '2025-01-20', 'Level 1 Completed', 360, '2025-01-19'),
    (2, '2025-01-21', 'Level 2 Started', 120, '2025-01-19'),
    (3, '2025-01-22', 'Level 3 Completed', 450, '2025-01-19');

WITH daily_active_users AS (
    SELECT
        activity_date,
        COUNT(DISTINCT id) AS dau
    FROM
        table_1
    GROUP BY
        activity_date
),
monthly_active_users AS (
    SELECT
        DATE_TRUNC('month', activity_date) AS activity_month,
        COUNT(DISTINCT id) AS mau
    FROM
        table_1
    GROUP BY
        DATE_TRUNC('month', activity_date)
)
SELECT
    d.activity_date,
    d.dau,
    m.activity_month,
    m.mau
FROM
    daily_active_users d
LEFT JOIN
    monthly_active_users m
ON
    DATE_TRUNC('month', d.activity_date) = m.activity_month;