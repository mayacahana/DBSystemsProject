
DROP FUNCTION IF EXISTS getArtistId;
CREATE FUNCTION getArtistId() RETURNS INTEGER DETERMINISTIC return @artistId;
SET @artistId = 1;
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
from Artist INNER JOIN Songs_Genre ON Artist.artist_id = Songs_Genre.artist_id INNER JOIN Track ON track.artist_id = Songs_Genre.artist_id INNER JOIN Lyrics ON Lyrics.track_id = Track.track_id
where lyrics.lyrics IS NOT NULL   ;    
 
#returns songs of artists from genre
DROP view if exists ALL_SONGS;
CREATE VIEW ALL_SONGS AS                
select artist_id, count(track_id) as num_of_songs
from lyrics_genre
group by artist_id;
                 
SET @badWord1 = "fuck fucking awesome";

select Track.title
from Artist INNER JOIN Track ON Artist.artist_id = Track.artist_id
where Artist.artist_id = (select M.artist_id
						  from (
								select BAD_LYRICS.artist_id,  count(BAD_LYRICS.track_id)/ALL_SONGS.num_of_songs*100 as percentOfBadSongs
								from (select Artist.name as artist_name, Artist.artist_id as artist_id, Track.track_id as track_id, lyrics.lyrics as lyrics
									  from Artist INNER JOIN Track ON Artist.artist_id = Track.artist_id INNER JOIN lyrics ON lyrics.track_id = track.track_id
									   where Artist.genre= (select * from Artist_Genre) AND match (lyrics) against (@badWord1 IN BOOLEAN MODE)) as BAD_LYRICS , ALL_SONGS
								where ALL_SONGS.artist_id = BAD_LYRICS.artist_id
								group by BAD_LYRICS.artist_id
								order by percentOfBadSongs 
								limit 1) as M

						  order by track.listeners
						  limit 20);