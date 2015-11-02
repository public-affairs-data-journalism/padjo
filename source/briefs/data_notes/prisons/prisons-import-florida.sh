SALDBPATH=./state-prisons.sqlite

################################

SLUGNAME=INMATE_ACTIVE_INCARHIST
TABLE_NAME=FLORIDA_$SLUGNAME
DATA_FILENAME=./florida/$SLUGNAME-cleaned.csv

# get the schema
# cat <(head -n 1000  $DATA_FILENAME) <(tail -n 500 $DATA_FILENAME)  |
#   csvsql -i sqlite --no-constraints --tables $TABLE_NAME

sqlite3 $SALDBPATH <<EOF
DROP TABLE IF EXISTS "$TABLE_NAME";
CREATE TABLE "$TABLE_NAME" (
  "DCNumber" VARCHAR,
  "ReceiptDate" DATE,
  "ReleaseDate" DATE
);
EOF


cat $DATA_FILENAME |
  csvsql --no-constraints --no-inference  --no-create \
           --insert --tables $TABLE_NAME --db sqlite:///$SALDBPATH



################################
SLUGNAME=INMATE_ACTIVE_ROOT
TABLE_NAME=FLORIDA_$SLUGNAME
DATA_FILENAME=./florida/$SLUGNAME-cleaned.csv


sqlite3 $SALDBPATH <<EOF
DROP TABLE IF EXISTS "$TABLE_NAME";
CREATE TABLE "$TABLE_NAME" (
  "DCNumber" VARCHAR,
  "LastName" VARCHAR,
  "FirstName" VARCHAR,
  "MiddleName" VARCHAR,
  "NameSuffix" VARCHAR,
  "Race" VARCHAR,
  "Sex" VARCHAR,
  "BirthDate" DATE,
  "HairColor" VARCHAR,
  "EyeColor" VARCHAR,
  "Height" INTEGER,
  "Weight" INTEGER,
  "PrisonReleaseDate" DATE,
  "ReceiptDate" DATE,
  releasedateflag_descr VARCHAR,
  custody_description VARCHAR,
  "FACILITY_description" VARCHAR
);
EOF

cat $DATA_FILENAME |
  csvsql --no-constraints --no-inference  --no-create \
           --insert --tables $TABLE_NAME --db sqlite:///$SALDBPATH




################################
SLUGNAME=INMATE_ACTIVE_OFFENSES_CPS
TABLE_NAME=FLORIDA_$SLUGNAME
DATA_FILENAME=./florida/$SLUGNAME-cleaned.csv


sqlite3 $SALDBPATH <<EOF
DROP TABLE IF EXISTS "$TABLE_NAME";
CREATE TABLE "$TABLE_NAME" (
  "DCNumber" VARCHAR,
  "Sequence" INTEGER,
  "OffenseDate" DATE,
  "DateAdjudicated" DATE,
  "County" VARCHAR,
  "CaseNumber" VARCHAR,
  prisonterm VARCHAR,
  "ProbationTerm" VARCHAR,
  "ParoleTerm" VARCHAR,
  adjudicationcharge_descr VARCHAR,
  qualifier_descr VARCHAR,
  adjudication_descr VARCHAR
);
EOF



cat $DATA_FILENAME |
  csvsql --no-constraints --no-inference  --no-create \
           --insert --tables $TABLE_NAME --db sqlite:///$SALDBPATH



################################
SLUGNAME=INMATE_ACTIVE_OFFENSES_prpr
TABLE_NAME=FLORIDA_$SLUGNAME
DATA_FILENAME=./florida/$SLUGNAME-cleaned.csv


sqlite3 $SALDBPATH <<EOF
DROP TABLE IF EXISTS "$TABLE_NAME";
CREATE TABLE "$TABLE_NAME" (
  "DCNumber" VARCHAR,
  "Sequence" INTEGER,
  "OffenseDate" DATE,
  "DateAdjudicated" DATE,
  "County" VARCHAR,
  "CaseNumber" VARCHAR,
  prisonterm VARCHAR,
  "ProbationTerm" VARCHAR,
  "ParoleTerm" VARCHAR,
  adjudicationcharge_descr VARCHAR,
  qualifier_descr VARCHAR,
  adjudication_descr VARCHAR
);
EOF


cat $DATA_FILENAME |
  csvsql --no-constraints --no-inference  --no-create \
           --insert --tables $TABLE_NAME --db sqlite:///$SALDBPATH













# Create the indexes
sqlite3 $SALDBPATH <<EOF
  CREATE INDEX DCN_on_fl_INMATE_ACTIVE_ROOT ON "FLORIDA_INMATE_ACTIVE_ROOT"("DCNumber");
  CREATE INDEX birthdate_on_fl_INMATE_ACTIVE_ROOT ON "FLORIDA_INMATE_ACTIVE_ROOT"("BirthDate");
  CREATE INDEX release_date_on_fl_INMATE_ACTIVE_ROOT ON "FLORIDA_INMATE_ACTIVE_ROOT"("PrisonReleaseDate");
  CREATE INDEX Receipt_date_on_fl_INMATE_ACTIVE_ROOT ON "FLORIDA_INMATE_ACTIVE_ROOT"("ReceiptDate");



  CREATE INDEX dcn_on_fl_INMATE_ACTIVE_INCARHIST ON "FLORIDA_INMATE_ACTIVE_INCARHIST"("DCNumber");
  CREATE INDEX release_date_on_fl_INMATE_ACTIVE_INCARHIST ON "FLORIDA_INMATE_ACTIVE_INCARHIST"("ReleaseDate");
  CREATE INDEX receipt_date_on_fl_INMATE_ACTIVE_INCARHIST ON "FLORIDA_INMATE_ACTIVE_INCARHIST"("ReceiptDate");



  CREATE INDEX dcn_on_fl_INMATE_ACTIVE_OFFENSES_CPS ON "FLORIDA_INMATE_ACTIVE_OFFENSES_CPS"("DCNumber");
  CREATE INDEX OffenseDate_on_fl_INMATE_ACTIVE_OFFENSES_CPS ON "FLORIDA_INMATE_ACTIVE_OFFENSES_CPS"("OffenseDate");
  CREATE INDEX adjudicationcharge_descr_fl_INMATE_ACTIVE_OFFENSES_CPS ON "FLORIDA_INMATE_ACTIVE_OFFENSES_CPS"("adjudicationcharge_descr");



  CREATE INDEX DCNumberon_fl_INMATE_ACTIVE_OFFENSES_prpr ON "FLORIDA_INMATE_ACTIVE_OFFENSES_prpr"("DCNumber");
  CREATE INDEX OffenseDateon_fl_INMATE_ACTIVE_OFFENSES_prpr ON "FLORIDA_INMATE_ACTIVE_OFFENSES_prpr"("OffenseDate");
  CREATE INDEX adjudicationcharge_descron_fl_INMATE_ACTIVE_OFFENSES_prpr ON "FLORIDA_INMATE_ACTIVE_OFFENSES_prpr"("adjudicationcharge_descr");


EOF
