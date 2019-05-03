--WITH races AS (
--  SELECT "800M" AS race,
--    [STRUCT("Rudisha" as name, [23.4, 26.3, 26.4, 26.1] as splits),
--     STRUCT("Makhloufi" as name, [24.5, 25.4, 26.6, 26.1] as splits),
--     STRUCT("Murphy" as name, [23.9, 26.0, 27.0, 26.0] as splits),
--     STRUCT("Bosse" as name, [23.6, 26.2, 26.5, 27.1] as splits),
--     STRUCT("Rotich" as name, [24.7, 25.6, 26.9, 26.4] as splits),
--     STRUCT("Lewandowski" as name, [25.0, 25.7, 26.3, 27.2] as splits),
--     STRUCT("Kipketer" as name, [23.2, 26.1, 27.3, 29.4] as splits),
--     STRUCT("Berian" as name, [23.7, 26.1, 27.0, 29.3] as splits)]
--       AS participants)
--SELECT
--  race,
--  participant
--FROM races r
--CROSS JOIN UNNEST(r.participants) as participant;

--WITH races AS (
--  SELECT "800M" AS race,
--    [STRUCT("Rudisha" as name, [23.4, 26.3, 26.4, 26.1] as splits),
--     STRUCT("Makhloufi" as name, [24.5, 25.4, 26.6, 26.1] as splits),
--     STRUCT("Murphy" as name, [23.9, 26.0, 27.0, 26.0] as splits),
--     STRUCT("Bosse" as name, [23.6, 26.2, 26.5, 27.1] as splits),
--     STRUCT("Rotich" as name, [24.7, 25.6, 26.9, 26.4] as splits),
--     STRUCT("Lewandowski" as name, [25.0, 25.7, 26.3, 27.2] as splits),
--     STRUCT("Kipketer" as name, [23.2, 26.1, 27.3, 29.4] as splits),
--     STRUCT("Berian" as name, [23.7, 26.1, 27.0, 29.3] as splits)]
--       AS participants)
--SELECT
--  race,
--  (SELECT name
--   FROM UNNEST(participants)
--   ORDER BY (
--     SELECT sum(duration)
--     FROM unnest(splits) AS duration) ASC
--   LIMIT 1) AS fastest_racer
--FROM races;

-----------------------------------------
-- implicit cross join via comma operator
-----------------------------------------
--WITH races AS (
--  SELECT "800M" AS race,
--    [STRUCT("Rudisha" as name, [23.4, 26.3, 26.4, 26.1] as splits),
--     STRUCT("Makhloufi" as name, [24.5, 25.4, 26.6, 26.1] as splits),
--     STRUCT("Murphy" as name, [23.9, 26.0, 27.0, 26.0] as splits),
--     STRUCT("Bosse" as name, [23.6, 26.2, 26.5, 27.1] as splits),
--     STRUCT("Rotich" as name, [24.7, 25.6, 26.9, 26.4] as splits),
--     STRUCT("Lewandowski" as name, [25.0, 25.7, 26.3, 27.2] as splits),
--     STRUCT("Kipketer" as name, [23.2, 26.1, 27.3, 29.4] as splits),
--     STRUCT("Berian" as name, [23.7, 26.1, 27.0, 29.3] as splits)]
--       AS participants)
--SELECT
--  race,
--  (SELECT name
--   FROM UNNEST(participants),
--     UNNEST(splits) as duration
--   ORDER BY duration ASC LIMIT 1) AS runner_with_fastest_lap
--FROM races;

----------------------
-- explicit cross join
----------------------
--WITH races AS (
--  SELECT "800M" AS race,
--    [STRUCT("Rudisha" as name, [23.4, 26.3, 26.4, 26.1] as splits),
--     STRUCT("Makhloufi" as name, [24.5, 25.4, 26.6, 26.1] as splits),
--     STRUCT("Murphy" as name, [23.9, 26.0, 27.0, 26.0] as splits),
--     STRUCT("Bosse" as name, [23.6, 26.2, 26.5, 27.1] as splits),
--     STRUCT("Rotich" as name, [24.7, 25.6, 26.9, 26.4] as splits),
--     STRUCT("Lewandowski" as name, [25.0, 25.7, 26.3, 27.2] as splits),
--     STRUCT("Kipketer" as name, [23.2, 26.1, 27.3, 29.4] as splits),
--     STRUCT("Berian" as name, [23.7, 26.1, 27.0, 29.3] as splits)]
--       AS participants)
--SELECT
--  race,
--  (SELECT name
--   FROM UNNEST(participants)
--   CROSS JOIN UNNEST(splits) AS duration
--   ORDER BY duration ASC LIMIT 1) AS runner_with_fastest_lap
--FROM races;

-------------------------------------------------------------------------------------
-- NOTE: flattening arrays with a CROSS JOIN excludes rows with empty or NULL arrays.
-- Use LEFT JOIN to include these rows
-------------------------------------------------------------------------------------
WITH races AS (
  SELECT "800M" AS race,
    [STRUCT("Rudisha" as name, [23.4, 26.3, 26.4, 26.1] as splits),
     STRUCT("Makhloufi" as name, [24.5, 25.4, 26.6, 26.1] as splits),
     STRUCT("Murphy" as name, [23.9, 26.0, 27.0, 26.0] as splits),
     STRUCT("Bosse" as name, [23.6, 26.2, 26.5, 27.1] as splits),
     STRUCT("Rotich" as name, [24.7, 25.6, 26.9, 26.4] as splits),
     STRUCT("Lewandowski" as name, [25.0, 25.7, 26.3, 27.2] as splits),
     STRUCT("Kipketer" as name, [23.2, 26.1, 27.3, 29.4] as splits),
     STRUCT("Berian" as name, [23.7, 26.1, 27.0, 29.3] as splits),
     STRUCT("Nathan" as name, ARRAY<FLOAT64>[] as splits),
     STRUCT("David" as name, NULL as splits)]
     AS participants)
SELECT
  name, sum(duration) as finish_time
FROM races, races.participants LEFT JOIN participants.splits duration
GROUP BY name;
