with sequences as
  (select [0,1,1,2,3,5] as some_numbers
  union all select [2,4,8,16,32] as some_numbers
  union all select [5,10] as some_numbers)
select some_numbers,
  array(select x * 2
	from unnest(some_numbers) as x) as doubled
from sequences;
