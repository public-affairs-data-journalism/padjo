# creating a schema
# cat frpm-2009-2010--cleaned.csv <(tail -n +2 frpm-2014-2015--cleaned.csv) |
#    csvsql --tables frpm --no-constraints -i sqlite

# spotcheck
# for fn in *.csv; do
#     printf "\n\n\n$fn"
#     head -n 10 $fn | csvcut -c 1,2,3,4,5 | csvlook
#     head -n 10 $fn | csvcut -c 6,7,8,9,10 | csvlook
#     head -n 10 $fn | csvcut -c 11,12,13,14 | csvlook
# done

cdedbpath=../cde-schools.sqlite



sqlite3 $cdedbpath <<EOF
DROP TABLE IF EXISTS frpm;
CREATE TABLE frpm (
  year VARCHAR,
  county_code VARCHAR,
  district_code VARCHAR,
  school_code VARCHAR,
  county_name VARCHAR,
  district_name VARCHAR,
  school_name VARCHAR,
  low_grade VARCHAR,
  high_grade VARCHAR,
  enrollment_ages_5_to_17 INTEGER,
  free_meal_count_ages_5_to_17 INTEGER,
  free_meal_pct_eligible_ages_5_to_17 FLOAT,
  frpm_count_ages_5_to_17 INTEGER,
  frpm_pct_eligible_ages_5_17 FLOAT
);

EOF



# Insert data
for fn in *.csv; do
  csvsql --insert --no-create \
  --tables frpm --db sqlite:///$cdedbpath $fn
done

sqlite3 $cdedbpath <<EOF
  CREATE INDEX year_on_frpm ON frpm(year);
  CREATE INDEX school_code_on_frpm ON frpm(school_code);
  CREATE INDEX county_name_school_code_on_frpm ON frpm(county_name, school_code);
EOF
