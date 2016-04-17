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
print("Medal...")
query_medal = "INSERT INTO `medal` (`code`, `name`) VALUES (%s, %s)"

data = ('G', 'Gold')
cursor.execute(query_medal, data)

data = ('S', 'Silver')
cursor.execute(query_medal, data)

data = ('B', 'Bronze')
cursor.execute(query_medal, data)



# Table `gender`
print("Gender...")
query_gender = "INSERT INTO `gender` (`code`, `name`) VALUES (%s, %s)"

data = ('M', 'Men')
cursor.execute(query_gender, data)

data = ('W', 'Women')
cursor.execute(query_gender, data)

data = ('X', 'Mixed')
cursor.execute(query_gender, data)



# Table `country` et création d'une table d'association
# IOC : `IOC_country_codes` -> {`name`, `iso`}
print("Country...")
query_country = "INSERT INTO `country` (`NOC`, `name`, `ISO_code`) VALUES (%s, %s, %s)"

IOC = dict()
for row in IOC_country_codes:
    IOC[row[1]] = {'name': row[0], 'iso': row[2]}
    data = (row[1], row[0], row[2])
    cursor.execute(query_country, data)



# Table `sport`
print("Sport...")

query_select_sport = "SELECT DISTINCT `sport` FROM `medallist`"
cursor_flat.execute(query_select_sport)
sport = cursor_flat.fetchall()
query_sport = "INSERT INTO `sport` (`name`) VALUES (%s)"

for data in sport:
    cursor.execute(query_sport, [data[0]])



# Table `discipline`
print("Discipline...")

query_select_discipline = "SELECT DISTINCT `discipline`, `sport` FROM `medallist`"
cursor_flat.execute(query_select_discipline)
discipline = cursor_flat.fetchall()
query_discipline = "INSERT INTO `discipline` (`name`, `id_sport`) VALUES (%s, (SELECT `id` FROM `sport` WHERE `name` = %s))"

for data in discipline:
    cursor.execute(query_discipline, (data[0],data[1]))



# Table `event`
print("Event...")

query_select_event = "SELECT DISTINCT `event`, `discipline` FROM `medallist`"
cursor_flat.execute(query_select_event)
event = cursor_flat.fetchall()
query_event = "INSERT INTO `event` (`name`, `id_discipline`) VALUES (%s, (SELECT `id` FROM `discipline` WHERE `name` = %s))"

for data in event:
    cursor.execute(query_event, (data[0],data[1]))



# Table athlete
print("Athlete...")

query_select_athlete = "SELECT DISTINCT `athlete`, `gender`, `NOC` FROM `medallist`"
cursor_flat.execute(query_select_athlete)
athlete = cursor_flat.fetchall()
query_athlete = "INSERT INTO `athlete` (`name`, `first_name`, `code_gender`, `NOC`) VALUES (%s, %s, (SELECT `code` FROM `gender` WHERE `name` = %s), %s)"

for data in athlete:
    st = data[0].split(", ", 1)
    name = st[0]
    if len(st) == 2:
        first_name = st[1]
    else :
        first_name = "N-C"
    cursor.execute(query_athlete, (name, first_name, data[1], data[2]))



# Table city
print("City...")

query_select_city = "SELECT DISTINCT `city` FROM `medallist`"
cursor_flat.execute(query_select_city)
city = cursor_flat.fetchall()
query_city = "INSERT INTO `city` (`name`) VALUES (%s)"

for data in city:
    cursor.execute(query_city, [data[0]])



# Table `edition`
print("Edition...")

query_select_edition = "SELECT DISTINCT `edition`, `city` FROM `medallist`"
cursor_flat.execute(query_select_edition)
edition = cursor_flat.fetchall()
query_edition = "INSERT INTO `edition` (`year`, `id_city`) VALUES (%s, (SELECT `id` FROM `city` WHERE `name` = %s))"

for data in edition:
    cursor.execute(query_edition, (data[0],data[1]))



# Table `medallist`
print("Medallist...")

query_select_medallist = "SELECT DISTINCT `edition`, `event`, `discipline`, `event_gender`, `athlete`, `NOC`, `medal` FROM `medallist`"
cursor_flat.execute(query_select_medallist)
medallist = cursor_flat.fetchall()

query_medallist = "INSERT INTO `medallist` (`edition`, `id_event`, `code_gender`, `id_athlete`, `code_medal`) \
                   VALUES (%s,\
                           (SELECT `id` FROM `event` WHERE `name` = %s AND `id_discipline` = (SELECT `id` FROM `discipline` WHERE `name` = %s)),\
                           %s,\
                           (SELECT `id` FROM `athlete` WHERE `name` = %s AND `first_name` = %s AND `NOC` = %s),\
                           (SELECT `code` FROM `medal` WHERE `name` = %s))"

for data in medallist:
    st = data[4].split(", ", 1)
    name = st[0]
    if len(st) == 2:
        first_name = st[1]
    else :
        first_name = "N-C"
    cursor.execute(query_medallist, (data[0], data[1], data[2], data[3], name, first_name, data[5], data[6]))

db.commit()

print("Successfully imported !")
