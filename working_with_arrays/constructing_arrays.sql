--select [1,2,3] as numbers;

--select ["apple", "pear", "orange"] as fruit;

--select [true, false, true] as booleans;

--select [a,b,c]
--from
--  (select 5 as a,
--	  37 as b,
--	  406 as c);

--select [a,b,c]
--from
--  (select cast(5 as int64) as a,
--	  cast(37 as float64) as b,
--	  406 as c);

--select array<float64>[1,2,3] as floats;

--select [1,2,3] as numbers;

--select generate_array(11, 33, 2) as odds;

--select generate_array(21, 14, -1) as countdown;

--select 
--  generate_date_array('2017-11-21', '2017-12-31', interval 1 week) 
--    as date_array;
