import csv
import MySQLdb
from connectionInfo import *

INPUT_FILE = PATH_ROOT + "artists\\artists.csv"

# Open database connection
db = MySQLdb.connect(host=SERVER_NAME, port=SERVER_PORT, user=DB_USERNAME, passwd=DB_PASSWORD, db=DB_NAME)

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

        # set null values
        if (artist_genre == "N\\A"):
            artist_genre = None

        # define sql queries
        add_artist = """INSERT INTO Artist (artist_id, name, genre, playcount, listeners)
                        VALUES (%s,%s,%s,%s,%s)"""

        # inserting the artist
        try:
            # inserting 0 for artist_id to use sql auto increment
            cursor.execute(add_artist, (0,artist_name,artist_genre,artist_playcount,artist_listeners))
            db.commit()
        except Exception as e:
            print("error")
            print(e)
            db.rollback()
            break;


# disconnect from server
db.close()


