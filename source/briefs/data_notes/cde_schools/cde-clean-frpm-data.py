from xlrd import open_workbook
from collections import OrderedDict
from csv import DictWriter
from glob import glob
import re


headers_history = {

    range(2009, 2010): [
        'county_code', 'district_code', 'school_code',
        'charter_school_number',
        'county_name', 'district_name', 'school_name',
        'low_grade', 'high_grade',
        'enrollment_ages_5_to_17', 'free_meal_count_ages_5_to_17',
        'reduced_price_meals_ages_5_to_17',
        'total_frpm', 'total_frpm_pct'  # counted from Oct 2009
    ],
    range(2014, 2015): [
        'year',
        'county_code', 'district_code', 'school_code',
        'county_name', 'district_name', 'school_name',
        'district_type', 'school_type', 'educational_option_type',
        'nslp_provision_status', 'is_charter_school',
        'charter_school_number', 'charter_funding_type', 'irc',
        'low_grade', 'high_grade',
        'enrollment_k_12',
        'free_meal_count_k_12', 'free_meal_pct_eligible_k_12',
        'frpm_count_k_12', 'frpm_pct_eligible_k_12',
        'enrollment_ages_5_to_17',
        'free_meal_count_ages_5_to_17',
        'free_meal_pct_eligible_ages_5_to_17',
        'frpm_count_ages_5_to_17', 'frpm_pct_eligible_ages_5_17',
        'calpads_certification_status'
    ]
}


common_headers = [
        'year',
        'county_code', 'district_code', 'school_code',
        'county_name', 'district_name', 'school_name',
        'low_grade', 'high_grade',
        'enrollment_ages_5_to_17',
        'free_meal_count_ages_5_to_17',
        'free_meal_pct_eligible_ages_5_to_17',
        'frpm_count_ages_5_to_17', 'frpm_pct_eligible_ages_5_17']



for xlsname in glob('./frpm*.xls'):
    data = []
    # extract the year numbers from the file name
    # eg
    # http://www.cde.ca.gov/ds/sd/sd/documents/frpm0910.xls
    # http://www.cde.ca.gov/ds/sd/sd/documents/frpm1415.xls

    yr_1, yr_2 = [int('20' + m) for m in re.search('(\d{2})(\d{2})(?=\.xls)', xlsname).groups()]
    headers = next(v for k, v in headers_history.items() if yr_1 in k)

    # hacky
    starting_row =  2 if yr_1 == 2014 else 1

    # open the Excel workbook
    book = open_workbook(xlsname)
    # open the first non-empty spreadsheet
    sheet = [s for s in book.sheets() if s.nrows > 5000][0]
    print(xlsname, "has", sheet.nrows, "rows")
    for x in range(starting_row, sheet.nrows):
        rowvals = sheet.row_values(x)
        row = dict(zip(headers, rowvals))
        d = dict.fromkeys(common_headers, None)
        d['year'] = '%s-%s' % (yr_1, yr_2)
        for key in common_headers:
            if row.get(key):
                d[key] = row[key]
        data.append(d)
        # write to file
    csvname = "frpm-%s-%s--cleaned.csv" % (yr_1, yr_2)
    cfile = open(csvname, 'w', encoding = 'utf-8')
    writer = DictWriter(cfile, fieldnames = common_headers)
    writer.writeheader()
    writer.writerows(data)
    cfile.close()
