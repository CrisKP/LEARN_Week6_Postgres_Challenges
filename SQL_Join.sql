-- Relatively Simple JOINS

-- What languages are spoken in the United States? (12) Brazil? (not Spanish...) Switzerland? (6)
SELECT
c.name AS name,
cl.language AS language
FROM
country c JOIN
countrylanguage cl ON c.code = cl.countrycode
WHERE name = 'United States' or name = 'Brazil' or name = 'Switzerland'
ORDER BY name desc

-- What are the cities of the US? (274) India? (341)
SELECT
c.name AS name,
city.name AS city
FROM
country c JOIN
city city ON c.code = city.countrycode
WHERE c.name = 'United States' or c.name = 'India'

-- Languages

-- What are the official languages of Switzerland? (4 languages)
SELECT
    c.name AS name,
    cl.language AS language
FROM
	country c JOIN
    countrylanguage cl ON c.code = cl.countrycode
WHERE
	c.name = 'Switzerland'

-- Which country or contries speak the most languages? (12 languages)
-- Hint: Use GROUP BY and COUNT(...)
SELECT
    c.name AS name,
    count(cl.language) AS num_language
FROM
	country c JOIN
    countrylanguage cl ON c.code = cl.countrycode
GROUP BY
	c.name
ORDER BY
	count(cl.language) desc

-- Which country or contries have the most official languages? (4 languages)
-- Hint: Use GROUP BY and ORDER BY
-- Which languages are spoken in the ten largest (area) countries?
-- Hint: Use WITH to get the countries and join with that table
WITH ten_largest AS
(SELECT code, name, surfacearea FROM country WHERE code != 'ATA' ORDER BY surfacearea desc LIMIT 10)
SELECT
	t.name AS name,
	cl.language AS language
FROM
	countrylanguage cl JOIN ten_largest t ON cl.countrycode = t.code
ORDER BY
	t.name desc

--
-- What languages are spoken in the 20 poorest (GNP/ capita) countries in the world? (94 with GNP > 0)
-- Hint: Use WITH to get the countries, and SELECT DISTINCT to remove duplicates
WITH gnp_per_capita AS
	(SELECT code, name, gnp/population FROM country WHERE GNP > 0 ORDER BY (gnp/population) asc LIMIT 20)
SELECT
	g.name AS name,
    cl.language AS language
FROM
	countrylanguage cl JOIN gnp_per_capita g ON (cl.countrycode = g.code)
ORDER BY
	g.name asc

-- Are there any countries without an official language?
-- Hint: Use NOT IN with a SELECT
WITH official_lang AS
(SELECT c.code, c.name, cl.countrycode, cl.isofficial FROM country c JOIN countrylanguage cl ON (c.code = cl.countrycode) WHERE cl.isofficial = 'true')
SELECT
	c.name
FROM
	country c LEFT OUTER JOIN official_lang o ON (c.code = o.code) WHERE c.name NOT IN (SELECT name FROM official_lang)

-- What are the languages spoken in the countries with no official language? (49 countries, 172 languages, incl. English)

WITH official_lang AS
(SELECT c.code, c.name, cl.countrycode, cl.isofficial
FROM country c JOIN countrylanguage cl ON (c.code = cl.countrycode) WHERE cl.isofficial = 'true')
SELECT
	c.name,
  cl.language
FROM
	country c LEFT OUTER JOIN official_lang o ON (c.name = o.name)
JOIN countrylanguage cl ON (c.code = cl.countrycode)
WHERE c.name NOT IN (SELECT name FROM official_lang)
ORDER BY c.name asc

-- Which countries have the highest proportion of official language speakers? The lowest?
WITH perc_lang AS
(SELECT * FROM countrylanguage WHERE isofficial = 'true' ORDER BY percentage desc)
SELECT
	c.name,
    p.language,
    c.population,
    (p.percentage/100)*c.population AS off_lang_speak,
    p.percentage
FROM country c JOIN perc_lang p ON (c.code = p.countrycode)
--
-- What is the most spoken language in the world?


-- Cities
--
-- What is the population of the United States? What is the city population of the United States?
--
--
--
-- What is the population of the India? What is the city population of the India?
--
--
--
-- Which countries have no cities? (7 not really contries...)
-- Languages and Cities
--
-- What is the total population of cities where English is the offical language? Spanish?
-- Hint: The official language of a city is based on country.
-- Which countries have the 100 biggest cities in the world?
--
--
--
-- What languages are spoken in the countries with the 100 biggest cities in the world?
