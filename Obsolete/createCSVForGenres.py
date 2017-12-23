import requests
import csv
import json

inputFile = 'topArtists.csv'
outputFile = 'artistGenres.csv'
cols =  ["artist_id",
         "album_id",
         "album_name",
         "album_release_date",
         "album_track_count"]
API_KEY = "2be95b32489bf42da7ff5af042b72247"
URL_PREFIX = "http://ws.audioscrobbler.com/2.0/"
REQUEST_METHOD = "?method=artist.getinfo"
REQUEST_MBID = "&mbid="
REQUEST_FORMAT = "&format=json"
REQUEST_API = "&api_key="
OUTPUT_FILE = 'artistsGenres.csv'
INPUT_FILE = 'topArtists.csv'


genres = ["rock", "electronic", "indie", "pop", "metal", "jazz", "folk", "punk", "Hip-Hop",
          "instrumental", "dance", "80s", "soul", "Classical", "rap", "90s", "funk", "hip hop",
          "reggae", "60", "hard rock", "blues", "thrash metal", "psychedelic", "german",
          "trance", "rnb", "french", "britpop", "pop rock", "Gothic Rock", "Disco", "folk rock",
          "italian", "party", "funky", "deep house", "50s", "salsa", "Pop-Rock","Pop Rock", "podcast",
          "tech house", "underground hip hop", "acoustic", "hardcore", "chillout", "Soundtrack", "a cappella"
          "Alt-country", "alternative", "alternative rock", "Broadway", "classic rock", "country", "dubstep",
          "dream pop", "Grunge", "hard rock", "heavy metal", "House", "metalcore", "trip-hop"]


def createRequestURI(artistMbid):
    return (URL_PREFIX + REQUEST_METHOD + REQUEST_MBID+ artistMbid +
            REQUEST_API + API_KEY+ REQUEST_FORMAT)


def getGenre1(artistGenres):
    array_of_tags_dics = artistGenres["artist"]["tags"]["tag"]
    for dic in array_of_tags_dics:
        for genre in genres:
            if dic["name"].lower() == genre.lower():
                return genre
        return "not found";

def getGenre(artistGenres):
    genre = getGenre1(artistGenres)
    try:
        if genre.lower() == "Hip-Hop".lower():
            return "hip hop"
        if genre.lower() == "Pop-Rock".lower():
            return "pop rock"
    except:
        None;
    return genre; 
    

def createCSV():    
    with open (OUTPUT_FILE, "w") as output:
        writer = csv.writer(output, lineterminator='\n')
        artistsGenres = []
        with open(INPUT_FILE, newline='') as f:
            reader = csv.reader(f)
            try:
                counter = 1
                for row in reader:                
                    artistGenres = (requests.get(createRequestURI(row[4]))).json()
                    if "error" in artistGenres:
                        print("Request Error in: "+str(counter))
                        artistsGenres.append([counter,"ERROR"])
                        continue
                    artistsGenres.append([counter,getGenre(artistGenres)])
                    counter = counter+1
                
                    
            except requests.exceptions.RequestException:
                print("ERROR in connection")
        writer.writerows(artistsGenres)
 

    
def main():
    createCSV()

main()
