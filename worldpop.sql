-- ALTER TABLE worldpop
-- Add variant varchar(255),
-- Add region varchar(255),
-- Add location_code int,
-- Add type varchar(255),
-- Add parent_code int,
-- Add year int,
-- Add total_pop_jan_1 int,
-- Add total_pop_july_1 int,
-- Add male_pop int,
-- Add female_pop int,
-- Add pop_density float,
-- Add pop_sex_ration float,
-- Add median_age_years float,
-- Add change_in_pop int,
-- Add rate_of_change float,
-- Add population_change int,
-- Add pop_growth_rate float,
-- Add pop_doubling_time float,
-- Add births int,
-- Add births_15_to_19 int,
-- Add crude_birth_rate float,
-- Add total_fertility_rate float,
-- Add net_repro_rate float,
-- Add mean_childbearing_age float,
-- Add sex_ratio_at_birth float,
-- Add total_deaths int,
-- Add male_deaths int,
-- Add female_deaths int,
-- Add crude_death_rate float,
-- Add life_expectancy float,
-- Add male_life_expectancy float,
-- Add female_life_expectancy float,
-- Add life_expectancy_15 float,
-- Add male_life_expectancy_15 float,
-- Add female_life_expectancy_15 float,
-- Add life_expectancy_65 float,
-- Add male_life_expectancy_65 float,
-- Add female_life_expectancy_65 float,
-- Add life_expectancy_80 float,
-- Add male_life_expectancy_80 float,
-- Add female_life_expectancy_80 float,
-- Add infant_deaths_sub_1 int,
-- Add infant_mortality_rate float,
-- Add births_surv_age_1 float,
-- Add deaths_under_5 int,
-- Add mortality_under_5 int,
-- Add mortality_under_40 int,
-- Add male_mortality_under_40 int,
-- Add female_mortality_under_40 int,
-- Add mortality_under_60 int,
-- Add male_mortality_under_60 int,
-- Add female_mortality_under_60 int,
-- Add mortality_under_15_to_50 int,
-- Add male_mortality_under_15_to_50 int,
-- Add female_mortality_under_15_to_50 int,
-- Add mortality_under_15_to_60 int,
-- Add male_mortality_under_15_to_60 int,
-- Add female_mortality_under_15_to_60 int,
-- Add net_migrants int,
-- Add net_migration_rate float;

-- copy worldpop from 'C:\Users\Public\WorldPopData.csv' delimiter ',' csv header

SELECT *
FROM worldpop
where region = 'China'


SELECT distinct type
From worldpop

-- Which 5 countries have the highest population density in 2005
select region, pop_density, type
FROM worldpop
WHERE region != 'WORLD' and year = 2005
ORDER BY pop_density DESC
LIMIT 20

-- Which 5 countries have the highest population for the latest year
select region, max(total_pop_july_1)
from worldpop
WHERE type = 'Country/Area' and year = (SELECT max(year) FROM worldpop)
GROUP BY region
ORDER by max(total_pop_july_1) DESC
LIMIT 10
-- Which country had the greatest yoy change in births


-- How to include the year here
with cte as(
	select region, year, births, lag(births) over(Order By region, year) as previous,
	round(((births - lag(births) over(Order By region, year))/births),5) as yoy_change
	from worldpop
	WHERE births != 0
	Group by region, year, births
)
SELECT region,year,max(yoy_change)
FROM cte
WHERE year > 1990
GROUP by region, year
ORDER by year DESC
LIMIT 50

-- What is the maximum population reached for each country
SELECT region, max(total_pop_july_1)
from worldpop
where type = 'Country/Area'
group by region
ORDER BY max(total_pop_july_1) DESC

-- Which 10 countries have the highest female life expectancy
SELECT region, max(female_life_expectancy)
from worldpop
WHERE type = 'Country/Area' and region = 'United States of America'
Group by region
ORDER by max(female_life_expectancy) Desc

-- Select the country, pop_density and life_expectancy
SELECT region, pop_density, life_expectancy
FROM worldpop
WHERE year = 2021
ORDER BY pop_density DESC

-- window function, what am I doing not sure
select region, max(total_pop_july_1) over(partition by region)
FROM worldpop
WHERE type = 'Country/Area'
Group By region, total_pop_july_1

-- Why was this so difficult
with cte as(
select region, total_pop_july_1
from worldpop as wp
where total_pop_july_1
	= (Select max (total_pop_july_1)
	  from worldpop
	  where region = wp.region
	  )
)
SELECT *
FROM cte
Order by total_pop_july_1 DESC

-- Contributing factors to life expectancy?
-- Population Density, pop_sex_ration, median_age_years, population_growth_rate

WITH cte as (
	SELECT region, CORR(life_expectancy, pop_density) as density_corr, 
	CORR(life_expectancy, pop_sex_ration) as pop_sex_corr,
	CORR(life_expectancy, median_age_years) as median_age_corr,
	CORR(life_expectancy, pop_growth_rate) as pop_growth_corr
	FROM worldpop
	GROUP BY region)
SELECT AVG(cte.density_corr) as density_corr,
AVG(cte.pop_sex_corr) as pop_sex_corr,
AVG(cte.median_age_corr) as median_age_corr,
AVG(cte.pop_growth_corr) as pop_growth_corr
FROM cte

-- Shown Graphically

SELECT region, life_expectancy, pop_density
FROM worldpop
WHERE pop_density IS NOT NULL

-- Window Function?
-- What is the yoy change in population from 1970-1980 for Ireland
SELECT year, total_pop_july_1, 
round((cast(total_pop_july_1 as decimal) - lag(cast(total_pop_july_1 as decimal),1, total_pop_july_1) over (order by year))/cast(total_pop_july_1 as decimal) * 100,5) as yoy_change
FROM worldpop
WHERE region = 'Ireland'

-- Self Join

