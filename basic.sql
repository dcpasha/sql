# Checking a list The word IN allows us to check if an item is in a list. The example shows the name and population for the countries:
SELECT name, population FROM world
  WHERE name IN ('Brazil', 'Russia', 'India', 'China');

# BETWEEN allows range checking (range specified is inclusive of boundary values). 
SELECT name, area FROM world
  WHERE area BETWEEN 200000 AND 250000

# Pattern Matching Queries
# LIKE operator to check names. The % is a wild-card it can match any characters
SELECT name FROM world
  WHERE name LIKE '%x%'

# A name that has three letters a. ex: 'Bahama'
SELECT name FROM world
  WHERE name LIKE '%a%a%a%'

# '_%' You can use the underscore as a single character wildcard.
# India and Angola have an n as the second character. 
SELECT name FROM world
 WHERE name LIKE '_n%'
ORDER BY name

# Find the countries that have two "o" characters separated by two others.
SELECT name FROM world  
 WHERE name LIKE '%o__o%'
