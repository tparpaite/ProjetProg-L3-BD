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
