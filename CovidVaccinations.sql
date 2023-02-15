select * from dbo.[Covid_vac]
select * from dbo.[Covid_vac_manufacturer]

ALTER TABLE dbo.[Covid_vac]
DROP COLUMN source_website
ALTER TABLE dbo.[Covid_vac]
DROP COLUMN iso_code

--we have 223 countries and 483 days (22nd February 2021 - 29th March 2022)
SELECT DISTINCT Country from dbo.[Covid_vac]
SELECT DISTINCT date from dbo.[Covid_vac]

--Inserting and updating data into the new added column
UPDATE dbo.[Covid_vac]
SET [Year]  = PARSENAME(REPLACE(date,'-','.'),3)
UPDATE dbo.[Covid_vac]
SET [Month]  = PARSENAME(REPLACE(date,'-','.'),2)


--Note that you can also use the datetime module 'DATEPART'
SELECT Country,date, DATEPART (YY, date)[Year],DATEPART (MM, date)[Month]
from dbo.[Covid_vac]


---Replacing NULL with zero
UPDATE dbo.[Covid_vac]
SET people_fully_vaccinated  = 0
where people_fully_vaccinated is null 

--Total vaccination = 2,002,854,013,358
SELECT SUM (total_vaccinations)
FROM dbo.[Covid_vac]

---Total vaccination, people vaccinated and vaccine left by country 
SELECT Country,SUM (total_vaccinations) Total_vaccine,SUM (people_vaccinated) pple_vac
, (SUM (total_vaccinations)-SUM (people_vaccinated)) Vaccine_left
FROM dbo.[Covid_vac]
group by Country 
order by 2 desc

---How many people are fully vaccinated by country
SELECT Country,SUM (people_fully_vaccinated) pple_fully_vac
FROM dbo.[Covid_vac]
group by Country 
order by 2 desc

---People vaccinated and fully vacinated by year 
SELECT [Year], SUM (people_fully_vaccinated) pple_fully_vac
FROM dbo.[Covid_vac]
group by [Year] 
order by 1 desc

SELECT [Year], SUM (people_vaccinated) pple_vac
FROM dbo.[Covid_vac]
group by [Year] 
order by 1 desc

--How many people are not fully vaccinated out of those vaccinated by Year and country
SELECT [Year], SUM (people_vaccinated) pple_vac,SUM (people_fully_vaccinated) pple_fully_vac
, (SUM (people_vaccinated)-SUM (people_fully_vaccinated)) Not_fully_vaccinated
FROM dbo.[Covid_vac]
group by [Year]
order by 1 desc
--by country
SELECT Country, SUM (people_vaccinated) pple_vac,SUM (people_fully_vaccinated) pple_fully_vac
, (SUM (people_vaccinated)-SUM (people_fully_vaccinated)) Not_fully_vaccinated
FROM dbo.[Covid_vac]
group by Country
order by 4 desc

--Daily vaccination by Month
SELECT [Year],[Month], SUM (daily_vaccinations_per_million) daily_vac
FROM dbo.[Covid_vac]
group by [Year],[Month]
order by 3 desc

--Names of vaccines
SELECT DISTINCT (vaccine)--, SUM(total_vaccinations)--,location
FROM dbo.[Covid_vac_manufacturer]
--GROUP BY vaccine
--WHERE location like'%Germany%'

---Total vaccinations by vaccine type
SELECT location, vaccine, SUM (total_vaccinations) total_vac
FROM dbo.[Covid_vac_manufacturer]
WHERE location like '%Argent%'
group by location,vaccine
order by 1 desc

select * from dbo.[Covid_vac_manufacturer]