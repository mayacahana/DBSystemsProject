DROP VIEW IF EXISTS Events_for_artists;
CREATE VIEW Events_for_artists AS
SELECT  A.artist_id as artist_id, A.name as artist_name,
		A.genre as genre, A.listeners as listeners, A.playcount as playcount,
        E.event_id as event_id, E.date as event_date, E.country_id
FROM Event AS E INNER JOIN Artist AS A ON E.artist_id = A.artist_id
WHERE CURRENT_DATE() <= E.date;

# find event
# LATEST ARTISTS - 
# return the events of artists that release at least @num_albums in @num_years last years
SELECT E.artist_id, E.artist_name, COUNT(E.event_id)
	FROM (SELECT E.artist_id as artist_id, E.artist_name as artist_name, COUNT(A.release_year) as cnt_albums
		  FROM Events_for_artists AS E INNER JOIN Album AS A ON E.artist_id = A.artist_id
		  WHERE YEAR(CURRENT_DATE()) - A.release_year <= 2
		  GROUP BY E.artist_id) AS T INNER JOIN Events_for_artists AS E ON T.artist_id = E.artist_id
WHERE T.cnt_albums >= 2
GROUP BY E.artist_id