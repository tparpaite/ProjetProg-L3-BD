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
