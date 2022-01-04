#Death Percentage 
SELECT Location,date, total_cases, total_deaths,(total_deaths/total_cases)*100 as "Death Percentage"
from covid_deaths
Order by 1,2;

#Percentage of Population affected by Country
SELECT Location,MAX(date), Population, max(total_cases) as "total cases",(max(total_cases)/Population)*100 as "Infection Percentage"
FROM covid_deaths
GROUP BY Location
ORDER BY 1,2;


#Top 10 Highly Infected Countries in terms of % of Population
SELECT Location, Population, max(total_cases) as "total cases",(max(total_cases)/Population)*100 as Infection_Percentage
FROM covid_deaths
GROUP BY Location
ORDER BY 4 desc
LIMIT 10;




#Top 10 countries by Death Count
SELECT Location, MAX(cast(total_deaths as unsigned)) as Total_DEATHS
FROM covid_deaths
WHERE continent is not null
GROUP BY Location
ORDER BY 2 Desc;

#Total number of cases and deaths worldwide daily
SELECT date, sum(new_cases) as Glabal_cases,sum(new_deaths) as Global_deaths,sum(new_deaths)/sum(new_cases) *100 as Global_Death_Percentage
from covid_deaths
group by date;

#Joining two tables

SELECT * FROM covid_vaccination as vac 
LEFT JOIN 
covid_deaths as dea 
on vac.date=dea.date and vac.location=dea.location and vac.iso_code=dea.iso_code;


-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
#, (RollingPeopleVaccinated/population)*100
From covid_deaths as dea
Join covid_vaccination as vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3;


#Using CTE  to find Rolling Percentage

With VacDEA (CONTINENT,LOCATION,DATE,POPULATION,NEW_VACCINATIONS,ROLLING_VACCINATIONS) AS
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
#, (RollingPeopleVaccinated/population)*100
From covid_deaths as dea
Join covid_vaccination as vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
)
SELECT *,Rolling_vaccinations/population*100 from VACDEA;


#tEMP tABLE
 Drop TABLE  IF EXISTS Vaccinated_People;
Create TABLE Vaccinated_People
(
continent varchar(300),
location varchar(300),
population integer,
new_vaccinations varchar(300),
rollingvaccinations int
);

Insert into Vaccinated_People
Select dea.continent, dea.location, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From covid_deaths as dea
Join covid_vaccination as vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null ;

select * from Vaccinated_People;

#Creating Views
Create View Vaccinatedpeople as(
Select vaccinatedpeople, dea.continent, dea.location, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From covid_deaths as dea
Join covid_vaccination as vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null) ;



