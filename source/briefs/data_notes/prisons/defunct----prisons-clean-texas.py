# use in2csv for now...

from xlrd import open_workbook, xldate_as_tuple
from datetime import datetime
from collections import OrderedDict
from csv import DictWriter
DATE_HEADERS = [
'DOB', 'Projected Release',
'Maximum Sentence Date' , 'Parole Eligibility Date',
'Sentence Date', 'Offense Date'
]

xls_name = 'texas-inmates.xlsx'
csv_name = 'texas-inmates-cleaned.csv'

wb = open_workbook(xls_name)
wbdatemode = wb.datemode
sheet = wb.sheets()[0]
headers = sheet.row_values(0)


c = open(csv_name, 'w')
writer = DictWriter(c, fieldnames = headers)
writer.writeheader()
for n in range(1, sheet.nrows):
    print(n)
    rvals = sheet.row_values(n)
    row = OrderedDict(zip(headers, rvals))
    # fix up the dates
    if row['Parole Eligibility Date'] == '#NULL!':
        row['Parole Eligibility Date'] = None
    for dh in DATE_HEADERS:
        if row[dh]:
            dateval = datetime(*xldate_as_tuple(row[dh], datemode = wbdatemode))
            row[dh] = dateval.strftime("%Y-%m-%d")
    # write the data
    writer.writerow(row)



# Notes:
# Row 359 has a NULL for Sentence Date
