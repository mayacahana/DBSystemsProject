# Genres view
CREATE OR REPLACE VIEW Artist_Genres AS
SELECT DISTINCT genre
FROM Artist
WHERE genre IS NOT NULL;

# Artists with future events view
CREATE OR REPLACE VIEW Artists_With_Future_Events AS
SELECT  A.artist_id as artist_id, A.name as artist_name,
		A.genre as genre, A.listeners as listeners, A.playcount as playcount,
        E.event_id as event_id, E.date as event_date, E.country_id as country_id,
        E.sale_date as sale_date, E.venue as venue,E.city_id as city_id,
        E.description as description
FROM Event AS E INNER JOIN Artist AS A ON E.artist_id = A.artist_id
WHERE CURRENT_DATE() <= E.date;


#getter functions for using params in views
DROP FUNCTION IF EXISTS getArtistId;
CREATE FUNCTION getArtistId() RETURNS INTEGER DETERMINISTIC RETURN @artistId;

DROP FUNCTION IF EXISTS getDate;
CREATE FUNCTION getDate() RETURNS DATE DETERMINISTIC RETURN @date;

DROP FUNCTION IF EXISTS getTimes;
CREATE FUNCTION getTimes() RETURNS INTEGER DETERMINISTIC RETURN @times;

DROP FUNCTION IF EXISTS getNumYears;
CREATE FUNCTION getNumYears() RETURNS INTEGER DETERMINISTIC RETURN @numYears;

DROP FUNCTION IF EXISTS getGenre;
CREATE FUNCTION getGenre() RETURNS VARCHAR(45) DETERMINISTIC RETURN @genre;
