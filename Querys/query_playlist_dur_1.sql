
#PLAYLIST QUERY

#VIEW - artist Track
DROP VIEW IF EXISTS ArtistTracks;
CREATE VIEW ArtistTracks AS
SELECT  Track.title as track, Track.duration as duration,
 Track.lyrics as lyrics, Track.listeners as listeners
FROM  Artist INNER JOIN Track ON Artist.artist_id = Track.artist_id
WHERE Artist.artist_id = @artist_id;


#stored procedure
DELIMITER //
DROP PROCEDURE IF EXISTS build_playlist//
CREATE PROCEDURE build_playlist(IN param INT)
BEGIN

DECLARE numOfSongs  INT;
DECLARE i INT;
DECLARE playlistDur INT;
 
SET i = 0;
SET playlistDur = 0;
SET numOfSongs = (select count(*)
				  from ArtistTracks);
SET param = param*60;
WHILE playlistDur <= param  AND i <= numOfSongs DO
	SET  i = i + 1; 
	SET playlistDur = (select (SUM(A.duration)) as playlist_duration
					   from (select *
							  from ArtistTracks
                              order by listeners DESC
                              limit i) as A);			   
	
END WHILE; 
SELECT track, lyrics, duration/60 as song_duration
FROM ArtistTracks
order by ArtistTracks.listeners DESC
limit i;

END//
DELIMITER ;

 
CALL build_playlist(180);