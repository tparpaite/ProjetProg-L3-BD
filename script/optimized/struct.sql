DROP DATABASE IF EXISTS `SummerOlympicGames_Optimized`;
CREATE DATABASE `SummerOlympicGames_Optimized`;

USE `SummerOlympicGames_Optimized`;

CREATE TABLE `sport`(
  `id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `name` varchar(11)
);

CREATE TABLE `discipline`(
  `id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `name` varchar(30),
  `id_sport` int(11) REFERENCES `sport`(`id`)
);

CREATE TABLE `event_gender`(
  `code` char(1) NOT NULL PRIMARY KEY,
  `name` varchar(20)
);

CREATE TABLE `event`(
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(60),
  `code_gender` char(1) REFERENCES `event_gender`(`code`),
  PRIMARY KEY(`id`, `code_gender`)
);

CREATE TABLE `medal`(
  `code` char(1),
  `name` varchar(611)
);

CREATE TABLE `country` (
       `NOC` char (3),
       `name` varchar(60),
       `ISO_code` char(2)
);

CREATE TABLE `athlete` (
       `id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
       `name` varchar(60),
       `first_name` varchar(60),
       `gender` varchar(5),
       `NOC` char(3) REFERENCES country(NOC)
);

CREATE TABLE `city` (
       `id` int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
       `name` varchar(60)
);

CREATE TABLE `edition` (
       `year` year PRIMARY KEY,
       `id_city` int(11) REFERENCES city(id)
);

CREATE TABLE `medallist` (
       `edition` year REFERENCES edition(year),
       `id_event` int(11),
       `code_gender` char(1),
       `id_athlete` int(11) REFERENCES athlete(id),
       `code_medal` char(1) REFERENCES medal(code),
       CONSTRAINT `FK` FOREIGN KEY (`id_event`, `code_gender`) REFERENCES `event`(`id`, `code_gender`),
       PRIMARY KEY (`edition`, `id_event`, `code_gender`, `id_athlete`)
);
