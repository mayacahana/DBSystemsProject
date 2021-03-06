import csv
import MySQLdb
from connectionInfo import *

INPUT_FILE = PATH_ROOT + "/tracks/tracksWithListeners.csv"

def getForeignKeyFromTable(query, value):
    # execute the SQL query using execute() method.
	cursor.execute(query, [value])
	# fetch all of the rows from the query
	data = cursor.fetchall()
	if (data== ()):     # not found
		return None
	else:
		return data[0][0]

def getForeignKeyFromTable2(query, value):
    # execute the SQL query using execute() method.
	cursor.execute(query, value)
	# fetch all of the rows from the query
	data = cursor.fetchall()
	if (data== ()):     # not found
		return None
	else:
		return data[0][0]
	
# Open database connection
db = MySQLdb.connect(host=SERVER_NAME, port=SERVER_PORT, user=DB_USERNAME, passwd=DB_PASSWORD, db=DB_NAME)

# prepare a cursor object using cursor() method
cursor = db.cursor()

# to prevent encoding problems
db.set_character_set('utf8')
cursor.execute('SET NAMES utf8;')
cursor.execute('SET CHARACTER SET utf8;')
cursor.execute('SET character_set_connection=utf8;')

# Inserting...
x = 0
with open(INPUT_FILE, 'r') as fin:
	reader = csv.reader(fin, lineterminator='\n')

	for row in reader:
		x = x+1
		print(x)

        # csv row info
		artist_name = row[0]
		album_title = row[2]
		track_title = row[4]
		track_duration = row[6]
		track_lyrics = row[7]
		track_listeners = row[8]

        # set null values
		if (track_lyrics == "NULL"):
			track_lyrics = None
		if (track_listeners == "NULL"):
			track_listeners = None
		if (track_duration == "-1" or track_duration == "0"):
			track_duration = None

        # define sql queries
		add_track = """INSERT INTO Track (track_id, title, artist_id, duration, listeners)
                        VALUES (%s,%s,%s,%s,%s)"""
		add_lyrics = """INSERT INTO Lyrics (track_id, lyrics)
                        VALUES (%s,%s)"""
		add_album_track = """INSERT INTO AlbumTracks (album_id, track_id)
                        VALUES (%s,%s)"""
		get_artist_id = "SELECT artist_id from Artist WHERE name = %s"
		get_album_id = "SELECT album_id from Album WHERE title = %s AND artist_id = %s"
		get_track_id = "SELECT MAX(track_id) from Track"

        # getting the foreign keys from artist table
		artist_id = getForeignKeyFromTable(get_artist_id, artist_name)
		album_id = getForeignKeyFromTable2(get_album_id, (album_title, artist_id))
        

        # inserting the album
		try:
            # inserting 0 for artist_id to use sql auto increment
			cursor.execute(add_track, (0,track_title,artist_id,track_duration,track_listeners))
			db.commit()
            # get the track_id
			cursor.execute(get_track_id)
			track_id = cursor.fetchall()
            # inserting to AlbumTracks table
			cursor.execute(add_album_track, (album_id,track_id[0][0]))
			db.commit()
            # inserting to lyrics table
			cursor.execute(add_lyrics, (track_id[0][0],track_lyrics))
			db.commit()
		except Exception as e:
			print("error")
			print(e)
			db.rollback()
			break;


# disconnect from server
db.close()
