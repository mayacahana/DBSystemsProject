import csv
import requests

INPUT_FILE = "events\\EventsForArtists_new.csv"
OUTPUT_FILE = "countries\\country.csv"

def main():
    country_col_index = 9
    x = 0
    countries = set()
    
    with open(INPUT_FILE, 'r') as fin:
        reader = csv.reader(fin, lineterminator='\n')

        for row in reader:
            x = x + 1
            print(x)
            if (row[2] == 'error'):
                continue
            country = row[country_col_index]
            if (country not in countries):
                countries.add(country)

    print(countries)


    with open(OUTPUT_FILE, 'w') as fout:
        writer = csv.writer(fout, lineterminator='\n')
        for country in countries:
            writer.writerow([country])
    
main()


