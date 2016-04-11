DROP DATABASE IF EXISTS `SummerOlympicGames_Flat`;
CREATE DATABASE `SummerOlympicGames_Flat`;

USE `SummerOlympicGames_Flat`;

CREATE TABLE `medallist` (
  `city` varchar(30),
  `edition` year,
  `sport` varchar(30),
  `discipline` varchar(30),
  `athlete` varchar(60),
  `NOC` char(3),
  `country` varchar(60),
  `ISO_code` char(2),
  `gender` varchar(5),
  `event` varchar(60),
  `event_gender` char(1),
  `medal` varchar(6)
);
