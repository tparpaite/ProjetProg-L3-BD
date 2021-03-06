/* Projet de base de données
 * Université de Bordeaux (licence 3)
 * PARPAITE Thibault
 * SARRABAYROUSE Alexis
 * 11 avril 2016
 *
 * Code SQL permettant de créer une BD à plat
 */

DROP DATABASE IF EXISTS `SummerOlympicGames_Flat`;
CREATE DATABASE `SummerOlympicGames_Flat` CHARACTER SET `utf8`;

USE `SummerOlympicGames_Flat`;

/* USE `thparpai`; */

CREATE TABLE `medallist` (
  `city` varchar(30),
  `edition` SMALLINT,
  `sport` varchar(30),
  `discipline` varchar(30),
  `athlete` varchar(60),
  `NOC` char(3),
  `country` varchar(100),
  `ISO_code` char(2),
  `gender` varchar(5),
  `event` varchar(60),
  `event_gender` char(1),
  `medal` varchar(6)
)ENGINE=InnoDB;
