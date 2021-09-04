SELECT*
FROM [PortfolioProject-andrewnwq]..Covid_Deaths$
ORDER BY 3,4

SELECT*
FROM [PortfolioProject-andrewnwq]..Covid_Vaccination$
ORDER BY 3,4

--Selecting the data I am using
SELECT Location,date, total_cases, new_cases, total_deaths,population 
FROM [PortfolioProject-andrewnwq]..Covid_Deaths$
ORDER BY 1,2

--Comparison total cases vs total deaths (United Kingdom)
SELECT Location,date, total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
FROM [PortfolioProject-andrewnwq]..Covid_Deaths$
WHERE LOCATION = 'UNITED KINGDOM'
ORDER BY 1,2

--Comparison total cases vs population (United Kingdom)
SELECT Location,date, total_cases, population,(total_cases/population)*100 as DeathPercentage
FROM [PortfolioProject-andrewnwq]..Covid_Deaths$
WHERE LOCATION = 'UNITED KINGDOM'
ORDER BY 1,2

--Countries with Highest Infection rate vs Population
SELECT Location,MAX(total_cases) as HighestInfectionCount,max((total_cases/population))*100 as PercentagePopulationInfected
FROM [PortfolioProject-andrewnwq]..Covid_Deaths$
GROUP by LOCATION,POPULATION
ORDER by PercentagePopulationInfected desc

--By Countries with Highest Death Count per Population
SELECT Location,MAX(total_cases) as TotalDeathCount
FROM [PortfolioProject-andrewnwq]..Covid_Deaths$
WHERE continent is not null
GROUP by LOCATION
ORDER by TotalDeathCount desc

--By Continent with Highest Death Count per Population
SELECT Continent,MAX(total_cases) as TotalDeathCount
FROM [PortfolioProject-andrewnwq]..Covid_Deaths$
WHERE continent is not null
GROUP by continent
ORDER by TotalDeathCount desc

--Worldwide numbers
SELECT SUM(new_cases) as total_cases,SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_cases)*100 as DeathPercentage
FROM [PortfolioProject-andrewnwq]..Covid_Deaths$
WHERE continent is not null
ORDER BY 1,2

Select*
From [PortfolioProject-andrewnwq]..Covid_Deaths$ dea
Join [PortfolioProject-andrewnwq]..Covid_Vaccination$ vac
	on dea.location = vac.location
	and dea.date = vac.date


 --Total Population vs Vaccination
 Select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations
 From [PortfolioProject-andrewnwq]..Covid_Deaths$ dea
Join [PortfolioProject-andrewnwq]..Covid_Vaccination$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

 --Total Population vs Vaccination(Count by country)
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [PortfolioProject-andrewnwq]..Covid_Deaths$ dea
Join [PortfolioProject-andrewnwq]..Covid_Vaccination$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3


--creating for visualization
Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From [PortfolioProject-andrewnwq]..Covid_Deaths$ dea
Join [PortfolioProject-andrewnwq]..Covid_Vaccination$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null