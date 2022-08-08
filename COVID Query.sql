--COVID Information

--TOTAL CASES VS TOTAL DEATHS
select
location, date, total_cases, new_cases, total_deaths, population 
from COVID..CovidDeaths$
order by 1,2


--LIKELIHOOD OF DEATH FROM COVID IN USA

select
location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from COVID..CovidDeaths$
where location like '%states'
order by 1,2

--PERCENT OF USA INFECTED OVER TIME

select
location, date, total_cases, population, total_cases, (total_cases/population)*100 as PercentInfected
from COVID..CovidDeaths$
where location like '%states'
order by 1,2

--HIGHEST INFECTION RATE

select
location, population, max(total_cases) as MaxInfectionCount, Max((total_cases/population))*100 as PercentInfected
from COVID..CovidDeaths$
group by location, population
order by PercentInfected desc

-- HIGHEST DEATH TOLL

select
location, max(cast(total_deaths as int)) as TotalDeathToll
from COVID..CovidDeaths$
where continent is not null
group by location, population
order by TotalDeathToll desc

-- DEATH BY CONTINENT

select
location, max(cast(total_deaths as int)) as TotalDeathToll
from COVID..CovidDeaths$
where continent is null
group by location
order by TotalDeathToll desc


-- TOTAL GLOBAL CASE/DEATH/DEATH PERCENTAGE
select
sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercent
from COVID..CovidDeaths$
where continent is not null
order by 1,2

-- TOTAL POPULATION VACCINATED OVER TIME
With popvac (continent, location, date, population, new_vaccinations, vaccinationcount)
as(
Select death.continent, death.location, death.date, death.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as int))
over (partition by death.location order by death.location, death.date) as VaccinationCount
from COVID..CovidDeaths$ death
join COVID..CovidVaccinations$ vac
on death.location = vac.location 
and death.date = vac.date
where death.continent is not null
)
Select *, (vaccinationcount/population)*100
from popvac
