import os
import MySQLdb as mdb
from flask import Flask, request, session, g, redirect, url_for, abort, \
     render_template, flash

# Create the application instance
app = Flask(__name__)
# MySQL configurations
SERVER_NAME = "127.0.0.1"
SERVER_PORT = 3306
DB_USERNAME = "root"
DB_PASSWORD = "Mc240195"
DB_NAME = "DbMysql11"


@app.route('/', methods=['GET','POST'])
def main():
    _q1_genre = ""
    _q1_country = ""
    _q1_songs = ""
    _q1_listeners = ""
    genres = []
    countries = [""]
    if (request.method == 'POST'):
        print "after if"
        # QUERY 1 - TOP EVENTS
        if "Submit 1" in request.form["btn"]:
            print "im in post!"
            _q1_songs = request.form['q1_songs']
            _q1_genre = request.form['q1_genre']
            _q1_country = request.form['q1_country']
            _q1_songs = request.form['q1_songs']
            _q1_listeners = request.form['q1_listeners']
            print _q1_songs
            print _q1_country
            return redirect(url_for('events_query1',genre=_q1_genre, country=_q1_country, songs=_q1_songs, listeners=_q1_listeners))
        print "hereee"
        if "Submit 2" in request.form["btn"]:
            print "im in query 2"
            _q2_date = request.form['q2_datepicker']
            print(_q2_date)
            _q2_times = request.form['q2_times']
            print(_q2_times)
            return redirect(url_for('events_query2',date=_q2_date, times=_q2_times))
        if "Submit 3" in request.form["btn"]:
            print "im in query 3"
            _q3_years = request.form['q3_years']
            _q3_albums = request.form['q3_albums']
            print _q3_albums
            print _q3_years
            return redirect(url_for('events_query3', years=_q3_years, albums=_q3_years))
    if (request.method == 'GET'):
        con = mdb.connect(host=SERVER_NAME, port=SERVER_PORT, user=DB_USERNAME, passwd=DB_PASSWORD, db=DB_NAME)
        with con:
            cur = con.cursor(mdb.cursors.DictCursor)
            cur.execute("SELECT DISTINCT genre FROM Artist WHERE genre IS NOT NULL")
            genres = [item['genre'] for item in cur.fetchall()]
            cur.close()
            cur = con.cursor(mdb.cursors.DictCursor)
            cur.execute("SELECT country FROM Country")
            countries = [[item['country'] for item in cur.fetchall()]]
            cur.close()
    return render_template('homepage.html',genres = genres, countries=countries[0])

@app.route('/Events/<path:genre>/<country>/<songs>/<listeners>', methods = ['GET','POST'])
def events_query1(genre,country,songs,listeners):
    if request.method == 'POST':
        
    print "im in here"
    con = mdb.connect(host=SERVER_NAME, port=SERVER_PORT, user=DB_USERNAME, passwd=DB_PASSWORD, db=DB_NAME)
    with con:
        print("connected")
        cur = con.cursor(mdb.cursors.DictCursor)
        query = "SELECT artist_id,artist_name,event_date,sale_date,country,city,venue,description\
        FROM (SELECT Artist.artist_id AS artist_id\
		FROM Artist INNER JOIN Track ON track.artist_id = artist.artist_id\
		WHERE Track.listeners >= %s AND genre = %s\
        GROUP BY Artist.artist_id HAVING COUNT(track_id) >= %s) as A INNER JOIN\
        Events_for_artists AS E ON A.artist_id = E.artist_id\
        INNER JOIN Country AS C ON E.country_id = C.country_id\
        INNER JOIN City ON E.city_id = City.city_id\
        WHERE C.country = %s"
        cur.execute(query ,(listeners,genre,songs,country))
        rows = cur.fetchall()
        cur.close()
        return render_template('artistsEvents.html', data = rows)

@app.route('/Events/<date>/<times>', methods = ['GET','POST'])
def events_query2(date, times):
    print ("im in func events_query2")
    con = mdb.connect(host=SERVER_NAME, port=SERVER_PORT, user=DB_USERNAME, passwd=DB_PASSWORD, db=DB_NAME)
    with con:
        statements = ["SET @in_date = %s;","SET @times = %s;","CREATE OR REPLACE VIEW events_60 AS \
	    SELECT * FROM event as E \
	    WHERE DATEDIFF(E.date,getDate()) <= 60;\
        CREATE OR REPLACE VIEW relevant_events AS \
        SELECT * FROM events_60 as E2 \
        WHERE EXISTS (SELECT E3.artist_id \
				FROM event as E3 \
				WHERE DATEDIFF(E2.date,E3.date) <= 30 AND \
					  DATEDIFF(E2.date,E3.date) > 0   AND \
					  E2.artist_id = E3.artist_id \
				HAVING COUNT(E3.event_id) < getTimes());","SELECT A.artist_id as artist_id, A.name as artist_name, D.sale_date as sale_date,\
	            D.date as event_date, D.venue as venue, C.country as country,\
                C2.city as city, D.description as description \
                FROM relevant_events AS D INNER JOIN Artist AS A ON D.artist_id = A.artist_id\
                INNER JOIN Country AS C ON C.country_id = D.country_id \
	            INNER JOIN City AS C2 ON C2.city_id = D.city_id  \
                ORDER BY A.playcount DESC ;",
        "DROP VIEW events_60; ",
        "DROP VIEW relevant_events;"]
        for index, statement in enumerate(statements):
            cur = con.cursor(mdb.cursors.DictCursor)
            if (index == 0):
                cur.execute(statement,(date,))
            elif (index == 1):
                cur.execute(statement, (times,))
            elif (index == 3):
                cur.execute(statement)
                rows = cur.fetchall()
            else:
                cur.execute(statement)
            cur.close()
        return render_template('artistsEvents.html', data = rows)


@app.route('/Events/<years>/<albums>', methods = ['GET','POST'])
def events_query3(years, albums):
    print ("im in func events_query3")
    con = mdb.connect(host=SERVER_NAME, port=SERVER_PORT, user=DB_USERNAME, passwd=DB_PASSWORD, db=DB_NAME)
    with con:
        statements = ["SET @numYears = %s;","SET @numAlbums = %s;", "CREATE OR REPLACE VIEW latest_artists AS\
SELECT  E.artist_id as artist_id, COUNT(A.release_year) as cnt_albums\
FROM Artist AS E INNER JOIN Album AS A ON E.artist_id = A.artist_id\
WHERE A.release_year<=YEAR(current_date()) AND YEAR(current_date()) - A.release_year <= getNumYears()\
GROUP BY E.artist_id;", "SELECT  E.artist_id, E.artist_name, E.sale_date, E.event_date, C.country, C2.city,\
        E.venue, E.description\
FROM 	latest_artists AS T INNER JOIN Artists_With_Future_Events AS E ON T.artist_id = E.artist_id\
		INNER JOIN Country as C ON C.country_id = E.country_id\
        INNER JOIN City as C2 ON C2.city_id = E.city_id\
WHERE T.cnt_albums >= @numAlbums\
ORDER BY E.listeners DESC;","DROP VIEW latest_artists;"]
        for index, statement in statements:
            cur = con.cursor(mdb.cursors.DictCursor)
            if (index == 0):
                cur.execute(statement,(years,))
            elif (index == 1):
                cur.execute(statement, (albums,))
            elif (index == 3):
                cur.execute(statement)
                rows = cur.fetchall()
            else:
                cur.execute(statement)
            cur.close() 
        return render_template('artistsEvents.html', data = rows)





@app.route('/artistsEvents/')
def test():
    data=[['0','Beyonce','2'],['1','Coldplay','5']]
    return render_template('artistsEvents.html', data = data)
    
if (__name__ == '__main__'):
    app.run(port=5000, host="127.0.0.1", debug = True)