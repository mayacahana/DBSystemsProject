#!/usr/bin/python
# -*- coding: utf-8 -*-

import json
import MySQLdb


def getEventListFromFile(filePath):
    """ exctracting the data from the .json file
        to a list of events
    """
    # trying to open the file. If fails, printing an error
    try:
        f = open(filePath,"r") 
    except:
        print("ERROR: Couldn't open the file")
        return False

    # trying to load the json. If fails (not in the right format),
    # printing an error
    try:
        data = json.loads(f.read())
    except ValueError as e:
        print("ERROR: invalid json: %s" % e)
        f.close()
        return False
    f.close()
    
    return data
password = 
# Open database connection
db = MySQLdb.connect("localhost","root",,"test")

# prepare a cursor object using cursor() method
cursor = db.cursor()

# Drop table if it already exist using execute() method.
#cursor.execute("DROP TABLE IF EXISTS EMPLOYEE")

# Create table as per requirement
sql = """CREATE TABLE EMPLOYEE (
         FIRST_NAME  CHAR(20) NOT NULL,
         LAST_NAME  CHAR(20),
         AGE INT,  
         SEX CHAR(1),
         INCOME FLOAT )"""

cursor.execute(sql)


db.commit()

# disconnect from server
db.close()

def get_db_version():
    # Open database connection
    db = MySQLdb.connect("localhost","root","U6fwn3s9","test")

    # prepare a cursor object using cursor() method
    cursor = db.cursor()

    # execute SQL query using execute() method.
    cursor.execute("SELECT VERSION()")

    # Fetch a single row using fetchone() method.
    data = cursor.fetchone()
    print("Database version : %s " % data)

    # disconnect from server
    db.close()
