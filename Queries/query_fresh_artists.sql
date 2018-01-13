# find event
# FRESH ARTISTS - Find events of popular artists (sorted by listeners)
# that dont perform more than @times times in the 30 days before the show
# in the the 2 months from the date @date

SET @in_date = "2018-03-01";
SET @times = 1;

CREATE OR REPLACE VIEW events_60 AS
	# all the events + 60 from current date
	SELECT *
	FROM event as E
	WHERE DATEDIFF(E.date,getDate()) <= 60;

CREATE OR REPLACE VIEW relevant_events AS
  # all the relevant events as defined above
  SELECT *
  FROM events_60 as E2
  WHERE EXISTS (
				SELECT E3.artist_id
				FROM event as E3
				WHERE DATEDIFF(E2.date,E3.date) <= 30 AND 
					  DATEDIFF(E2.date,E3.date) > 0   AND 
					  E2.artist_id = E3.artist_id
				HAVING COUNT(E3.event_id) < getTimes());


# the query			
SELECT A.artist_id as artist_id, A.name as artist_name, D.sale_date as sale_date,
	   D.date as event_date, D.venue as venue, C.country as country,
       C2.city as city, D.description as description
FROM relevant_events AS D INNER JOIN Artist AS A ON D.artist_id = A.artist_id
     INNER JOIN Country AS C ON C.country_id = D.country_id 
	 INNER JOIN City AS C2 ON C2.city_id = D.city_id  
ORDER BY A.playcount DESC ;   

DROP VIEW events_60;
DROP VIEW relevant_events;                      