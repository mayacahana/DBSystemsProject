import requests
import csv
import json
import time

API_KEY = "1b7b4e9e256de6e8f661b33ed26ccdc1"
URL_PREFIX = "http://api.musicgraph.com/api/v2/"
REQUEST_METHOD = "artist/"
REQUEST_SEARCH_METHOD = "/albums"
REQUEST_API = "?api_key="+API_KEY
REQUEST_LIMIT = "&limit=50"
OUTPUT_FILE = 'artistsAlbumsMusicgraph2.csv'
INPUT_FILE = 'artistsInfoMusicgraph.csv'
cols = ["album_artist_id",
        "album_name",
        "id",
        "title",
        "release_year",
        "release_date",
        "number_of_tracks"]
        
def createRequestURI(artistID):
    return (URL_PREFIX + REQUEST_METHOD+ artistID +
            REQUEST_SEARCH_METHOD + REQUEST_API+ REQUEST_LIMIT)

def main():
    with open(INPUT_FILE, newline='') as f:
        reader = csv.reader(f)
        with open(OUTPUT_FILE, 'w') as outfile:
            writer =  csv.writer(outfile, lineterminator='\n')
            for row in reader:
                try:
                    artistAlbumsResponse = (requests.get(createRequestURI(row[0]))).json()
                except requests.exceptions.RequestException:
                    print("error in request for: "+row[1])
                if artistAlbumsResponse["status"]["code"]==0 and len(artistAlbumsResponse["data"])>0:
                    for album in artistAlbumsResponse["data"]:                        
                        if "product_form" in album and album["product_form"]=="album":
                            try:
                                album_id = album[cols[2]]
                                album_title = album[cols[3]]
                                album_release_year = album[cols[4]]
                                album_release_date = "N/A"
                                album_num_of_tracks = album[cols[6]]
                                if cols[5] in album:
                                    album_release_date = album[cols[5]]
                            except:
                                continue
                            if int(album_num_of_tracks)>=10 and int(album_num_of_tracks)<=30:
                                try:
                                    writer.writerow([row[0],row[1],album_id,
                                                    album_title,album_release_year,
                                                    album_release_date,album_num_of_tracks])
                                except Exception as e:
                                    print("write error in: "+row[1])
                                    print(e)
                    print(row[1])
                    time.sleep(1)

main()
