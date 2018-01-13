# return num of events per city
CREATE OR REPLACE VIEW TOTAL_EVENTS_PER_CITY AS
SELECT e.country_id, e.city_id, city.city, COUNT(e.event_id) AS numOfEvents
FROM Event AS e INNER JOIN city ON e.city_id = city.city_id 
GROUP BY e.city_id
HAVING numOfEvents >= 5;

# return num of events of spcific genre per city
SET @genre = "Country";
CREATE OR REPLACE VIEW TOTAL_EVENTS_IN_CITY_PER_GENRE AS
SELECT city.city_id, city.city, COUNT(e.event_id) AS numOfEvents
FROM event AS e, city, artist
WHERE e.artist_id = artist.artist_id AND city.city_id = e.city_id AND artist.genre = getGenre() 
GROUP BY city.city_id;

# return which city has the highest (total events of genre/total events) ratio
SELECT TOTAL_EVENTS_PER_CITY.country_id, Country.country,TOTAL_EVENTS_PER_CITY.city_id,
		TOTAL_EVENTS_PER_CITY.city,
		(TOTAL_EVENTS_IN_CITY_PER_GENRE.numOfEvents / TOTAL_EVENTS_PER_CITY.numOfEvents * 100) AS percent
FROM TOTAL_EVENTS_PER_CITY JOIN TOTAL_EVENTS_IN_CITY_PER_GENRE ON TOTAL_EVENTS_PER_CITY.city_id = TOTAL_EVENTS_IN_CITY_PER_GENRE.city_id
	JOIN Country ON TOTAL_EVENTS_PER_CITY.country_id = Country.country_id
ORDER BY percent DESC
LIMIT 1;

DROP VIEW TOTAL_EVENTS_PER_CITY;
