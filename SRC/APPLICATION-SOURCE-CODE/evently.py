import os
import MySQLdb as mdb
from flask import Flask, request, session, g, redirect, url_for, abort, \
     render_template, flash

# Create the application instance
app = Flask(__name__)
# MySQL configurations
SERVER_NAME = "127.0.0.1"
SERVER_PORT = 3305
DB_USERNAME = "DbMysql11"
DB_PASSWORD = "DbMysql11"
DB_NAME = "DbMysql11"


@app.route('/eventsList')
def showEvents():
    return render_template('eventsList.html')

@app.route('/', methods=['GET'])
def main():
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
    return render_template('homepage.html', genres=genres, countries=countries[0])
if (__name__ == '__main__'):
    app.run()
