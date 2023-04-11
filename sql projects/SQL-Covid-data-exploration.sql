select *
from project..covid_deaths
where continent is not null
order by 3,4

select *
from project..covid_vaccinations

-- select data to use

select Location, date, total_cases, new_cases, total_deaths, population
from project..covid_deaths
order by 1,2

-- Total cases vs Total deaths in US
-- likelihood of dying if you get covid in us
select Location, date, total_cases, total_deaths, (total_deaths/(cast(total_cases AS numeric)))*100 AS DeathPercentage
from project..covid_deaths
where location like '%states%'
order by 1,2


-- Total Cases vs Population 
-- shows twhat percentage of population got covid
select Location, date, population, total_cases, (total_cases/population)*100 AS InfectionPercentage
from project..covid_deaths
where location like '%states%'
order by 1,2


-- Look at countries with highest infection rate compared to populations
select Location, population, max(total_cases) as highest_infection_count, max((total_cases/population))*100 AS percent_population_infected 
from project..covid_deaths
group by location, population
order by percent_population_infected desc


-- showing countries with the highest death count per population
select Location, max(cast(total_deaths as int)) as TotalDeathCount
from project..covid_deaths
where continent is not null
group by location
order by TotalDeathCount desc



-- death count by continent 
select continent, max(cast(total_deaths as int)) as TotalDeathCount
from project..covid_deaths
where continent is not null
group by continent
order by TotalDeathCount desc

--showing continents with the highest death count 
select continent, max(cast(total_deaths as int)) as TotalDeathCount
from project..covid_deaths
where continent is not null
group by continent
order by TotalDeathCount desc


-- global numbers

select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage 
from project..covid_deaths
where continent is not null
order by 1,2


-- looking at total population vs vaccination
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as float)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
-- ,(RollingPeopleVaccinated/population 
from project..covid_deaths dea
join project..covid_vaccinations vac
	on dea.location = vac.location 
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3

-- use cte

with PopvsVac (continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated)
as
(select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as float)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
-- ,(RollingPeopleVaccinated/population 
from project..covid_deaths dea
join project..covid_vaccinations vac
	on dea.location = vac.location 
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
select*, (RollingPeopleVaccinated/population)
from PopvsVac

-- create view
create view PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as float)) over (partition by dea.location order by dea.location, dea.date)
as RollingPeopleVaccinated
from project..covid_deaths dea
join project..covid_vaccinations vac
	on dea.location = vac.location 
	and dea.date = vac.date
where dea.continent is not null 

select *
from PercentPopulationVaccinated