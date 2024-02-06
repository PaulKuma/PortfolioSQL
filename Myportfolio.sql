use portfolio_db;


-- select *
-- from portfolio_db.coviddeaths;
-- select *
-- from portfolio_db.covidvaccinations
-- order by 3,4;

select Location, date, total_cases, new_cases, total_deaths, population
from portfolio_db.coviddeaths
WHERE continent is null
order by 1,2;

select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from portfolio_db.coviddeaths
where Location like '%ghana%' and continent is not null
order by 1,2;

select Location, date, total_cases, population, (total_cases/population)*100 as CasePercentage
from portfolio_db.coviddeaths
where Location like '%ghana%' and continent is not null
order by 1,2;

-- looking at countries with highest infection rate

select Location, population, MAX(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as CasePercentage
from portfolio_db.coviddeaths
-- where Location like '%ghana%'
group by population, location
order by CasePercentage desc;

-- looking for highest death rates

select Continent, MAX(total_deaths) AS DeathCount
from portfolio_db.coviddeaths
-- where Location like '%ghana%'
WHERE continent is not null
group by continent
order by DeathCount desc;

select continent, MAX(cast(total_deaths as dec)) AS DeathCount
from portfolio_db.coviddeaths
-- where Location like '%ghana%'
WHERE continent is not null
group by continent
order by DeathCount desc;

-- showing the continent with the highest death count

select continent, MAX(cast(total_deaths as dec)) AS DeathCount
from portfolio_db.coviddeaths
-- where Location like '%ghana%'
WHERE continent is not null
group by continent
order by DeathCount desc;

select date, SUM(new_cases), SUM(cast(new_deaths as dec)), SUM(cast(new_deaths as dec))/SUM(new_cases)*100 as DeathPercentage-- total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from portfolio_db.coviddeaths
-- here Location like '%ghana%' and 
where continent is not null
Group by date
order by 1,2;


select * 
from portfolio_db.coviddeaths dea
join portfolio_db.covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date;

-- total population vs vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as dec)) over (partition by dea.location order by dea.location, dea.date) as RollingVaccination
from portfolio_db.coviddeaths dea
join portfolio_db.covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3;

-- CTE

with PopvsVac (Continent, location, Date, Population, new_vaccinations, RollingVaccination)
as(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as dec)) over (partition by dea.location order by dea.location, dea.date) as RollingVaccination
from portfolio_db.coviddeaths dea
join portfolio_db.covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
)
select * 
from PopvsVac

-- TEMP TABLE

create table #PercentPopulationVaccinated

insert into
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as dec)) over (partition by dea.location order by dea.location, dea.date) as RollingVaccination
from portfolio_db.coviddeaths dea
join portfolio_db.covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null;

-- create views to store data

create view PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as dec)) over (partition by dea.location order by dea.location, dea.date) as RollingVaccination
from portfolio_db.coviddeaths dea
join portfolio_db.covidvaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3;