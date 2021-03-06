
import csv
import json

INPUT_FILE = 'EventsBandsInTown.json'
OUTPUT_FILE = 'EventsForArtists_new.csv'
cols = ['id', 'artist_id', 'on_sale_datetime','datetime','description','lineup','venue','city','country']

def create_csv():
    with open(OUTPUT_FILE, 'w+') as output:
        writer = csv.writer(output, lineterminator='\n')
        json_data = open(INPUT_FILE).read()
        artistsEvents = json.loads(json_data)
        #print "artists Event:", artistsEvents[1][1]['venue']['city']
        count = 0;
        for artist_events in artistsEvents:
            count += 1
            if (len(artist_events) == 2):
                if (artist_events[1] == 'error'):
                    print artist_events
                    writer.writerow([count, artist_events[0], artist_events[1]])
                    continue
            for event in artist_events:
                try:
                    _id = event[cols[0]]
                    artist_id = event[cols[1]]
                    on_sale_datetime = event[cols[2]]
                    datetime = event[cols[3]]
                    description = event[cols[4]]
                    lineup = event[cols[5]][0]
                    venue = event[cols[6]]['name']
                    city = event[cols[6]][cols[7]]
                    country = event[cols[6]][cols[8]]
                    writer.writerow([count,_id, artist_id,on_sale_datetime,datetime,description,lineup,venue,city,country])

                except:
                    continue



create_csv()