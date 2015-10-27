import datetime
import csv
from io import StringIO
FNAME = 'sf311.csv'
CNAME = 'sf311-cleaned.csv'
f = open(FNAME)
oldheaders = list(csv.reader(StringIO(f.readline())))[0]
rows = csv.reader(f)

newheaders = oldheaders[0:13] + [oldheaders[14]] + ['latitude', 'longitude']
o = open(CNAME, 'w')
writer = csv.writer(o)
writer.writerow(newheaders)

for row in rows:
  # fix dates: Opened, Closed, Updated
  for i in [1, 2, 3]:
    if row[i]:
      nt = datetime.datetime.strptime(row[i], '%m/%d/%Y %I:%M:%S %p')
      row[i] = nt.strftime("%Y-%m-%d %H:%M:%S")

  # get Latitude, Longitude
  # from "(37.7762305280824, -122.414711168083)"
  if '(3' in row[13]:
    latlng = row[13][1:-1].split(', ')
  else:
    latlng = [None, None]
  writer.writerow(row[0:13] + [row[14]] + latlng)

o.close()
f.close()
