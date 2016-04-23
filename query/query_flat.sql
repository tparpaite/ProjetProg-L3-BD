SELECT COUNT(*) as "nombre total de médailles"
FROM medallist;

SELECT gender, count(medal) as "nombre de médailles par sexe"
FROM medallist
GROUP BY(gender);

SELECT gender, count(medal) as "nombre de médailles d'or par sexe"
FROM medallist
WHERE medal = "Gold"
GROUP BY(gender);
