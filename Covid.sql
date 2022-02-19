select *
from CovidPandemic..Death
order by 3,4 


select *
from CovidPandemic..Vaccination
order by 3,4 




--The overall highest total cases according to the total death and death percentage on the  02.02.2022

select location, Max(date) as Last_Update , MAX(CONVERT(int, total_cases)) as Total_Case_Max, MAX(CONVERT(int, total_deaths)) as Total_death_Max, (MAX(cast(total_deaths as float)))/ MAX(cast(total_cases as float)) *100 as DeathPercentage
From CovidPandemic..Death
Where continent is not null 
Group by location
Order by Total_Case_Max desc 



-- Death, and cases Worldwide

--Temp Table
Create Table popSum(Location nvarchar(255),Population numeric)
insert into popSum
select Distinct location, population From CovidPandemic..Death WHERE continent is not null 

--CTE
With dcWorld (Date, Total_cases_WorldWide, Total_deaths_WorldWide)
as
(
Select date, SUM(cast(total_cases as int)) as Total_cases_WorldWide, SUM(cast(total_deaths as int)) as Total_deaths_WorldWide
From CovidPandemic..Death
WHERE continent is not null  and date = '2022-02-02' or date= '2021-08-02' or date= '2021-02-02' or date= '2020-08-02' or date= '2020-02-02' 
Group by date

)
Select *, Total_cases_WorldWide / (Select SUM(population) From popSum)*100 as Total_cases_WorldWide_Percentage
From dcWorld





-- Germany vaccination data

select date, total_vaccinations, people_fully_vaccinated, total_boosters, new_vaccinations
from CovidPandemic..Vaccination
where location like '%germany%'
ORDER by 1 desc





 
-- Average of new vaccinations regarding population vc new cases and deaths in european countries  

Select  dt.location, dt.date, dt.new_cases,dt.new_deaths, vc.new_vaccinations, vc.people_fully_vaccinated,
AVG(cast(vc.new_vaccinations as int )/ dt.population * 100) OVER (Partition by dt.location Order by dt.location, dt.date) 
as new_vac_per_population
From CovidPandemic..Death dt
Join CovidPandemic..Vaccination vc
	On dt.location = vc.location
	and dt.date = vc.date
where dt.continent is not null and dt.continent like '%europe' and vc.people_fully_vaccinated is not null
--Group by dt.continent and dt.location
order by 1,2





CREATE VIEW Vaccination_New_cases AS 
Select  dt.location, dt.date, dt.new_cases,dt.new_deaths, vc.new_vaccinations, vc.people_fully_vaccinated,
AVG(cast(vc.new_vaccinations as int )/ dt.population * 100) OVER (Partition by dt.location Order by dt.location, dt.date) 
as new_vac_per_population
From CovidPandemic..Death dt
Join CovidPandemic..Vaccination vc
	On dt.location = vc.location
	and dt.date = vc.date
where dt.continent is not null and dt.continent like '%europe' and vc.people_fully_vaccinated is not null
--Group by dt.continent and dt.location
--order by 1,2

