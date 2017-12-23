#import requests
import csv
import json

inputFile = 'topAlbums.json'
outputFile = 'topAlbums2.csv'
OUTPUT_FILE = 'edSheeran.json'
cols =  ["name",
         "mbid"]

def createCSV():    
    with open (outputFile, "w") as output:
        #writer = csv.writer(output, lineterminator='\n')
        json_data = open(inputFile).read()
        artistsAlbums = json.loads(json_data)
        with open(OUTPUT_FILE, 'w') as outfile:
            json.dump(artistsAlbums[0], outfile)
        return;
        topArtistsAlbums = []
        counter = 1
        for artistAlbums in artistsAlbums:            
            if(counter == 2):
                break
            try:
                albumCounter = 1
                for album in artistAlbums["topalbums"]["album"]:                    
                    if albumCounter == 10:
                        break
                    try:
                        writer.writerow([counter,
                                         album["artist"]["name"],
                                         album["artist"]["mbid"],
                                         album[cols[0]],
                                         album[cols[1]]])
                        albumCounter = albumCounter+1
                    except:
                        print("Error in writing :" +str(counter)+" in album number :"+albumCounter) 
            except:
                 writer.writerow([counter,"NA","NA","NA","NA"])
            counter = counter+1
        
    
def main():
    createCSV()

main()
