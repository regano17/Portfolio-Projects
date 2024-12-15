#  World Life Expectancy Project (Data Cleaning)


SELECT *
FROM world_life_expectancy
;

SELECT country, Year, concat(country, year), count(concat(country, year))
FROM world_life_expectancy
group by country, Year, concat(country, year)
having count(concat(country, year)) > 1
;

select *
from(
	select row_id,
	concat(country, year),
	row_number() over(partition by concat(country, year) order by concat(country, year)) as row_num
	from world_life_expectancy
	) as row_table
where row_num > 1
;

delete from world_life_expectancy
where
	row_id in (
	select row_id
from(
	select row_id,
	concat(country, year),
	row_number() over(partition by concat(country, year) order by concat(country, year)) as row_num
	from world_life_expectancy
	) as row_table
where row_num > 1
)
;

select *
from world_life_expectancy
where status = ''
;

SELECT distinct(status)
FROM world_life_expectancy
where status <> ''
;

select distinct(country)
from world_life_expectancy
where status = 'Developing'
;

update world_life_expectancy
set status = 'Developing'
where country in (select distinct(country)
			from world_life_expectancy
			where status = 'Developing');

update world_life_expectancy t1
join world_life_expectancy t2
	on t1.country = t2.country
set t1.Status = 'Developing'
where t1.Status = ''
and t2.Status <> ''
and t2.Status = 'Developing'
;

update world_life_expectancy t1
join world_life_expectancy t2
	on t1.country = t2.country
set t1.Status = 'Developed'
where t1.Status = ''
and t2.Status <> ''
and t2.Status = 'Developed'
;

select * from world_life_expectancy
where country = 'United States of America'
;

select *
from world_life_expectancy
#where `Life Expectancy` = ''
;

select country, year, `Life Expectancy`
from world_life_expectancy
#where `Life Expectancy` = ''
;

select t1.country, t1.year, t1.`Life Expectancy`,
t2.country, t2.year, t2.`Life Expectancy`,
t3.country, t3.year, t3.`Life Expectancy`,
round((t2.`Life Expectancy` + t3.`Life Expectancy`)/2,1)
from world_life_expectancy t1
join world_life_expectancy t2
	on t1.country = t2.country
    and t1.year = t2.year - 1
join world_life_expectancy t3
	on t1.country = t3.country
    and t1.year = t3.year + 1
where t1.`Life Expectancy` = ''
;

update world_life_expectancy t1
join world_life_expectancy t2
	on t1.country = t2.country
    and t1.year = t2.year - 1
join world_life_expectancy t3
	on t1.country = t3.country
    and t1.year = t3.year + 1
set t1.`Life Expectancy` = round((t2.`Life Expectancy` + t3.`Life Expectancy`)/2,1)
where t1.`Life Expectancy` = ''
;

select country, year, `Life Expectancy`
from world_life_expectancy
where `Life Expectancy` = ''
;

select *
from world_life_expectancy
;













