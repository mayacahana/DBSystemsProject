import csv
import requests

INPUT_FILE = "artists\\artistsInfoMusicgraph.csv"
OUTPUT_FILE = "genres\\genre.csv"

def main():
    genre_col_index = 3
    x = 0
    genres = set()
    
    with open(INPUT_FILE, 'r') as fin:
        reader = csv.reader(fin, lineterminator='\n')

        for row in reader:
            genre = row[genre_col_index]
            if (genre not in genres):
                genres.add(genre)

    genres.remove('N\\A')
    print('\n')
    print(genres)


    with open(OUTPUT_FILE, 'w') as fout:
        writer = csv.writer(fout, lineterminator='\n')
        for genre in genres:
            writer.writerow([genre])
    
main()


