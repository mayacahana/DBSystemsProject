import csv
import MySQLdb
from connectionInfo import *

INPUT_FILE = PATH_ROOT + "countries\\country.csv"

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
        country = row[0]

        # define sql query
        add_country = "INSERT INTO Country VALUES (%s,%s)"

        # inserting the country
        try:
            # inserting 0 for country_id to use sql auto increment
            cursor.execute(add_country,(0,country))
            db.commit()
        except Exception as e:
            print("error")
            print(e)
            db.rollback()
            break;


# disconnect from server
db.close()
