# World Life Expectancy Project (Exploratory Data Analysis)

select *
from world_life_expectancy
;

select
country,
min(`Life expectancy`),
max(`Life expectancy`),
round(max(`Life expectancy`) - min(`Life expectancy`),1) as life_increase_15_years
from world_life_expectancy
group by country
having min(`Life expectancy`) <> 0
and max(`Life expectancy`) <> 0
order by life_increase_15_years
;

select year,
round(avg(`Life expectancy`),2)
from world_life_expectancy
where `Life expectancy` <> 0
and `Life expectancy` <> 0
group by year
order by year
;

select *
from world_life_expectancy
;

select country, round(avg(`Life expectancy`),1) as Life_Exp, round(avg(GDP),1) as GDP
from world_life_expectancy
group by country
having Life_Exp > 0
and GDP > 0
order by GDP desc
;

select *
from world_life_expectancy
order by GDP
;

select
sum(case when GDP >= 1500 then 1 else 0 end) high_GDP_count,
avg(case when GDP >= 1500 then `Life expectancy` else null end) high_GDP_Life_Expectancy,
sum(case when GDP <= 1500 then 1 else 0 end) low_GDP_count,
sum(case when GDP <= 1500 then `Life expectancy` else null end) low_GDP_Life_Expectancy
from world_life_expectancy
;

select status, round(avg(`Life expectancy`),1)
from world_life_expectancy
group by status
;

select status, count(distinct country), round(avg(`Life expectancy`),1)
from world_life_expectancy
group by status
;

select country, round(avg(`Life expectancy`),1) as Life_Exp, round(avg(BMI),1) as BMI
from world_life_expectancy
group by country
having Life_Exp > 0
and BMI > 0
order by BMI asc
;

select country,
year,
`Life expectancy`,
`Adult Mortality`,
sum(`Adult Mortality`) over(partition by country order by year) as rolling_total
from world_life_expectancy
where country like '%United%'
;

