# Stored procedures
DELIMITER $$
#QUERIES FOR FINDING EVENTS

#query_top_artists

# TOP ARTISTS - Find events of artists with popular songs
# (at least numSongs songs with at least numListeners listeners)
# by your favorite genre (inGenre) in specific location

DROP PROCEDURE IF EXISTS top_artists$$
CREATE PROCEDURE top_artists(IN inGenre VARCHAR(45), IN numListeners INT(11), 
							 IN numSongs TINYINT, IN countryName VARCHAR(45))
BEGIN
SELECT A.artist_id AS artist_id, artist_name, sale_date, event_date,
		country, city, venue, description
FROM	(SELECT Artist.artist_id AS artist_id
		FROM Artist INNER JOIN Track ON Track.artist_id = Artist.artist_id  
		WHERE Track.listeners >= numListeners AND genre = inGenre
		GROUP BY Artist.artist_id
		HAVING COUNT(track_id) >= numSongs) AS A INNER JOIN
        Artists_With_Future_Events AS E ON A.artist_id = E.artist_id
        INNER JOIN Country AS C ON E.country_id = C.country_id
		INNER JOIN City ON E.city_id = City.city_id
WHERE C.country = countryName;
END$$

#query_fresh_artists

# FRESH ARTISTS - Find events of popular artists (sorted by playcount)
# that dont perform more than @times times in the 30 days before the show
# in the the 2 months from the date @in_date
DROP PROCEDURE IF EXISTS fresh_artists$$
CREATE PROCEDURE fresh_artists(IN times TINYINT, IN in_date DATE)
BEGIN
SET @times = times;
SET @in_date = in_date;
CREATE OR REPLACE VIEW events_60 AS
	# all the events + 60 from in_date
	SELECT *
	FROM Event as E
	WHERE DATEDIFF(E.date,getDate()) <= 60 AND DATEDIFF(E.date,getDate()) >=0;

CREATE OR REPLACE VIEW relevant_events AS
  # all the relevant events as defined above
  SELECT *
  FROM events_60 AS E2
  WHERE EXISTS (
				SELECT E3.artist_id
				FROM Event as E3
				WHERE DATEDIFF(E2.date,E3.date) <= 30 AND 
					  DATEDIFF(E2.date,E3.date) > 0   AND 
					  E2.artist_id = E3.artist_id
				HAVING COUNT(E3.event_id) < getTimes());
		
SELECT A.artist_id AS artist_id, A.name AS artist_name, D.sale_date AS sale_date,
	   D.date AS event_date, D.venue AS venue, C.country AS country,
       C2.city AS city, D.description AS description
FROM relevant_events AS D INNER JOIN Artist AS A ON D.artist_id = A.artist_id
     INNER JOIN Country AS C ON C.country_id = D.country_id 
	 INNER JOIN City AS C2 ON C2.city_id = D.city_id  
ORDER BY A.playcount DESC ;   

DROP VIEW events_60;
DROP VIEW relevant_events;
END$$                      

#query_latest_artists
# LATEST ARTISTS - return the events of artists that release at least @numAlbums 
# in @numYears last years

DROP PROCEDURE IF EXISTS latest_artists$$
CREATE PROCEDURE latest_artists(IN numYears TINYINT, IN numAlbums TINYINT)
BEGIN
SET @numYears = numYears;
SET @numAlbums = numAlbums;

# view to hold the most recent artists
CREATE OR REPLACE VIEW latest_artists AS
SELECT  E.artist_id as artist_id, COUNT(A.release_year) as cnt_albums
FROM Artist AS E INNER JOIN Album AS A ON E.artist_id = A.artist_id
WHERE A.release_year<=YEAR(current_date())
		AND YEAR(current_date()) - A.release_year <= getNumYears()
GROUP BY E.artist_id;

SELECT  E.artist_id as artist_id, artist_name, sale_date, event_date, country, city,
        venue, description
FROM 	latest_artists AS T INNER JOIN Artists_With_Future_Events AS E 
							ON T.artist_id = E.artist_id
		INNER JOIN Country as C ON C.country_id = E.country_id
        INNER JOIN City as C2 ON C2.city_id = E.city_id
WHERE T.cnt_albums >= @numAlbums
ORDER BY E.listeners DESC;

DROP VIEW latest_artists;
END$$

#CREATE PLAYLIST

#query_playlist_dur
#PLAYLIST DUR- returns a playlist of the event's artist's songs and their lyrics.
#The playlist length(sum of all track durations)<=playlistDuration(input)

DROP PROCEDURE IF EXISTS playlist_dur$$
CREATE PROCEDURE playlist_dur(IN artistId SMALLINT(5), IN playlistDuration INT)
BEGIN

DECLARE numOfSongs  INT;
DECLARE i INT;
DECLARE currentDur INT;
SET @artistId = artistId;

CREATE OR REPLACE VIEW ArtistTracks AS
SELECT  Track.title as track_name, Track.duration AS duration,
		Lyrics.lyrics as lyrics, Track.listeners AS listeners
FROM  Track INNER JOIN Artist ON Artist.artist_id = Track.artist_id
INNER JOIN Lyrics ON Track.track_id = Lyrics.track_id		
WHERE Artist.artist_id = getArtistId() AND Lyrics.lyrics IS NOT NULL
AND duration IS NOT NULL;

SET i = 0;
SET currentDur = 0;
SET numOfSongs = (SELECT COUNT(*)
				  FROM ArtistTracks);
SET playlistDuration = playlistDuration*60;
WHILE currentDur <= playlistDuration  AND i <= numOfSongs DO
	SET  i = i + 1; 
	SET currentDur = (SELECT (SUM(duration)) AS playlist_duration
					  FROM (SELECT * FROM ArtistTracks ORDER BY listeners DESC LIMIT i ) AS R);	
	
END WHILE; 


SET i = IF(currentDur>playlistDuration,i-1,i);
SELECT track_name AS title, (duration/60) AS duration, listeners, lyrics
FROM ArtistTracks
ORDER BY ArtistTracks.listeners DESC
LIMIT i;

DROP VIEW ArtistTracks;
END$$


#query_bad_words
#BAD WORDS- returns a playlist of 20 popular songs of an artist
# from the same genre of artistId who has at least 10 songs with lyrics in our db
# and who's songs contain the least percentage of bad words.
# in case of a tie, the most popular artist(by listeners) is selected.
DROP PROCEDURE IF EXISTS bad_words$$
CREATE PROCEDURE bad_words(IN artistId SMALLINT(5), IN badWords VARCHAR(255))
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
WHERE Artist.artist_id = 
		(SELECT M.ALL_SONGS_ID
		  FROM (
				SELECT ALL_SONGS.artist_id as ALL_SONGS_ID
				FROM ( SELECT Artist.artist_id as artist_id, Track.track_id AS track_id
						FROM Artist INNER JOIN Track ON Artist.artist_id = Track.artist_id 
						INNER JOIN Lyrics ON Lyrics.track_id = Track.track_id
						WHERE MATCH (lyrics) AGAINST (@badWords IN BOOLEAN MODE)) AS BAD_LYRICS 
				RIGHT JOIN ALL_SONGS ON ALL_SONGS.artist_id = BAD_LYRICS.artist_id
				GROUP BY ALL_SONGS.artist_id
				ORDER BY (COUNT(BAD_LYRICS.track_id)/ALL_SONGS.num_of_songs) asc, 
						  listeners desc 
				limit 1) AS M)

ORDER BY Track.listeners
LIMIT 20;

DROP VIEW ALL_SONGS;
END$$


#TRIVIA

#query_trivia_1
#TRIVIA 1- what is the most popular (by sum of track listeners per relevant track) album 
# of artist @artistId which contains
# at least @numTracks tracks with a given word @word

DROP PROCEDURE IF EXISTS trivia_1$$
CREATE PROCEDURE trivia_1(IN artistId SMALLINT(5), IN word VARCHAR(45), IN numTracks TINYINT)
BEGIN
SET @artistId = artistId;
SET @word = word;
SET @numTracks = numTracks;

CREATE OR REPLACE VIEW artistAlbumTracks AS
SELECT Album.album_id AS album_id, Album.title AS album_title, 
	   Album.num_of_tracks AS num_of_tracks, Album.release_year AS release_year,
	   Track.track_id AS track_id, Track.listeners AS listeners
FROM Artist INNER JOIN Album ON Artist.artist_id = Album.artist_id 
	INNER JOIN Albumtracks ON AlbumTracks.album_id = Album.album_id
	INNER JOIN Track ON Track.track_id = AlbumTracks.track_id 	
WHERE Artist.artist_id = getArtistId();


SELECT album_title, release_year, num_of_tracks, SUM(listeners) as listeners
FROM artistAlbumTracks AS A INNER JOIN Lyrics ON A.track_id = Lyrics.track_id
WHERE MATCH(lyrics) AGAINST(@word)
GROUP BY album_id
HAVING COUNT(listeners)>=@numTracks
ORDER BY SUM(listeners)
LIMIT 1;

DROP VIEW artistAlbumTracks;
END$$
	
#query_trivia_2
#TRIVIA_2 - return which city has the highest (total events of artist's genre/total events) ratio
# from the genre of the selected artist

DROP PROCEDURE IF EXISTS trivia_2$$
CREATE PROCEDURE trivia_2(IN p_genre VARCHAR(45))
BEGIN

SET @genre = p_genre;
# return num of events of spcific genre per city
CREATE OR REPLACE VIEW TOTAL_EVENTS_IN_CITY_PER_GENRE AS
SELECT City.city_id, City.city, COUNT(E.event_id) AS numOfEvents
FROM Artist INNER JOIN Event AS E on Artist.artist_id = E.artist_id 
			INNER Join City ON E.city_id = City.city_id
WHERE Artist.genre = getGenre()
GROUP BY City.city_id;

#return which city has the highest (total events of genre/total events) ratio
SELECT Total_Events_Per_City.country_id as country_id, Country.country as country,
	   Total_Events_Per_City.city_id as city_id, Total_Events_Per_City.city as city,
		(TOTAL_EVENTS_IN_CITY_PER_GENRE.numOfEvents / Total_Events_Per_City.numOfEvents * 100) 
        AS percent
FROM Total_Events_Per_City JOIN TOTAL_EVENTS_IN_CITY_PER_GENRE 
			ON Total_Events_Per_City.city_id = TOTAL_EVENTS_IN_CITY_PER_GENRE.city_id
	JOIN Country ON Total_Events_Per_City.country_id = Country.country_id
ORDER BY percent DESC
LIMIT 1;

DROP VIEW TOTAL_EVENTS_IN_CITY_PER_GENRE;
END$$
DELIMITER ;
