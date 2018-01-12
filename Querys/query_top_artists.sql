CREATE OR REPLACE VIEW Events_for_artists AS
SELECT  A.artist_id as artist_id, A.name as artist_name,
		A.genre as genre, A.listeners as listeners, A.playcount as playcount,
        E.event_id as event_id, E.date as event_date, E.country_id as country_id,
        E.sale_date as sale_date, E.venue as venue,E.city_id as city_id,
        E.description as description
FROM Event AS E INNER JOIN Artist AS A ON E.artist_id = A.artist_id
WHERE CURRENT_DATE() <= E.date;

	
# find event
# TOP ARTISTS - Find events of artists with popular songs
# (at least @numSongs songs with at least @listeners listeners)
# by your favorite genre (@genre) in specific location 
SELECT artist_name,event_date,sale_date,country,city,venue,description
FROM	(SELECT Artist.artist_id AS artist_id
		FROM Artist INNER JOIN Track ON track.artist_id = artist.artist_id  
		WHERE Track.listeners >= 100400 AND genre = "pop"
		GROUP BY Artist.artist_id
		HAVING COUNT(track_id) >= 21) as A INNER JOIN
        Events_for_artists AS E ON A.artist_id = E.artist_id
        INNER JOIN Country AS C ON E.country_id = C.country_id
         INNER JOIN City ON E.city_id = City.city_id
WHERE C.country = "United Kingdom"
        

