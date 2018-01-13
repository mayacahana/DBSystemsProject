# find event
# LATEST ARTISTS - 
# return the events of artists that release at least @num_albums in @num_years last years
# or all of their albums in the last @num_years2 years

DROP VIEW IF EXISTS Events_for_artists;
CREATE VIEW Events_for_artists AS
SELECT  A.artist_id as artist_id, A.name as artist_name,
		A.genre as genre, A.listeners as listeners, A.playcount as playcount,
		E.event_id as event_id, E.date as event_date, E.country_id as country_id,
        E.sale_date as sale_date, E.venue as venue,E.city_id as city_id,
        E.description as description
FROM Event AS E INNER JOIN Artist AS A ON E.artist_id = A.artist_id
WHERE CURRENT_DATE() <= E.date;

SET @years = 2;
SET @numAlbums = 5;

DROP FUNCTION IF EXISTS getNumYears;
CREATE FUNCTION getNumYears() RETURNS INTEGER DETERMINISTIC RETURN @years;

CREATE OR REPLACE VIEW latest_artists AS
SELECT  E.artist_id as artist_id, COUNT(A.release_year) as cnt_albums
FROM Artist AS E INNER JOIN Album AS A ON E.artist_id = A.artist_id
WHERE A.release_year<=YEAR(current_date()) AND YEAR(current_date()) - A.release_year <= getNumYears()
GROUP BY E.artist_id;

SELECT  E.artist_id,E.artist_name, E.sale_date, E.event_date, C.country, C2.city,
        E.venue, E.description
	FROM latest_artists AS T INNER JOIN Events_for_artists AS E ON T.artist_id = E.artist_id
		 INNER JOIN Country as C ON C.country_id = E.country_id
         INNER JOIN City as C2 ON C2.city_id = E.city_id
WHERE T.cnt_albums >= @numAlbums
ORDER BY E.listeners DESC;
