CREATE INDEX "opened_time_on_311_cases" ON "311_cases"("Opened");
CREATE INDEX "closed_time_on_311_cases" ON "311_cases"("Closed");
CREATE INDEX "responsible_agency_on_311_cases" ON "311_cases"("Responsible Agency");
CREATE INDEX "category_on_311_cases" ON "311_cases"("Category")  ;
CREATE INDEX "request_type_on_311_cases" ON "311_cases"("Request Type");
CREATE INDEX "request_details_on_311_cases" ON "311_cases"("Request Details");



CREATE INDEX "pd_district_on_sfpd" ON "sfpd_incidents"("PdDistrict");
CREATE INDEX "category_on_sfpd" ON "sfpd_incidents"("Category");
CREATE INDEX "datetime_on_sfpd" ON "sfpd_incidents"("datetime");
