select *
from covid

-- select data that we will be used
select location,date,total_cases,total_deaths,population
from covid
order by 1,2;

-- total cases vs total deaths
-- show percentage of total cases died
select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as deathpercentage
from covid
order by 1,2;

-- total cases vs population
-- show percentage of total population got covid
select location,date,population,total_cases,(total_cases/population)*100 as InfectedPopulationPercentage
from covid
order by 1,2;

-- show countries with highest infection rate compared to population
select location,population,max(total_cases) highestInfection,max(total_cases/population)*100 as InfectedPopulationPercentage
from covid
group by location,population
order by 4 desc;

-- show countries with highest death
select location, max(total_deaths) as totalDeaths
from covid
where continent is not null
group by location
having max(total_deaths) is not null
order by totalDeaths desc

-- Global Numbers
select date,sum(new_cases) new_Cases,sum(new_deaths) new_deaths,sum(new_deaths)/sum(new_cases) deathpercentage
from covid
where continent is not null
group by date

-- show total population VS new vaccinations
select continent,location,date,population,new_vaccinations
	,sum(new_vaccinations) over(partition by location order by location,date) totalPeopleVaccinated
from covid
where continent is not null
order by 2,3

-- show percentage of vaccinated people of population
with popVSvac (continent,location,date,population,new_vaccinations,totalPeopleVaccinated)
as(
select continent,location,date,population,new_vaccinations
	,sum(new_vaccinations) over(partition by location order by location,date) totalPeopleVaccinated
from covid
where continent is not null
order by 2,3
)
select *,(totalPeopleVaccinated/population)*100 vaccienatedPercentage
from popVSvac

-- create view to show total vaccienated population
create view totalvaccinated as 
select continent,location,date,population,new_vaccinations
	,sum(new_vaccinations) over(partition by location order by location,date) totalPeopleVaccinated
from covid
where continent is not null