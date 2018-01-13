# Stored procedures
DELIMITER //
#QUERIES FOR FINDING EVENTS

#query_top_artists

# TOP ARTISTS - Find events of artists with popular songs
# (at least numSongs songs with at least numListeners listeners)
# by your favorite genre (inGenre) in specific location

DROP PROCEDURE IF EXISTS top_artists//
CREATE PROCEDURE top_artists(IN inGenre VARCHAR(45), IN numListeners INT, IN numSongs INT)
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
WHERE C.country = "United Kingdom";
END//

#query_fresh_artists

# FRESH ARTISTS - Find events of popular artists (sorted by listeners)
# that dont perform more than @times times in the 30 days before the show
# in the the 2 months from the date @in_date
DROP PROCEDURE IF EXISTS fresh_artists//
CREATE PROCEDURE fresh_artists(IN times INT, IN in_date DATE)
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
END//                      

#query_latest_artists
# LATEST ARTISTS - return the events of artists that release at least @numAlbums 
# in @numYears last years

DROP PROCEDURE IF EXISTS latest_artists//
CREATE PROCEDURE latest_artists(IN numYears INT, IN numAlbums DATE)
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
END//

#CREATE PLAYLIST

#query_playlist_dur
#PLAYLIST DUR- returns a playlist of the event's artist's songs and their lyrics.
#The playlist length(sum of all track durations)<=playlistDuration(input)

DROP PROCEDURE IF EXISTS playlist_dur//
CREATE PROCEDURE playlist_dur(IN playlistDuration INT)
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
END//


#query_bad_words
#BAD WORDS- returns a playlist of 20 popular songs of the artist who's songs contain
#the least percentage of bad words(songs that contain 1 or more words from @badWords

DROP PROCEDURE IF EXISTS bad_words//
CREATE PROCEDURE bad_words(IN badWords VARCHAR(255))
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
END//


#TRIVIA

#query_trivia_1
#TRIVIA 1- what is the most popular (by sum of track listeners per relevant track) album 
# of artist @artistId which contains
# at least @numTracks tracks with a given word @word

DROP PROCEDURE IF EXISTS trivia_1//
CREATE PROCEDURE trivia_1(IN artistId SMALLINT(5), IN word VARCHAR(45), IN numTracks INT)
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
END//
	
#query_trivia_2
#TRIVIA_2 - return which city has the highest (total events of artist's genre/total events) ratio
# from the genre of the selected artist

DROP PROCEDURE IF EXISTS trivia_2//
CREATE PROCEDURE trivia_2(IN artistId SMALLINT(5))
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
END//

