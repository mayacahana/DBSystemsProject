import requests
import csv
import json

INPUT_FILE = "tracksWithLyrics.csv"
OUTPUT_FILE = "tracksWithListeners.csv"
API_KEY = "2be95b32489bf42da7ff5af042b72247"
URL_PREFIX = "http://ws.audioscrobbler.com/2.0/"
REQUEST_METHOD = "?method=track.search"
REQUEST_API = "&api_key="+API_KEY
REQUEST_FORMAT = "&format=json"
REQUEST_LIMIT = "&limit=1"
REQUEST_ARTIST = "&artist="
REQUEST_TRACK = "&track="
track_title_col_index = 4
artist_name_col_index = 0

def createRequestURI(trackName, artistName):
    return (URL_PREFIX + REQUEST_METHOD +
            REQUEST_ARTIST + artistName + REQUEST_TRACK+ trackName+
            REQUEST_LIMIT + REQUEST_API + REQUEST_FORMAT)
def main():
    with open(INPUT_FILE, 'r') as fin, open(OUTPUT_FILE, 'w') as fout:
        reader = csv.reader(fin, lineterminator='\n')
        writer = csv.writer(fout, lineterminator='\n')
        for row in reader:                          
            track_title = row[track_title_col_index]
            artist_name = row[artist_name_col_index]
            print(artist_name + ": " + track_title)
            
            #search in lyrics API's:
            # lyrics.ovh:
            try:
                trackData = (requests.get(createRequestURI(track_title,artist_name))).json()                
                track = trackData["results"]["trackmatches"]["track"]
                if len(track) == 0  or "listeners" not in track[0]:
                    print(artist_name+" "+track_title+" not found")
                    writer.writerow(row + ["NULL"])                        
                else:                                          
                    writer.writerow(row + [track[0]["listeners"]])
                    continue

            except requests.exceptions.RequestException:
                print("Request Exception")
                writer.writerow(row + ["NULL"])
            except json.decoder.JSONDecodeError:
                print("Decoder Exception")
                writer.writerow(row + ["NULL"])            

main()
