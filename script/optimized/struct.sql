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
