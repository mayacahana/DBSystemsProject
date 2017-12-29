#!/usr/bin/python
# -*- coding: utf-8 -*-

import csv
import MySQLdb

INPUT_FILE = "genres\\genre.csv"
PASSWORD = ""


# Open database connection
db = MySQLdb.connect("localhost","root",PASSWORD,"test")

# prepare a cursor object using cursor() method
cursor = db.cursor()

# Inserting...
with open(INPUT_FILE, 'r') as fin:
    reader = csv.reader(fin, lineterminator='\n')

    for row in reader:
        genre = row[0]
        add_genre = "INSERT INTO genre VALUES (%s,%s)"
        try:
            cursor.execute(add_genre,(0,genre))
            db.commit()
        except:
            print("error")
            db.rollback()


# disconnect from server
db.close()

