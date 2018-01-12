
# trivia 
# check how many albums of artist @artistId contain at least @numTracks tracks
# which contain a given word

SELECT *
FROM Artist INNER JOIN Album ON Artist.artist_id = Album.artist_id 
INNER JOIN Albumtracks ON Albumtracks.album_id = Album.album_id
INNER JOIN Track ON Track.track_id = Albumtracks.track_id INNER JOIN Lyrics ON Track.track_id = Lyrics.track_id
WHERE Artist.artist_id = 3 AND lyrics IS NOT NULL AND MATCH(lyrics) AGAINST (+"fuck" IN BOOLEAN MODE) 
GROUP BY Albumtracks.album_id
HAVING COUNT(Albumtracks.track_id)>=4