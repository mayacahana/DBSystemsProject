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
        # QUERY 1 - TOP EVENTS
        if "Submit 1" in request.form["btn"]:
            _q1_songs = request.form['q1_songs']
            _q1_genre = request.form['q1_genre']
            _q1_country = request.form['q1_country']
            _q1_songs = request.form['q1_songs']
            _q1_listeners = request.form['q1_listeners']
            return redirect(url_for("events_query1",genre=_q1_genre, country=_q1_country, songs=_q1_songs, listeners=_q1_listeners))
        
        if "Submit 2" in request.form["btn"]:
            _q2_date = request.form['q2_datepicker']
            _q2_times = request.form['q2_times']
            return redirect(url_for("events_query2",date=_q2_date, times=_q2_times))
        
        if "Submit 3" in request.form["btn"]:
            _q3_years = request.form['q3_years']
            _q3_albums = request.form['q3_albums']
            return redirect(url_for("events_query3", years=_q3_years, albums=_q3_albums))

    if (request.method == 'GET'):
        con = mdb.connect(host=SERVER_NAME, port=SERVER_PORT, user=DB_USERNAME, passwd=DB_PASSWORD, db=DB_NAME)
        with con:
            try:
                cur = con.cursor(mdb.cursors.DictCursor)
                cur.execute("SELECT genre FROM Artist_Genres")
                genres = [item['genre'] for item in cur.fetchall()]
                cur.close()
                cur = con.cursor(mdb.cursors.DictCursor)
                cur.execute("SELECT country FROM Country")
                countries = [[item['country'] for item in cur.fetchall()]]
                cur.close()
            except Exception as e:
                return render_template('homepage', error = str(e))
    return render_template('homepage.html',genres = genres, countries=countries[0])

@app.route('/Events1/<path:genre>/<country>/<songs>/<listeners>', methods = ['GET','POST'])
def events_query1(genre,country,songs,listeners):
    if (request.method == 'POST'):
        artist_id = request.form["click"]
        print artist_id
        return redirect(url_for('playlist_trivia', artist_id=artist_id))
    con = mdb.connect(host=SERVER_NAME, port=SERVER_PORT, user=DB_USERNAME, passwd=DB_PASSWORD, db=DB_NAME)
    with con:
        try:
            cur = con.cursor(mdb.cursors.DictCursor)
            cur.callproc('top_artists',(genre,listeners,songs,country))
            rows = cur.fetchall()
            cur.close()
        except Exception as e:
            return render_template('artistsEvents.html', error = str(e))
        return render_template('artistsEvents.html', data = rows)

@app.route('/Events3/<years>/<albums>', methods = ['GET','POST'])
def events_query3(years, albums):
    if (request.method == 'POST'):
        artist_id = request.form["click"]
        return redirect(url_for('playlist_trivia', artist_id=artist_id))
    con = mdb.connect(host=SERVER_NAME, port=SERVER_PORT, user=DB_USERNAME, passwd=DB_PASSWORD, db=DB_NAME)
    with con:
        cur = con.cursor(mdb.cursors.DictCursor)
        cur.callproc('latest_artists',(years, albums))
        rows = cur.fetchall()
        cur.close()
        return render_template('artistsEvents.html', data = rows)

@app.route('/Events2/<date>/<times>', methods = ['GET','POST'])
def events_query2(date, times):
    if (request.method == 'POST'):
        artist_id = request.form["click"]
        print artist_id
        return redirect(url_for('playlist_trivia', artist_id=artist_id))
    con = mdb.connect(host=SERVER_NAME, port=SERVER_PORT, user=DB_USERNAME, passwd=DB_PASSWORD, db=DB_NAME)
    with con:
        cur = con.cursor(mdb.cursors.DictCursor)
        cur.callproc('fresh_artists',(times, date))
        rows = cur.fetchall()
        cur.close()
        return render_template('artistsEvents.html', data = rows)



@app.route('/Playlists/<artist_id>',methods = ['GET','POST'])
def playlist_trivia(artist_id):
    if request.method == 'POST':
        if "duration" in request.form["submit"]:
            _duration = request.form["p1_duration"]
            return redirect(url_for('playlist_duration', artist_id = artist_id, duration = _duration))
        if "bad words" in request.form["submit"]:
            _word1 = request.form["p2_word1"]
            _word2 = request.form["p2_word2"]
            _word3 = request.form["p2_word3"]
            words = [_word1,_word2,_word3]
            bad_words = ""
            for word in words:
                if (word != ""):
                    bad_words += word+"+"
            print bad_words[:-1]
            print("return ")
            return redirect(url_for('playlist_badwords', artist_id = artist_id, bad_words = bad_words[:-1]))
        if "trivia 1" in request.form["submit"]:
            _word = request.form["t1_word"]
            _tracks = request.form["t1_tracks"]
            return redirect(url_for('playlist_trivia', artist_id=artist_id, trivia_success=1))
    if request.method == 'GET':
        con = mdb.connect(host=SERVER_NAME, port=SERVER_PORT, user=DB_USERNAME, passwd=DB_PASSWORD, db=DB_NAME)
        with con:
            cur = con.cursor(mdb.cursors.DictCursor)
            cur.execute("SELECT genre FROM Artist_Genres")
            genres = [item['genre'] for item in cur.fetchall()]
            cur.close()
            return render_template('playlists.html', genres=genres)

@app.route(/Trivia, methods=['POST','GET'])
def get_trivia_data():
    word_value = request.args.get('words')
    tracks_value = request.args.get('tracks')
    con = mdb.connect(host=SERVER_NAME, port=SERVER_PORT, user=DB_USERNAME, passwd=DB_PASSWORD, db=DB_NAME)
        with con:
           cur = con.cursor(mdb.cursors.DictCursor)
           cur.callproc 
    
@app.route('/showPlaylist_duration/<duration>/<artist_id>',methods = ['GET','POST'])
def playlist_duration(duration,artist_id):
    con = mdb.connect(host=SERVER_NAME, port=SERVER_PORT, user=DB_USERNAME, passwd=DB_PASSWORD, db=DB_NAME)
    with con:
        cur = con.cursor(mdb.cursors.DictCursor)
        cur.callproc('playlist_dur',(artist_id,duration))
        rows = cur.fetchall()
        print rows
        cur.close()
        return render_template('durationPlaylist.html', data=rows)

@app.route('/showPlaylist_badwords/<bad_words>/<artist_id>',methods = ['GET','POST'])
def playlist_badwords(bad_words,artist_id):
    con = mdb.connect(host=SERVER_NAME, port=SERVER_PORT, user=DB_USERNAME, passwd=DB_PASSWORD, db=DB_NAME)
    with con:
        cur = con.cursor(mdb.cursors.DictCursor)
        cur.callproc('bad_words',(artist_id,bad_words))
        rows = cur.fetchall()
        cur.close()
        return render_template('badwordsPlaylist.html', data=rows)
        

@app.route('/Edit/', methods=['GET','POST'])
def edit():
    if (request.method == 'POST'):
        if "Insert event" in request.form["btn"]:
            # insert new event
            event_artist = request.form["i1_artist"]
            event_desc = request.form["i1_desc"]
            event_sale = request.form["i1_sale"]
            event_date = request.form["i1_date"]
            event_venue = request.form["i1_venue"]
            event_city = request.form["i1_city"]
            con = mdb.connect(host=SERVER_NAME, port=SERVER_PORT, user=DB_USERNAME, passwd=DB_PASSWORD, db=DB_NAME)
            with con:
                cur = con.cursor(mdb.cursors.DictCursor)
                cur.callproc('sp_insertEvent',(event_artist,event_desc, event_sale, event_date, event_venue, event_city))
                try: 
                    affected_rows = cur.fetchall()
                    if affected_rows == 0:
                        return_string = "Failed to insert event. Please try again"
                    else:
                        return_string = "Event inserted successfully!"
                except:
                    return_string 
                cities =[]
                artists=[]
                return redirect(url_for('edit',cities = cities, artists=artists, insert_event=return_string))
        if "Insert album" in request.form["btn"]:
            #insert new album
            album_artist = request.form["i2_artist"]
            album_title = request.form["i2_title"]
            album_year = request.form["i2_year"]
            album_tracks = request.form["i2_tracks"]
            con = mdb.connect(host=SERVER_NAME, port=SERVER_PORT, user=DB_USERNAME, passwd=DB_PASSWORD, db=DB_NAME)
            with con:
                cur = con.cursor(mdb.cursors.DictCursor)
                cur.callproc('sp_insertAlbum',(album_title,album_artist, album_year,album_tracks))
                try: 
                    affected_rows = cur.fetchall()
                    if affected_rows == 0:
                        return_string = "Failed to insert album. Please try again"
                    else:
                        return_string = "Album inserted successfully!"
                except:
                    return_string 
                cities =[]
                artists=[]
                return redirect(url_for('edit',cities = cities, artists=artists, insert_album=return_string))

        if "Update event date" in request.form["btn"]:
            # update event date
            artist = request.form["i3_artist"]
            return redirect(url_for('update_event', artist_id=artist))

    if (request.method == 'GET'):
        con = mdb.connect(host=SERVER_NAME, port=SERVER_PORT, user=DB_USERNAME, passwd=DB_PASSWORD, db=DB_NAME)
        with con:
            cur = con.cursor(mdb.cursors.DictCursor)
            cur.execute("SELECT artist_id, name FROM Artist")
            artists = cur.fetchall()
            cur.close()
            cur = con.cursor(mdb.cursors.DictCursor)
            cur.execute("SELECT city_id, city FROM City")
            cities = cur.fetchall()
            cur.close()
            cur = con.cursor(mdb.cursors.DictCursor)
            cur.execute("SELECT genre FROM Artist_Genres")
            genres = [item['genre'] for item in cur.fetchall()]
            cur.close()
            return render_template('edit.html',cities = cities, artists=artists, genres=genres)

@app.route('/EditDateOfEvent/<event_id>/<message>', methods = ['GET', 'POST'])
def edit_date(event_id, message):
    if request.method == 'POST':
        print "test"
        edited_date = request.form["new_date"]
        print edited_date
        con = mdb.connect(host=SERVER_NAME, port=SERVER_PORT, user=DB_USERNAME, passwd=DB_PASSWORD, db=DB_NAME)
        with con:
                cur = con.cursor(mdb.cursors.DictCursor)
                cur.callproc('sp_updateEventDate',(event_id,edited_date))
                affected_rows = cur.fetchall()
                if affected_rows == 0:
                    return_string = "Failed to update event date. Please try again"
                else:
                    return_string = "Event date updated successfully!"
                return redirect(url_for('edit_date',event_id = event_id, message = return_string))
    if request.method == 'GET':
        con = mdb.connect(host=SERVER_NAME, port=SERVER_PORT, user=DB_USERNAME, passwd=DB_PASSWORD, db=DB_NAME)
        with con:
            cur = con.cursor(mdb.cursors.DictCursor)
            cur.execute("SELECT  description, sale_date, date, venue, name, genre, country, city \
            FROM Event AS D INNER JOIN Artist AS A ON D.artist_id = A.artist_id \
            INNER JOIN Country AS C ON C.country_id = D.country_id  \
	        INNER JOIN City AS C2 ON C2.city_id = D.city_id   \
            WHERE event_id = %s LIMIT 1;", event_id)
            event = cur.fetchall()
            print event
            return render_template('editDate.html', events = event, message = message)

@app.route('/EditDate/<artist_id>', methods=['GET','POST'])
def update_event(artist_id):
    if request.method == 'POST':
        print ("im in post")
        event_id = request.form["click"]
        message = "Please edit date"
        print message
        return redirect(url_for('edit_date', event_id = event_id, message = message))
    if request.method == 'GET':
        con = mdb.connect(host=SERVER_NAME, port=SERVER_PORT, user=DB_USERNAME, passwd=DB_PASSWORD, db=DB_NAME)
        with con:
            cur = con.cursor(mdb.cursors.DictCursor)
            cur.execute("SELECT A.artist_id as artist_id, A.name as artist_name, E.date as event_date, E.event_id as event_id\
            FROM Event AS E INNER JOIN Artist AS A ON E.artist_id = A.artist_id \
            WHERE A.artist_id = %s",(artist_id))
            rows = cur.fetchall()
            cur.close()
            return render_template('eventsUpdateDate.html', events = rows)
    
    

if (__name__ == '__main__'):
    app.run(port=5000, host="127.0.0.1", debug=True)