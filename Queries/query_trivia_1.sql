# trivia 
# what is the most popular (by sum of track listeners per relevant track) album 
# of artist @artistId which contains
# at least @numTracks tracks with a given word @word

SET @artistId = 2;
SET @word = "love";
SET @numTracks = 4;

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

