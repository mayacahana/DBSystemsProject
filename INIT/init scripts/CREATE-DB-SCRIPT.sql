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
CREATE SCHEMA IF NOT EXISTS `DbMysql11` DEFAULT CHARACTER SET latin1 ;
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
-- Placeholder table for view `DbMysql11`.`Artist_Genres`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `DbMysql11`.`Artist_Genres` (`genre` INT);

-- -----------------------------------------------------
-- Placeholder table for view `DbMysql11`.`Artists_With_Future_Events`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `DbMysql11`.`Artists_With_Future_Events` (`artist_id` INT, `artist_name` INT, `genre` INT, `listeners` INT, `playcount` INT, `event_id` INT, `event_date` INT, `country_id` INT, `sale_date` INT, `venue` INT, `city_id` INT, `description` INT);

-- -----------------------------------------------------
-- procedure bad_words
-- -----------------------------------------------------

USE `DbMysql11`;
DROP procedure IF EXISTS `DbMysql11`.`bad_words`;

DELIMITER $$
USE `DbMysql11`$$
CREATE DEFINER=`DbMysql11`@`%.cs.tau.ac.il` PROCEDURE `bad_words`(IN artistId SMALLINT(5), IN badWords VARCHAR(255))
BEGIN

SET @badWords = badWords;
SET @artistId = artistId;
#return num of tracks which has lyrics per artist of input artist's genre
CREATE OR REPLACE VIEW ALL_SONGS AS
SELECT  A.artist_id, COUNT(T.track_id) AS num_of_songs, A.listeners
FROM Track AS T INNER JOIN Artist AS A ON T.artist_id = A.artist_id
	JOIN Lyrics AS L ON T.track_id = L.track_id
WHERE A.genre = (SELECT Artist.genre FROM Artist WHERE artist_id = getArtistId())
		AND L.lyrics IS NOT NULL
GROUP BY A.artist_id
HAVING num_of_songs>10;               


SELECT Artist.name AS artist_name, Track.title AS title, (Track.duration/60) AS duration
FROM Artist INNER JOIN Track ON Artist.artist_id = Track.artist_id
WHERE Artist.artist_id = (SELECT M.ALL_SONGS_ID
						  FROM (
								SELECT ALL_SONGS.artist_id as ALL_SONGS_ID
								FROM ( SELECT Artist.artist_id as artist_id, Track.track_id AS track_id
										FROM Artist INNER JOIN Track ON Artist.artist_id = Track.artist_id 
                                        INNER JOIN lyrics ON lyrics.track_id = track.track_id
										WHERE MATCH (lyrics) AGAINST (@badWords IN BOOLEAN MODE)) AS BAD_LYRICS 
								RIGHT JOIN ALL_SONGS ON ALL_SONGS.artist_id = BAD_LYRICS.artist_id
								GROUP BY ALL_SONGS.artist_id
								ORDER BY (COUNT(BAD_LYRICS.track_id)/ALL_SONGS.num_of_songs) asc, 
										  listeners desc 
                                limit 1) AS M)

ORDER BY track.listeners
LIMIT 20;

DROP VIEW ALL_SONGS;

						
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure fresh_artists
-- -----------------------------------------------------

USE `DbMysql11`;
DROP procedure IF EXISTS `DbMysql11`.`fresh_artists`;

DELIMITER $$
USE `DbMysql11`$$
CREATE DEFINER=`DbMysql11`@`%.cs.tau.ac.il` PROCEDURE `fresh_artists`(IN times INT, IN in_date DATE)
BEGIN
SET @times = times;
SET @in_date = in_date;
CREATE OR REPLACE VIEW events_60 AS
	# all the events + 60 from current date
	SELECT *
	FROM event as E
	WHERE DATEDIFF(E.date,getDate()) <= 60;

CREATE OR REPLACE VIEW relevant_events AS
  # all the relevant events as defined above
  SELECT *
  FROM events_60 as E2
  WHERE EXISTS (
				SELECT E3.artist_id
				FROM event as E3
				WHERE DATEDIFF(E2.date,E3.date) <= 30 AND 
					  DATEDIFF(E2.date,E3.date) > 0   AND 
					  E2.artist_id = E3.artist_id
				HAVING COUNT(E3.event_id) < getTimes());
		
SELECT A.artist_id as artist_id, A.name as artist_name, D.sale_date as sale_date,
	   D.date as event_date, D.venue as venue, C.country as country,
       C2.city as city, D.description as description
FROM relevant_events AS D INNER JOIN Artist AS A ON D.artist_id = A.artist_id
     INNER JOIN Country AS C ON C.country_id = D.country_id 
	 INNER JOIN City AS C2 ON C2.city_id = D.city_id  
ORDER BY A.playcount DESC ;   

DROP VIEW events_60;
DROP VIEW relevant_events;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- function getArtistId
-- -----------------------------------------------------

USE `DbMysql11`;
DROP function IF EXISTS `DbMysql11`.`getArtistId`;

DELIMITER $$
USE `DbMysql11`$$
CREATE DEFINER=`DbMysql11`@`%.cs.tau.ac.il` FUNCTION `getArtistId`() RETURNS smallint(5)
    DETERMINISTIC
RETURN @artistId$$

DELIMITER ;

-- -----------------------------------------------------
-- function getDate
-- -----------------------------------------------------

USE `DbMysql11`;
DROP function IF EXISTS `DbMysql11`.`getDate`;

DELIMITER $$
USE `DbMysql11`$$
CREATE DEFINER=`DbMysql11`@`%.cs.tau.ac.il` FUNCTION `getDate`() RETURNS date
    DETERMINISTIC
RETURN @in_date$$

DELIMITER ;

-- -----------------------------------------------------
-- function getGenre
-- -----------------------------------------------------

USE `DbMysql11`;
DROP function IF EXISTS `DbMysql11`.`getGenre`;

DELIMITER $$
USE `DbMysql11`$$
CREATE DEFINER=`DbMysql11`@`%.cs.tau.ac.il` FUNCTION `getGenre`() RETURNS varchar(45) CHARSET latin1
    DETERMINISTIC
RETURN @genre$$

DELIMITER ;

-- -----------------------------------------------------
-- function getNumYears
-- -----------------------------------------------------

USE `DbMysql11`;
DROP function IF EXISTS `DbMysql11`.`getNumYears`;

DELIMITER $$
USE `DbMysql11`$$
CREATE DEFINER=`DbMysql11`@`%.cs.tau.ac.il` FUNCTION `getNumYears`() RETURNS int(11)
    DETERMINISTIC
RETURN @numYears$$

DELIMITER ;

-- -----------------------------------------------------
-- function getTimes
-- -----------------------------------------------------

USE `DbMysql11`;
DROP function IF EXISTS `DbMysql11`.`getTimes`;

DELIMITER $$
USE `DbMysql11`$$
CREATE DEFINER=`DbMysql11`@`%.cs.tau.ac.il` FUNCTION `getTimes`() RETURNS int(11)
    DETERMINISTIC
RETURN @times$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure latest_artists
-- -----------------------------------------------------

USE `DbMysql11`;
DROP procedure IF EXISTS `DbMysql11`.`latest_artists`;

DELIMITER $$
USE `DbMysql11`$$
CREATE DEFINER=`DbMysql11`@`%.cs.tau.ac.il` PROCEDURE `latest_artists`(IN numYears INT, IN numAlbums INT)
BEGIN
SET @numYears = numYears;
SET @numAlbums = numAlbums;

# view to hold the most recent artists
CREATE OR REPLACE VIEW latest_artists AS
SELECT  E.artist_id as artist_id, COUNT(A.release_year) as cnt_albums
FROM Artist AS E INNER JOIN Album AS A ON E.artist_id = A.artist_id
WHERE A.release_year<=YEAR(current_date()) AND YEAR(current_date()) - A.release_year <= getNumYears()
GROUP BY E.artist_id;

SELECT  E.artist_id as artist_id, artist_name, sale_date, event_date, country, city,
        venue, description
FROM 	latest_artists AS T INNER JOIN Artists_With_Future_Events AS E ON T.artist_id = E.artist_id
		INNER JOIN Country as C ON C.country_id = E.country_id
        INNER JOIN City as C2 ON C2.city_id = E.city_id
WHERE T.cnt_albums >= @numAlbums
ORDER BY E.listeners DESC;

DROP VIEW latest_artists;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure playlist_dur
-- -----------------------------------------------------

USE `DbMysql11`;
DROP procedure IF EXISTS `DbMysql11`.`playlist_dur`;

DELIMITER $$
USE `DbMysql11`$$
CREATE DEFINER=`DbMysql11`@`%.cs.tau.ac.il` PROCEDURE `playlist_dur`(IN artistId SMALLINT(5), IN playlistDuration INT)
BEGIN

DECLARE numOfSongs  INT;
DECLARE i INT;
DECLARE currentDur INT;
SET @artistId = artistId;

CREATE OR REPLACE VIEW ArtistTracks AS
SELECT  Track.title as track_name, Track.duration as duration,
		Lyrics.lyrics as lyrics, Track.listeners as listeners
FROM  Track INNER JOIN Artist ON Artist.artist_id = Track.artist_id
INNER JOIN Lyrics ON Track.track_id = Lyrics.track_id		
WHERE Artist.artist_id = getArtistId() AND Lyrics.lyrics IS NOT NULL
AND duration IS NOT NULL;


SET i = 0;
SET currentDur = 0;
SET numOfSongs = (select count(*)
				  from ArtistTracks);
SET playlistDuration = playlistDuration*60;
WHILE currentDur <= playlistDuration  AND i <= numOfSongs DO
	SET  i = i + 1; 
	SET currentDur = (SELECT (SUM(duration)) as playlist_duration
					  FROM (SELECT * FROM ArtistTracks ORDER BY listeners DESC limit i ) as R);	
	
END WHILE; 

SET i = IF(currentDur>playlistDuration,i-1,i);
SELECT track_name as title, (duration/60) as duration, listeners, lyrics
FROM ArtistTracks
ORDER BY ArtistTracks.listeners DESC
LIMIT i;

DROP VIEW ArtistTracks;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure sp_insertAlbum
-- -----------------------------------------------------

USE `DbMysql11`;
DROP procedure IF EXISTS `DbMysql11`.`sp_insertAlbum`;

DELIMITER $$
USE `DbMysql11`$$
CREATE DEFINER=`DbMysql11`@`%.cs.tau.ac.il` PROCEDURE `sp_insertAlbum`(
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
CREATE DEFINER=`DbMysql11`@`%.cs.tau.ac.il` PROCEDURE `sp_insertEvent`(
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
CREATE DEFINER=`DbMysql11`@`%.cs.tau.ac.il` PROCEDURE `sp_updateEventDate`(
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

-- -----------------------------------------------------
-- procedure top_artists
-- -----------------------------------------------------

USE `DbMysql11`;
DROP procedure IF EXISTS `DbMysql11`.`top_artists`;

DELIMITER $$
USE `DbMysql11`$$
CREATE DEFINER=`DbMysql11`@`%.cs.tau.ac.il` PROCEDURE `top_artists`(IN inGenre VARCHAR(45), IN numListeners INT, IN numSongs INT, IN countryName VARCHAR(45))
BEGIN
SELECT A.artist_id as artist_id, artist_name, sale_date, event_date, country, city, venue, description
FROM	(SELECT Artist.artist_id AS artist_id
		FROM Artist INNER JOIN Track ON track.artist_id = artist.artist_id  
		WHERE Track.listeners >= numListeners AND genre = inGenre
		GROUP BY Artist.artist_id
		HAVING COUNT(track_id) >= numSongs) as A INNER JOIN
        Artists_With_Future_Events AS E ON A.artist_id = E.artist_id
        INNER JOIN Country AS C ON E.country_id = C.country_id
		INNER JOIN City ON E.city_id = City.city_id
WHERE C.country = countryName;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure trivia_1
-- -----------------------------------------------------

USE `DbMysql11`;
DROP procedure IF EXISTS `DbMysql11`.`trivia_1`;

DELIMITER $$
USE `DbMysql11`$$
CREATE DEFINER=`DbMysql11`@`%.cs.tau.ac.il` PROCEDURE `trivia_1`(IN artistId SMALLINT(5), IN word VARCHAR(45), IN numTracks INT)
BEGIN
SET @artistId = artistId;
SET @word = word;
SET @numTracks = numTracks;

CREATE OR REPLACE VIEW artistAlbumTracks AS
SELECT Album.album_id as album_id, Album.title as album_title, 
	   Track.track_id as track_id, Track.listeners as listeners
FROM Artist INNER JOIN Album ON Artist.artist_id = Album.artist_id 
	INNER JOIN Albumtracks ON Albumtracks.album_id = Album.album_id
	INNER JOIN Track ON Track.track_id = Albumtracks.track_id 	
WHERE Artist.artist_id = getArtistId();


SELECT album_title,SUM(listeners)
FROM artistAlbumTracks as A INNER JOIN Lyrics ON A.track_id = Lyrics.track_id
WHERE Match(lyrics) Against(@word)
GROUP BY album_id
HAVING COUNT(listeners)>=@numTracks
ORDER BY SUM(listeners)
limit 1;

DROP VIEW artistAlbumTracks;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure trivia_2
-- -----------------------------------------------------

USE `DbMysql11`;
DROP procedure IF EXISTS `DbMysql11`.`trivia_2`;

DELIMITER $$
USE `DbMysql11`$$
CREATE DEFINER=`DbMysql11`@`%.cs.tau.ac.il` PROCEDURE `trivia_2`(IN artistId SMALLINT(5))
BEGIN

# return num of events per city
CREATE OR REPLACE VIEW TOTAL_EVENTS_PER_CITY AS
SELECT e.country_id, e.city_id, city.city, COUNT(e.event_id) AS numOfEvents
FROM Event AS e INNER JOIN city ON e.city_id = city.city_id 
GROUP BY e.city_id
HAVING numOfEvents >= 5;

# return num of events of spcific genre per city
SET @genre = (SELECT genre FROM Artist WHERE artist_id = artistId);
CREATE OR REPLACE VIEW TOTAL_EVENTS_IN_CITY_PER_GENRE AS
SELECT city.city_id, city.city, COUNT(e.event_id) AS numOfEvents
FROM event AS e, city, artist
WHERE e.artist_id = artist.artist_id AND city.city_id = e.city_id AND artist.genre = getGenre() 
GROUP BY city.city_id;

# return which city has the highest (total events of genre/total events) ratio
SELECT TOTAL_EVENTS_PER_CITY.country_id, Country.country,TOTAL_EVENTS_PER_CITY.city_id,
		TOTAL_EVENTS_PER_CITY.city,
		(TOTAL_EVENTS_IN_CITY_PER_GENRE.numOfEvents / TOTAL_EVENTS_PER_CITY.numOfEvents * 100) AS percent
FROM TOTAL_EVENTS_PER_CITY JOIN TOTAL_EVENTS_IN_CITY_PER_GENRE ON TOTAL_EVENTS_PER_CITY.city_id = TOTAL_EVENTS_IN_CITY_PER_GENRE.city_id
	JOIN Country ON TOTAL_EVENTS_PER_CITY.country_id = Country.country_id
ORDER BY percent DESC
LIMIT 1;

DROP VIEW TOTAL_EVENTS_PER_CITY;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- View `DbMysql11`.`Artist_Genres`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `DbMysql11`.`Artist_Genres` ;
DROP TABLE IF EXISTS `DbMysql11`.`Artist_Genres`;
USE `DbMysql11`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`DbMysql11`@`%.cs.tau.ac.il` SQL SECURITY DEFINER VIEW `DbMysql11`.`Artist_Genres` AS select distinct `DbMysql11`.`Artist`.`genre` AS `genre` from `DbMysql11`.`Artist` where (`DbMysql11`.`Artist`.`genre` is not null);

-- -----------------------------------------------------
-- View `DbMysql11`.`Artists_With_Future_Events`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `DbMysql11`.`Artists_With_Future_Events` ;
DROP TABLE IF EXISTS `DbMysql11`.`Artists_With_Future_Events`;
USE `DbMysql11`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`DbMysql11`@`%.cs.tau.ac.il` SQL SECURITY DEFINER VIEW `DbMysql11`.`Artists_With_Future_Events` AS select `A`.`artist_id` AS `artist_id`,`A`.`name` AS `artist_name`,`A`.`genre` AS `genre`,`A`.`listeners` AS `listeners`,`A`.`playcount` AS `playcount`,`E`.`event_id` AS `event_id`,`E`.`date` AS `event_date`,`E`.`country_id` AS `country_id`,`E`.`sale_date` AS `sale_date`,`E`.`venue` AS `venue`,`E`.`city_id` AS `city_id`,`E`.`description` AS `description` from (`DbMysql11`.`Event` `E` join `DbMysql11`.`Artist` `A` on((`E`.`artist_id` = `A`.`artist_id`))) where (curdate() <= `E`.`date`);
USE `DbMysql11`;

DELIMITER $$

USE `DbMysql11`$$
DROP TRIGGER IF EXISTS `DbMysql11`.`check_release_year` $$
USE `DbMysql11`$$
CREATE
DEFINER=`DbMysql11`@`%.cs.tau.ac.il`
TRIGGER `DbMysql11`.`check_release_year`
BEFORE INSERT ON `DbMysql11`.`Album`
FOR EACH ROW
BEGIN
	IF (NEW.release_year > YEAR(CURRENT_DATE())) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: Release year cannot be older than current year';
	END IF;
END$$


USE `DbMysql11`$$
DROP TRIGGER IF EXISTS `DbMysql11`.`check_date` $$
USE `DbMysql11`$$
CREATE
DEFINER=`DbMysql11`@`%.cs.tau.ac.il`
TRIGGER `DbMysql11`.`check_date`
BEFORE UPDATE ON `DbMysql11`.`Event`
FOR EACH ROW
BEGIN
	IF NEW.date <=> OLD.date THEN 
		IF (NEW.date < OLD.sale_date) THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: Event date cannot be earlier than sale date';
		END IF;
	END IF;
END$$


USE `DbMysql11`$$
DROP TRIGGER IF EXISTS `DbMysql11`.`event_BEFORE_INSERT` $$
USE `DbMysql11`$$
CREATE
DEFINER=`DbMysql11`@`%.cs.tau.ac.il`
TRIGGER `DbMysql11`.`event_BEFORE_INSERT`
BEFORE INSERT ON `DbMysql11`.`Event`
FOR EACH ROW
BEGIN
	IF (NEW.date <= CURRENT_DATE()) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: Event date cannot be earlier than current date';
	END IF;
    
	IF (NEW.date < NEW.sale_date) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: Event date cannot be earlier than sale date';
	END IF;
    
	IF (SELECT NOT EXISTS (
		SELECT 1 FROM City WHERE NEW.city_id = city_id AND NEW.country_id = country_id
			)
        ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: city_id is not corresponded to country_id';
	END IF;
END$$


DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
