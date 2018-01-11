#hello
#parental supervision, return the percentage of songs conatining "bad words"
#input: event_id, up to 3 "bad words"
#returns the percentage of songs conatining bad words of the artist
select numOfNaughtySongs/numOfsongs as percentageOfNaughtySongs 
from(
	select count(lyrics) as numOfNaughtySongs
	from (
		select tracks.lyrics as lyrics
		from artists, tracks, events
		where events.event_id = %input_param and events.artist_id= track.artist_id and 
			   track.artist_id = artist.artist_id ) as lyrics_of_event
	where lyrics REGEXP '%param|%param|%param') as a, 
    (select count(tracks.lyrics) as numOfSongs
		from artists, tracks, events
		where events.event_id = %input_param and events.artist_id= track.artist_id and 
			   track.artist_id = artist.artist_id ) as lyrics_of_event) as b
               
               
#Oldies but Goodies vs. Shorties and Newbies
# Perfect genre for your event - insert: year span, minimal plays, duration span
# input - year span, minimal plays, event_id 
select tracks.tilte as TITLE
from (#find genre:
	   select artist.genre_id as selectedGenre
	   from events, artist
	   where events.event_id = %input_param and event.artist_id = artist.artist_id) as selectedGenre, 
       artist, tracks, albums, 
where artist.genre_id = selectedGenre and tracks.artist_id = artist.artist_id and 
	albums.artist_id = artist.artist_id and albums.release_year < %input_param and albums.release_year > %input_param
    and tracks.duration < %input_param and tracks.duration > %input_param
order by artist.playcount DESC
limit 20


#trivia - origin of the genre of the event
#input - event_id
select country.country, city.city
from (#top country ID
	select count(country) as numOfArtists, artist.country_id
	from country, city, event, artist, 
		(#find genre:
		select artist.genre_id as selectedGenre
		from events, artist
		where events.event_id = %input_param and event.artist_id = artist.artist_id) as selectedGenre
	where artist.genre_id = selectedGenre
	group by country
	order by desc numOfArtsits
	limit 1) as topCountryID
where country.country_id = topCountryID and country.country_id = topCountryID


#learn the words of the newest songs
#input - event_id , album year
#change to HAVING / JOINS
select tracks.title as TITLE, tracks.lyrics as LYRICS
from events, artists, tracks, albums
where events.event_id = %input_param and events.artist_id = artist.artist_id and tracks.artist_id = artist.artist_id
	and albums.aritst_id = artist.artist_id and albums.release_year > %input_param
order by rand()
limit 1;


CREATE VIEW Events_for_artists AS
SELECT  *
FROM Events AS E INNER JOIN Artists AS A ON E.artist_id = A.artist_id
ORDER BY A.artist_id
WHERE CURRENT_DATE() <= E.event_date

# find event
# TOP ARTISTS - Find events of artists with popular songs(at least <%param1> songs with at least <%param2> listeners)
# by your favorite genre in specific location 
SELECT E.artist_id, COUNT(E.event_id)
FROM 
	(SELECT relevant_artists.artist_id AS artist_id
	FROM (SELECT artist_id FROM Artists INNER JOIN Genres ON Artists.artist_id = Genre.artist_id
		WHERE Genre.genre_name = '%param') AS relevant_artists
		INNER JOIN Tracks ON track.artist_id = relevant_artists.artist_id
		WHERE Tracks.listeners >= <%param2>
		HAVING COUNT(track_id) >= <%param1>
		GROUP BY artist_id ) as T INNER JOIN Events_for_artists AS E ON E.artist_id = T.artist_id
WHERE event_location
GROUP BY E.artist_id


# find event
# FRESH ARTISTS - Find events of popular artists (sorted by listeners)
# that dont perform more than <%param> times in the 30 days before the show 
SELECT *
FROM Events_for_artists AS x
WHERE (SELECT count(event_id)
	 FROM Events_for_artists INNER JOIN x ON x.artist_id = Events_for_artists.artist_id
	 WHERE DATEDIFF(x.event_date, Events_for_artists.event_date)>=0 and DATEDIFF(x.event_date, Events_for_artists.event_date)<=30
	 GROUP BY event_id) <= <%param>
ORDER BY  x.listeners
	

# find event
# LATEST ARTISTS - 
# return the events of artists that release at least %param_x albums in %param_y last years
SELECT E.artist_id, COUNT(E.event_id)
	FROM (SELECT E.artist_id as artist_id, COUNT(A.release_year) as cnt_albums
		  FROM Events_for_artists AS E INNER JOIN Albums A ON E.artist_id = A.artist_id
		  WHERE YEAR(CURRENT_DATE()) - A.release_year <= %param_y
		  GROUP BY E.artist_id) AS T INNER JOIN Events_for_artists E ON T.artist_is = E.artist_id
WHERE T.cnt_albums >= %param_x
GROUP BY E.artist_id

# trivia 
# check if there is an album that contains at least 3 tracks which contain a given word
SELECT album_id
FROM albumTracks
WHERE EXISTS 
	(SELECT album_id
	FROM albumTracks
	WHERE MATCH(lyrics) AGAINST (+'%param_word' IN BOOLEAN MODE) AND artist_id = '%param_artist' 
	GROUP BY album_id
	HAVING COUNT(track_id)>=3)