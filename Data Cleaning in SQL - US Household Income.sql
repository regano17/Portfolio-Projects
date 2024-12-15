# US Household Income Data Cleaning
	# 1. Checked and removed duplicates
	# 2. Identified and fixed issues with spelling of State names
    # 3. Noticed and fixed values missing in the County column


select *
from us_household_income
;

select *
from us_household_income_statistics
;

alter table us_household_income_statistics rename column `ï»¿id` to `id`
;

select count(id)
from us_household_income
;

select count(id)
from us_household_income_statistics
;

select *
from us_household_income
;

select *
from us_household_income_statistics
;

select id,
count(id) 
from us_household_income
group by id
having count(id) > 1
;

select *
from(
select row_id,
id,
row_number() over(partition by id order by id) row_num
from us_household_income
) duplicates
where row_num > 1
;

delete from us_household_income
where row_id in(
	select row_id
    from(
		select row_id,
        id,
	row_number() over(partition by id order by id) row_num
	from us_household_income
	) duplicates
where row_num > 1)
;

select id,
count(id) 
from us_household_income_statistics
group by id
having count(id) > 1
;

select distinct state_name
from us_household_income
order by 1
;

update us_household_income
set state_name = 'Georgia'
where state_name = 'georia'
;

update us_household_income
set state_name = 'Alabama'
where state_name = 'alabama'
;

select distinct state_ab
from us_household_income
;

select *
from us_household_income
where county = 'Autauga County'
order by 1
;

update us_household_income
set place = 'Autaugaville'
where county = 'Autauga County'
and city = 'Vinemont'
;

select type, count(type)
from us_household_income
group by type
;

update us_household_income
set type = 'Borough'
where type = 'Boroughs'
;

select aland,
awater
from us_household_income
where
(aland = 0
or aland = ''
or aland is null)
;


