import csv
import requests

INPUT_FILE = "artists\\artistsInfoMusicgraph.csv"
OUTPUT_FILE1 = "countries\\country.csv"
OUTPUT_FILE2 = "genres\\genre.csv"

def main():
    country_col_index = 2
    genre_col_index = 3
    count1 = 0
    x = 0
    countries = set()
    genres = set()
    
    with open(INPUT_FILE, 'r') as fin:
        reader = csv.reader(fin, lineterminator='\n')

        for row in reader:
            country = row[country_col_index]
            genre = row[genre_col_index]
            if (country not in countries):
                countries.add(country)
            if (genre not in genres):
                genres.add(genre)

    countries.remove('N\\A')
    genres.remove('N\\A')
    print(countries)
    print('\n')
    print(genres)


    with open(OUTPUT_FILE1, 'w') as fout1, open(OUTPUT_FILE2, 'w') as fout2:
        writer1 = csv.writer(fout1, lineterminator='\n')
        writer2 = csv.writer(fout2, lineterminator='\n')
        for country in countries:
            writer1.writerow([country])
        for genre in genres:
            writer2.writerow([genre])
    
main()


