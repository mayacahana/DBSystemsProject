
CREATE VIEW Events_for_artists AS
SELECT  A.artist_id, A.artist_name, E.event_id, E.event_date
FROM Events AS E INNER JOIN Artists AS A ON E.artist_id = A.artist_id
ORDER BY A.artist_id
WHERE GETDATE() <= E.event_date

# query 1 - event
# TOP ARTISTS - Find events of artists with popular songs(at least <%param> songs with at least 100k listeners)
# by your favorite genre 


SELECT E.artist_id, COUNT(E.event_id)
FROM 
	(SELECT relevant_artists.artist_id AS artist_id
	FROM (SELECT artist_id FROM Artists INNER JOIN Genres ON Artists.artist_id = Genre.artist_id
		WHERE Genre.genre_name = '%param') AS relevant_artists
		INNER JOIN Tracks ON track.artist_id = relevant_artists.artist_id
		WHERE Tracks.listeners >= 100000 
		HAVING COUNT(track_id) >= <%param>
		GROUP BY artist_id ) as T INNER JOIN Events_for_artists AS E ON E.artist_id = T.artist_id
GROUP BY E.artist_id


# query 2 - event
# FRESH ARTISTS - Find popular artists (at least 2500000 listeners per artist)
# that dont perform more than <%param> times in the month before the show 

SELECT artist_id, artist_name, event_id 
FROM Events_for_artists
WHERE artist_listeners >= 2500000 AND 

# query 3 - event
# BUSY ARTISTS - return the events of artists that release at least %param_x albums in %param_y last years

SELECT E.artist_id, COUNT(E.event_id)
	FROM (SELECT E.artist_id as artist_id, COUNT(A.release_year) as cnt_albums
	FROM Events_for_artists AS E INNER JOIN Albums A ON E.artist_id = A.artist_id
	WHERE YEAR(GETDATE()) - A.release_year <= %param_y
	GROUP BY E.artist_id) AS T INNER JOIN Events_for_artists E ON T.artist_is = E.artist_id
WHERE T.cnt_albums >= %param_x
GROUP BY E.artist_id


# query 4 - playlist by gnere
# 

# query 5 - playlist by top songs
# 

# query 6 - trivia 
# check if there is an album that contains at least 3 tracks which contain a given word

SELECT album_id
FROM albumTracks
WHERE EXISTS 
	(SELECT album_id
	FROM albumTracks
	WHERE MATCH(lyrics) AGAINST (+'%param_word' IN BOOLEAN MODE)
		AND artist_id = '%param_artist' 
	GROUP BY album_id
	HAVING COUNT(track_id)>=3)







