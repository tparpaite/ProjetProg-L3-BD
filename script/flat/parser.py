#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Projet de base de données
# Université de Bordeaux (licence 3)
# PARPAITE Thibault
# SARRABAYROUSE Alexis
# 11 avril 2016
#
# Script permettant de remplir la BD à plat

import csv
import MySQLdb



# Connexion à la BD
db = MySQLdb.connect(host="localhost", user="root", passwd="root", db="SummerOlympicGames_Flat")
# Connexion à la BD au cremi (à supprimer, utilisé pour les tests)
#db = MySQLdb.connect(host="dbserver", user="thparpai", passwd="beyblade33", db="thparpai")
cursor = db.cursor()



# Ouverture des fichiers csv et création d'un reader
all_medalists     = csv.reader(open("../../csv/all_medalists.csv"))
IOC_country_codes = csv.reader(open("../../csv/IOC_country_codes.csv"))



# On passe la première ligne qui contient le nom des attributs
all_medalists.next()
IOC_country_codes.next()



# On créé une table d'association : un `IOC_country_codes` est associé à un `name` et `iso`
IOC = dict()
for row in IOC_country_codes:
    IOC[row[1]] = {'name': row[0], 'iso': row[2]}


    
# On créé une requête et on remplit la BD    
query = "INSERT INTO `medallist` (`city`, `edition`, `sport`, `discipline`, `athlete`, `NOC`, `country`, `ISO_code`, `gender`, `event`, `event_gender`, `medal`) \
         VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"

for row in all_medalists:
    data = (row[0], row[1], row[2], row[3], row[4], row[5], IOC[row[5]]['name'], IOC[row[5]]['iso'], row[6], row[7], row[8], row[9])
    try:
        cursor.execute(query, data)
    except Exception as e:
        print(e)
        print(data);
        
db.commit()
