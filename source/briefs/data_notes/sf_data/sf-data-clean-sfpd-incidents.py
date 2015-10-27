import datetime
import csv
from io import StringIO
FNAME = 'sfcrime.csv'
CNAME = 'sfcrime-cleaned.csv'
# read the dirty file
f = open(FNAME)
dirty_headers = list(csv.reader(StringIO(f.readline())))[0]
rows = csv.reader(f)


# read the new file
clean_headers = (dirty_headers[0:3] + # IncidntNum, Category, Descript
    dirty_headers[6:11]  +            # PdDistrict, Resolution, Address, X, Y
    dirty_headers[12:13] +             # PdId
    ['datetime']
)

o = open(CNAME, 'w')
writer = csv.writer(o)
writer.writerow(clean_headers)

for row in rows:
  # create the datetime field,
  # which is 'Date' + 'Time' (fields 4 and 5)
  # 10/12/2015, 23:59
    xt = row[4] + ' ' + row[5]
    dt_val = datetime.datetime.strptime(xt, '%m/%d/%Y %H:%M')
    writer.writerow(row[0:3] + row[6:11] + row[12:13] + [dt_val])

o.close()
f.close()
