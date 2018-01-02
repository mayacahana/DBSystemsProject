import csv
import MySQLdb
from connectionInfo import *

INPUT_FILE = "artists\\artists.csv"

def getForeignKeyFromTable(query, value):
    # execute the SQL query using execute() method.
    cursor.execute(query, [value])
    # fetch all of the rows from the query
    data = cursor.fetchall()
    if (data== ()):     # not found
        return None
    else:
        return data[0][0]   

# Open database connection
db = MySQLdb.connect(SERVER_NAME,DB_USERNAME,DB_PASSWORD,DB_NAME)

# prepare a cursor object using cursor() method
cursor = db.cursor()

# Inserting...
x = 0
with open(INPUT_FILE, 'r') as fin:
    reader = csv.reader(fin, lineterminator='\n')

    for row in reader:
        x = x+1
        print(x)

        # csv row info
        artist_name = row[1]
        artist_genre = row[3]
        artist_playcount = row[4]
        artist_listeners = row[5]
        

        # define sql queries
        add_artist = """INSERT INTO Artist (artist_id, name, genre_id, playcount, listeners)
                        VALUES (%s,%s,%s,%s,%s)"""
        get_genre_id = "SELECT genre_id from Genre WHERE genre = %s"

        # getting the foreign keys from genre table
        genre = getForeignKeyFromTable(get_genre_id, artist_genre)

        # inserting the artist
        try:
            # inserting 0 for artist_id to use sql auto increment
            cursor.execute(add_artist, (0,artist_name,genre,artist_playcount,artist_listeners))
            db.commit()
        except Exception as e:
            print("error")
            print(e)
            db.rollback()
            break;


# disconnect from server
db.close()


