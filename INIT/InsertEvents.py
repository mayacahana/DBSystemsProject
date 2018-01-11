import csv
import MySQLdb
from connectionInfo import *

INPUT_FILE = "events\\EventsForArtists_new.csv"

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

        if (row[2] == 'error'):
            continue

        # csv row info
        event_artist = row[6]
        event_desc = row[5]
        event_sale_date = row[3]
        event_date = row[4]
        event_venue = row[7]
        event_city = row[8]
        event_country = row[9]

        if (event_sale_date == ''):
            event_sale_date = None

        # define sql queries
        add_event = """INSERT INTO Event (event_id, artist_id, description, sale_date, date, venue, city_id, country_id)
                        VALUES (%s,%s,%s,DATE(%s),DATE(%s),%s,%s,%s)"""
        get_artist_id = "SELECT artist_id from Artist WHERE name = %s"
        get_city_id = "SELECT city_id from City WHERE city = %s"
        get_country_id = "SELECT country_id from Country WHERE country = %s"

        # getting the foreign keys from artist table
        artist_id = getForeignKeyFromTable(get_artist_id, event_artist)
        city_id = getForeignKeyFromTable(get_city_id, event_city)
        country_id = getForeignKeyFromTable(get_country_id, event_country)

        if (artist_id == None):
            continue
    
        # inserting the event
        try:
            # inserting 0 for artist_id to use sql auto increment
            cursor.execute(add_event, (0,artist_id,event_desc,event_sale_date,event_date,event_venue,city_id,country_id))
            db.commit()
        except Exception as e:
            print("error")
            print(e)
            db.rollback()
            break;


# disconnect from server
db.close()


