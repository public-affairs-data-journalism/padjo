from xlrd import open_workbook
from collections import OrderedDict
from csv import DictWriter
COMMON_HEADERS = [
    'year',
    'cds',
    'county_number',
    'district_number',
    'school_number',
    'county_name',
    'district_name',
    'school_name',
    'enrolled_9_12th_graders',
    'enrolled_12th_graders',
    'number_tested',
    'pct_tested',
    'reading_mean',
    'math_mean',
    'writing_mean',
    'total_mean',
    'count_gte_1500',
    'pct_gte_1500'
]

COMMON_HEADERS_AS_FLOATS = [
 'pct_tested',
 'pct_gte_1500'
]

COMMON_HEADERS_AS_INTEGERS = [
 'reading_mean',
 'math_mean',
 'writing_mean',
 'total_mean',
 'count_gte_1500',
 'enrolled_9_12th_graders',
 'enrolled_12th_graders',
 'number_tested'
]


HEADERS_PRE_2014_LOOKUP = {
    'county_number': 0,
    'district_number': 1,
    'school_number': 2,
    'county_name': 3,
    'district_name': 4,
    'school_name': 5,
    'enrolled_12th_graders': 6,
    'number_tested': 7,
    'pct_tested': 8,
    'reading_mean': 9,
    'math_mean': 10,
    'writing_mean': 11,
    'total_mean': 12,
    'count_gte_1500': 13,
    'pct_gte_1500': 14
}

HEADERS_2014_LOOKUP = {
    'cds': 0,
    'county_name': 4,
    'district_name': 3,
    'school_name': 2,
    'enrolled_9_12th_graders': 5,
    'number_tested': 6,
    'reading_mean': 7,
    'math_mean': 8,
    'writing_mean': 9,
    'count_gte_1500': 10,
    'pct_gte_1500': 11
}



for yr in range(10, 15):
    yrnum =  2000 + yr
    year = "%s-%s" % (yrnum - 1, yrnum)
    print("Cleaning: ", year)

    xls_name = 'sat%s.xls' % yr
    book = open_workbook(xls_name)
    sheet = book.sheets()[0]
#    headers = [v.replace('\n', ' ') for v in sheet.row_values(3)]
    csv_name = 'sat-%s-cleaned.csv' % year
    c = open(csv_name, 'w')
    writer = DictWriter(c, fieldnames = COMMON_HEADERS)
    writer.writeheader()
    for i in range(4, sheet.nrows):
        rowvals = sheet.row_values(i)
        d = dict.fromkeys(COMMON_HEADERS, None)
        d['year'] = year
        try:
            yr_headers =  HEADERS_2014_LOOKUP if yrnum >= 2014 else HEADERS_PRE_2014_LOOKUP
            for k, v in yr_headers.items():
                d[k] = rowvals[v]

            # do some sanity checking
            # validate the floats
            for col in COMMON_HEADERS_AS_FLOATS:
                if not d[col] or d[col] in ['NA', '.', '*', 'E']:
                    # this is some weird stand-in for null
                    d[col] = None
                else:
                # this should throw error for non floats
                    d[col] = float(d[col])
            for col in COMMON_HEADERS_AS_INTEGERS:
                if not d[col] or d[col] in ['NA', '*']:
                    d[col] = None
                else:
                # this should throw error for non floats
                    d[col] = round(float(d[col]))
        except Exception as err:
            print(type(err), str(err))
            print(rowvals)

        else:
            # write the row to file
            writer.writerow(d)
    c.close()



# browse in SH
"""
for fx in "1 6" "7 9" "10 13" "14 18"; do
    printf "\n\n\n"
    echo "-------------------"
    for fname in sat-2010-2011-cleaned.csv sat-2013-2014-cleaned.csv; do
        head $fname | csvcut -c $(seq -s, $fx | sed 's/,$//') | csvlook
    done
done
"""
