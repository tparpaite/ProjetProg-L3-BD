RESET QUERY CACHE;
FLUSH TABLES;

SELECT COUNT(*) as "nombre total de médailles"
FROM medallist;

SELECT gender.name, count(code_medal) as "nombre de médailles par sexe"
FROM medallist
JOIN athlete ON id_athlete = athlete.id
JOIN gender ON athlete.code_gender = gender.code
GROUP BY(athlete.code_gender);

SELECT gender.name, count(code_medal) as "nombre de médailles d'or par sexe"
FROM medallist
JOIN medal ON code_medal = medal.code
JOIN athlete ON id_athlete = athlete.id
JOIN gender ON athlete.code_gender = gender.code
WHERE medal.name = "Gold"
GROUP BY(athlete.code_gender);


SELECT "Nombre de médailles par pays par édtion" as "";

SELECT country.NOC, country.name, edition, count(DISTINCT id_event, code_medal, medallist.code_gender) as nb_medal
FROM medallist
JOIN athlete ON id_athlete = athlete.id
JOIN country ON athlete.NOC = country.NOC
GROUP BY country.NOC, edition
ORDER BY nb_medal DESC
LIMIT 0, 30;


SELECT "Moyenne de médailles d'or par pays par édtion" as "";

SELECT tmp.name, avg(nb_medal) as moyenne
FROM (
  SELECT country.NOC, country.name, edition, count(DISTINCT id_event, code_medal, medallist.code_gender) as nb_medal
  FROM medallist
  JOIN athlete ON id_athlete = athlete.id
  JOIN country ON athlete.NOC = country.NOC
  JOIN medal ON code_medal = medal.code
  WHERE medal.name = "Gold"
  GROUP BY country.NOC, edition) as tmp
GROUP BY tmp.NOC
ORDER BY moyenne DESC, tmp.name;

SELECT city.name,edition.year
FROM city
JOIN edition ON id_city = id
ORDER BY edition.year;

SELECT "Event des JO de 2004" as "";
SELECT sport.name, discipline.name, event.name
FROM event
JOIN discipline ON id_discipline = discipline.id
JOIN sport ON id_sport = sport.id
WHERE event.id IN (
  SELECT DISTINCT id_event
  FROM medallist
  WHERE edition = 2004)
ORDER BY sport.name, discipline.name, event.name;


/* La liste des évenements dans la catégorie natation */
SELECT event.name
FROM event
JOIN discipline ON id_discipline = discipline.id
JOIN sport ON id_sport = sport.id
WHERE sport.name =  "Aquatics"
LIMIT 0 , 30


/* Les athlètes français les plus médaillés */
SELECT athlete.name, athlete.first_name, count(athlete.id) as "Nombre de médailles"
FROM medallist
JOIN athlete ON id_athlete = athlete.id
JOIN country ON athlete.NOC = country.NOC
WHERE country.name = "France"
GROUP BY athlete.name, athlete.first_name
ORDER BY "Nombre de médailles" DESC;


/* Les meilleurs nageurs de l'histoire des JO */
SELECT athlete.name, athlete.first_name, count(athlete.id) as "Nombre de médailles"
FROM medallist
JOIN athlete ON id_athlete = athlete.id
JOIN event ON id_event = event.id
JOIN discipline ON id_discipline = discipline.id
JOIN sport ON id_sport = sport.id
WHERE sport.name = "Aquatics"
GROUP BY athlete.name, athlete.first_name
ORDER BY "Nombre de médailles" DESC


SELECT country.name, count(id) as nb_athlete
FROM athlete
JOIN country ON athlete.NOC = country.NOC
GROUP BY country.NOC
ORDER BY nb_athlete DESC;

/* Athlete avec plus de 10 medal */
SELECT athlete.name, athlete.first_name, gender.name as gender, country.name as country, count(id_athlete) as nb_medal
FROM medallist
JOIN athlete ON id_athlete = athlete.id
JOIN country ON athlete.NOC = country.NOC
JOIN gender  ON athlete.code_gender = gender.code
GROUP BY id_athlete
HAVING nb_medal > 10
ORDER BY nb_medal DESC, athlete.name, athlete.first_name;

/* Prenom le plus courant des Athlete */

SELECT first_name, count(first_name) as nb
FROM athlete
WHERE first_name <> "N-C"
AND first_name NOT LIKE "_."
GROUP BY first_name
HAVING nb > 20
ORDER BY nb DESC, first_name;

