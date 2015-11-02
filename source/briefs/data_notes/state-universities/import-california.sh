SALDBPATH=./university_salaries.sqlite
TABLE_NAME='ca_positions'
CSV_NAME=ca-combined-higher-ed-2014--cleaned.csv

# Get the schema
# csvsql -i sqlite --no-constraints \
#   --tables $TABLE_NAME < $CSV_NAME


sqlite3 $SALDBPATH <<EOF
DROP TABLE IF EXISTS "$TABLE_NAME";
CREATE TABLE "$TABLE_NAME" (
  first_name_guess VARCHAR,
  "Employee Name" VARCHAR,
  "Job Title" VARCHAR,
  "Base Pay" FLOAT,
  "Overtime Pay" VARCHAR,
  "Other Pay" VARCHAR,
  "Benefits" VARCHAR,
  "Total Pay" FLOAT,
  "Total Pay & Benefits" FLOAT,
  "Year" INTEGER,
  "Notes" VARCHAR,
  "Agency" VARCHAR
);
EOF


# insert the data
cat $CSV_NAME |
csvsql --no-constraints --no-inference  --no-create \
      --insert --tables $TABLE_NAME \
      --db sqlite:///$SALDBPATH

sqlite3 $SALDBPATH <<EOF
  CREATE INDEX "first_name_guess_$TABLE_NAME" ON "$TABLE_NAME"(first_name_guess);
  CREATE INDEX "job_title_$TABLE_NAME" ON "$TABLE_NAME"("Job Title");
  CREATE INDEX "agency_$TABLE_NAME" ON "$TABLE_NAME"("Agency");
EOF
