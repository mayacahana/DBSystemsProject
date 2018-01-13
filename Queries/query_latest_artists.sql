# find event
# LATEST ARTISTS - 
# return the events of artists that release at least @num_albums in @num_years last years
# or all of their albums in the last @num_years2 years

SET @numYears = 2;
SET @numAlbums = 5;

# view to hold the most recent artists
CREATE OR REPLACE VIEW latest_artists AS
SELECT  E.artist_id as artist_id, COUNT(A.release_year) as cnt_albums
FROM Artist AS E INNER JOIN Album AS A ON E.artist_id = A.artist_id
WHERE A.release_year<=YEAR(current_date()) AND YEAR(current_date()) - A.release_year <= getNumYears())
GROUP BY E.artist_id;

SELECT  E.artist_id, E.artist_name, E.sale_date, E.event_date, C.country, C2.city,
        E.venue, E.description
FROM 	latest_artists AS T INNER JOIN Artists_With_Future_Events AS E ON T.artist_id = E.artist_id
		INNER JOIN Country as C ON C.country_id = E.country_id
        INNER JOIN City as C2 ON C2.city_id = E.city_id
WHERE T.cnt_albums >= @numAlbums
ORDER BY E.listeners DESC;

DROP VIEW latest_artists;