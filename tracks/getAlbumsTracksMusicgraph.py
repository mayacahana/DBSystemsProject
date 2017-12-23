import requests
import csv
import json
import time

API_KEY = "3c94af04ed22c5af025270daab2c473e"
URL_PREFIX = "http://api.musicgraph.com/api/v2/"
REQUEST_METHOD = "album/"
REQUEST_SEARCH_METHOD = "/tracks"
REQUEST_API = "?api_key="+API_KEY
REQUEST_LIMIT = "&limit="
OUTPUT_FILE = 'albumsTracksMusicgraph.csv'
INPUT_FILE = 'artistsAlbumsMusicgraph2.csv'
cols = ["artist_name",
        "album_id",
        "album_title",
        "id",
        "title",
        "track_index",
        "duration"]
        
def createRequestURI(albumID, limit):
    return (URL_PREFIX + REQUEST_METHOD+ albumID +
            REQUEST_SEARCH_METHOD + REQUEST_API + REQUEST_LIMIT + limit )

    return name
def main():
    with open(INPUT_FILE, newline='') as f:
        reader = csv.reader(f)
        with open(OUTPUT_FILE, 'w') as outfile:
            writer =  csv.writer(outfile, lineterminator='\n')
            curr_artist = "97dbc840-8900-1b06-0942-d5f170c02045"
            album_counter = 1
            for row in reader:
                if row[0] == curr_artist:
                    if album_counter == 4:
                        continue
                else:
                    album_counter = 1
                    curr_artist = row[0]
                try:
                    albumTracksResponse = (requests.get(createRequestURI(row[2],row[5]))).json()
                except requests.exceptions.RequestException:
                    print("error in request for: "+row[3])
                if albumTracksResponse["status"]["code"]==0 and len(albumTracksResponse["data"])>0:
                    album_counter = album_counter+1
                    for track in albumTracksResponse["data"]:
                        try:
                            track_index = -1
                            duration = -1
                            if cols[5] in track:
                                track_index = track[cols[5]]
                            if cols[6] in track:
                                duration = track[cols[6]]
                            writer.writerow([row[1],row[2],row[3],
                                            track[cols[3]],track[cols[4]],track_index,duration])                            
                        except:
                            print("error in track for: "+row[3])
                    print(row[3] +" is successfull")
                else:
                    print("Didn't find tracks for :" +row[3])
                time.sleep(1)

main()
