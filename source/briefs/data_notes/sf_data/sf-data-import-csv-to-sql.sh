

# import just 2009 and 2014
csvgrep -c 'Opened' -r '^(?:2014|2009)' < sf311-cleaned.csv |
  csvsql --insert --no-create \
  --db  'sqlite:///sf-city-data.sqlite' --tables 311_cases


  # import just 2009 and 2014
csvgrep -c 'datetime' -r '^(?:2014|2009)' < sfcrime-cleaned.csv |
  csvsql --insert --no-create \
  --db  'sqlite:///sf-city-data.sqlite' --tables sfpd_incidents


