import requests
import csv
import json
import time

URL_PREFIX = "http://musicbrainz.org/ws/2/"
REQUEST_METHOD = "artist/"
REQUEST_FORMAT = "&fmt=json"
REQUEST_INC = "?inc=release-groups"
OUTPUT_FILE = 'artistAlbumsMusicbrainz2.json'
INPUT_FILE = 'topArtists.csv'

def createRequestURI(artistMbid):
    return (URL_PREFIX + REQUEST_METHOD + artistMbid +
            REQUEST_INC + REQUEST_FORMAT)

def main():
    artistsAlbums = []
    with open(INPUT_FILE, newline='') as f:
        reader = csv.reader(f)
        try:
            for row in reader:                
                artistAlbums = (requests.get(createRequestURI(row[4]))).json()
                if "error" in artistAlbums:
                    print("Request Error in: "+row[1])
                    break
                artistsAlbums.append(artistAlbums)
                time.sleep(1.5) 
        except requests.exceptions.RequestException:
            print("Connection Error")
    with open(OUTPUT_FILE, 'w') as outfile:
        json.dump(artistsAlbums, outfile)

main()
