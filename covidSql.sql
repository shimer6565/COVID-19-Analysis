--shows covidDeaths table
select * from covidProject..covidDeaths
where continent is not null
order by 3,4;

--shows covidVaccinations table
select * from covidProject..covidVaccinations
order by 3,4;


--Shows the necessary columns of the covidDeaths table
select location,date,total_cases,new_cases,total_deaths,population
from covidProject..covidDeaths
where continent is not null
order by 1,2;

--Shows the death percentage if a person is affected by covid in India
select location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from covidProject..covidDeaths
where location = 'India'
and continent is not null
order by 1,2;

--Shows what percentage of the population is affected by covid
select location,date,Population,total_cases, (total_cases/population)*100 as InfectionRate
from covidProject..covidDeaths
where location = 'India'
order by 1,2;

--Countries with highest infection rate compared to population
select location,Population,max(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as PercentagePopulationInfected
from covidProject..covidDeaths
where continent is not null
group by location, population
order by PercentagePopulationInfected desc;

--Showing countries with highest death count per population
select location, max(cast(Total_deaths as int)) as TotalDeathCount
from covidProject..covidDeaths
where continent is not null
group by location
order by TotalDeathCount desc;

--Breaking down by continent
select continent, max(cast(Total_deaths as int)) as TotalDeathCount
from covidProject..covidDeaths
where continent is not null
group by continent
order by TotalDeathCount desc;

--Global numbers
select date,sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from covidProject..covidDeaths
where continent is not null
group by date
order by 1,2;

--Total global numbers
select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from covidProject..covidDeaths
where continent is not null
order by 1,2;

--Total population vs Vaccinations
select dea.continent, dea.location, dea.date, dea.population,  vac.new_vaccinations,
sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location, dea.date)
as PeopleVaccinated
from covidProject..covidDeaths dea
join covidProject..covidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3;

--CTE  
with PopvsVac(Continent, Location, Date, Population,New_Vaccinations, PeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population,  vac.new_vaccinations,
sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location, dea.date)
as PeopleVaccinated
from covidProject..covidDeaths dea
join covidProject..covidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
)
select *, (PeopleVaccinated/Population)*100
from PopvsVac

--Creating view
create view PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population,  vac.new_vaccinations,
sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location, dea.date)
as PeopleVaccinated
from covidProject..covidDeaths dea
join covidProject..covidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null

select * from PercentPopulationVaccinated;