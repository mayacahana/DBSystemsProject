#parental supervision, return a playlist of songs, where the artist
#has less than @param percent bad words
#conatining "bad words"
#input: event_id, up to 3 "bad words"
#returns the percentage of songs conatining bad words of the artist
select artist_id
from (               
select BAD_SONGS.artist_id, BAD_SONGS.num_of_bad_songs/ALL_SONGS.num_of_all_songs*100 as percentOfBadSongs
from(
		select GENRE_LYRICS.artist_name, GENRE_LYRICS.artist_id, count(GENRE_LYRICS.track_id) as num_of_bad_songs
		from (
				select Track.lyrics as lyrics, Artist.artist_id as artist_id, Track.track_id as track_id, Artist.name as artist_name
				from Artist, Track
				where Artist.genre= (select A.genre as genre
									from Artist as A
									where A.artist_id = 1) and Track.lyrics like "%fuck%"
		) as GENRE_LYRICS, Track
		where GENRE_LYRICS.artist_id = Track.artist_id and Track.track_id = GENRE_LYRICS.track_id 
		group by GENRE_LYRICS.artist_id)as BAD_SONGS,
        
        (select GENRE_LYRICS.artist_id, GENRE_LYRICS.name, GENRE_LYRICS.lyrics, count(track_id) as num_of_all_songs
		 from (select T.lyrics as lyrics,A.artist_id as artist_id, T.track_id as track_id, A.name
			   from Artist as A INNER JOIN Track as T ON A.artist_id=T.artist_id
			   where A.genre = (select genre
							    from Artist
                                Where Artist.artist_id = 1)
               ) as GENRE_LYRICS
		Group by GENRE_LYRICS.artist_id) as ALL_SONGS) as M
where M.percentOfBadSongs < 50
        
        
        
