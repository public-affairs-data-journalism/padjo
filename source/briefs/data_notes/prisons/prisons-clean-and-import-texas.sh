SALDBPATH=./state-prisons.sqlite
TABLE_NAME=texas-inmates
DATA_FILENAME=./texas/texas-inmates-cleaned.csv

function dnptx_cleanser(){
  sed 's/#NULL!//g'
}

## convert from Excel
# in2csv './texas/texas-inmates.xlsx' | dnptx_cleanser > $DATA_FILENAME


## get the schema
#cat <(head -n 1000  $DATA_FILENAME) <(tail -n 500 $DATA_FILENAME)  |
#   csvsql -i sqlite --no-constraints --tables $TABLE_NAME

sqlite3 $SALDBPATH <<EOF
DROP TABLE IF EXISTS "$TABLE_NAME";
CREATE TABLE "$TABLE_NAME" (
  "SID Number" VARCHAR,
  "TDCJ Number" VARCHAR,
  "Name" VARCHAR,
  "Current Facility" VARCHAR,
  "Gender" VARCHAR,
  "Race" VARCHAR,
  "DOB" DATE,
  "Projected Release" DATE,
  "Maximum Sentence Date" DATE,
  "Parole Eligibility Date" DATE,
  "Case Number" VARCHAR,
  "County" VARCHAR,
  "Offense Code" VARCHAR,
  "Offense" VARCHAR,
  "Sentence Date" DATE,
  "Offense Date" DATE,
  "Sentence Years" VARCHAR,
  "Last Parole Decision" VARCHAR,
  "Next Parole Review Date" VARCHAR,
  "Parole Review Status" VARCHAR
);
EOF

# insert into the database

cat $DATA_FILENAME |
  csvsql --no-constraints --no-inference  --no-create \
         --insert --tables $TABLE_NAME --db sqlite:///$SALDBPATH


# Create the indexes
sqlite3 $SALDBPATH <<EOF
  CREATE INDEX tdcj_on_texasinmates ON "$TABLE_NAME"("TDCJ Number");
  CREATE INDEX Offense_on_texasinmates ON "$TABLE_NAME"("Offense");
  CREATE INDEX OffenseCode_on_texasinmates ON "$TABLE_NAME"("Offense Code");
  CREATE INDEX DOB_on_texas_inmates ON "$TABLE_NAME"(DOB);
  CREATE INDEX sentence_on_texas_inmates ON "$TABLE_NAME"("Sentence Date");
  CREATE INDEX Projected_Release_on_texas_inmates ON "$TABLE_NAME"("Projected Release");
  CREATE INDEX max_sentence_on_texas_inmates ON "$TABLE_NAME"("Maximum Sentence Date");
  CREATE INDEX parole_date_on_texas_inmates ON "$TABLE_NAME"("Parole Eligibility Date");
EOF
