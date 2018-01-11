
#PLAYLIST QUERY
#stored procedure
DELIMITER //
DROP PROCEDURE IF EXISTS build_playlist//
CREATE PROCEDURE build_playlist(IN playlistDuration INT, IN artistId INT)
BEGIN

DECLARE numOfSongs  INT;
DECLARE i INT;
DECLARE currentDur INT;

SET i = 0;
SET currentDur = 0;
SET numOfSongs = (select count(*)
				  from ArtistTracks);
SET playlistDuration = playlistDuration*60;
WHILE currentDur <= playlistDuration  AND i <= numOfSongs DO
	SET  i = i + 1; 
	SET currentDur = (select (SUM(duration)) as playlist_duration
					   from (SELECT  Track.title as track, Track.duration as duration,
									Track.lyrics as lyrics, Track.listeners as listeners
							 FROM  Artist INNER JOIN Track ON Artist.artist_id = Track.artist_id
							 WHERE Artist.artist_id = artistId AND Track.lyrics IS NOT NULL) as T
					  order by listeners DESC
					  limit i);			   
	
END WHILE; 
SELECT track, lyrics, duration/60 as song_duration
FROM ArtistTracks
order by ArtistTracks.listeners DESC
limit i;

END//
DELIMITER ;

#CALL build_playlist(180,2);
 