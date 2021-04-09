-- Checking a list The word IN allows us to check if an item is in a list. The example shows the name and population for the countries:
SELECT name, population FROM world
  WHERE name IN ('Brazil', 'Russia', 'India', 'China');

-- BETWEEN allows range checking (range specified is inclusive of boundary values). 
SELECT name, area FROM world
  WHERE area BETWEEN 200000 AND 250000

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
SELECT name
  FROM world
 WHERE capital LIKE concat(name, ' City')
 
--Find the capital and the name where the capital includes the name of the country.
--	capital             name
-- Andorra la Vella   	Andorra
select capital, name
from world
where capital like '%'+name+'%'

--Find the capital and the name where the capital is an extension of name of the country.
--You should include Mexico City as it is longer than Mexico. You should not include Luxembourg as the capital is the same as the country.
select capital, name
from world
where capital like name+'%' and len(capital) > len(name)


--Show the name and the extension where the capital is an extension of name of the country.
--For Monaco-Ville the name is Monaco and the extension is -Ville.
--REPLACE(f, s1, s2) returns the string f with all occurances of s1 replaced with s2.
select name, replace(capital, name, '') as 'extension'
from world
where capital like name+'%' and len(capital) > len(name)
