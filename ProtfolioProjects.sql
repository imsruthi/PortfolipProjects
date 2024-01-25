Select Row_Number()OVER(Order by isocode)as SNO, coviddeaths.* from coviddeaths;

Select * from covidvaccinations
order by 1,2;

Select location,date,total_cases,new_cases,total_deaths,population from coviddeaths
order by 1,2;

# Looking at total cses Vs total_deaths
Select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage from coviddeaths
where location like '%India%'
order by 1,2;

#Looking at the % of Total Cases VS population
Select location,date,total_cases,population,(total_cases/population)*100 as populated_Affected from coviddeaths
where location like '%states%';

#Looking at Countries with Highest Affected Rate compared to Population
Select location,population, MAX(total_cases)as Highest_Affected_Count,MAX((total_cases/population))*100 as Highest_Affected_Percentage 
from coviddeaths
#where location like '%states%'
Group by location,population
Order by Highest_Affected_Percentage desc;

#Showing the countries with the highest death count of the population
Select location,MAX(total_deaths) as Highest_Deaths
from coviddeaths
Where continent is not null
Group by location
Order by Highest_deaths desc;

#Showing Continents with highest death
Select continent,MAX(total_deaths) as TotalDeath_Count
from Coviddeaths
where continent is not null
Group by continent
order by Max(total_deaths) desc;

#Global Cases
Select SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths , sum(new_deaths)/sum(new_cases)*100 as Death_percentage from coviddeaths
where continent is not null
order by 1,2;

#Looking at population Vs vaccinations 
# CTE- Common Table Expression(Used to store the result of query exists temporarily in a table)

with PopVsVac (continent,Location, Date, Population, new_vaccinations,RollingPeopleVaccinated)
as 
(
Select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From coviddeaths dea
Join covidvaccinations vac
on dea.location= vac.location
and dea.date = vac.date 
where dea.continent is not null
-- order by 2,3
)
Select *, (RollingPeoplevaccinated/population)*100 as Total_Vaccinations from PopVsVac;

-- Temp Table ---

DROP TABLE IF EXISTS #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
continent nvarchar(20)Not null ,
location nvarchar(20)Not null,
Date DateTime,
Population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into
Select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From coviddeaths dea
Join covidvaccinations vac
on dea.location= vac.location
and dea.date = vac.date 
where dea.continent is not null
-- order by 2,3

Select *, (RollingPeoplevaccinated/population)*100 as Total_Vaccinations from PercentPopulationVaccinated;

-- Creating view to store the data for later visualizations
Select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From coviddeaths dea
Join covidvaccinations vac
on dea.location= vac.location
and dea.date = vac.date 
where dea.continent is not null;
-- order by 2,3


Select *
from PercentPopulationVaccinated




















