#import requests
import csv
import json

inputFile = 'artistAlbumsMusicbrainz2.json'
outputFile = 'artistAlbumsMusicbrainz2.csv'
cols =  ["id",
         "name",
         "country",
         "id",
         "title",
         "first-release-date"]

def createCSV():    
    with open (outputFile, "w") as output:
        writer = csv.writer(output, lineterminator='\n')
        json_data=open(inputFile).read()
        artistsAlbums = json.loads(json_data)
        counter = 1
        for artistAlbums in artistsAlbums:
            for album in artistAlbums["release-groups"]:
                if album["primary-type"] == 'Album':
                    try:
                        writer.writerow([counter,
                                    artistAlbums[cols[0]],
                                    artistAlbums[cols[1]],
                                    artistAlbums[cols[2]],
                                    album[cols[3]],
                                    album[cols[4]],
                                    album[cols[5]]])
                    except:
                        print("Error in: "+str(counter))
                        
            counter = counter+1            

    
def main():
    createCSV()

main()
