--with sequences as
--  (SELECT [0,1,1,2,3,5] as some_numbers
--  union all SELECT [2,4,8,16,32] as some_numbers
--  union all SELECT [5,10] as some_numbers)
--SELECT 
--  array(SELECT x * 2
--	FROM UNNEST(some_numbers) as x
--        where x < 5) as doubled_less_than_five
--FROM sequences;

--WITH sequences AS
--  (SELECT [0,1,1,2,3,5] AS some_numbers)
--SELECT array(SELECT DISTINCT x
--             FROM UNNEST(some_numbers) AS x) AS unique_numbers
--FROM sequences;

with sequences as
  (SELECT [0,1,1,2,3,5] as some_numbers
  union all SELECT [2,4,8,16,32] as some_numbers
  union all SELECT [5,10] as some_numbers)
SELECT 
  ARRAY(SELECT x
	FROM UNNEST(some_numbers) as x
        WHERE 2 IN unnest(some_numbers)) as contains_two
FROM sequences;
