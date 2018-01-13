-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema dbmysql11
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema dbmysql11
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `dbmysql11` DEFAULT CHARACTER SET utf8 ;
USE `dbmysql11` ;

-- -----------------------------------------------------
-- Table `dbmysql11`.`artist`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dbmysql11`.`artist` ;

CREATE TABLE IF NOT EXISTS `dbmysql11`.`artist` (
  `artist_id` SMALLINT(5) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `genre` VARCHAR(45) NULL DEFAULT NULL,
  `playcount` INT(11) UNSIGNED NULL DEFAULT NULL,
  `listeners` INT(11) UNSIGNED NULL DEFAULT NULL,
  PRIMARY KEY (`artist_id`),
  INDEX `listeners_idx` (`listeners` ASC))
ENGINE = InnoDB
AUTO_INCREMENT = 888
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `dbmysql11`.`album`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dbmysql11`.`album` ;

CREATE TABLE IF NOT EXISTS `dbmysql11`.`album` (
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
    REFERENCES `dbmysql11`.`artist` (`artist_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 9648
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `dbmysql11`.`track`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dbmysql11`.`track` ;

CREATE TABLE IF NOT EXISTS `dbmysql11`.`track` (
  `track_id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(250) NOT NULL,
  `artist_id` SMALLINT(5) UNSIGNED NOT NULL,
  `duration` SMALLINT(5) UNSIGNED NULL DEFAULT NULL,
  `listeners` INT(11) UNSIGNED NULL DEFAULT NULL,
  PRIMARY KEY (`track_id`),
  INDEX `fk_track_artist_idx` (`artist_id` ASC),
  CONSTRAINT `fk_track_artist`
    FOREIGN KEY (`artist_id`)
    REFERENCES `dbmysql11`.`artist` (`artist_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 24318
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `dbmysql11`.`albumtracks`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dbmysql11`.`albumtracks` ;

CREATE TABLE IF NOT EXISTS `dbmysql11`.`albumtracks` (
  `album_id` SMALLINT(5) UNSIGNED NOT NULL,
  `track_id` INT(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`album_id`, `track_id`),
  INDEX `fk_track_idx` (`track_id` ASC),
  CONSTRAINT `fk_album`
    FOREIGN KEY (`album_id`)
    REFERENCES `dbmysql11`.`album` (`album_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_track`
    FOREIGN KEY (`track_id`)
    REFERENCES `dbmysql11`.`track` (`track_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `dbmysql11`.`country`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dbmysql11`.`country` ;

CREATE TABLE IF NOT EXISTS `dbmysql11`.`country` (
  `country_id` SMALLINT(5) UNSIGNED NOT NULL AUTO_INCREMENT,
  `country` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`country_id`),
  UNIQUE INDEX `country_UNIQUE` (`country` ASC))
ENGINE = InnoDB
AUTO_INCREMENT = 70
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `dbmysql11`.`city`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dbmysql11`.`city` ;

CREATE TABLE IF NOT EXISTS `dbmysql11`.`city` (
  `city_id` SMALLINT(5) UNSIGNED NOT NULL AUTO_INCREMENT,
  `city` VARCHAR(45) NOT NULL,
  `country_id` SMALLINT(5) UNSIGNED NOT NULL,
  PRIMARY KEY (`city_id`),
  INDEX `fk_city_country_idx` (`country_id` ASC),
  INDEX `city_idx` (`city` ASC),
  CONSTRAINT `fk_city_country`
    FOREIGN KEY (`country_id`)
    REFERENCES `dbmysql11`.`country` (`country_id`)
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 1061
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `dbmysql11`.`event`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dbmysql11`.`event` ;

CREATE TABLE IF NOT EXISTS `dbmysql11`.`event` (
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
    REFERENCES `dbmysql11`.`artist` (`artist_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_event_city`
    FOREIGN KEY (`city_id`)
    REFERENCES `dbmysql11`.`city` (`city_id`)
    ON UPDATE CASCADE,
  CONSTRAINT `fk_event_country`
    FOREIGN KEY (`country_id`)
    REFERENCES `dbmysql11`.`country` (`country_id`)
    ON UPDATE CASCADE)
ENGINE = InnoDB
AUTO_INCREMENT = 6129
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `dbmysql11`.`lyrics`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `dbmysql11`.`lyrics` ;

CREATE TABLE IF NOT EXISTS `dbmysql11`.`lyrics` (
  `track_id` INT(10) UNSIGNED NOT NULL,
  `lyrics` TEXT NULL DEFAULT NULL,
  PRIMARY KEY (`track_id`),
  FULLTEXT INDEX `lyrics_idx` (`lyrics` ASC))
ENGINE = MyISAM
DEFAULT CHARACTER SET = utf8;

USE `dbmysql11` ;

-- -----------------------------------------------------
-- Placeholder table for view `dbmysql11`.`artist_genres`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dbmysql11`.`artist_genres` (`genre` INT);

-- -----------------------------------------------------
-- Placeholder table for view `dbmysql11`.`artists_with_future_events`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dbmysql11`.`artists_with_future_events` (`artist_id` INT, `artist_name` INT, `genre` INT, `listeners` INT, `playcount` INT, `event_id` INT, `event_date` INT, `country_id` INT, `sale_date` INT, `venue` INT, `city_id` INT, `description` INT);

-- -----------------------------------------------------
-- procedure bad_words
-- -----------------------------------------------------

USE `dbmysql11`;
DROP procedure IF EXISTS `dbmysql11`.`bad_words`;

DELIMITER $$
USE `dbmysql11`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `bad_words`(IN badWords VARCHAR(255))
BEGIN
SET @badWords = badWords;
#return total tracks which has lyrics of input artist's genre
CREATE OR REPLACE VIEW ALL_SONGS AS
SELECT  A.artist_id, A.name, T.track_id, COUNT(T.track_id) AS num_of_songs
FROM Track AS T INNER JOIN Artist AS A ON T.artist_id = A.artist_id
	JOIN Lyrics AS L ON T.track_id = L.track_id
WHERE A.genre = (SELECT Artist.genre FROM Artist WHERE artist_id = getArtistID())
		AND L.lyrics IS NOT NULL
GROUP BY A.artist_id;                


SELECT Track.title
FROM Artist INNER JOIN Track ON Artist.artist_id = Track.artist_id
WHERE Artist.artist_id = (SELECT M.artist_id
						  FROM (
								SELECT BAD_LYRICS.artist_id,  COUNT(BAD_LYRICS.track_id)/ALL_SONGS.num_of_songs*100 AS percentOfBadSongs
								FROM (SELECT Artist.artist_id as artist_id, Track.track_id AS track_id
									  FROM Artist INNER JOIN Track ON Artist.artist_id = Track.artist_id INNER JOIN lyrics ON lyrics.track_id = track.track_id
									   WHERE MATCH (lyrics) AGAINST (@badWords IN BOOLEAN MODE)) AS BAD_LYRICS , ALL_SONGS
								WHERE ALL_SONGS.artist_id = BAD_LYRICS.artist_id
								GROUP BY BAD_LYRICS.artist_id
								ORDER BY percentOfBadSongs 
								LIMIT 1) AS M

						  ORDER BY track.listeners
						  LIMIT 20);
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure fresh_artists
-- -----------------------------------------------------

USE `dbmysql11`;
DROP procedure IF EXISTS `dbmysql11`.`fresh_artists`;

DELIMITER $$
USE `dbmysql11`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `fresh_artists`(IN times INT, IN in_date DATE)
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

USE `dbmysql11`;
DROP function IF EXISTS `dbmysql11`.`getArtistId`;

DELIMITER $$
USE `dbmysql11`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `getArtistId`() RETURNS smallint(5)
    DETERMINISTIC
RETURN @artistId$$

DELIMITER ;

-- -----------------------------------------------------
-- function getDate
-- -----------------------------------------------------

USE `dbmysql11`;
DROP function IF EXISTS `dbmysql11`.`getDate`;

DELIMITER $$
USE `dbmysql11`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `getDate`() RETURNS date
    DETERMINISTIC
RETURN @in_date$$

DELIMITER ;

-- -----------------------------------------------------
-- function getGenre
-- -----------------------------------------------------

USE `dbmysql11`;
DROP function IF EXISTS `dbmysql11`.`getGenre`;

DELIMITER $$
USE `dbmysql11`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `getGenre`() RETURNS varchar(45) CHARSET utf8
    DETERMINISTIC
RETURN @genre$$

DELIMITER ;

-- -----------------------------------------------------
-- function getNumYears
-- -----------------------------------------------------

USE `dbmysql11`;
DROP function IF EXISTS `dbmysql11`.`getNumYears`;

DELIMITER $$
USE `dbmysql11`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `getNumYears`() RETURNS int(11)
    DETERMINISTIC
RETURN @numYears$$

DELIMITER ;

-- -----------------------------------------------------
-- function getTimes
-- -----------------------------------------------------

USE `dbmysql11`;
DROP function IF EXISTS `dbmysql11`.`getTimes`;

DELIMITER $$
USE `dbmysql11`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `getTimes`() RETURNS int(11)
    DETERMINISTIC
RETURN @times$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure latest_artists
-- -----------------------------------------------------

USE `dbmysql11`;
DROP procedure IF EXISTS `dbmysql11`.`latest_artists`;

DELIMITER $$
USE `dbmysql11`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `latest_artists`(IN numYears INT, IN numAlbums DATE)
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

USE `dbmysql11`;
DROP procedure IF EXISTS `dbmysql11`.`playlist_dur`;

DELIMITER $$
USE `dbmysql11`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `playlist_dur`(IN playlistDuration INT)
BEGIN

DECLARE numOfSongs  INT;
DECLARE i INT;
DECLARE currentDur INT;

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
	SET currentDur = (select (SUM(duration)) as playlist_duration
					  from ArtistTracks
					  order by listeners DESC
					  limit i);			   
	
END WHILE; 

SELECT track_name, lyrics, duration/60 as song_duration
FROM ArtistTracks
order by ArtistTracks.listeners DESC
limit i;

DROP VIEW ArtistTracks;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure sp_insertAlbum
-- -----------------------------------------------------

USE `dbmysql11`;
DROP procedure IF EXISTS `dbmysql11`.`sp_insertAlbum`;

DELIMITER $$
USE `dbmysql11`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_insertAlbum`(
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

USE `dbmysql11`;
DROP procedure IF EXISTS `dbmysql11`.`sp_insertEvent`;

DELIMITER $$
USE `dbmysql11`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_insertEvent`(
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

USE `dbmysql11`;
DROP procedure IF EXISTS `dbmysql11`.`sp_updateEventDate`;

DELIMITER $$
USE `dbmysql11`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_updateEventDate`(
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

USE `dbmysql11`;
DROP procedure IF EXISTS `dbmysql11`.`top_artists`;

DELIMITER $$
USE `dbmysql11`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `top_artists`(IN inGenre VARCHAR(45), IN numListeners INT, IN numSongs INT, IN country_name VARCHAR(45))
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
WHERE C.country = country_name;
END$$

DELIMITER ;

-- -----------------------------------------------------
-- procedure trivia_1
-- -----------------------------------------------------

USE `dbmysql11`;
DROP procedure IF EXISTS `dbmysql11`.`trivia_1`;

DELIMITER $$
USE `dbmysql11`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `trivia_1`(IN artistId SMALLINT(5), IN word VARCHAR(45), IN numTracks INT)
BEGIN
SET @artistId = artistId;
SET @word = word;
SET @numTracks = numTracks;

CREATE OR REPLACE VIEW artistAlbumTracks AS
SELECT Album.album_id as album_id, Album.title as album_title, Track.listeners as listeners, Lyrics.lyrics as lyrics
FROM Artist INNER JOIN Album ON Artist.artist_id = Album.artist_id 
	INNER JOIN Albumtracks ON Albumtracks.album_id = Album.album_id
	INNER JOIN Track ON Track.track_id = Albumtracks.track_id 
	INNER JOIN Lyrics ON Track.track_id = Lyrics.track_id
WHERE Artist.artist_id = getArtistId();


SELECT album_title,SUM(listeners)
FROM artistAlbumTracks 
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

USE `dbmysql11`;
DROP procedure IF EXISTS `dbmysql11`.`trivia_2`;

DELIMITER $$
USE `dbmysql11`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `trivia_2`(IN artistId SMALLINT(5))
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
-- View `dbmysql11`.`artist_genres`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `dbmysql11`.`artist_genres` ;
DROP TABLE IF EXISTS `dbmysql11`.`artist_genres`;
USE `dbmysql11`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `dbmysql11`.`artist_genres` AS select distinct `dbmysql11`.`artist`.`genre` AS `genre` from `dbmysql11`.`artist` where (`dbmysql11`.`artist`.`genre` is not null);

-- -----------------------------------------------------
-- View `dbmysql11`.`artists_with_future_events`
-- -----------------------------------------------------
DROP VIEW IF EXISTS `dbmysql11`.`artists_with_future_events` ;
DROP TABLE IF EXISTS `dbmysql11`.`artists_with_future_events`;
USE `dbmysql11`;
CREATE  OR REPLACE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `dbmysql11`.`artists_with_future_events` AS select `a`.`artist_id` AS `artist_id`,`a`.`name` AS `artist_name`,`a`.`genre` AS `genre`,`a`.`listeners` AS `listeners`,`a`.`playcount` AS `playcount`,`e`.`event_id` AS `event_id`,`e`.`date` AS `event_date`,`e`.`country_id` AS `country_id`,`e`.`sale_date` AS `sale_date`,`e`.`venue` AS `venue`,`e`.`city_id` AS `city_id`,`e`.`description` AS `description` from (`dbmysql11`.`event` `e` join `dbmysql11`.`artist` `a` on((`e`.`artist_id` = `a`.`artist_id`))) where (curdate() <= `e`.`date`);
USE `dbmysql11`;

DELIMITER $$

USE `dbmysql11`$$
DROP TRIGGER IF EXISTS `dbmysql11`.`check_release_year` $$
USE `dbmysql11`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `dbmysql11`.`check_release_year`
BEFORE INSERT ON `dbmysql11`.`album`
FOR EACH ROW
BEGIN
	IF (NEW.release_year > YEAR(CURRENT_DATE())) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERROR: Release year cannot be older than current year';
	END IF;
END$$


USE `dbmysql11`$$
DROP TRIGGER IF EXISTS `dbmysql11`.`check_date` $$
USE `dbmysql11`$$
CREATE
DEFINER=`root`@`localhost`
TRIGGER `dbmysql11`.`check_date`
BEFORE UPDATE ON `dbmysql11`.`event`
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
