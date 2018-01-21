import csv
import MySQLdb
from connectionInfo import *

INPUT_FILE = PATH_ROOT + "/genres/genre.csv"

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
        genre = row[0]

        # define sql query
        add_genre = "INSERT INTO Genre VALUES (%s,%s)"

        # inserting the genre
        try:
            # inserting 0 for genre_id to use sql auto increment
            cursor.execute(add_genre,(0,genre))
            db.commit()
        except:
            print("error")
            db.rollback()


# disconnect from server
db.close()
