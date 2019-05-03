--select 2 in unnest([0,1,1,2,3,5]) as contains_value;

--with sequences as
--  (SELECT 1 as id, [0,1,1,2,3,5] as some_numbers
--  union all SELECT 2 as id, [2,4,8,16,32] as some_numbers
--  union all SELECT 3 as id, [5,10] as some_numbers)
--select id as matching_rows
--from sequences
--where 2 in unnest(sequences.some_numbers)
--order by matching_rows;

with sequences as
  (SELECT 1 as id, [0,1,1,2,3,5] as some_numbers
  union all SELECT 2 as id, [2,4,8,16,32] as some_numbers
  union all SELECT 3 as id, [5,10] as some_numbers)
select id as matching_rows from sequences
where exists (select *
	      from unnest(some_numbers) as x
	      where x > 5);
