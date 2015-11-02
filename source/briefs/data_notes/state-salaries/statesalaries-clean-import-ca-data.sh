SALDBPATH=./state-salaries.sqlite

function d_ca_cleanser(){
  iconv -f windows-1252 -t UTF-8 |
  perl -ne 's#(\d{2})/(\d{2})/(\d{4})#\3-\1-\2#g; print;' # fix the date MM/DD/YYYY
}

# note: CA files have 5 lines of boilerplate that must be skipped

## We can use csvsql to generate a pretty good CREATE TABLE
## statement based on a sample of the data
# cat <(head -n 1000  2014_StateDepartment.csv | tail -n +5) \
#     <(tail -n 200 2013_StateDepartment.csv)                \
#     <(tail -n 200 2012_StateDepartment.csv) |
#     d_ca_cleanser |
#     csvsql -i sqlite --no-constraints --tables ca

sqlite3 $SALDBPATH <<EOF
DROP TABLE IF EXISTS ca;
CREATE TABLE ca (
  "Year" INTEGER,
  "Entity Type" VARCHAR,
  "Entity Group" VARCHAR,
  "Entity Name" VARCHAR,
  "Department / Subdivision" VARCHAR,
  "Position" VARCHAR,
  "Elected Official" BOOLEAN,
  "Judicial" BOOLEAN,
  "Other Positions" VARCHAR,
  "Min Classification Salary" FLOAT,
  "Max Classification Salary" FLOAT,
  "Reported Base Wage" VARCHAR,
  "Regular Pay" FLOAT,
  "Overtime Pay" FLOAT,
  "Lump-Sum Pay" FLOAT,
  "Other Pay" FLOAT,
  "Total Wages" FLOAT,
  "Defined Benefit Plan" FLOAT,
  "Employees Retirement Cost Covered" INTEGER,
  "Deferred Compensation Plan" INTEGER,
  "Health Dental Vision" FLOAT,
  "Total Retirement and Health Cost" FLOAT,
  "Pension Formula" VARCHAR,
  "Entity URL" VARCHAR,
  "Entity Population" VARCHAR,
  "Last Updated" DATE,
  "Entity County" VARCHAR,
  "Special District Activities" VARCHAR
);
EOF


# insert the data
for yr in 2011 2012 2013 2014; do
  fname=${yr}_StateDepartment.csv
  echo $fname
  # all together now
  sed '1,4d' < $fname |
    d_ca_cleanser |
    csvformat -U 1 |
    head -n 10000 |
    csvsql --no-constraints --no-inference  --no-create \
          --insert --tables ca --db sqlite:///$SALDBPATH
done


sqlite3 $SALDBPATH <<EOF
  CREATE INDEX "entity_type_on_ca" ON ca("Entity Type");
  CREATE INDEX "entity_name_on_ca" ON ca("Entity Name");
  CREATE INDEX "Entity_County_on_ca" ON ca("Entity County");
  CREATE INDEX "Department_Subdivision_on_ca" ON ca("Department / Subdivision");
  CREATE INDEX "Position_on_ca" ON ca(Position);
EOF
