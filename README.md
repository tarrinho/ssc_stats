# ssc_stats
Fortify SSC scans statistics

Extract all the scan done in the SSC and generate
a csv file with all the available informations

Example:
$ export FORTIFY_TOKEN="base 64 encoded token" 
 > The encoded token below can be used with the SSC REST api.
 
$ sh ./retrieve.scans.bash -f result.csv
