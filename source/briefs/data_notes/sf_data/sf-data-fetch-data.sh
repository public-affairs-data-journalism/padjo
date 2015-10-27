DATADIR=~/data/padjo/sf
curl 'https://data.sfgov.org/api/views/tmnf-yvry/rows.csv?accessType=DOWNLOAD' > $DATADIR/sfcrime.csv
curl 'https://data.sfgov.org/api/views/vw6y-z8j6/rows.csv?accessType=DOWNLOAD' > $DATADIR/sf311.csv
