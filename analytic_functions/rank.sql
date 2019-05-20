--with employees as
--(
--  SELECT "Andrew" as firstname, 1 as department, "1999-01-23" as startdate UNION ALL
--  SELECT "Jacob" as firstname, 1 as department, "1990-07-11" as startdate UNION ALL
--  SELECT "Daniel" as firstname, 2 as department, "2004-06-24" as startdate UNION ALL
--  SELECT "Anna" as firstname, 1 as department, "2001-10-07" as startdate UNION ALL
--  SELECT "Pierre" as firstname, 1 as department, "2009-02-22" as startdate UNION ALL
--  SELECT "Ruth" as firstname, 2 as department, "1998-06-05" as startdate UNION ALL
--  SELECT "Anthony" as firstname, 1 as department, "1995-11-25" as startdate UNION ALL
--  SELECT "Isabelle" as firstname, 2 as department, "1997-09-28" as startdate UNION ALL
--  SELECT "Jose" as firstname, 2 as department, "2013-03-17" as startdate
--)
--SELECT firstname, department, startdate
--FROM employees;

--------------------------------------------------------------------------------
--| Description: 
--| 1. partition by: split into two partitions by department
--| 2. order by: order each partition by startdate
--| 3. framing: None. Window frame clause is disALLowed for RANK() an ALL numbering functions
--| 4. rank(): seniority ranking is computed for each row over the window frame
--------------------------------------------------------------------------------
--with employees as
--(
--  SELECT "Andrew" as firstname, 1 as department, "1999-01-23" as startdate UNION ALL
--  SELECT "Jacob" as firstname, 1 as department, "1990-07-11" as startdate UNION ALL
--  SELECT "Daniel" as firstname, 2 as department, "2004-06-24" as startdate UNION ALL
--  SELECT "Anna" as firstname, 1 as department, "2001-10-07" as startdate UNION ALL
--  SELECT "Pierre" as firstname, 1 as department, "2009-02-22" as startdate UNION ALL
--  SELECT "Ruth" as firstname, 2 as department, "1998-06-05" as startdate UNION ALL
--  SELECT "Anthony" as firstname, 1 as department, "1995-11-25" as startdate UNION ALL
--  SELECT "Isabelle" as firstname, 2 as department, "1997-09-28" as startdate UNION ALL
--  SELECT "Jose" as firstname, 2 as department, "2013-03-17" as startdate
--)
--SELECT firstname, department, startdate,
--  rank() over ( partition by department order by startdate ) as rank
--FROM employees;

--------------------------------------------------------------------------------
--| Description: Attempt at a cumulative sum
--------------------------------------------------------------------------------
with clickstream as
(
  SELECT "A" AS visitor_id, 0 AS orders, "2019-01-01" AS trans_date UNION ALL
  SELECT "A" AS visitor_id, 0 AS orders, "2019-01-02" AS trans_date UNION ALL
  SELECT "A" AS visitor_id, 0 AS orders, "2019-01-03" AS trans_date UNION ALL
  SELECT "B" AS visitor_id, 0 AS orders, "2019-01-01" AS trans_date UNION ALL
  SELECT "B" AS visitor_id, 0 AS orders, "2019-01-02" AS trans_date UNION ALL
  SELECT "B" AS visitor_id, 1 AS orders, "2019-01-03" AS trans_date UNION ALL
  SELECT "C" AS visitor_id, 0 AS orders, "2019-01-01" AS trans_date UNION ALL
  SELECT "C" AS visitor_id, 1 AS orders, "2019-01-02" AS trans_date UNION ALL
  SELECT "C" AS visitor_id, 0 AS orders, "2019-01-03" AS trans_date UNION ALL
  SELECT "D" AS visitor_id, 0 AS orders, "2019-01-01" AS trans_date UNION ALL
  SELECT "D" AS visitor_id, 1 AS orders, "2019-01-02" AS trans_date UNION ALL
  SELECT "D" AS visitor_id, 1 AS orders, "2019-01-03" AS trans_date UNION ALL
  SELECT "E" AS visitor_id, 1 AS orders, "2019-01-01" AS trans_date UNION ALL
  SELECT "E" AS visitor_id, 0 AS orders, "2019-01-02" AS trans_date UNION ALL
  SELECT "E" AS visitor_id, 0 AS orders, "2019-01-03" AS trans_date UNION ALL
  SELECT "F" AS visitor_id, 1 AS orders, "2019-01-01" AS trans_date UNION ALL
  SELECT "F" AS visitor_id, 0 AS orders, "2019-01-02" AS trans_date UNION ALL
  SELECT "F" AS visitor_id, 1 AS orders, "2019-01-03" AS trans_date UNION ALL
  SELECT "G" AS visitor_id, 1 AS orders, "2019-01-01" AS trans_date UNION ALL
  SELECT "G" AS visitor_id, 1 AS orders, "2019-01-02" AS trans_date UNION ALL
  SELECT "G" AS visitor_id, 0 AS orders, "2019-01-03" AS trans_date UNION ALL
  SELECT "H" AS visitor_id, 1 AS orders, "2019-01-01" AS trans_date UNION ALL
  SELECT "H" AS visitor_id, 1 AS orders, "2019-01-02" AS trans_date UNION ALL
  SELECT "H" AS visitor_id, 1 AS orders, "2019-01-03" AS trans_date
),
a as
(SELECT visitor_id, orders, trans_date,
  SUM(orders) OVER (PARTITION BY visitor_id ORDER BY trans_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) cumsum
FROM clickstream),
b as
(SELECT visitor_id, orders, trans_date, cumsum,
  LAG(cumsum) OVER (PARTITION BY visitor_id ORDER BY trans_date) lagcumsum
FROM a),
c as
(SELECT visitor_id, orders, trans_date, cumsum, lagcumsum, IFNULL(lagcumsum+1,0) path_num
FROM b)
SELECT CONCAT(visitor_id, "_", CAST(path_num as STRING)) visitor_id, orders, trans_date, cumsum, lagcumsum
FROM c
