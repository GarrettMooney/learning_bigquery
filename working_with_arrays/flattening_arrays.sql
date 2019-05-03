--select *
--from unnest(['foo', 'bar', 'baz', 'qux', 'corge', 'garply', 'waldo', 'fred'])
--  as element
--with offset as offset
--order by offset;

with sequences as
  (select 1 as id, [0,1,1,2,3,5] as some_numbers
  union all select 2 as id, [2,4,8,16,32] as some_numbers
  union all select 3 as id, [5,10] as some_numbers)
select id, some_numbers
from sequences
cross join unnest(sequences.some_numbers) as flattened_numbers;
