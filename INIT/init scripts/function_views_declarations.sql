# Genres view
CREATE OR REPLACE VIEW Artist_Genres AS
SELECT DISTINCT genre
FROM Artist
WHERE genre IS NOT NULL;

# Artists with future events view
CREATE OR REPLACE VIEW Artists_With_Future_Events AS
SELECT  A.artist_id AS artist_id, A.name AS artist_name,
		A.genre AS genre, A.listeners AS listeners, A.playcount AS playcount,
        E.event_id AS event_id, E.date AS event_date, E.country_id AS country_id,
        E.sale_date AS sale_date, E.venue AS venue,E.city_id AS city_id,
        E.description AS description
FROM Event AS E INNER JOIN Artist AS A ON E.artist_id = A.artist_id
WHERE CURRENT_DATE() <= E.date;


#getter functions for using params in views
DROP FUNCTION IF EXISTS getArtistId;
CREATE FUNCTION getArtistId() RETURNS SMALLINT(5) DETERMINISTIC RETURN @artistId;

DROP FUNCTION IF EXISTS getDate;
CREATE FUNCTION getDate() RETURNS DATE DETERMINISTIC RETURN @in_date;

DROP FUNCTION IF EXISTS getTimes;
CREATE FUNCTION getTimes() RETURNS INTEGER DETERMINISTIC RETURN @times;

DROP FUNCTION IF EXISTS getNumYears;
CREATE FUNCTION getNumYears() RETURNS INTEGER DETERMINISTIC RETURN @numYears;

DROP FUNCTION IF EXISTS getGenre;
CREATE FUNCTION getGenre() RETURNS VARCHAR(45) DETERMINISTIC RETURN @genre;
