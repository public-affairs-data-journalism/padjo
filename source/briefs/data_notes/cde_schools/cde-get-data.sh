
# getting the school data

echo "ftp://ftp.cde.ca.gov/demo/schlname/pubschls.txt
http://www.cde.ca.gov/ds/sp/ai/documents/sat14.xls
http://www.cde.ca.gov/ds/sp/ai/documents/sat13.xls
http://www.cde.ca.gov/ds/sp/ai/documents/sat12.xls
http://www.cde.ca.gov/ds/sp/ai/documents/sat11.xls
http://www.cde.ca.gov/ds/sp/ai/documents/sat10.xls
https://www.cdph.ca.gov/programs/immunize/Documents/2014-15%20CA%20Kindergarten%20Data.xlsx
https://www.cdph.ca.gov/programs/immunize/Documents/2013-2014%20CA%20Kindergarten%20Data.xls
https://www.cdph.ca.gov/programs/immunize/Documents/2012-2013%20California%20Kindergarten%20Data.xls
https://www.cdph.ca.gov/programs/immunize/Documents/2011-2012%20CA%20Kindergarten%20Data.xls
https://www.cdph.ca.gov/programs/immunize/Documents/2010-2011CAKindergartenData%20(2).xls
http://www.cde.ca.gov/ds/sd/sd/documents/frpm0910.xls
http://www.cde.ca.gov/ds/sd/sd/documents/frpm1314.xls
http://www.cde.ca.gov/ds/sd/sd/documents/frpm1415.xls" | while read url; do
  echo $url
  curl $url -sO &
done


for stub in frpm sat; do
  mkdir -p $stub
  mv $stub*.* $stub/
done

mkdir -p immune_kinder
find . -name '*Kinder*' | while read -r fn; do
  mv $fn immune_kinder/
done

