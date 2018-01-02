-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema DbMysql11
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `DbMysql11` ;

-- -----------------------------------------------------
-- Schema DbMysql11
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `DbMysql11` DEFAULT CHARACTER SET utf8 ;
USE `DbMysql11` ;

-- -----------------------------------------------------
-- Table `DbMysql11`.`Genre`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DbMysql11`.`Genre` ;

CREATE TABLE IF NOT EXISTS `DbMysql11`.`Genre` (
  `genre_id` SMALLINT(5) UNSIGNED NOT NULL AUTO_INCREMENT,
  `genre` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`genre_id`),
  INDEX `genre_idx` (`genre` ASC))
ENGINE = InnoDB
AUTO_INCREMENT = 1
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `DbMysql11`.`Artist`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DbMysql11`.`Artist` ;

CREATE TABLE IF NOT EXISTS `DbMysql11`.`Artist` (
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
    REFERENCES `DbMysql11`.`Genre` (`genre_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 1
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `DbMysql11`.`Album`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DbMysql11`.`Album` ;

CREATE TABLE IF NOT EXISTS `DbMysql11`.`Album` (
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
    REFERENCES `DbMysql11`.`Artist` (`artist_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 1
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `DbMysql11`.`Track`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DbMysql11`.`Track` ;

CREATE TABLE IF NOT EXISTS `DbMysql11`.`Track` (
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
    REFERENCES `DbMysql11`.`Artist` (`artist_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 1
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `DbMysql11`.`AlbumTracks`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DbMysql11`.`AlbumTracks` ;

CREATE TABLE IF NOT EXISTS `DbMysql11`.`AlbumTracks` (
  `album_id` SMALLINT(5) UNSIGNED NOT NULL,
  `track_id` INT(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`album_id`, `track_id`),
  INDEX `fk_track_idx` (`track_id` ASC),
  CONSTRAINT `fk_album`
    FOREIGN KEY (`album_id`)
    REFERENCES `DbMysql11`.`Album` (`album_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_track`
    FOREIGN KEY (`track_id`)
    REFERENCES `DbMysql11`.`Track` (`track_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `DbMysql11`.`Country`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DbMysql11`.`Country` ;

CREATE TABLE IF NOT EXISTS `DbMysql11`.`Country` (
  `country_id` SMALLINT(5) UNSIGNED NOT NULL AUTO_INCREMENT,
  `country` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`country_id`),
  UNIQUE INDEX `country_UNIQUE` (`country` ASC),
  INDEX `country_idx` (`country` ASC))
ENGINE = InnoDB
AUTO_INCREMENT = 1
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `DbMysql11`.`City`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DbMysql11`.`City` ;

CREATE TABLE IF NOT EXISTS `DbMysql11`.`City` (
  `city_id` SMALLINT(5) UNSIGNED NOT NULL AUTO_INCREMENT,
  `city` VARCHAR(45) NOT NULL,
  `country_id` SMALLINT(5) UNSIGNED NOT NULL,
  PRIMARY KEY (`city_id`),
  INDEX `fk_city_country_idx` (`country_id` ASC),
  INDEX `city_idx` (`city` ASC),
  CONSTRAINT `fk_city_country`
    FOREIGN KEY (`country_id`)
    REFERENCES `DbMysql11`.`Country` (`country_id`)
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 1
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `DbMysql11`.`Event`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DbMysql11`.`Event` ;

CREATE TABLE IF NOT EXISTS `DbMysql11`.`Event` (
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
    REFERENCES `DbMysql11`.`Artist` (`artist_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_event_city`
    FOREIGN KEY (`city_id`)
    REFERENCES `DbMysql11`.`City` (`city_id`)
    ON UPDATE CASCADE,
  CONSTRAINT `fk_event_country`
    FOREIGN KEY (`country_id`)
    REFERENCES `DbMysql11`.`Country` (`country_id`)
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 1
DEFAULT CHARACTER SET = utf8;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
