/* Projet de base de données
 * Université de Bordeaux (licence 3)
 * PARPAITE Thibault
 * SARRABAYROUSE Alexis
 * 11 avril 2016
 *
 * Code SQL permettant de créer une BD optimisée
 */

DROP DATABASE IF EXISTS `SummerOlympicGames_Optimized`;
CREATE DATABASE `SummerOlympicGames_Optimized` CHARACTER SET `utf8`;

USE `SummerOlympicGames_Optimized`;

/* USE `thparpai`; */

CREATE TABLE `sport`(
  `id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `name` varchar(11)
)ENGINE=InnoDB;



CREATE TABLE `discipline`(
  `id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `name` varchar(30),
  `id_sport` int(11),
  CONSTRAINT `FK_discipline_sport` FOREIGN KEY (`id_sport`) REFERENCES `sport`(`id`)
)ENGINE=InnoDB;



CREATE TABLE `event_gender`(
  `code` char(1) NOT NULL PRIMARY KEY,
  `name` varchar(20)
)ENGINE=InnoDB;



CREATE TABLE `event`(
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code_gender` char(1) NOT NULL,
  `name` varchar(60),
  `id_discipline` int(11),
  CONSTRAINT `FK_event_discipline` FOREIGN KEY (`id_discipline`) REFERENCES `discipline`(`id`),
  CONSTRAINT `FK_event_gender`     FOREIGN KEY (`code_gender`)   REFERENCES `event_gender`(`code`),
  PRIMARY KEY(`id`, `code_gender`)
)ENGINE=InnoDB;



CREATE TABLE `medal`(
  `code` char(1) NOT NULL PRIMARY KEY,
  `name` varchar(30)
)ENGINE=InnoDB;



CREATE TABLE `country` (
       `NOC` char (3) NOT NULL PRIMARY KEY,
       `name` varchar(100),
       `ISO_code` char(2)
)ENGINE=InnoDB;



CREATE TABLE `athlete` (
       `id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
       `name` varchar(60),
       `first_name` varchar(60),
       `gender` varchar(5),
       `NOC` char(3),
       CONSTRAINT `FK_athlete_country` FOREIGN KEY (`NOC`) REFERENCES `country`(`NOC`)
)ENGINE=InnoDB;



CREATE TABLE `city` (
       `id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
       `name` varchar(60)
)ENGINE=InnoDB;



CREATE TABLE `edition` (
       `year` SMALLINT NOT NULL PRIMARY KEY,
       `id_city` int(11),
       CONSTRAINT `FK_edition_city` FOREIGN KEY (`id_city`) REFERENCES `city`(`id`)
)ENGINE=InnoDB;



CREATE TABLE `medallist` (
       `edition` SMALLINT NOT NULL,
       `id_event` int(11) NOT NULL,
       `code_gender` char(1) NOT NULL,
       `id_athlete` int(11) NOT NULL,
       `code_medal` char(1),
       CONSTRAINT `FK_medallist_edition` FOREIGN KEY (`edition`)    REFERENCES `edition`(`year`),
       CONSTRAINT `FK_medallist_medal`   FOREIGN KEY (`code_medal`) REFERENCES `medal`(`code`),
       CONSTRAINT `FK_medallist_athlete` FOREIGN KEY (`id_athlete`) REFERENCES `athlete`(`id`),
       CONSTRAINT `FK_medallist_event`   FOREIGN KEY (`id_event`, `code_gender`) REFERENCES `event`(`id`, `code_gender`),
       PRIMARY KEY (`edition`, `id_event`, `code_gender`, `id_athlete`)
)ENGINE=InnoDB;
