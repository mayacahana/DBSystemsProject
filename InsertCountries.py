import csv
import MySQLdb

INPUT_FILE = "countries\\country.csv"
SERVER_NAME = "localhost"
DB_USERNAME = "root"
DB_PASSWORD = ""
DB_NAME = "test"

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
        country = row[0]

        # define sql query
        add_country = "INSERT INTO country VALUES (%s,%s)"

        # inserting the country
        try:
            # inserting 0 for country_id to use sql auto increment
            cursor.execute(add_country,(0,country))
            db.commit()
        except:
            print("error")
            db.rollback()


# disconnect from server
db.close()
