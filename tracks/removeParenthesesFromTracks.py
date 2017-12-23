import csv

OUTPUT_FILE = 'albumsTracksMusicgraph.csv'
INPUT_FILE = 'albumsTracksMusicgraph2.csv'
def main():
    with open(INPUT_FILE, newline='') as f:
        reader = csv.reader(f)
        with open(OUTPUT_FILE, 'w') as outfile:
            writer =  csv.writer(outfile, lineterminator='\n')
            for row in reader:
                writer.writerow([row[0],row[1],removeParentheses(row[2]),
                                 row[3], row[4],
                                 row[5], row[6]])

def removeParentheses(trackName):
    str_arr = trackName.split("[")
    if len(str_arr) >1:
        print("Change :" +trackName)
        print("To :" + str_arr[0].rstrip())
    return str_arr[0].rstrip()

main()
