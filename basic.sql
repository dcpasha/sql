-- Checking a list The word IN allows us to check if an item is in a list. The example shows the name and population for the countries:
SELECT name, population FROM world
  WHERE name IN ('Brazil', 'Russia', 'India', 'China');

-- BETWEEN allows range checking (range specified is inclusive of boundary values). 
SELECT name, area FROM world
  WHERE area BETWEEN 200000 AND 250000

------------------------------------------------------------------------------------------------
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
------------------------------------------------------------------------------------------------
-- Nested Statements


------------------------------------------------------------------------------------------------
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

--List the continents that have a total population of at least 100 million.
select continent--, sum(population)
from world
group by continent
having sum(population) > 100000000





------------------------------------------------------------------------------------------------
--The JOIN operation
SELECT *
  FROM game JOIN goal ON (id=matchid) -- to be more specific ON (game.id=goal.matchid)

--Show the player, teamid, stadium and mdate for every German goal.
SELECT player, teamid, stadium, mdate
  FROM game JOIN goal ON (id=matchid)
  WHERE teamid = 'GER'
  
--List the player for every goal scored in a game where the stadium was 'National Stadium, Warsaw'
SELECT player
FROM goal JOIN game ON (game.id = goal.matchid)
WHERE stadium =  'National Stadium, Warsaw'

--Show the name of all players who scored a goal against Germany.
SELECT DISTINCT(player) --DISTINCT to stop players being listed twice.
  FROM game JOIN goal ON matchid = id 
    WHERE (team1='GER' or team2='GER') 
    and (teamid != 'GER') --teamid!='GER' to prevent listing German players.
    
 --Show teamname and the total number of goals scored.
SELECT teamname, COUNT(player)
  FROM eteam JOIN goal ON id=teamid
 GROUP BY teamname
 ORDER BY teamname

--Show the stadium and the number of goals scored in each stadium.
SELECT stadium, count(player)
FROM game JOIN goal ON matchid=id
GROUP BY stadium

--For every match involving 'POL', show the matchid, date and the number of goals scored.
SELECT matchid, mdate, count(teamid)
  FROM game JOIN goal ON matchid = id 
 WHERE (team1 = 'POL' OR team2 = 'POL')
GROUP BY matchid, mdate

--For every match where 'GER' scored, show matchid, match date and the number of goals scored by 'GER'
SELECT matchid, mdate, count(player)
FROM goal JOIN game ON (id=matchid)
WHERE teamid = 'GER'
GROUP BY matchid, mdate

--"CASE WHEN"
--List every match with the goals scored by each team
--Notice in the query given every goal is listed. If it was a team1 goal then a 1 appears in score1, otherwise there is a 0. 
--You could SUM this column to get a count of the goals scored by team1. Sort your result by mdate, matchid, team1 and team2.
SELECT  mdate,
  team1,
  SUM(CASE WHEN teamid=team1 THEN 1 ELSE 0 END) as score1, 
  team2,
  SUM(CASE WHEN teamid=team2 THEN 1 ELSE 0 END) as score2
  FROM game JOIN goal ON matchid = id
 GROUP BY mdate, matchid, team1, team2
 ORDER BY mdate, matchid, team1, team2

--Cast list for Casablanca
SELECT name
FROM casting JOIN  movie ON id=movieid 
JOIN actor ON actorid = actor.id
where  title = 'Casablanca' 
