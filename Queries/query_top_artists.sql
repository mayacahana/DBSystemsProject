
# find event
# TOP ARTISTS - Find events of artists with popular songs
# (at least @numSongs songs with at least @listeners listeners)
# by your favorite genre (@genre) in specific location
 
SELECT A.artist_id, artist_name, sale_date, event_date, country, city, venue, description
FROM	(SELECT Artist.artist_id AS artist_id
		FROM Artist INNER JOIN Track ON track.artist_id = artist.artist_id  
		WHERE Track.listeners >= 100400 AND genre = "pop"
		GROUP BY Artist.artist_id
		HAVING COUNT(track_id) >= 21) as A INNER JOIN
        Artists_With_Future_Events AS E ON A.artist_id = E.artist_id
        INNER JOIN Country AS C ON E.country_id = C.country_id
		INNER JOIN City ON E.city_id = City.city_id
WHERE C.country = "United Kingdom";
        

