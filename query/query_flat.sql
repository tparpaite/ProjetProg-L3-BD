RESET QUERY CACHE;
FLUSH TABLES;

SELECT COUNT(*) as "nombre total de médailles"
FROM medallist;

SELECT gender, count(medal) as "nombre de médailles par sexe"
FROM medallist
GROUP BY(gender);

SELECT gender, count(medal) as "nombre de médailles d'or par sexe"
FROM medallist
WHERE medal = "Gold"
GROUP BY(gender);

SELECT "Nombre de médailles par pays par édtion" as "";

SELECT NOC, country, edition, count(DISTINCT event, discipline, medal, event_gender) as nb_medal
FROM medallist
GROUP BY NOC, edition
ORDER BY nb_medal DESC
LIMIT 0, 30;



SELECT "Moyenne de médailles d'or par pays par édtion" as "";
SELECT tmp.country, avg(nb_medal) as moyenne
FROM (
  SELECT NOC, country, edition, count(DISTINCT event, discipline, medal, event_gender) as nb_medal
  FROM medallist
  WHERE medal = "Gold"
  GROUP BY NOC, edition) as tmp
GROUP BY tmp.NOC
ORDER BY moyenne DESC, tmp.country;

SELECT DISTINCT city,edition
FROM medallist
ORDER BY edition;

SELECT "Event des JO de 2004" as "";
SELECT DISTINCT sport, discipline, event
FROM medallist
WHERE edition = 2004
ORDER BY sport, discipline, event;


/* La liste des évenements dans la catégorie natation */
SELECT DISTINCT event
FROM medallist
WHERE sport =  "Aquatics"
LIMIT 0 , 30


/* Les athlètes français les plus médaillés */
SELECT athlete, count(medal) as "Nombre de médailles"
FROM medallist
WHERE country = "France"
GROUP BY (athlete)
ORDER BY "Nombre de médailles" DESC;


/* Les meilleurs nageurs de l'histoire des JO */
SELECT athlete, count(medal) as "Nombre de médailles"
FROM medallist
WHERE sport = "Aquatics"
GROUP BY (athlete)
ORDER BY "Nombre de médailles" DESC

SELECT country, count(DISTINCT athlete) as nb_athlete
FROM medallist
GROUP BY NOC
ORDER BY nb_athlete DESC;

/* Athlete avec plus de 10 medal */
SELECT athlete, gender, country, count(athlete) as nb_medal
FROM medallist
GROUP BY athlete
HAVING nb_medal > 10
ORDER BY nb_medal DESC, athlete;



SELECT IF(
    LOCATE(', ', athlete) > 0,
    SUBSTRING_INDEX(athlete, ', ', -1),
    NULL
    ) as first_name
FROM (
    SELECT DISTINCT athlete
    FROM medallist
    ) as t
HAVING first_name NOT LIKE "_."
AND <> ""


SELECT IF(
    LOCATE(', ', tmp.athlete) > 0,
    SUBSTRING_INDEX(tmp.athlete, ', ', -1),
    NULL
    ) as first_name
FROM (
    SELECT DISTINCT athlete
    FROM medallist
  ) as tmp;



SELECT first_name, count(first_name) as nb
FROM (
  SELECT IF(
      LOCATE(', ', athlete) > 0,
      SUBSTRING_INDEX(athlete, ', ', -1),
      NULL
      ) as first_name
  FROM (
      SELECT DISTINCT athlete, NOC
      FROM medallist
      ) as athlete
) as t
WHERE first_name IS NOT NULL
AND first_name NOT LIKE "_."
GROUP BY first_name
HAVING nb > 20
ORDER BY nb DESC, first_name;



SELECT SUBSTRING_INDEX(athlete, ', ', -1) as first_name, count(athlete) as nb
FROM medallist
WHERE first_name <> ""
AND first_name NOT LIKE "_."
GROUP BY first_name
HAVING nb > 20
ORDER BY nb DESC, first_name;

