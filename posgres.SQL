-- SQL Country Database Challenges
-- Save your queries in a file if you want to keep them for posterity.

-- WHERE

-- What is the population of the US? (HINT: starts with 2, ends with 000)
SELECT population FROM country WHERE name='United States'
-- What is the area of the US? (starts with 9, ends with million square miles)
SELECT surfacearea FROM country WHERE name='United States'
-- List the countries in Africa that have a population smaller than 30,000,000 and a life expectancy of more than 45? (all 37 of them)
SELECT name, population, lifeexpectancy FROM country WHERE continent = 'Africa' and population < 30000000 and lifeexpectancy > 45
-- Which countries are something like a republic? (are there 122 or 143 countries or ?)
SELECT name, governmentform FROM country WHERE governmentform LIKE '%Republic%'
-- Which countries are some kind of republic and acheived independence after 1945?
SELECT name, governmentform, indepyear FROM country WHERE governmentform LIKE '%Republic%' and indepyear > 1945
-- Which countries acheived independence after 1945 and are not some kind of republic?
SELECT name, governmentform, indepyear FROM country WHERE governmentform NOT LIKE '%Republic%' and indepyear > 1945

-- ORDER BY

-- Which fifteen countries have the lowest life expectancy? highest life expectancy?
SELECT name, lifeexpectancy FROM country WHERE lifeexpectancy > 0 ORDER BY lifeexpectancy asc LIMIT 15;
SELECT name, lifeexpectancy FROM country WHERE lifeexpectancy > 0 ORDER BY lifeexpectancy desc LIMIT 15;
-- Which five countries have the lowest population density? highest population density?
SELECT name, surfacearea, population FROM country ORDER BY (population/surfacearea) asc LIMIT 5
SELECT name, surfacearea, population FROM country ORDER BY (population/surfacearea) desc LIMIT 5
-- Which is the smallest country, by area and population? the 10 smallest countries, by area and population?
SELECT name, surfacearea, population FROM country ORDER BY surfacearea + population asc LIMIT 1
SELECT name, surfacearea, population FROM country ORDER BY surfacearea + population asc LIMIT 10
-- Which is the biggest country, by area and population? the 10 biggest countries, by area and population?
SELECT name, surfacearea, population FROM country ORDER BY surfacearea + population desc LIMIT 1
SELECT name, surfacearea, population FROM country ORDER BY surfacearea + population desc LIMIT 10

-- WITH

-- Of the smallest 10 countries, which has the biggest gnp? (hint: use WITH and LIMIT)
WITH smallest10 AS
(SELECT * FROM country WHERE gnp > 0.0 ORDER BY population asc LIMIT 10)
SELECT name, gnp FROM smallest10 ORDER BY gnp desc
-- Of the smallest 10 countries, which has the biggest per capita gnp?
WITH smallest10 AS
(SELECT * FROM country WHERE gnp > 0.0 ORDER BY population asc LIMIT 10)
SELECT name, gnp, gnp/population AS gnpPop FROM smallest10 ORDER BY gnp/population desc
-- Of the biggest 10 countries, which has the biggest gnp?
WITH biggest10 AS
(SELECT * FROM country WHERE gnp > 0.0 ORDER BY population desc LIMIT 10)
SELECT name, gnp FROM biggest10 ORDER BY gnp desc LIMIT 1
-- Of the biggest 10 countries, which has the biggest per capita gnp?
WITH biggest10 AS
(SELECT * FROM country WHERE gnp > 0.0 ORDER BY population desc LIMIT 10)
SELECT name, gnp FROM biggest10 ORDER BY gnp/population desc LIMIT 1
-- What is the sum of surface area of the 10 biggest countries in the world? The 10 smallest?
WITH biggest10 AS
(SELECT * FROM country WHERE population > 0 ORDER BY population desc LIMIT 10)
SELECT SUM(surfacearea) FROM biggest10
-- GROUP BY

-- How big are the continents in term of area and population?
SELECT continent,
SUM(surfacearea) AS surfaceareaSum,
SUM(population) AS populationSum
FROM country GROUP BY continent
-- Which region has the highest average gnp?
SELECT region, avg(gnp) AS avgGnp FROM country GROUP BY region ORDER BY avgGnp desc LIMIT 1
-- Who is the most influential head of state measured by population?
SELECT headofstate, max(population) AS maxPop FROM country GROUP BY headofstate ORDER BY maxPop desc LIMIT 1;
-- Who is the most influential head of state measured by surface area?
SELECT headofstate, max(surfacearea) AS maxarea FROM country GROUP BY headofstate ORDER BY maxarea desc LIMIT 1;
-- What are the most common forms of government? (hint: use count(*))
SELECT governmentform, COUNT(*) FROM country
GROUP BY governmentform ORDER BY count desc
-- What are the forms of government for the top ten countries by surface area?
SELECT governmentform, max(surfacearea) AS bySurfaceArea FROM country
GROUP BY governmentform ORDER BY bySurfaceArea desc LIMIT 10
-- What are the forms of government for the top ten richest nations? (technically most productive)
SELECT governmentform, max(gnp) FROM country
GROUP BY governmentform ORDER BY max(gnp) desc LIMIT 10

-- What are the forms of government for the top ten richest per capita nations? (technically most productive)
WITH richest10 AS
(SELECT * FROM country ORDER BY gnp desc LIMIT 10)
SELECT governmentform, MAX(gnp/population) AS gnp_percapita FROM richest10 WHERE population > 0 GROUP BY governmentform ORDER BY gnp_percapita desc

-- or

SELECT (gnp/population) AS gnp_percapita, code, governmentform
FROM country WHERE population > 0
ORDER BY gnp_percapita desc LIMIT 10

-- Interesting...

-- Which countries are in the top 5% in terms of area?
-- (hint: use a SELECT in a LIMIT clause)
SELECT name FROM country ORDER BY surfacearea desc LIMIT (SELECT COUNT(*) * .05 FROM country)

-- When is the database from?
--
-- Stretch Challenges
--
-- What is the 3rd most common language spoken?
-- How many cities are in Chile?
-- What is the total population in China?
-- How many countries are in North America?
-- Which countries gained their independence before 1963?
-- What is the total population of all continents?
-- What is the average life expectancy for all continents?
-- Which countries have the letter z in the name? How many?
-- What is the age of Jamaica?
-- Are there any countries without an official language? Hint: WHERE ... NOT IN ( SELECT ... FROM ... WHERE ...)
