from datetime import timedelta
from datetime import datetime
from collections import OrderedDict
from csv import DictWriter, DictReader
import re

DATE_HEADERS = {
    'INMATE_ACTIVE_ROOT': ['BirthDate', 'ReceiptDate', 'PrisonReleaseDate'],
    'INMATE_ACTIVE_INCARHIST': ['ReceiptDate', 'ReleaseDate'],
    'INMATE_ACTIVE_OFFENSES_CPS': ['OffenseDate', 'DateAdjudicated'],
    'INMATE_ACTIVE_OFFENSES_prpr': ['OffenseDate', 'DateAdjudicated']
}


def delta_years(today, d2):
    return int((d2 - today).days / 365.25)

def translate_date_century(date_string):
    refyear =  datetime.now().year
    refcentury = (refyear // 100) * 100
    mth, dy, yr = [int(d) for d in re.match('(\d{2})/(\d{2})/(\d{2})', date_string).groups()]
    # total hack for now: the only invalid date is 02/29/00
    if mth == 2 and dy == 29 and yr == 0:
        leapd =  datetime(2000, 2, 29 )
        return {'past': leapd, 'current': leapd, 'next': leapd}
    else:
        return {'past': datetime(refcentury - 100 + yr, mth, dy),
            'current': datetime(refcentury + yr,  mth, dy),
            'next': datetime(refcentury + 100 + yr, mth, dy)
        }


def fix_row_date(row, headers):
    today = datetime.now()
    for dh in headers:
        if row[dh]:
            pd = translate_date_century(row[dh])
            if 'BirthDate' == dh:
                # youngest inmate is 15
                if delta_years(today, pd['current']) >= 15:
                    this_date = pd['current']
                else:
                    this_date = pd['past']
            # past dates
            elif dh in ['ReceiptDate',  'ReleaseDate', 'DateAdjudicated', 'OffenseDate']:
                if pd['current'].year <= today.year:
                    this_date = pd['current']
                else:
                    this_date = pd['past']
            elif 'PrisonReleaseDate' == 'dh':
                # assume that PrisonReleaseDate has been set
                if delta_years(row['PrisonReleaseDate'], pd['current'].year) >= 1:
                    # this dangerously assumes <100 year sentences
                    this_date = pd['current']
                else:
                    this_date = pd['next']
            # set the date
            row[dh] = this_date
        else:
            row[dh] = None




for fname, date_headers in DATE_HEADERS.items():
    ofile = open(fname + '.csv')
    print(fname)
    headers = ofile.readline().strip().split(',')
    oldcsv = DictReader(ofile, fieldnames = headers)
    nfile = open(fname + "-cleaned.csv", "w")
    newcsv = DictWriter(nfile, fieldnames = headers)
    newcsv.writeheader()
    for idx, row in enumerate(oldcsv):
        try:
            fix_row_date(row, date_headers)
            newcsv.writerow(row)
        except Exception as err:
            print(fname, ': ', idx)
            print(row)

    ofile.close()
    nfile.close()

