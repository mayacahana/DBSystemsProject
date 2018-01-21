import csv
INPUT_FILE = "tracksWithLyrics2.csv"
OUTPUT_FILE = "tracksWithLyrics.csv"


def main():
    with open(INPUT_FILE, 'r') as fin, open(OUTPUT_FILE, 'w') as fout:
        reader = csv.reader(fin, lineterminator='\n')
        writer = csv.writer(fout, lineterminator='\n')
        for row in reader:
            row[7] = fixLyrics(row[7])
            writer.writerow(row)


def fixLyrics(lyric):    
    start_index = lyric.find("Paroles")    
    if start_index != -1:        
        end_index = lyric.find("\n")        
        if end_index !=-1:
            end = end_index+1           
            lyric = lyric.replace(lyric[start_index:end],"").lstrip()    
    return lyric
        
main()
