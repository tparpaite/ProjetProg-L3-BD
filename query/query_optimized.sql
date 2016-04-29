RESET QUERY CACHE;
FLUSH TABLES;


/* Les prénoms les plus courants */
SELECT first_name, count(first_name) AS nb
FROM athlete
WHERE first_name <> "N-C"
AND first_name NOT LIKE "_."
GROUP BY first_name
HAVING nb > 20
ORDER BY nb DESC, first_name;


/* Liste des épreuves des JO de 2004 */
SELECT sport.name, discipline.name, event.name
FROM event
JOIN discipline ON id_discipline = discipline.id
JOIN sport ON id_sport = sport.id
WHERE event.id IN (
  SELECT DISTINCT id_event
  FROM medallist
  WHERE edition = 2004)
ORDER BY sport.name, discipline.name, event.name;

/* Nombre de médaille par pays par édition */
SELECT country.NOC, country.name, edition, count(DISTINCT id_event, code_medal, medallist.code_gender) AS nb_medal
FROM medallist
JOIN athlete ON id_athlete = athlete.id
JOIN country ON athlete.NOC = country.NOC
GROUP BY country.NOC, edition
ORDER BY nb_medal DESC;


/* Liste des villes ayant accueillant les JO */
SELECT city.name,edition.year
FROM city
JOIN edition ON id_city = id
ORDER BY edition.year;



/* Nombre de médailles d'or par sexe */
SELECT gender.name, count(code_medal) AS "Nombre de médailles d'or par sexe"
FROM medallist
JOIN medal ON code_medal = medal.code
JOIN athlete ON id_athlete = athlete.id
JOIN gender ON athlete.code_gender = gender.code
WHERE medal.name = "Gold"
GROUP BY(athlete.code_gender);


/* Moyenne de médaille obtenue par édition pour chaque pays */
SELECT tmp.name, avg(nb_medal) AS moyenne
FROM (
  SELECT country.NOC, country.name, edition, count(DISTINCT id_event, code_medal, medallist.code_gender) AS nb_medal
  FROM medallist
  JOIN athlete ON id_athlete = athlete.id
  JOIN country ON athlete.NOC = country.NOC
  JOIN medal ON code_medal = medal.code
  WHERE medal.name = "Gold"
  GROUP BY country.NOC, edition) AS tmp
GROUP BY tmp.NOC
ORDER BY moyenne DESC, tmp.name;


/* Nombre d’athlètes par pays */
SELECT country.name, count(id) AS nb_athlete
FROM athlete
JOIN country ON athlete.NOC = country.NOC
GROUP BY country.NOC
ORDER BY nb_athlete DESC;


/* La liste des événements pour le sport natation */
SELECT event.name
FROM event
JOIN discipline ON id_discipline = discipline.id
JOIN sport ON id_sport = sport.id
WHERE sport.name =  "Aquatics"
LIMIT 0 , 30


/* Les athlètes français les plus médaillés */
SELECT athlete.name, athlete.first_name, count(athlete.id) AS "Nombre de médailles"
FROM medallist
JOIN athlete ON id_athlete = athlete.id
JOIN country ON athlete.NOC = country.NOC
WHERE country.name = "France"
GROUP BY athlete.name, athlete.first_name
ORDER BY "Nombre de médailles" DESC;


/* Les meilleurs nageurs de l'histoire des JO */
SELECT athlete.name, athlete.first_name, count(athlete.id) AS "Nombre de médailles"
FROM medallist
JOIN athlete ON id_athlete = athlete.id
JOIN event ON id_event = event.id
JOIN discipline ON id_discipline = discipline.id
JOIN sport ON id_sport = sport.id
WHERE sport.name = "Aquatics"
GROUP BY athlete.name, athlete.first_name
ORDER BY "Nombre de médailles" DESC;
