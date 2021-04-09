-- Checking a list The word IN allows us to check if an item is in a list. The example shows the name and population for the countries:
SELECT name, population FROM world
  WHERE name IN ('Brazil', 'Russia', 'India', 'China');

-- BETWEEN allows range checking (range specified is inclusive of boundary values). 
SELECT name, area FROM world
  WHERE area BETWEEN 200000 AND 250000

--
-- Pattern Matching Queries
-- LIKE operator to check names. The % is a wild-card it can match any characters
SELECT name FROM world
  WHERE name LIKE '%x%'

-- A name that has three letters a. ex: 'Bahama'
SELECT name FROM world
  WHERE name LIKE '%a%a%a%'

-- '_%' You can use the underscore as a single character wildcard.
-- India and Angola have an n as the second character. 
SELECT name FROM world
 WHERE name LIKE '_n%'
ORDER BY name

-- Find the countries that have two "o" characters separated by two others.
SELECT name FROM world  
 WHERE name LIKE '%o__o%'

-- Find the country where the capital is the country plus "City".
-- concat(name, ' City')
SELECT name FROM world
 WHERE capital LIKE concat(name, ' City')
 
--Find the capital and the name where the capital includes the name of the country.
--	capital             name
-- Andorra la Vella   	Andorra
select capital, name from world
where capital like '%'+name+'%'

--Find the capital and the name where the capital is an extension of name of the country.
--You should include Mexico City as it is longer than Mexico. You should not include Luxembourg as the capital is the same as the country.
select capital, name from world
where capital like name+'%' and len(capital) > len(name)


--Show the name and the extension where the capital is an extension of name of the country.
--For Monaco-Ville the name is Monaco and the extension is -Ville.
--REPLACE(f, s1, s2) returns the string f with all occurances of s1 replaced with s2.
select name, replace(capital, name, '') as 'extension' from world
where capital like name+'%' and len(capital) > len(name)

--Exclusive OR (XOR). Show the countries that are big by area (more than 3 million) or big by population (more than 250 million) but not both. 
select name, population, area from world
where (area > 3000000 and population < 250000000) or (area < 3000000 and population > 250000000)

--Round(number,significant_figures)
select name, round(population/1000000, 2), round(gdp/1000000000,2) from world
where continent = 'South America'

--Show per-capita GDP for the trillion dollar countries to the nearest $1000.
select name, round(gdp/population, -3) -- Rounds to the nearest $1000 by -3
from world where gdp > 1000000000000

--Show the name and the capital where the first letters of each match. Don't include countries where the name and the capital are the same word.
SELECT name, capital FROM world
where left(name,1) = left(capital,1) and name != capital

--Find the country that has all the vowels(a e i o u) and no spaces in its name.
SELECT name FROM world
WHERE name LIKE '%a%' AND name LIKE '%e%' AND name LIKE '%i%'  AND name LIKE '%o%' AND name LIKE '%u%'  AND name NOT LIKE '% %'


--
--
-- Nested Statements


--
--Aggregate functions: COUNT, SUM and AVG
--It takes many values and returns one.
--What is the total population of ('Estonia', 'Latvia', 'Lithuania')?
select sum(population)
from world
where name in  ('Estonia', 'Latvia', 'Lithuania')

--HAVING and GROUPBY:
--By including a GROUP BY clause functions such as SUM and COUNT are applied to groups of items sharing values. 
--When you specify GROUP BY continent the result is that you get only one row for each different value of continent. 
--All the other columns must be "aggregated" by one of SUM, COUNT ...

--The HAVING clause allows use to filter the groups which are displayed. The WHERE clause filters rows before the aggregation, 
--the HAVING clause filters after the aggregation.
--If a ORDER BY clause is included we can refer to columns by their position.

--For each continent show the number of countries:
SELECT continent, COUNT(name)
  FROM world
 GROUP BY continent

--WHERE and GROUP BY. The WHERE filter takes place before the aggregating function. 
--For each relevant continent show the number of countries that has a population of at least 200000000.
SELECT continent, COUNT(name)
  FROM world
 WHERE population>200000000
 GROUP BY continent
 
 --GROUP BY and HAVING. The HAVING clause is tested after the GROUP BY. 
 --Show the total population of those continents with a total population of at least half a billion.
SELECT continent, SUM(population)
  FROM world
 GROUP BY continent
HAVING SUM(population)>500000000

--For each continent show the continent and number of countries with populations of at least 10 million.
select continent, count(name)
from world
where population > 10000000
group by continent

--DOESN'T WORK
--select continent, sum(population)
from world
group by continent
having population > 100000000
