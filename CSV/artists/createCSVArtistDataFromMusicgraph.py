#import requests
import csv
import json

inputFile = 'artistsInfoMusicgraph.json'
outputFile = 'artistsInfoMusicgraph.csv'
cols =  ["id",
         "country",
         "main genre"]

def createCSV():    
    with open (outputFile, "w") as output:
        writer = csv.writer(output, lineterminator='\n')
        json_data=open(inputFile).read()
        artistsInfo = json.loads(json_data)
        counter = 1
        for artistInfo in artistsInfo:
            try:
                artistID  = artistInfo["data"][0]["id"]
            except:
                print("Error in: " + str(counter))
                continue
            try:
                country = artistInfo["data"][0]["country_of_origin"]
            except KeyError:
                country = "N\A"
            try:
                genre = artistInfo["data"][0]["main_genre"]
            except KeyError:
                genre = "N\A"
            CSVinput = [artistID, country, genre]
            try:
                writer.writerow(CSVinput)
            except:
                print("Error in: "+str(counter))
            counter = counter+1            
    
def main():
    createCSV()

main()
