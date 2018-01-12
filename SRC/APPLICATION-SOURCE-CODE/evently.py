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

@app.route('/eventsList')
def showEvents():
    return render_template('eventsList.html')

@app.route('/', methods=['GET','POST'])
def main():
    # QUERY 1 - TOP EVENTS
    if request.form["submit"]=="Submit 1":
        if (request.method == 'POST'):
            _q1_genre = request.form['q1_genre']
            _q1_country = request.form['q1_country']
            _q1_songs = request.form['q1_songs']
            _q1_listeners = request.form['q1_listeners']
            # check validation
            return redirect(url_for('events_query1',genre=_q1_genre, country=_q1_country, songs=_q1_songs, listeners=_q1_listeners))
            

    if (request.method == 'GET'):
        print "get!"
        con = mdb.connect(host=SERVER_NAME, port=SERVER_PORT, user=DB_USERNAME, passwd=DB_PASSWORD, db=DB_NAME)
        with con:
            print ("connected")
            cur = con.cursor(mdb.cursors.DictCursor)
            cur.execute("SELECT DISTINCT genre FROM Artist WHERE genre IS NOT NULL")
            genres = [item['genre'] for item in cur.fetchall()]
            print genres
            cur = con.cursor(mdb.cursors.DictCursor)
            cur.execute("SELECT country FROM Country")
            countries = [[item['country'] for item in cur.fetchall()]]
    return render_template('homepage.html',genres = genres, countries=countries[0])

@app.route('/events/<genre><country><songs><listeners>')
def events_query1(genre,country,songs,listeners):
    con = mdb.connect(host=SERVER_NAME, port=SERVER_PORT, user=DB_USERNAME, passwd=DB_PASSWORD, db=DB_NAME)
    with con:
        print("connected")
        cur = con.cursor(mdb.cursors.DictCursor)
        cur.execute
    
if (__name__ == '__main__'):
    app.run()