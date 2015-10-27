# imports public school data

# create the table
sqlite3 cde-schools.sqlite <<EOF
DROP TABLE IF EXISTS pubschls;
CREATE TABLE pubschls (
  "CDSCode" VARCHAR,
  "NCESDist" VARCHAR,
  "NCESSchool" VARCHAR,
  "StatusType" VARCHAR,
  "County" VARCHAR,
  "District" VARCHAR,
  "School" VARCHAR,
  "Street" VARCHAR,
  "StreetAbr" VARCHAR,
  "City" VARCHAR,
  "Zip" VARCHAR,
  "State" VARCHAR,
  "MailStreet" VARCHAR,
  "MailStrAbr" VARCHAR,
  "MailCity" VARCHAR,
  "MailZip" VARCHAR,
  "MailState" VARCHAR,
  "Phone" VARCHAR,
  "Ext" INTEGER,
  "Website" VARCHAR,
  "OpenDate" DATE,
  "ClosedDate" DATE,
  "Charter" BOOLEAN,
  "CharterNum" VARCHAR,
  "FundingType" VARCHAR,
  "DOC" VARCHAR,
  "DOCType" VARCHAR,
  "SOC" VARCHAR,
  "SOCType" VARCHAR,
  "EdOpsCode" VARCHAR,
  "EdOpsName" VARCHAR,
  "EILCode" VARCHAR,
  "EILName" VARCHAR,
  "GSoffered" VARCHAR,
  "GSserved" VARCHAR,
  "Virtual" VARCHAR,
  "Latitude" FLOAT,
  "Longitude" FLOAT,
  "AdmFName1" VARCHAR,
  "AdmLName1" VARCHAR,
  "AdmEmail1" VARCHAR,
  "AdmFName2" VARCHAR,
  "AdmLName2" VARCHAR,
  "AdmEmail2" VARCHAR,
  "AdmFName3" VARCHAR,
  "AdmLName3" VARCHAR,
  "AdmEmail3" VARCHAR,
  "LastUpdate" DATE
);
EOF

# Insert data

iconv -f iso-8859-1 -t utf-8 < pubschls.txt |
  csvformat -t |
  csvsql --insert --no-create \
    --tables pubschls --db sqlite:///cde-schools.sqlite
# indexes
sqlite3 cde-schools.sqlite <<EOF
  CREATE INDEX CDSCode_on_pubschls ON pubschls(CDSCode);
EOF