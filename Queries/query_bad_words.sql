

SET @artistId = 1;
SET @badWord = "fuck fucking awesome";
#returns the genre of the artist
CREATE OR REPLACE VIEW Artist_Genre AS
select A.genre as genre
from Artist as A
where A.artist_id = getArtistId();

#returns songs of artists from genre
CREATE OR REPLACE VIEW Songs_Genre AS
select  A.artist_id as artist_id, A.name, T.track_id as track_id
from Artist as A INNER JOIN Track as T ON A.artist_id=T.artist_id
where A.genre = (select *
				 from Artist_Genre);
                 
#returns lyrics of songs in genre
DROP VIEW IF EXISTS lyrics_genre;
CREATE VIEW lyrics_genre AS
select distinct Artist.name, Artist.artist_id, Track.title, Track.track_id,  Artist.genre , Lyrics.lyrics 
from Artist INNER JOIN Songs_Genre ON Artist.artist_id = Songs_Genre.artist_id 
INNER JOIN Track ON track.artist_id = Songs_Genre.artist_id 
INNER JOIN Lyrics ON Lyrics.track_id = Track.track_id
where lyrics.lyrics IS NOT NULL ;    
 
#returns songs of artists from genre
DROP view if exists ALL_SONGS;
CREATE VIEW ALL_SONGS AS                
select artist_id, count(track_id) as num_of_songs
from lyrics_genre
group by artist_id;
                 
SELECT 
    Track.title
FROM
    Artist
        INNER JOIN
    Track ON Artist.artist_id = Track.artist_id
WHERE
    Artist.artist_id = (SELECT 
            M.artist_id
        FROM
            (SELECT 
                BAD_LYRICS.artist_id,
                    COUNT(BAD_LYRICS.track_id) / ALL_SONGS.num_of_songs * 100 AS percentOfBadSongs
            FROM
                (SELECT 
                Artist.name AS artist_name,
                    Artist.artist_id AS artist_id,
                    Track.track_id AS track_id,
                    lyrics.lyrics AS lyrics
            FROM
                Artist
            INNER JOIN Track ON Artist.artist_id = Track.artist_id
            INNER JOIN lyrics ON lyrics.track_id = track.track_id
            WHERE
                Artist.genre = (SELECT 
                        *
                    FROM
                        Artist_Genre)
                    AND MATCH (lyrics) AGAINST (@badWord IN BOOLEAN MODE)) AS BAD_LYRICS, ALL_SONGS
            WHERE
                ALL_SONGS.artist_id = BAD_LYRICS.artist_id
            GROUP BY BAD_LYRICS.artist_id
            ORDER BY percentOfBadSongs
            LIMIT 1) AS M
        ORDER BY track.listeners
        LIMIT 20);