sqlite3 cde-schools.sqlite <<EOF
DROP TABLE IF EXISTS kinder_vaccines;
CREATE TABLE kinder_vaccines (
  year VARCHAR,
  school_code VARCHAR,
  county VARCHAR,
  school_type VARCHAR,
  district_code VARCHAR,
  district_name VARCHAR,
  city VARCHAR,
  school_name VARCHAR,
  enrollment INTEGER,
  uptodate_num FLOAT,
  uptodate_pct FLOAT,
  conditional_num FLOAT,
  conditional_pct FLOAT,
  pme_num FLOAT,
  pme_pct FLOAT,
  pbe_num FLOAT,
  pbe_pct FLOAT,
  pre_jan_pbe_num FLOAT,
  pre_jan_pbe_pct FLOAT,
  hcp_counseled_pbe_num FLOAT,
  hcp_counseled_pbe_pct FLOAT,
  religous_pbe_num FLOAT,
  religous_pbe_pct FLOAT,
  dtp_num FLOAT,
  dtp_pct FLOAT,
  polio_num FLOAT,
  polio_pct FLOAT,
  mmr1_num FLOAT,
  mmr1_pct FLOAT,
  mmr2_num FLOAT,
  mmr2_pct FLOAT,
  hepb_num FLOAT,
  hepb_pct FLOAT,
  vari_num FLOAT,
  vari_pct FLOAT,
  reported CHAR
);
EOF



for fn in *.csv; do
  echo Inserting $fn
  csvformat -U 1 <  $fn |
    csvsql --insert --no-create \
      --tables kinder_vaccines --db sqlite:///cde-schools.sqlite
done


sqlite3 cde-schools.sqlite <<EOF
  CREATE INDEX year_on_kinder_vaccines ON kinder_vaccines(year);
  CREATE INDEX school_code_on_kinder_vaccines ON kinder_vaccines(school_code);
EOF




# for fn in *2007-2008*.csv; do
#   echo Inserting $fn

#   head -n 6000 $fn |
#   csvformat |
#   csvsql --insert --no-create \
#     --tables kinder_vaccines --db sqlite:///cde-schools.sqlite
# done


# for n in $(seq 2 400); do
#   echo $n
#   cat <(head -n 1 $fn) <(tail -n +$n $fn) | head -n 2 |
#   csvsql --insert --no-create \
#     --tables kinder_vaccines --db sqlite:///cde-schools.sqlite
# done

# creating a schema
# cat k-immune-2000-2001--cleaned.csv <(tail -n +2 k-immune-2011-2012--cleaned.csv) <(tail -n +2 k-immune-2013-2014--cleaned.csv) <(tail -n +2 k-immune-2009-2010--cleaned.csv) <(tail -n +2 k-immune-2014-2015--cleaned.csv) | csvsql --tables kinder_vaccines --no-constraints -i sqlite

# # spotchecking
# for fn in *.csv; do
#   csvcut -c county $fn
# done

