## This expects the fetching script to have run
## it compiles all the spreadsheets:
##   - k-immune.csv
##   - k-immune.json

import csv
import os.path
import re
from glob import glob
from os import makedirs
from xlrd import open_workbook

headers_history = {
    # e.g. 2014-2015
    range(2014, 2015): ['school_code', 'county', 'school_type', 'district_name', 'city',
            'school_name', 'enrollment', 'uptodate_num', 'uptodate_pct',
            'conditional_num', 'conditional_pct',
            'pme_num', 'pme_pct', 'pbe_num', 'pbe_pct',
            # special fields to 2014
            'pre_jan_pbe_num','pre_jan_pbe_pct',
            'hcp_counseled_pbe_num', 'hcp_counseled_pbe_pct',
            'religous_pbe_num', 'religous_pbe_pct',
            # same ol fields as before
            'dtp_num', 'dtp_pct', 'polio_num',
            'polio_pct', 'mmr2_num', 'mmr2_pct', 'hepb_num', 'hepb_pct',
            'vari_num', 'vari_pct', 'reported'
            ],
    range(2012, 2014): ['school_code', 'county', 'school_type', 'district_name', 'city',
            'school_name', 'enrollment', 'uptodate_num', 'uptodate_pct', 'conditional_num', 'conditional_pct',
            'pme_num', 'pme_pct', 'pbe_num', 'pbe_pct', 'dtp_num', 'dtp_pct', 'polio_num',
            'polio_pct', 'mmr2_num', 'mmr2_pct', 'hepb_num', 'hepb_pct', 'vari_num', 'vari_pct', 'reported'
        ],
    range(2011, 2012): ['school_code', 'county', 'school_type', 'district_name', 'city', 'school_name',
            'enrollment', 'uptodate_num', 'uptodate_pct', 'conditional_num', 'conditional_pct',
            'pme_num', 'pme_pct', 'pbe_num', 'pbe_pct', 'dtp_num', 'dtp_pct', 'polio_num',
            'polio_pct', 'mmr1_num', 'mmr1_pct', 'mmr2_num', 'mmr2_pct', 'hepb_num', 'hepb_pct',
            'vari_num', 'vari_pct', 'reported'
        ],
    range(2001, 2011): ['school_code', 'county', 'school_type', 'district_code', 'school_name',
            'enrollment', 'uptodate_num', 'uptodate_pct', 'conditional_num', 'conditional_pct',
            'pme_num', 'pme_pct', 'pbe_num', 'pbe_pct', 'dtp_num', 'dtp_pct', 'polio_num',
            'polio_pct', 'mmr1_num', 'mmr1_pct', 'mmr2_num', 'mmr2_pct', 'hepb_num', 'hepb_pct',
            'vari_num', 'vari_pct'
        ],
    range(2000,2001): ['school_code', 'county', 'school_type', 'district_code', 'school_name',
            'enrollment', 'uptodate_num', 'uptodate_pct', 'conditional_num', 'conditional_pct',
            'pme_num', 'pme_pct', 'pbe_num', 'pbe_pct', 'dtp_num', 'dtp_pct', 'polio_num',
            'polio_pct', 'mmr1_num', 'mmr1_pct', 'mmr2_num', 'mmr2_pct', 'hepb_num', 'hepb_pct'
        ]
}






common_headers = ['year',
    'school_code', 'county', 'school_type',
    'district_code', 'district_name', 'city', 'school_name',
    'enrollment', 'uptodate_num', 'uptodate_pct', 'conditional_num', 'conditional_pct',
    'pme_num', 'pme_pct', 'pbe_num', 'pbe_pct',
    'pre_jan_pbe_num','pre_jan_pbe_pct',
    'hcp_counseled_pbe_num', 'hcp_counseled_pbe_pct',
    'religous_pbe_num', 'religous_pbe_pct',
    'dtp_num', 'dtp_pct', 'polio_num',
    'polio_pct', 'mmr1_num', 'mmr1_pct', 'mmr2_num', 'mmr2_pct', 'hepb_num', 'hepb_pct',
    'vari_num', 'vari_pct',
    'reported']



sheets = []
for xlsname in glob(os.path.join('.', '*.xls*')):
    data = []
    # extract the year numbers from the file name
    # e.g. "2006" and "2007" from "K--2006-2007.xls"
    yr_1, yr_2 = re.search('(\d{4})-(\d{4})', xlsname).groups()
    the_year = int(yr_1)
    headers = next(v for k, v in headers_history.items() if the_year in k)


    # open the Excel workbook
    book = open_workbook(xlsname)
    # open the first non-empty spreadsheet
    sheet = [s for s in book.sheets() if s.nrows > 0][0]
    sheets.append(sheet)
    print(xlsname, "has", sheet.nrows, "rows")
    for x in range(1, sheet.nrows - 1): # note: we skip last row because it is just notes
        row = sheet.row_values(x)
        if re.search('\d{7}', str(row[0])):
            d = dict.fromkeys(common_headers, None)
            d.update(dict(zip(headers, row)))
            d['year'] = "%s-%s" % (yr_1, yr_2)
            # make sure these aren't floats
            for col in ['school_code', 'district_code', 'enrollment']:
                try:
                    if not d[col] or d[col] == ' ':
                        d[col] = None
                    else:
                        d[col] = int(d[col])
                except Exception as err:
                    print(str(err))
                    print(col, ':', d[col])
                    raise err
            data.append(d)
    # write to file
    csvname = "k-immune-%s-%s--cleaned.csv" % (yr_1, yr_2)
    cfile = open(csvname, 'w', encoding = 'utf-8')

    writer = csv.DictWriter(cfile, fieldnames = common_headers, delimiter = ',')
    writer.writeheader()
    writer.writerows(data)

