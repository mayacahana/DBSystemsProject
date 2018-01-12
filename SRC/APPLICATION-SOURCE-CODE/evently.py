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
        if request.form["btn"] == "Submit 1":
            print "im in post!"
            _q1_songs = request.form['q1_songs']
            _q1_genre = request.form['q1_genre']
            _q1_country = request.form['q1_country']
            _q1_songs = request.form['q1_songs']
            _q1_listeners = request.form['q1_listeners']
            print _q1_songs
            print _q1_country
            return redirect(url_for('events_query1',genre=_q1_genre, country=_q1_country, songs=_q1_songs, listeners=_q1_listeners))
    
    if (request.method == 'GET'):
        con = mdb.connect(host=SERVER_NAME, port=SERVER_PORT, user=DB_USERNAME, passwd=DB_PASSWORD, db=DB_NAME)
        with con:
            cur = con.cursor(mdb.cursors.DictCursor)
            cur.execute("SELECT DISTINCT genre FROM Artist WHERE genre IS NOT NULL")
            genres = [item['genre'] for item in cur.fetchall()]
            cur = con.cursor(mdb.cursors.DictCursor)
            cur.execute("SELECT country FROM Country")
            countries = [[item['country'] for item in cur.fetchall()]]
    return render_template('homepage.html',genres = genres, countries=countries[0])

@app.route('/Events/<genre>/<country>/<songs>/<listeners>', methods = ['GET','POST'])
def events_query1(genre,country,songs,listeners):
    print "im in here"
    con = mdb.connect(host=SERVER_NAME, port=SERVER_PORT, user=DB_USERNAME, passwd=DB_PASSWORD, db=DB_NAME)
    with con:
        print("connected")
        cur = con.cursor(mdb.cursors.DictCursor)
        cur.execute("SELECT E.artist_id, artist_name, COUNT(event_id) \
            FROM  Events_for_artists as E INNER JOIN Track as T ON T.artist_id = E.artist_id \
	        INNER JOIN Country as C ON E.country_id = C.country_id \
            WHERE T.listeners >= %s AND E.genre like %s AND  C.country = %s \
            GROUP BY E.artist_id \
            HAVING COUNT(T.track_id) >= %s \
            ORDER BY E.listeners DESC",(genre,country,songs,listeners))
        rows = cur.fetchall()
        print rows
        return render_template('artistsEvents.html', data = rows)


@app.route('/artistsEvents/')
def test():
    data=[['0','Beyonce','2'],['1','Coldplay','5']]
    return render_template('artistsEvents.html', data = data)
    
if (__name__ == '__main__'):
    app.run(port=5000, host="127.0.0.1", debug = True)