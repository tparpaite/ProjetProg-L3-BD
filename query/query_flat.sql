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
ORDER BY moyenne DESC;
