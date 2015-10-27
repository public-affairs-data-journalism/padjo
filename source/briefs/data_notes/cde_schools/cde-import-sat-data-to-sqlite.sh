sqlite3 cde-schools.sqlite <<EOF
DROP TABLE IF EXISTS sat_scores;
CREATE TABLE sat_scores (
  year VARCHAR,
  cds VARCHAR,
  county_number VARCHAR,
  district_number VARCHAR,
  school_number VARCHAR,
  county_name VARCHAR,
  district_name VARCHAR,
  school_name VARCHAR,
  enrolled_9_12th_graders INTEGER,
  enrolled_12th_graders INTEGER,
  number_tested INTEGER,
  pct_tested FLOAT,
  reading_mean INTEGER,
  math_mean INTEGER,
  writing_mean INTEGER,
  total_mean INTEGER,
  count_gte_1500 INTEGER,
  pct_gte_1500 FLOAT
);
EOF



# Insert data
for fn in *.csv; do
  csvsql --insert --no-create \
  --tables sat_scores --db sqlite:///cde-schools.sqlite $fn
done

sqlite3 cde-schools.sqlite <<EOF
  CREATE INDEX year_on_sat_scores ON sat_scores(year);
  CREATE INDEX cds_on_sat_scores ON sat_scores(cds);
EOF
