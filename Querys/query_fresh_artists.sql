# find event
# FRESH ARTISTS - Find events of popular artists (sorted by playcount)
# in the 2 months before @date
# that dont perform more than @times times in the 30 days before the show 

CREATE OR REPLACE VIEW Events_for_artists AS
SELECT  A.artist_id as artist_id, A.name as artist_name,
		A.genre as genre, A.listeners as listeners, A.playcount as playcount,
        E.event_id as event_id, E.date as event_date, E.country_id
FROM Event AS E INNER JOIN Artist AS A ON E.artist_id = A.artist_id
WHERE CURRENT_DATE() <= E.date;

DROP FUNCTION IF EXISTS getDate;
CREATE FUNCTION getDate() RETURNS INTEGER DETERMINISTIC RETURN @date;
CREATE OR REPLACE VIEW latest_events_60 AS
SELECT E.event_id as event_id, E.date as event_date, A.artist_id as artist_id, A.name as artist_name
FROM event as E INNER JOIN artist as A ON E.artist_id = A.artist_id
WHERE DATEDIFF(E.event_date, getDate())>=0 and DATEDIFF(E.event_date, getDate())<=60;

CREATE OR REPLACE VIEW latest_events_90 AS
SELECT E.event_id as event_id, E.date as event_date, A.artist_id as artist_id, A.name as artist_name
FROM event as E INNER JOIN artist as A ON E.artist_id = A.artist_id
WHERE DATEDIFF(E.date, getDate())>=0 and DATEDIFF(E.date, getDate())<=90;

select *
from latest_events_60 AS L
where EXISTS (SELECT * 
			  FROM latest_events_90 as L2
              WHERE L.artist_id = L2.artist_id AND DATEDIFF(L.event_date , L2.event_date)
              GROUP BY L.artist_id
              HAVING COUNT(L2.event_id<=@times))
