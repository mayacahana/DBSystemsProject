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

-- -----------------------------------------------------
-- Schema DbMysql11
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `DbMysql11` DEFAULT CHARACTER SET utf8 ;
USE `DbMysql11` ;

-- -----------------------------------------------------
-- Table `DbMysql11`.`Artist`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DbMysql11`.`Artist` ;

CREATE TABLE IF NOT EXISTS `DbMysql11`.`Artist` (
  `artist_id` SMALLINT(5) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `genre` VARCHAR(45) NULL DEFAULT NULL,
  `playcount` INT(11) UNSIGNED NULL DEFAULT NULL,
  `listeners` INT(11) UNSIGNED NULL DEFAULT NULL,
  PRIMARY KEY (`artist_id`),
  INDEX `listeners_idx` (`listeners` ASC),
  INDEX `genre_idx` (`genre` ASC))
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
  UNIQUE INDEX `country_UNIQUE` (`country` ASC))
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


-- -----------------------------------------------------
-- Table `DbMysql11`.`Lyrics`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `DbMysql11`.`Lyrics` ;

CREATE TABLE IF NOT EXISTS `DbMysql11`.`Lyrics` (
  `track_id` INT(10) UNSIGNED NOT NULL,
  `lyrics` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`track_id`),
  FULLTEXT INDEX `lyrics_idx` (`lyrics` ASC))
ENGINE = MyISAM
DEFAULT CHARACTER SET = utf8;

USE `DbMysql11` ;

-- -----------------------------------------------------
-- procedure sp_insertAlbum
-- -----------------------------------------------------

USE `DbMysql11`;
DROP procedure IF EXISTS `DbMysql11`.`sp_insertAlbum`;

DELIMITER $$
USE `DbMysql11`$$
CREATE PROCEDURE `sp_insertAlbum`(
	IN p_title VARCHAR(250),
    IN p_artist_id SMALLINT(5),
    IN p_release_year YEAR(4),
    IN p_num_of_tracks TINYINT(5))
BEGIN
	IF (SELECT EXISTS (
		SELECT 1 FROM Album WHERE p_artist_id = artist_id AND p_title = title
			)
        ) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: Album already exists';
	ELSE
		INSERT INTO Album
		(
			title,
			artist_id,
			release_year,
			num_of_tracks
        )
        VALUES
        (
            p_title,
            p_artist_id,
            p_release_year,
            p_num_of_tracks
        );
    END IF;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure sp_insertEvent
-- -----------------------------------------------------

USE `DbMysql11`;
DROP procedure IF EXISTS `DbMysql11`.`sp_insertEvent`;

DELIMITER $$
USE `DbMysql11`$$
CREATE PROCEDURE `sp_insertEvent`(
    IN p_artist_id SMALLINT(20),
    IN p_description TEXT,
    IN p_sale_date DATE,
    IN p_date DATE,
    IN p_venue VARCHAR(150),
    IN p_city_id SMALLINT(5))
BEGIN
	INSERT INTO Event
	(
		artist_id,
		description,
		sale_date,
        date,
        venue,
        city_id,
        country_id
	)
	VALUES
	(
		p_artist_id,
		p_description,
		p_sale_date,
		p_date,
        p_venue,
        p_city_id,
        (SELECT country_id FROM City WHERE city_id = p_city_id)
	);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure sp_updateEventDate
-- -----------------------------------------------------

USE `DbMysql11`;
DROP procedure IF EXISTS `DbMysql11`.`sp_updateEventDate`;

DELIMITER $$
USE `DbMysql11`$$
CREATE PROCEDURE `sp_updateEventDate`(
	IN p_event_id SMALLINT(5),
    IN p_event_date DATE)
BEGIN
	IF (SELECT NOT EXISTS (
		SELECT 1 FROM Event WHERE p_event_id = event_id
			)
        ) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: No such event_id';
	ELSE
		UPDATE Event
        SET date = p_event_date
        WHERE p_event_id = event_id;
    END IF;
END$$

DELIMITER ;
USE `DbMysql11`;

DELIMITER $$

USE `DbMysql11`$$
DROP TRIGGER IF EXISTS `DbMysql11`.`check_release_year` $$
USE `DbMysql11`$$
CREATE TRIGGER `DbMysql11`.`check_release_year`
BEFORE INSERT ON `DbMysql11`.`Album`
FOR EACH ROW
BEGIN
	IF (NEW.release_year > YEAR(CURRENT_DATE())) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: Release year cannot be older than current year';
	END IF;
END$$


DELIMITER ;
USE `DbMysql11`;

DELIMITER $$

USE `DbMysql11`$$
DROP TRIGGER IF EXISTS `DbMysql11`.`check_date` $$
USE `DbMysql11`$$
CREATE TRIGGER `DbMysql11`.`check_date`
BEFORE UPDATE ON `DbMysql11`.`Event`
FOR EACH ROW
BEGIN
	IF NEW.date <=> OLD.date THEN 
		IF (NEW.date < OLD.sale_date) THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: Event date cannot be earlier than sale date';
		END IF;
	END IF;
END$$


DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
