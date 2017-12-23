import requests
import csv
import json

API_KEY = "2be95b32489bf42da7ff5af042b72247"
URL_PREFIX = "http://ws.audioscrobbler.com/2.0/"
REQUEST_METHOD = "?method=artist.gettopalbums"
REQUEST_MBID = "&mbid="
REQUEST_API = "&api_key="+API_KEY
REQUEST_FORMAT = "&format=json"
REQUEST_LIMIT = "&limit=1000"
OUTPUT_FILE = 'topAlbums.json'
INPUT_FILE = 'topArtists.csv'
def createRequestURI(artistMbid):
    return (URL_PREFIX + REQUEST_METHOD+REQUEST_MBID+
            artistMbid+ REQUEST_API+
            REQUEST_LIMIT+ REQUEST_FORMAT)
def main():    
    artistsAlbums = []
    with open(INPUT_FILE, newline='') as f:
        reader = csv.reader(f)
        try:
            for row in reader:
                
                artistAlbums = (requests.get(createRequestURI(row[4]))).json()
                if "error" in artistAlbums:
                    print("Request Error in: "+row[1])
                    artistsAlbums.append(["error"])
                else:
                    print(row[1] +" successfull")
                    artistsAlbums.append(artistAlbums)
        except requests.exceptions.RequestException:
            print("ERROR")
    with open(OUTPUT_FILE, 'w') as outfile:
            json.dump(artistsAlbums, outfile)
            

main()
