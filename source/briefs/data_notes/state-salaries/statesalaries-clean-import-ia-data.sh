SALDBPATH=./state-salaries.sqlite

function d_ia_cleanser(){
  perl -ne  's/\$(?=[0-9])//g; print;' |  # remove dollar signs
  perl -ne 's#(\d{2})/(\d{2})/(\d{4})#\3-\1-\2#g; print;' # fix the date MM/DD/YYYY
}

## get the schema
# cat <(head -n 1000  iowa-salaries.csv) <(tail -n 500 iowa-salaries.csv)  |
#   d_ia_cleanser |
#   csvsql -i sqlite --no-constraints --tables ia


sqlite3 $SALDBPATH <<EOF
DROP TABLE IF EXISTS ia;
CREATE TABLE ia (
  "Fiscal Year" INTEGER,
  "Department" VARCHAR,
  "Agency/Institution" VARCHAR,
  "Name" VARCHAR,
  "Gender" VARCHAR,
  "Place of Residence" VARCHAR,
  "Position" VARCHAR,
  "Base Salary" VARCHAR,
  "Base Salary Date" DATE,
  "Total Salary Paid" FLOAT,
  "Travel & Subsistence" FLOAT
);
EOF


# insert the data

cat iowa-salaries.csv |
  d_ia_cleanser |
  csvsql --no-constraints --no-inference  --no-create \
         --insert --tables ia --db sqlite:///$SALDBPATH


sqlite3 $SALDBPATH <<EOF
  CREATE INDEX "Department_on_ia" ON ia(Department);
  CREATE INDEX "Agency_Institution_on_ia" ON ia("Agency/Institution");
  CREATE INDEX "Position_on_ia" ON ia(Position) ;
EOF
