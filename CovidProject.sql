select * from CovidPortfolio..CovidDeaths1
order by 3,4

--select * from CovidPortfolio..CovidVax1
--order by 3,4

--Select Data

select location, date, total_cases, new_cases, total_deaths, population
From CovidPortfolio..CovidDeaths1
order by 1,2

--Looking at Total Cases vs. Total Deaths
-- Shows the likelihood of dying if you contract covid in your country

SELECT * FROM CovidPortfolio..CovidDeaths1

ALTER TABLE CovidPortfolio..CovidDeaths1
ALTER column total_cases FLOAT
GO

ALTER TABLE CovidPortfolio..CovidDeaths1
ALTER column total_deaths FLOAT
GO

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From CovidPortfolio..CovidDeaths1
order by 1,2

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPecentage
From CovidPortfolio..CovidDeaths1
WHERE location like '%Canada%'
order by 1,2

-- Looking at Total Cases vs. Population
-- Shows what percentage of population got Covid

select location, date, population, total_cases,(total_cases/population)*100 as Percentage_of_Pop_With_Covid
From CovidPortfolio..CovidDeaths1
WHERE location like '%Canada%'
order by 1,2

--Looking at Countries With Highest Infections Rate Compared to Population

select location, population, MAX(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as Percent_Pop_Infected
From CovidPortfolio..CovidDeaths1
group by location, population
order by Percent_Pop_Infected desc

--Showing the Countries with the Highest Death Count per Population

select location, MAX(total_deaths) as TotalDeathCount
From CovidPortfolio..CovidDeaths1
group by location
order by TotalDeathCount desc

select location, MAX(total_deaths) as TotalDeathCount
From CovidPortfolio..CovidDeaths1
where continent is not null
group by location
order by TotalDeathCount desc

--- Displaying data by Continent

select continent, MAX(total_deaths) as TotalDeathCount
From CovidPortfolio..CovidDeaths1
where continent is NOT null
group by [continent]
order by TotalDeathCount desc

-- Global Numbers

ALTER TABLE CovidPortfolio..CovidDeaths1
ALTER column total_cases int
GO

ALTER TABLE CovidPortfolio..CovidDeaths1
ALTER column total_deaths int
GO

select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/(nullif((SUM(new_cases)), 0))*100 as DeathPercentage
From CovidPortfolio..CovidDeaths1
where continent is not NULL
group by date
order by 1,2


-- Looking at Tital Population vs Vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.location order by dea.location, dea.date) as Rolling#PeopleVaccinated
From CovidPortfolio..CovidDeaths1 dea
Join CovidPortfolio..CovidVax1 vac
    on dea.location = vac.location
    and dea.date = vac.date
where dea.continent is not NULL
ORDER by 2,3

-- Use CTE

with PopvsVac (continent, location, date, population, new_vaccinations, Rolling#PeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.location order by dea.location, dea.date) as Rolling#PeopleVaccinated
From CovidPortfolio..CovidDeaths1 dea
Join CovidPortfolio..CovidVax1 vac
    on dea.location = vac.location
    and dea.date = vac.date
where dea.continent is not NULL
)
select *, (Rolling#PeopleVaccinated/population)*100
From PopvsVac

-- Temp Table
DROP table if exists #PercentPopulationVaccinated
create TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
location nvarchar(255),
date DATETIME,
Population numeric,
new_vaccinations NUMERIC,
Rolling#PeopleVaccinated NUMERIC
)
Insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.location order by dea.location, dea.date) as Rolling#PeopleVaccinated
From CovidPortfolio..CovidDeaths1 dea
Join CovidPortfolio..CovidVax1 vac
    on dea.location = vac.location
    and dea.date = vac.date
where dea.continent is not NULL

select *, (Rolling#PeopleVaccinated/population)*100
From #PercentPopulationVaccinated


-- Creating View to store datat for later data visualisations 

Create View PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.location order by dea.location, dea.date) as Rolling#PeopleVaccinated
From CovidPortfolio..CovidDeaths1 dea
Join CovidPortfolio..CovidVax1 vac
    on dea.location = vac.location
    and dea.date = vac.date
where dea.continent is not NULL
