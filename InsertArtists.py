#!/usr/bin/python
# -*- coding: utf-8 -*-

import csv
import MySQLdb

INPUT_FILE = "artists\\artistsInfoMusicgraph.csv"
PASSWORD = ""

def getGenreID(artist_genre):
    get_genre_id = "SELECT genre_id from genre WHERE genre = %s"
    genre_id = cursor.execute(get_genre_id, [artist_genre])
    if (genre_id == 0):     # not found
        return None
    else:
        return genre_id

def getCountryID(artist_country):
    get_country_id = "SELECT country_id from country WHERE country = %s"
    country_id = cursor.execute(get_country_id, [artist_country])
    if (country_id == 0):   # not found
        return None
    else:
        return country_id

# Open database connection
db = MySQLdb.connect("localhost","root",PASSWORD,"test")

# prepare a cursor object using cursor() method
cursor = db.cursor()

# Inserting...
x = 0
with open(INPUT_FILE, 'r') as fin:
    reader = csv.reader(fin, lineterminator='\n')

    for row in reader:
        x = x+1
        print(x)
        artist_name = row[1]
        artist_country = row[2]
        artist_genre = row[3]
        add_artist = """INSERT INTO artist (artist_id, name, genre_id, country_id)
                        VALUES (%s,%s,%s,%s)"""
        genre = getGenreID(artist_genre)
        country = getCountryID(artist_country)
        try:       
            cursor.execute(add_artist, (0,artist_name,genre,country))
            db.commit()
        except Exception as e:
            print("error")
            print(e)
            db.rollback()
            break;



# disconnect from server
db.close()


