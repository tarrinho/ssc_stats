# ssc_stats
Fortify Software Security Center (SSC) scans statistics

Extract all the scan done in the SSC and generate
a csv file with all the available informations

Example:
 > The first value is the domain where the Fortify' SSC is installed 
$ export FORTIFY_URL="fortify.domain.local" 
 
 > The encoded token below can be used with this SSC REST api needs to be extracted from the the menu "Administration + Token Management" in the Software Security Center - Fortify by Microfocus.
$ export FORTIFY_TOKEN="base 64 encoded token" 
 
$ sh ./retrieve.scans.bash -f result.csv
