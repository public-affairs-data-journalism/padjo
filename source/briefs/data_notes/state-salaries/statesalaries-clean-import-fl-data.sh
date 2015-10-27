SALDBPATH=./state-salaries.sqlite

function d_fl_cleanser(){
  perl -ne  's/\$(?=\d+)//g; print;' |  # remove dollar signs
  perl -ne  's/,(?=\d{3})//g; print;' |  # remove comma separator
  perl -ne 's#(\d{2})/(\d{2})/(\d{4})#\3-\1-\2#g; print;' # fix the date MM/DD/YYYY
}

## get the schema
# cat <(head -n 1000  florida-salaries.csv) <(tail -n 500 florida-salaries.csv)  |
#   d_fl_cleanser |
#   csvsql -i sqlite --no-constraints --tables fl


sqlite3 $SALDBPATH <<EOF
DROP TABLE IF EXISTS fl;
CREATE TABLE fl (
  "Agency Name" VARCHAR,
  "Budget Entity" VARCHAR,
  "Position Number" VARCHAR,
  "Last Name" VARCHAR,
  "First Name" VARCHAR,
  "M.I." VARCHAR,
  "Employee Type" VARCHAR,
  "Full/Part Time" VARCHAR,
  "Class Code" VARCHAR,
  "Class Title" FLOAT,
  "State Hire Date" FLOAT,
  "Salary" FLOAT,
  "OPS Hourly Rate" FLOAT
);
EOF


# insert the data

cat florida-salaries.csv |
  d_fl_cleanser |
  csvsql --no-constraints --no-inference  --no-create \
         --insert --tables fl --db sqlite:///$SALDBPATH


sqlite3 $SALDBPATH <<EOF
  CREATE INDEX "_on_ia" ON ia()
  CREATE INDEX "_on_ia" ON ia()
  CREATE INDEX "_on_ia" ON ia()
EOF
