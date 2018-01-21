import requests
import csv
import json

API_KEY = "e0ee63a3ba877c865e3b10453ee5db9c"
URL_PREFIX = "http://api.musicgraph.com/api/v2/"
REQUEST_METHOD = "artist/search"
REQUEST_SEARCH_METHOD = "&name="
REQUEST_API = "?api_key="+API_KEY
OUTPUT_FILE = 'artistsInfoMusicgraph.json'
INPUT_FILE = 'topArtists.csv'

# dic for incorrect names
dic = {"Foo Fighters" : "The Foo Fighters" , "The Smashing Pumpkins" : "Smashing Pumpkins" ,
        "Ramones" : "The Ramones" , "Tom Petty and The Heartbreakers" : "Tom Petty The Heartbreakers",
       "Marina  the Diamonds" : "Marina and the Diamonds"}

def createRequestURI(artistName):
    return (URL_PREFIX + REQUEST_METHOD+REQUEST_API+
            REQUEST_SEARCH_METHOD + artistName)

def getName(name):    
    if name in dic:
        return dic[name];
    return name

def main():    
    artistsInfo = []
    with open(INPUT_FILE, newline='') as f:
        reader = csv.reader(f)
        try:
            for row in reader:                
                artistInfo = requests.get(createRequestURI(getName(row[1].replace("&","")))).json()
                if artistInfo["status"]["code"] !=0 or len(artistInfo["data"])==0:
                    print("Request Error in: "+row[1])
                    artistsInfo.append(["error"])
                else:
                    print(row[1] +" successfull")
                    artistsInfo.append(artistInfo)
        except requests.exceptions.RequestException:
            print("ERROR")
    with open(OUTPUT_FILE, 'w') as outfile:
            json.dump(artistsInfo, outfile)
            

main()
