import requests
import csv
import json

API_KEY = "775c524464739de3d39cb0725637c15b"
URL_PREFIX = "https://api.musixmatch.com/ws/1.1/"
REQUEST_METHOD = "artist.albums.get?"
REQUEST_API = "&apikey="+API_KEY
REQUEST_FORMAT = "&format=json"
REQUEST_MBID = "artist_mbid="
OUTPUT_FILE = 'artistAlbums.json'
INPUT_FILE = 'topArtists.csv'

def createRequestURI(artistMbid):
    return (URL_PREFIX + REQUEST_METHOD+ REQUEST_MBID+artistMbid+
            REQUEST_API+ REQUEST_FORMAT)

def main():
    artistsAlbums = []
    with open(INPUT_FILE, newline='') as f:
        reader = csv.reader(f)
        try:
            for row in reader:
                artistAlbums = (requests.get(createRequestURI(row[4]))).json()
                artistsAlbums.append(artistAlbums)
        except requests.exceptions.RequestException:
            print("ERROR")
    with open(OUTPUT_FILE, 'w') as outfile:
        json.dump(artistsAlbums, outfile)

main()
