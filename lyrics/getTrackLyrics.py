import csv
import requests

INPUT_FILE = "albumsTracksMusicgraph.csv"
OUTPUT_FILE = "tracksWithLyrics2.csv"

def main():
    track_title_col_index = 4
    artist_name_col_index = 0
    count1 = 0
    x = 0
    no_lyrics_tracks = []
    with open(INPUT_FILE, 'r') as fin, open(OUTPUT_FILE, 'w') as fout:
        reader = csv.reader(fin, lineterminator='\n')
        writer = csv.writer(fout, lineterminator='\n')
        for row in reader:
            try:
                x = x+1
                print(x)
                track_title = row[track_title_col_index]
                artist_name = row[artist_name_col_index]
                print(artist_name + ": " + track_title)
                
                #search in lyrics API's:
                # lyrics.ovh:
                try:
                    lyricsOHV = (requests.get("https://api.lyrics.ovh/v1/{}/{}".format(artist_name,track_title))).json()
                    if ("error" in lyricsOHV):
                        print(artist_name+" "+track_title+" not found")
                        writer.writerow(row + ["NULL"])
                        no_lyrics_tracks.append(tuple((x,artist_name,track_title)))
                    else:                    
                        count1 = count1 + 1                    
                        writer.writerow(row + [fixLyrics(lyricsOHV["lyrics"],artist_name)])
                        continue

                except:
                    print("except")
                    writer.writerow(row + ["NULL"])
                    no_lyrics_tracks.append(tuple((x,artist_name,track_title)))
                    
            except:
                print("encoding error")
                writer.writerow(row + ["NULL"])
                no_lyrics_tracks.append(tuple((x,artist_name,track_title)))
    print("total finds in lyrics.ovh: " + str(count1))
    print("total finds on percents: " + str(((count1) / x)))
    print(no_lyrics_tracks)
        

def fixLyrics(lyric, artistName):    
    start_index = lyric.find("Paroles")    
    if start_index != -1:        
        end_index = lyric.find(artistName)        
        if end_index !=-1:
            end = end_index+len(artistName)            
            lyric = lyric.replace(lyric[start_index:end],"").lstrip()    
    return lyric
        
main()



