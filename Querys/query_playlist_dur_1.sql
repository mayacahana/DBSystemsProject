#PLAYLIST QUERY
#stored procedure
DROP FUNCTION IF EXISTS getArtistId;
CREATE FUNCTION getArtistId() RETURNS INTEGER DETERMINISTIC RETURN @artistId;
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

#call the procedure:
SET @artistId = 3 ;
CALL build_playlist(180);
 