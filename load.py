import postgrez
import pandas as pd

# data = pd.read_csv('data/test.txt', delimiter='|')

# sed '1d' data/sqlcontact_v2.csv > data/tmpfile.txt;
postgrez.load(setup='local', table_name='contact',
                filename='data/tmpfile2.txt', delimiter=',', null='NULL')


## contact table
# \copy contact FROM  './data/sqlcontact_v2.csv' CSV HEADER QUOTE '"' NULL 'NULL'


## account table
# \copy accounts FROM  './data/accounts_scrubbed2.csv' DELIMITER ',' CSV HEADER


## activity type
# \copy activity_type FROM  './data/activitytype_000.txt' DELIMITER '|' CSV HEADER


## activity
# \copy activity FROM  './data/activity_000.txt' DELIMITER '|' CSV HEADER


with open("./data/accounts_scrubbed2.csv") as f:
# with open("./data/accounts_test.txt") as f:
    lines = [[val.strip() for val in line.split(',')] for line in f]
    for i,line in enumerate(lines):
        # print len(line)
        # print (i,line[1], type(line[1]))
        try:
            if line[1] != '':
                int(line[1].replace('.0',''))
        except:
            print ('error on line %s' % i)
            print (line)
        # cols = [col for col in ]



# postgrez.export("local", query="past_activites", filename="past_activites.csv")
# postgrez.export("local", query="past_transactions", filename="past_transactions.csv")
postgrez.export("local", query="driver_meta", filename="driver_meta.csv")
