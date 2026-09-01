
WITH opportunity_counts AS (

    SELECT
        team,
        COUNT(*) AS opportunities

    FROM opportunities

    GROUP BY team
),

linked_regain_counts AS (

    SELECT
        team,
        COUNT(*) AS linked_high_regains

    FROM high_regains

    WHERE previous_possession_was_opportunity = 1

    GROUP BY team
),

outcome_counts AS (

    SELECT
        team,
        COUNT(*) AS high_regains,
        SUM(post_regain_attack) AS post_regain_attacks,
        SUM(dangerous_attack) AS dangerous_attacks

    FROM post_regain_outcomes

    GROUP BY team
)

SELECT
    o.team,

    op.opportunities,
    lr.linked_high_regains,

    ROUND(
        100.0 * lr.linked_high_regains
        / op.opportunities,
        2
    ) AS high_regain_rate_pct,

    o.high_regains,
    o.post_regain_attacks,

    ROUND(
        100.0 * o.post_regain_attacks
        / o.high_regains,
        2
    ) AS attack_per_regain_pct,

    o.dangerous_attacks,

    ROUND(
        100.0 * o.dangerous_attacks
        / o.high_regains,
        2
    ) AS danger_per_regain_pct

FROM outcome_counts AS o

LEFT JOIN opportunity_counts AS op
    ON o.team = op.team

LEFT JOIN linked_regain_counts AS lr
    ON o.team = lr.team

WHERE o.team IN (
    'Chelsea FCW',
    'Manchester City WFC',
    'Arsenal WFC'
)

ORDER BY high_regain_rate_pct DESC;
