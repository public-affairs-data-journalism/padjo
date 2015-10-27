CREATE TABLE "311_cases" (
  "CaseID" INTEGER,
  "Opened" DATETIME,
  "Closed" DATETIME,
  "Updated" DATETIME,
  "Status" VARCHAR,
  "Status Notes" VARCHAR,
  "Responsible Agency" VARCHAR,
  "Category" VARCHAR,
  "Request Type" VARCHAR,
  "Request Details" VARCHAR,
  "Address" VARCHAR,
  "Supervisor District" INTEGER,
  "Neighborhood" VARCHAR,
  "Source" VARCHAR,
  latitude FLOAT,
  longitude FLOAT
);


CREATE TABLE sfpd_incidents (
  "IncidntNum" VARCHAR,
  "Category" VARCHAR,
  "Descript" VARCHAR,
  "PdDistrict" VARCHAR,
  "Resolution" VARCHAR,
  "Address" VARCHAR,
  "X" FLOAT,
  "Y" FLOAT,
  "PdId" VARCHAR,
  datetime DATETIME
);


