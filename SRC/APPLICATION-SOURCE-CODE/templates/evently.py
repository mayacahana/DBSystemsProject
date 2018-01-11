import os
import MySQLdb as mdb
from flask import Flask, request, session, g, redirect, url_for, abort, \
     render_template, flash

# Create the application instance
app = Flask(__name__)
# MySQL configurations
mysql = mydb()
app.config['MYSQL_DATABASE_USER'] = ''
app.config['MYSQL_DATABASE_PASSWORD'] = ''
app.config['MYSQL_DATABASE_DB'] = ''
app.config['MYSQL_DATABASE_HOST'] = ''
mysql.init_app(app)

@app.route('/events', methods=['GET'])
def showEvents():
    return render_template('eventsList.html')

def main():
    return render_template('homepage.html')