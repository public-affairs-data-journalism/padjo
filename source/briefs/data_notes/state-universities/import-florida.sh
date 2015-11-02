SALDBPATH=./university_salaries.sqlite
TABLE_NAME='fl_positions'
CSV_NAME=florida-salaries-2015-11--cleaned.csv

# Get the schema
csvsql -i sqlite --no-constraints \
  --tables $TABLE_NAME < $CSV_NAME


sqlite3 $SALDBPATH <<EOF
DROP TABLE IF EXISTS "$TABLE_NAME";
CREATE TABLE "$TABLE_NAME" (
  "University" VARCHAR,
  "BudgetEntity" VARCHAR,
  "PositionNumber" VARCHAR,
  "LastName" VARCHAR,
  "FirstName" VARCHAR,
  "MI" VARCHAR,
  "EmployeeType" VARCHAR,
  "FTE" FLOAT,
  "ClassCode" VARCHAR,
  "ClassTitle" VARCHAR,
  "AnnualSalary" INTEGER,
  "OPSTermAmount" INTEGER
);
EOF


# insert the data
cat $CSV_NAME |
csvsql --no-constraints --no-inference  --no-create \
      --insert --tables $TABLE_NAME \
      --db sqlite:///$SALDBPATH

sqlite3 $SALDBPATH <<EOF
  CREATE INDEX "first_name_$TABLE_NAME" ON "$TABLE_NAME"("FirstName");
  CREATE INDEX "University_$TABLE_NAME" ON "$TABLE_NAME"("University");
  CREATE INDEX "BudgetEntity_$TABLE_NAME" ON "$TABLE_NAME"("BudgetEntity");
  CREATE INDEX "ClassCode_$TABLE_NAME" ON "$TABLE_NAME"("ClassCode");
  CREATE INDEX "ClassTitle_$TABLE_NAME" ON "$TABLE_NAME"("ClassTitle");
  CREATE INDEX "PositionNumber_$TABLE_NAME" ON "$TABLE_NAME"("PositionNumber");
EOF
