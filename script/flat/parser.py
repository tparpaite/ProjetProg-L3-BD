import csv
import MySQLdb
db = MySQLdb.connect(host="localhost", user="root", passwd="root", db="SummerOlympicGames_Flat")
cursor = db.cursor()


all_medalists     = csv.reader(open("../../csv/all_medalists.csv"))
IOC_country_codes = csv.reader(open("../../csv/IOC_country_codes.csv"))
IOC_country_codes.next()

IOC=dict()
for row in IOC_country_codes:
    IOC[row[1]] = {'nom': row[0], 'iso': row[2]}

all_medalists.next();
query = "INSERT INTO `medallist` (`city`, `edition`, `sport`, `discipline`, `athlete`, `NOC`, `country`, `ISO_code`, `gender`, `event`, `event_gender`, `medal`) \
         VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"

for row in all_medalists:
    data = (row[0], row[1], row[2], row[3], row[4], row[5], IOC[row[5]]['nom'], IOC[row[5]]['iso'], row[6], row[7], row[8], row[9])
    try:
        cursor.execute(query, data)
    except Exception as e:
        print(e)
        print(data);
db.commit()
