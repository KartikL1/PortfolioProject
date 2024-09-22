select * from [Portfolio Project].dbo.CovidDeaths
where continent is not null
order by 3,4


select location,date,total_cases,new_cases,total_deaths, 
--Looking at total cases vs Total Deaths
(total_deaths/total_cases) * 100 as DeathPercentage

from [Portfolio Project].dbo.CovidDeaths
--Location of the country which we're looking for
where location like '%India'
and continent is not null
order by 1,2




select location,date,total_cases,new_cases,population, 
--looking at the total_cases vs population
--shows that percentage of population got covid
(total_cases/population) * 100 as InfectedPercentage
from [Portfolio Project].dbo.CovidDeaths
--where location like '%India'
where continent is not null
order by 1,2

--Looking at the countries with highest infection rate compared to population

select location,Population,MAX(total_cases) as HighestInfection, 
MAX((total_cases/population)) * 100 as PercentPopulationInfected
from [Portfolio Project].dbo.CovidDeaths
--where location like '%India'
where continent is not null
group by location,population
order by PercentPopulationInfected desc


--showing the countries with the highest deathCount per population

select location,MAX(cast(total_deaths as int)) as TotalDeathCount
from [Portfolio Project].dbo.CovidDeaths
--where location like '%India'
where continent is not null
group by location
order by TotalDeathCount desc 

--LETS break things down by continent

select location,MAX(cast(total_deaths as int)) as TotalDeathCount
from [Portfolio Project].dbo.CovidDeaths
--where location like '%India'
where continent is not null
group by location
order by TotalDeathCount desc 

--SHowinng the continent with highest death count per continent

select continent,MAX(cast(total_deaths as int)) as TotalDeathCount
from [Portfolio Project].dbo.CovidDeaths
--where location like '%India'
where continent is not null
group by continent
order by TotalDeathCount desc 


--GLOBAL NUMBERS

select SUM(total_cases) as totalCases,SUM(cast(new_deaths as int)) as totalDeaths,SUM(cast(new_deaths as int))/SUM(new_cases) * 100 as DeathPercentage
from [Portfolio Project].dbo.CovidDeaths
--where location like '%world'
where continent is not null
--group by date
order by 1,2


--Looking at Total population vs Vaccinations

select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,SUM(cast(vac.new_vaccinations as int)) OVER(partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccination
from [Portfolio Project].dbo.CovidDeaths dea
join [Portfolio Project].dbo.CovidVaccinations vac 
on dea.location = vac.location 
   and dea.date = vac.date
where dea.continent is not null
order by 1,2

--USE CTE

with PopvsVac(continent,location,date,population,new_vaccinations,RollingPeopleVaccination)
as
(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,SUM(cast(vac.new_vaccinations as int)) OVER(partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccination
from [Portfolio Project].dbo.CovidDeaths dea
join [Portfolio Project].dbo.CovidVaccinations vac 
on dea.location = vac.location 
   and dea.date = vac.date
where dea.continent is not null
--order by 1,2
)
select * ,(RollingPeopleVaccination/population)*100
from PopvsVac

--Creating view to store data for later visrualization

Create View PercentPopulationnVaccineted as
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,SUM(cast(vac.new_vaccinations as int)) OVER(partition by dea.location order by dea.location,
dea.date) as RollingPeopleVaccination
from [Portfolio Project].dbo.CovidDeaths dea
join [Portfolio Project].dbo.CovidVaccinations vac 
on dea.location = vac.location 
   and dea.date = vac.date
where dea.continent is not null
--order by 1,2

select * from PercentPopulationnVaccineted