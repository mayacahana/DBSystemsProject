import csv

OUTPUT_FILE = 'artistsAlbumsMusicgraph.csv'
INPUT_FILE = 'artistsAlbumsMusicgraph3.csv'
def main():
    with open(INPUT_FILE, newline='') as f:
        reader = csv.reader(f)
        with open(OUTPUT_FILE, 'w') as outfile:
            writer =  csv.writer(outfile, lineterminator='\n')
            for row in reader:
                writer.writerow([row[0],row[1],row[2],
                                 removeParentheses(row[3]), row[4],
                                 row[5], row[6]])

def removeParentheses(albumName):
    str_arr = albumName.split("[")
    if len(str_arr) >1:
        print("Change :" +albumName)
        print("To :" + str_arr[0].rstrip())
    return str_arr[0].rstrip()

main()
