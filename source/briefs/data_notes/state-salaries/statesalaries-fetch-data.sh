
curl -o nj-salaries.csv 'https://data.nj.gov/api/views/iqwc-r2w7/rows.csv?accessType=DOWNLOAD'
curl -o iowa-salaries.csv 'https://data.iowa.gov/api/views/s3p7-wy6w/rows.csv?accessType=DOWNLOAD'
curl -o florida-salaries.csv 'http://dmssalaries.herokuapp.com/downloads/dmssalaries.csv'

for yr in $(seq 2011 2014); do
 curl -o ca-salaries-$yr.zip \
   "http://publicpay.ca.gov/Reports/RawExport.aspx?file=${yr}_StateDepartment.zip" && \
    unzip ca-salaries-$yr.zip
done
