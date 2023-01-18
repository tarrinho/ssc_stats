# ssc_stats
Fortify SSC scans statistics

Extract all the scan done in the SSC and generate
a csv file with all the available informations

Example:
$ export FORTIFY_TOKEN="base 64 encoded token" 
 > The encoded token above can be used with the SSC REST api needs to be extracted from the the menu "Administration + Token Management" in the Software Security Center - Fortify by Microfocus.
 
$ sh ./retrieve.scans.bash -f result.csv
