# US Household Income Exploratory Data Analysis
	# 1. Looked at area of land and water
	# 2. Identified rows with mean of 0
	# 3. States averages and medians
	# 4. Types of household areas


select *
from us_household_income
;

select *
from us_household_income_statistics
;

select state_name,
sum(aland),
sum(awater)
from us_household_income
group by state_name
order by 2 desc
limit 10
;

select state_name,
sum(aland),
sum(awater)
from us_household_income
group by state_name
order by 3 desc
;

select state_name,
sum(aland),
sum(awater)
from us_household_income
group by state_name
order by 3 desc
limit 10
;

select *
from us_household_income u
inner join us_household_income_statistics us
	on u.id = us.id
where mean <> 0
;

select u.State_Name,
county,
type,
`Primary`,
mean,
median
from us_household_income u
inner join us_household_income_statistics us
	on u.id = us.id
where mean <> 0
;

# 5 Lowest Average Incomes by State
select u.State_Name,
round(avg(mean),2),
round(avg(median),2)
from us_household_income u
inner join us_household_income_statistics us
	on u.id = us.id
where mean <> 0
group by u.state_name
order by 2
limit 5
;

# 10 Highest Average Incomes by State
select u.State_Name,
round(avg(mean),2),
round(avg(median),2)
from us_household_income u
inner join us_household_income_statistics us
	on u.id = us.id
where mean <> 0
group by u.state_name
order by 2 desc
limit 10
;

select u.State_Name,
round(avg(mean),2),
round(avg(median),2)
from us_household_income u
inner join us_household_income_statistics us
	on u.id = us.id
where mean <> 0
group by u.state_name
order by 3 desc
limit 10
;

select type,
count(type),
round(avg(mean),2),
round(avg(median),2)
from us_household_income u
inner join us_household_income_statistics us
	on u.id = us.id
where mean <> 0
group by type
order by 2
;

select type,
count(type),
round(avg(mean),2),
round(avg(median),2)
from us_household_income u
inner join us_household_income_statistics us
	on u.id = us.id
where mean <> 0
group by type
having count(type) > 100
order by 4 desc
;

select *
from us_household_income
where type = 'Community'
;

select u.state_name,
city,
round(avg(mean),1),
round(avg(median),1)
from us_household_income u
inner join us_household_income_statistics us
	on u.id = us.id
group by city, state_name
order by round(avg(mean),1) desc
limit 10
;



