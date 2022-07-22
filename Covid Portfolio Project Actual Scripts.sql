select *
from Portfolioproject.dbo.CovidDeaths
where continent is not null
order by 3,4

--select *
--from Portfolioproject.dbo.CovidVaccinations
--order by 3,4

select  location,date,total_cases,new_cases,total_deaths, population 
from Portfolioproject.dbo.CovidDeaths
order by 1,2

--# total cases versus total death 
--# This shows the liklihood of dying if you get covid in your country

select  location,date,total_cases,new_cases,total_deaths, population, (total_deaths/total_cases) *100 as DeathPercentage 
from Portfolioproject.dbo.CovidDeaths
where location like '%canada%'
order by 1,2

--# Total cases versus population  
--# shows what percentage of populations has covid 

select  location,date,total_cases,new_cases,total_deaths, population, (total_cases/population) *100 as CasesPercentage, (total_deaths/total_cases) *100 as DeathPercentage 
from Portfolioproject.dbo.CovidDeaths
where location like '%canada%'
order by 1,2

--# lookiong at countries with highest infection rate compared to population 

select  location, population, MAX(total_cases) as HighestinfectionCount, MAX((total_cases/population)) *100 as Percentagepopulationinfected
from Portfolioproject.dbo.CovidDeaths 
Group by location, population
---#-where location like '%canada%'
Order by Percentagepopulationinfected desc

--# SHOWING THE COUNTRIES WITH THE HIGHEST DEATH COUNT 

select  location, population, MAX(cast(total_deaths as int)) as TotalDeathCount
from Portfolioproject.dbo.CovidDeaths
where continent is not null
Group by location, population
---#-where location like '%canada%'
Order by TotalDeathCount desc

select  continent, MAX(cast(total_deaths as int)) as TotalDeathCount
from Portfolioproject.dbo.CovidDeaths
where continent is not null
Group by continent
---#-where location like '%canada%'
Order by TotalDeathCount desc

select  location, MAX(cast(total_deaths as int)) as TotalDeathCount
from Portfolioproject.dbo.CovidDeaths
where continent is null
Group by location
---#-where location like '%canada%'
Order by TotalDeathCount desc

select  continent, MAX(cast(total_deaths as int)) as TotalDeathCount
from Portfolioproject.dbo.CovidDeaths
where continent is not null
Group by continent
---#-where location like '%canada%'
Order by TotalDeathCount desc

GLOBAL NUMBERS 

select SUM(new_cases) as total_cases, SUM (cast(new_deaths as int)) as total_death,SUM (cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from Portfolioproject.dbo.CovidDeaths
where continent is not null
--Group by date 
---#-where location like '%canada%'
Order by 1, 2


select *
from Portfolioproject.dbo.CovidVaccinations
order by 3,4

--# LOOKING AT TOTAL POPULATION VS VACINATION 

select  dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations , SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingpeopleVaccinated
from Portfolioproject.dbo.CovidDeaths as dea
join Portfolioproject.dbo.CovidVaccinations as vac
on dea.location =vac.location 
and dea.date=vac.date
where dea.continent is not null
order by 2,3

creating a Temporary table 
with PopvsVac (continent, location, date, population, new_Vaccinations, RollingpeopleVaccinated )
as 
(select  dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations , SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingpeopleVaccinated
from Portfolioproject.dbo.CovidDeaths as dea
join Portfolioproject.dbo.CovidVaccinations as vac
on dea.location =vac.location 
and dea.date=vac.date
where dea.continent is not null
--order by 2,3 ) )

) 
Select *, (RollingpeopleVaccinated/population)*100 as percentagepeoplevaccinated
From PopvsVac

--TEMP TABLE 
Drop Table if exists #percentpopulationVaccinated 
Create Table #percentpopulationVaccinated 
(continent nvarchar(255),
location nvarchar(255),
date datetime,
Population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric)
Insert into #percentpopulationVaccinated 
select  dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations , SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingpeopleVaccinated
from Portfolioproject.dbo.CovidDeaths as dea
join Portfolioproject.dbo.CovidVaccinations as vac
on dea.location =vac.location 
and dea.date=vac.date
where dea.continent is not null
Select *, (RollingpeopleVaccinated/population)*100 as percentagepeoplevaccinated
From #percentpopulationVaccinated 


--#CREATING VIEW TO STORE DATA FOR VISUALIZATION 

Create View percentpopulationVaccinated  as 
select  dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations , SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingpeopleVaccinated
from Portfolioproject.dbo.CovidDeaths as dea
join Portfolioproject.dbo.CovidVaccinations as vac
on dea.location =vac.location 
and dea.date=vac.date
where dea.continent is not null
--order by 2,3

select *
from percentpopulationVaccinated 

