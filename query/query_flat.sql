RESET QUERY CACHE;
FLUSH TABLES;

/* Les prénoms les plus courants */
SELECT first_name, count(first_name) AS nb
FROM (
  SELECT IF(
      LOCATE(', ', athlete) > 0,
      SUBSTRING_INDEX(athlete, ', ', -1),
      NULL
      ) AS first_name
  FROM (
      SELECT DISTINCT athlete, NOC
      FROM medallist
      ) AS athlete
) AS t
WHERE first_name IS NOT NULL
AND first_name NOT LIKE "_."
GROUP BY first_name
HAVING nb > 20
ORDER BY nb DESC, first_name;


/* Liste des épreuves des JO de 2004 */
SELECT DISTINCT sport, discipline, event
FROM medallist
WHERE edition = 2004
ORDER BY sport, discipline, event;

/* Nombre de médaille par pays par édition */
SELECT NOC, country, edition, count(DISTINCT event, discipline, medal, event_gender) AS nb_medal
FROM medallist
GROUP BY NOC, edition
ORDER BY nb_medal DESC;


/* Liste des villes ayant accueillant les JO */
SELECT DISTINCT city,edition
FROM medallist
ORDER BY edition;


/* Nombre de médailles d'or par sexe */
SELECT gender, count(medal) AS "Nombre de médailles d'or par sexe"
FROM medallist
WHERE medal = "Gold"
GROUP BY(gender);


/* Moyenne de médaille obtenue par édition pour chaque pays */
SELECT tmp.country, avg(nb_medal) AS moyenne
FROM (
  SELECT NOC, country, edition, count(DISTINCT event, discipline, medal, event_gender) AS nb_medal
  FROM medallist
  WHERE medal = "Gold"
  GROUP BY NOC, edition) AS tmp
GROUP BY tmp.NOC
ORDER BY moyenne DESC, tmp.country;


/* Nombre d’athlètes par pays */
SELECT country, count(DISTINCT athlete) AS nb_athlete
FROM medallist
GROUP BY NOC
ORDER BY nb_athlete DESC;

/* La liste des événements pour le sport natation */
SELECT DISTINCT event
FROM medallist
WHERE sport =  "Aquatics"
LIMIT 0 , 30

/* Les athlètes français les plus médaillés */
SELECT athlete, count(medal) AS nb_medals
FROM medallist
WHERE country = "France"
GROUP BY (athlete)
ORDER BY nb_medals DESC;


/* Les meilleurs nageurs de l'histoire des JO */
SELECT athlete, count(medal) AS nb_medals
FROM medallist
WHERE sport = "Aquatics"
GROUP BY (athlete)
ORDER BY nb_medals DESC;
