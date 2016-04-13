#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Projet de base de données
# Université de Bordeaux (licence 3)
# PARPAITE Thibault
# SARRABAYROUSE Alexis
# 11 avril 2016
#
# Script permettant de remplir la BD optimisée

import csv
import MySQLdb



# Connexion à la BD
db = MySQLdb.connect(host="localhost", user="root", passwd="root", db="SummerOlympicGames_Optimized")
db_flat = MySQLdb.connect(host="localhost", user="root", passwd="root", db="SummerOlympicGames_Flat")
# Connexion à la BD au cremi (à supprimer, utilisé pour les tests)
#db = MySQLdb.connect(host="dbserver", user="thparpai", passwd="beyblade33", db="thparpai")
cursor = db.cursor()
cursor_flat = db_flat.cursor()



# Ouverture des fichiers csv et création d'un reader
all_medalists     = csv.reader(open("../../csv/all_medalists.csv"))
IOC_country_codes = csv.reader(open("../../csv/IOC_country_codes.csv"))



# On passe la première ligne qui contient le nom des attributs
all_medalists.next()
IOC_country_codes.next()



# Table `medal`
query_medal = "INSERT INTO `medal` (`code`, `name`) VALUES (%s, %s)"

data = ('G', 'Gold')
cursor.execute(query_medal, data)

data = ('S', 'Silver')
cursor.execute(query_medal, data)

data = ('B', 'Bronze')
cursor.execute(query_medal, data)



# Table `event_gender`
query_event_gender = "INSERT INTO `event_gender` (`code`, `name`) VALUES (%s, %s)"

data = ('M', 'Male')
cursor.execute(query_event_gender, data)

data = ('F', 'Female')
cursor.execute(query_event_gender, data)

data = ('X', 'Mixed')
cursor.execute(query_event_gender, data)



# Table `country` et création d'une table d'association
# IOC : `IOC_country_codes` -> {`name`, `iso`}
query_country = "INSERT INTO `country` (`NOC`, `name`, `ISO_code`) VALUES (%s, %s, %s)"

IOC = dict()
for row in IOC_country_codes:
    IOC[row[1]] = {'name': row[0], 'iso': row[2]}

    data = (row[1], row[0], row[2])
    try:
        cursor.execute(query_country, data)
    except Exception as e:
        print(e)
        print(data);

db.commit()


# On parcourt la mega database

# Table `sport`
query_select_sport = "SELECT DISTINCT `sport` FROM `medallist`"
cursor_flat.execute(query_select_sport)
sport = cursor_flat.fetchall()
query_sport = "INSERT INTO `sport` (`name`) VALUES (%s)"
for data in sport:
    print(data[0])
    cursor.execute(query_sport, data[0])
    print(cursor.lastrowid)
db.commit()

query_select_discipline = "SELECT DISTINCT `discipline`, `sport` FROM `medallist`"
cursor_flat.execute(query_select_discipline)
discipline = cursor_flat.fetchall()



# Table `discipline`
query_discipline = "INSERT INTO `discipline` (`name`, `id_sport`) VALUES (%s, (SELECT `id` FROM `sport` WHERE `name` = %s))"
for data in discipline:
    cursor.execute(query_discipline, (data[0],data[1]))
    print(data)
db.commit()

query_select_event = "SELECT DISTINCT `event`, `discipline` FROM `medallist`"
cursor_flat.execute(query_select_event)
event = cursor_flat.fetchall()



# Table `event`
query_event = "INSERT INTO `event` (`name`, `id_discipline`) VALUES (%s, (SELECT `id` FROM `discipline` WHERE `name` = %s))"
for data in event:
    cursor.execute(query_event, (data[0],data[1]))
    print(data)
db.commit()



query_athlete = "INSERT INTO `athlete` (`name`, `first_name`, `gender`, `NOC`) VALUES (%s, %s, %s, %s)"

query_city = "INSERT INTO `city` (`name`) VALUES (%s)"



# Table `edition`
query_select_edition = "SELECT DISTINCT `edition`, `city` FROM `medallist`"
cursor_flat.execute(query_select_edition)
edition = cursor_flat.fetchall()

query_edition = "INSERT INTO `edition` (`year`, `id_city`) VALUES (%s, SELECT `id` FROM `city` WHERE `name` = %s)"
for data in edition:
    cursor.execute(query_edition, (data[0],data[1]))
    print(data)
db.commit()



# Table `medallist`
query_select_medallist = "SELECT DISTINCT `edition`, `event`, `event_gender`, `athlete`, `medal` FROM `medallist`"
cursor_flat.execute(query_select_medallist)
medallist = cursor_flat.fetchall()

query_medallist = "INSERT INTO `medallist` (`edition`, `id_event`, `code_gender`, `id_athlete`, `code_medal`) \
                   VALUES (%s,
                           SELECT `id` FROM `event` WHERE `name` = %s,
                           %s,
                           SELECT `id` FROM `athlete` WHERE `name` = %s,
                           %s)"
for data in medallist:
    cursor.execute(query_medallist, (data[0], data[1], data[2], data[3], data[4]))
    print(data)
db.commit()
