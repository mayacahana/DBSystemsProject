#TRIVIA
#returns the city who had the most percentage of events of the input genre

#returns how many events in each city
Drop view if exists ALL_SHOWS_PER_COUNTRY;
CREATE VIEW ALL_SHOWS_PER_COUNTRY AS
select country.country, city.city , city.city_id, e.event_id, count(e.event_id) as numOfEvents
from event as e inner join city on e.city_id = city.city_id 
		inner join country on country.country_id=city.country_id
group by city.city_id;

set @genre = "Country";

select ALL_SHOWS_PER_COUNTRY.country, ALL_SHOWS_PER_COUNTRY.city , ALL_SHOWS_PER_GENRE.numOFEvents as genreEvents, ALL_SHOWS_PER_COUNTRY.numOfEvents as allEvents , 
		MAX(ALL_SHOWS_PER_GENRE.numOFEvents/ALL_SHOWS_PER_COUNTRY.numOfEvents*100) as percent
from ALL_SHOWS_PER_COUNTRY, event as e, 
	(
    select country.country, city.city , city.city_id, e.event_id, count(e.event_id) as numOfEvents	
	from artist as a inner join event as e on a.artist_id= e.artist_id 
		inner join city on e.city_id = city.city_id 
		inner join country on country.country_id=city.country_id
	where a.genre = @genre
	group by city.city_id ) as ALL_SHOWS_PER_GENRE
where ALL_SHOWS_PER_GENRE.city_id = ALL_SHOWS_PER_COUNTRY.city_id and ALL_SHOWS_PER_COUNTRY.numOfEvents >= 5;

