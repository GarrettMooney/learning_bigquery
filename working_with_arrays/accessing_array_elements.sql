--with sequences as
--  (select [0,1,1,2,3,5] as some_numbers
--  union all select [2,4,8,16,32] as some_numbers
--  union all select [5,10] as some_numbers)
--select some_numbers,
--       some_numbers[offset(1)] as offset_1,
--       some_numbers[ordinal(1)] as ordinal_1
--from sequences;

with sequences as
  (select [0,1,1,2,3,5] as some_numbers
  union all select [2,4,8,16,32] as some_numbers
  union all select [5,10] as some_numbers)
select some_numbers,
       array_length(some_numbers) as len
from sequences;
