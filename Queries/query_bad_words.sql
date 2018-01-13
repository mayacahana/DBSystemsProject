# return total tracks which has lyrics of input artist's genre which 
DROP FUNCTION IF EXISTS getArtistID;
CREATE FUNCTION getArtistID() RETURNS SMALLINT(5) RETURN @artist_id;
SET @artist_id = 1;
CREATE OR REPLACE VIEW ALL_SONGS AS
SELECT  A.artist_id, A.name, T.track_id, COUNT(T.track_id) AS num_of_songs
FROM Track AS T INNER JOIN Artist AS A ON T.artist_id = A.artist_id
	JOIN Lyrics AS L ON T.track_id = L.track_id
WHERE A.genre = (SELECT Artist.genre FROM Artist WHERE artist_id = getArtistID())
		AND L.lyrics IS NOT NULL
GROUP BY A.artist_id;
                 
SET @badWord1 = "fuck fucking awesome";

SELECT Track.title
FROM Artist INNER JOIN Track ON Artist.artist_id = Track.artist_id
WHERE Artist.artist_id = (SELECT M.artist_id
						  FROM (
								SELECT BAD_LYRICS.artist_id,  COUNT(BAD_LYRICS.track_id)/ALL_SONGS.num_of_songs*100 AS percentOfBadSongs
								FROM (SELECT Artist.artist_id as artist_id, Track.track_id AS track_id
									  FROM Artist INNER JOIN Track ON Artist.artist_id = Track.artist_id INNER JOIN lyrics ON lyrics.track_id = track.track_id
									   WHERE MATCH (lyrics) AGAINST (@badWord1 IN BOOLEAN MODE)) AS BAD_LYRICS , ALL_SONGS
								WHERE ALL_SONGS.artist_id = BAD_LYRICS.artist_id
								GROUP BY BAD_LYRICS.artist_id
								ORDER BY percentOfBadSongs 
								LIMIT 1) AS M

						  ORDER BY track.listeners
						  LIMIT 20);