import csv
import requests
import MySQLdb
from connectionInfo import *

INPUT_FILE = PATH_ROOT + "/events/EventsForArtists_new.csv"

def getForeignKeyFromTable(query, value):
    # execute the SQL query using execute() method.
    cursor.execute(query, [value])
    # fetch all of the rows from the query
    data = cursor.fetchall()
    if (data== ()):     # not found
        return None
    else:
        return data[0][0]

city_col_index = 8
country_col_index = 9
x = 0
cities = set()

# Open database connection
db = MySQLdb.connect(host=SERVER_NAME, port=SERVER_PORT, user=DB_USERNAME, passwd=DB_PASSWORD, db=DB_NAME)

# prepare a cursor object using cursor() method
cursor = db.cursor()

# to prevent encoding problems
db.set_character_set('utf8')
cursor.execute('SET NAMES utf8;')
cursor.execute('SET CHARACTER SET utf8;')
cursor.execute('SET character_set_connection=utf8;')

# define sql queries
add_city = """INSERT INTO City (city_id, city, country_id)
                                    VALUES (%s,%s,%s)"""
get_country_id = "SELECT country_id from Country WHERE country = %s"


with open(INPUT_FILE, 'r') as fin:
    reader = csv.reader(fin, lineterminator='\n')

    for row in reader:
        x = x + 1
        print(x)
        if (row[2] == 'error'):
            continue
        city = row[city_col_index]
        country = row[country_col_index]
        if ((city,country) in cities):
            continue
        else:
            # adding the city to set
            cities.add((city,country))

            # getting the foreign keys from country table
            country_id = getForeignKeyFromTable(get_country_id,country)

            # inserting the city
            try:
                # inserting 0 for city_id to use sql auto increment
                cursor.execute(add_city,(0,city,country_id))
                db.commit()
            except Exception as e:
                print("error")
                print(e)
                db.rollback()
                break;

# disconnect from server
db.close()
