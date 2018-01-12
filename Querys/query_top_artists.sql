DROP VIEW IF EXISTS Events_for_artists;
CREATE VIEW Events_for_artists AS
SELECT  A.artist_id as artist_id, A.name as artist_name,
		A.genre as genre, A.listeners as listeners, A.playcount as playcount,
        E.event_id as event_id, E.date as event_date, E.country_id
FROM Event AS E INNER JOIN Artist AS A ON E.artist_id = A.artist_id
WHERE CURRENT_DATE() <= E.date;

# find event
# TOP ARTISTS - Find events of artists with popular songs
# (at least @numSongs songs with at least @listeners listeners)
# by your favorite genre (@genre) in specific location 


SELECT E.artist_id, artist_name, COUNT(event_id)
FROM  Events_for_artists as E INNER JOIN Track as T ON T.artist_id = E.artist_id
	  INNER JOIN Country as C ON E.country_id = C.country_id
WHERE T.listeners >= 100000 AND E.genre like "%indie%" AND  C.country = "United Kingdom"
GROUP BY E.artist_id
HAVING COUNT(T.track_id) >= 5
ORDER BY E.listeners DESC
