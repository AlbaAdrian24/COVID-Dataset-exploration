SELECT * FROM ..[CovidDeaths]
WHERE continent is not null
ORDER BY 3,4

--SELECT * FROM ..[CovidVaccinations]
--ORDER BY 3,4


----------------------------------

--Selecionar los datos a utilizar
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM ..[CovidDeaths]
WHERE continent is not null
ORDER BY 1,2



--total_cases vs total_deaths
--Porcentaje de probabilidad de muerte por pais
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
FROM ..[CovidDeaths]
WHERE location like '%mexico%'
WHERE continent is not null
ORDER BY 1,2



--total_cases vs population, para visualizar la cantidad de gente que contrajo covid
SELECT location, date, total_cases, population, (total_cases/population)*100 as porcentaje_contraido
FROM ..[CovidDeaths]
WHERE location like '%mexico%'
WHERE continent is not null
ORDER BY 1,2


--Paises con el más alto ratio de infeccion comparado con la poblacion
SELECT location, population, MAX(total_cases) as mayor_contagio, MAX((total_cases/population))*100 as porcentaje_poblacion_infectada
FROM ..[CovidDeaths]
WHERE continent is not null
GROUP BY population, location
ORDER BY 4 desc


--Paises con el mayor numero de muertos por poblacion
SELECT location, MAX(cast(total_deaths as int)) as mayores_muertes
FROM ..[CovidDeaths]
WHERE continent is not null
GROUP BY location
ORDER BY 2 desc


--Datos de muertes por continente

SELECT location, MAX(cast(total_deaths as int)) as mayores_muertes
FROM ..[CovidDeaths]
WHERE continent is null
GROUP BY location
ORDER BY 2 desc


--Numeros mundiales agrupados por muertes

SELECT date, SUM(new_cases) as total_casos, SUM(cast(new_deaths as int)) as total_muertes, SUM(cast(new_deaths as int))/SUM(new_cases) * 100 as relacion_muertes
FROM ..[CovidDeaths]
WHERE continent is not null
GROUP BY date
ORDER BY 1,2



--Total de muertes en relacion a los casos de infeccion registrados

SELECT SUM(new_cases) as total_casos, SUM(cast(new_deaths as int)) as total_muertes, SUM(cast(new_deaths as int))/SUM(new_cases) * 100 as relacion_muertes
FROM ..[CovidDeaths]
WHERE continent is not null
ORDER BY 1,2


--Unir tabla de muertes con vacunaciones

SELECT *
FROM [COVID]..[CovidDeaths] dea
JOIN [COVID]..[CovidVaccinations] vac
	ON dea.location = vac.location
	AND dea.date = vac.date



--Poblacion vs Vacunacion

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) OVER (
PARTITION BY dea.location ORDER BY dea.location, dea.date) as population_vaccinated
FROM [COVID]..[CovidDeaths] dea
JOIN [COVID]..[CovidVaccinations] vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2,3


--Crear 'View' para guardar data especifica

CREATE VIEW poblacion_vs_vacunacion as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) OVER (
PARTITION BY dea.location ORDER BY dea.location, dea.date) as population_vaccinated
FROM [COVID]..[CovidDeaths] dea
JOIN [COVID]..[CovidVaccinations] vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null


CREATE VIEW porcentaje_poblacion_infectada as
SELECT location, population, MAX(total_cases) as mayor_contagio, MAX((total_cases/population))*100 as porcentaje_poblacion_infectada
FROM ..[CovidDeaths]
WHERE continent is not null
GROUP BY population, location
