-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema test
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `test` ;

-- -----------------------------------------------------
-- Schema test
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `test` DEFAULT CHARACTER SET utf8 ;
USE `test` ;

-- -----------------------------------------------------
-- Table `test`.`genre`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `test`.`genre` ;

CREATE TABLE IF NOT EXISTS `test`.`genre` (
  `genre_id` SMALLINT(5) UNSIGNED NOT NULL AUTO_INCREMENT,
  `genre` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`genre_id`),
  INDEX `genre_idx` (`genre` ASC))
ENGINE = InnoDB
AUTO_INCREMENT = 39
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `test`.`artist`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `test`.`artist` ;

CREATE TABLE IF NOT EXISTS `test`.`artist` (
  `artist_id` SMALLINT(5) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `genre_id` SMALLINT(5) UNSIGNED NULL DEFAULT NULL,
  `playcount` INT(11) UNSIGNED NULL DEFAULT NULL,
  `listeners` INT(11) UNSIGNED NULL DEFAULT NULL,
  PRIMARY KEY (`artist_id`),
  INDEX `fk_artist_genre_idx` (`genre_id` ASC),
  INDEX `listeners_idx` (`listeners` ASC),
  CONSTRAINT `fk_artist_genre`
    FOREIGN KEY (`genre_id`)
    REFERENCES `test`.`genre` (`genre_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 3549
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `test`.`album`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `test`.`album` ;

CREATE TABLE IF NOT EXISTS `test`.`album` (
  `album_id` SMALLINT(5) UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(250) NOT NULL,
  `artist_id` SMALLINT(5) UNSIGNED NOT NULL,
  `release_year` YEAR(4) NULL DEFAULT NULL,
  `num_of_tracks` TINYINT(5) UNSIGNED NULL DEFAULT NULL,
  PRIMARY KEY (`album_id`),
  INDEX `fk_artist_album_idx` (`artist_id` ASC),
  INDEX `album_release_year_idx` (`release_year` ASC),
  CONSTRAINT `fk_artist_album`
    FOREIGN KEY (`artist_id`)
    REFERENCES `test`.`artist` (`artist_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 42234
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `test`.`track`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `test`.`track` ;

CREATE TABLE IF NOT EXISTS `test`.`track` (
  `track_id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(250) NOT NULL,
  `artist_id` SMALLINT(5) UNSIGNED NOT NULL,
  `duration` SMALLINT(5) UNSIGNED NULL DEFAULT NULL,
  `listeners` INT(11) UNSIGNED NULL DEFAULT NULL,
  `lyrics` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`track_id`),
  INDEX `fk_track_artist_idx` (`artist_id` ASC),
  CONSTRAINT `fk_track_artist`
    FOREIGN KEY (`artist_id`)
    REFERENCES `test`.`artist` (`artist_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 24319
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `test`.`album_tracks`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `test`.`album_tracks` ;

CREATE TABLE IF NOT EXISTS `test`.`album_tracks` (
  `album_id` SMALLINT(5) UNSIGNED NOT NULL,
  `track_id` INT(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`album_id`, `track_id`),
  INDEX `fk_track_idx` (`track_id` ASC),
  CONSTRAINT `fk_album`
    FOREIGN KEY (`album_id`)
    REFERENCES `test`.`album` (`album_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_track`
    FOREIGN KEY (`track_id`)
    REFERENCES `test`.`track` (`track_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `test`.`country`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `test`.`country` ;

CREATE TABLE IF NOT EXISTS `test`.`country` (
  `country_id` SMALLINT(5) UNSIGNED NOT NULL AUTO_INCREMENT,
  `country` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`country_id`),
  UNIQUE INDEX `country_UNIQUE` (`country` ASC),
  INDEX `country_idx` (`country` ASC))
ENGINE = InnoDB
AUTO_INCREMENT = 134
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `test`.`city`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `test`.`city` ;

CREATE TABLE IF NOT EXISTS `test`.`city` (
  `city_id` SMALLINT(5) UNSIGNED NOT NULL AUTO_INCREMENT,
  `city` VARCHAR(45) NOT NULL,
  `country_id` SMALLINT(5) UNSIGNED NOT NULL,
  PRIMARY KEY (`city_id`),
  INDEX `fk_city_country_idx` (`country_id` ASC),
  INDEX `city_idx` (`city` ASC),
  CONSTRAINT `fk_city_country`
    FOREIGN KEY (`country_id`)
    REFERENCES `test`.`country` (`country_id`)
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 4243
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `test`.`event`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `test`.`event` ;

CREATE TABLE IF NOT EXISTS `test`.`event` (
  `event_id` SMALLINT(5) UNSIGNED NOT NULL AUTO_INCREMENT,
  `artist_id` SMALLINT(5) UNSIGNED NOT NULL,
  `description` TEXT NULL DEFAULT NULL,
  `sale_date` DATE NULL DEFAULT NULL,
  `date` DATE NOT NULL,
  `venue` VARCHAR(150) NOT NULL,
  `city_id` SMALLINT(5) UNSIGNED NOT NULL,
  `country_id` SMALLINT(5) UNSIGNED NOT NULL,
  PRIMARY KEY (`event_id`),
  INDEX `fk_event_artist_idx` (`artist_id` ASC),
  INDEX `fk_event_city_idx` (`city_id` ASC),
  INDEX `fk_event_country_idx` (`country_id` ASC),
  INDEX `event_date_idx` (`date` ASC),
  CONSTRAINT `fk_event_artist`
    FOREIGN KEY (`artist_id`)
    REFERENCES `test`.`artist` (`artist_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_event_city`
    FOREIGN KEY (`city_id`)
    REFERENCES `test`.`city` (`city_id`)
    ON UPDATE CASCADE,
  CONSTRAINT `fk_event_country`
    FOREIGN KEY (`country_id`)
    REFERENCES `test`.`country` (`country_id`)
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 7488
DEFAULT CHARACTER SET = utf8;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
