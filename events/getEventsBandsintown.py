import requests
import csv
import json
import time
import sys

URL_PREFIX = "https://rest.bandsintown.com/artists/"
REQUEST_METHOD = "/events"
REQUEST_FORMAT = "&fmt=json"
REQUEST_INC = "?inc=release-groups"
OUTPUT_FILE = 'EventsBandsInTown.json'
INPUT_FILE = 'topArtists.csv'
APP_ID = '?app_id=111'
DATES = '&date=2015-05-05%2C2019-05-05'

def getRequest(artist_name):
    return (URL_PREFIX+artist_name+REQUEST_METHOD+APP_ID+DATES)

def main():
    artistEvents = []
    with open(INPUT_FILE) as artists:
        reader = csv.reader(artists)
        try:
            for row in reader:
                artist_event = (requests.get(getRequest(row[1]))).json()
                #sys.stdout.write(row[1])
                #sys.stdout.flush()
                if "error" in artist_event:
                    print "Request error"
                    break
                artistEvents.append(artist_event)
                #time.sleep(1.2)
        except requests.exceptions.RequestException:
            print("ERROR")
    print "Now writing the json"
    with open(OUTPUT_FILE) as out_file:
        json.dump(artistEvents, out_file)

main()
