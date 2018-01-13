# Genres view
CREATE OR REPLACE VIEW Artist_Genres AS
SELECT DISTINCT genre
FROM Artist;

# Artists with future events view
CREATE OR REPLACE VIEW Artists_With_Future_Events AS
SELECT  A.artist_id as artist_id, A.name as artist_name,
		A.genre as genre, A.listeners as listeners, A.playcount as playcount,
        E.event_id as event_id, E.date as event_date, E.country_id as country_id,
        E.sale_date as sale_date, E.venue as venue,E.city_id as city_id,
        E.description as description
FROM Event AS E INNER JOIN Artist AS A ON E.artist_id = A.artist_id
WHERE CURRENT_DATE() <= E.date;


#getter functions for using params in views
DROP FUNCTION IF EXISTS getArtistId;
CREATE FUNCTION getArtistId() RETURNS INTEGER DETERMINISTIC RETURN @artistId;

DROP FUNCTION IF EXISTS getDate;
CREATE FUNCTION getDate() RETURNS DATE DETERMINISTIC RETURN @date;

DROP FUNCTION IF EXISTS getTimes;
CREATE FUNCTION getTimes() RETURNS INTEGER DETERMINISTIC RETURN @times;

DROP FUNCTION IF EXISTS getNumYears;
CREATE FUNCTION getNumYears() RETURNS INTEGER DETERMINISTIC RETURN @numYears;

# Stored procedures
#stored procedure

DELIMITER //

DROP PROCEDURE IF EXISTS build_playlist//
CREATE PROCEDURE build_playlist(IN playlistDuration INT)
BEGIN

DECLARE numOfSongs  INT;
DECLARE i INT;
DECLARE currentDur INT;

CREATE OR REPLACE VIEW ArtistTracks AS
SELECT  Track.title as track_name, Track.duration as duration,
		Lyrics.lyrics as lyrics, Track.listeners as listeners
FROM  Track INNER JOIN Artist ON Artist.artist_id = Track.artist_id
INNER JOIN Lyrics ON Track.track_id = Lyrics.track_id		
WHERE Artist.artist_id = getArtistId() AND Lyrics.lyrics IS NOT NULL AND duration IS NOT NULL;

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
DELIMITER ;