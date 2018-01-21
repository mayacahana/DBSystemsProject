import requests
import csv
import json

API_KEY = "2be95b32489bf42da7ff5af042b72247"
URL_PREFIX = "http://ws.audioscrobbler.com/2.0/"
REQUEST_METHOD = "?method=chart.gettopartists"
REQUEST_API = "&api_key="+API_KEY
REQUEST_FORMAT = "&format=json"
REQUEST_LIMIT = "&limit=1000"
OUTPUT_FILE = 'topArtists.json'
def createRequestURI():
    return (URL_PREFIX + REQUEST_METHOD+REQUEST_API+
            REQUEST_LIMIT+ REQUEST_FORMAT)
def main():    
    try:
        topArtists = (requests.get(createRequestURI())).json()
        with open(OUTPUT_FILE, 'w') as outfile:
            json.dump(topArtists, outfile)
            
    except requests.exceptions.RequestException:
        print("ERROR")

main()
