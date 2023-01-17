#!/bin/bash
#
# Goal: Extract all the scan done in the SSC and generate
#       a csv file with all the available informations"
# requires : jq installed

############################################################
# Help                                                     #
############################################################
Help()
{
   # Display Help
   echo "Extract all the scan done in the SSC and generate"
   echo "a csv file with all the available informations"
   echo
   echo "Don't forget to add a Environment Variable : FORTIFY_TOKEN"
   echo
   echo "Syntax:  [h|filename.csv]"
   echo "options:"
   echo "h     Print this Help."
   echo "f     filename.csv - output file"
   echo
}

############################################################
# Process the input options. Add options as needed.        #
############################################################
# Get the options
while getopts ":hf:" option; do
   case $option in
      h) # display Help
         Help
         exit;;
      f) # Enter a filename
	 filename=$OPTARG;;
      \?) # Invalid option
	 echo "Error: Invalid option"
	 Help
         exit;;
   esac
done
if [ $# -eq 0 ]; then
    echo "No arguments provided, try -h"
    exit 1
fi

declare -a number_scans
declare -a i=1;
declare -a fortify_token=$FORTIFY_TOKEN

if [ -z "$fortify_token" ]; then
 echo "No FORTIFY_TOKEN environment variable provided, try -h"
 exit;
fi
echo "id, guid, uploadDate, type, certification, hostname, engineVersion, artifactId, noOfFiles, totalLOC, execLOC, elapsedTime, fortifyAnnotationsLOC, buildId" > $filename

while true
do
 ((i=i+1))

 number_scans=`curl -X GET "https://fortify.cfappsecurity.com:443/api/v1/scans/$i" -H  "accept: application/json" -H  "Authorization: FortifyToken $FORTIFY_TOKEN" > temp.file 2> /dev/null `
 id=`cat temp.file | jq -r '.data.id'`
 guid=`cat temp.file | jq -r '.data.guid'`
 uploadDate=`cat temp.file | jq -r '.data.uploadDate'`
 itype=`cat temp.file | jq -r '.data.itype'`
 certification=`cat temp.file | jq -r '.data.certification'`
 hostname=`cat temp.file | jq -r '.data.hostname'`
 engineVersion=`cat temp.file | jq -r '.data.Version'`
 artifactId=`cat temp.file | jq -r '.data.artifactId'`
 noOfFiles=`cat temp.file | jq -r '.data.noOfFiles'`
 totalLOC=`cat temp.file | jq -r '.data.totalLOC'`
 execLOC=`cat temp.file | jq -r '.data.execLOC'`
 elapsedTime=`cat temp.file | jq -r '.data.elapsedTime'`
 fortifyAnnotationsLOC=`cat temp.file | jq -r '.data.fortifyAnnotationsLOC'`
 buildId=`cat temp.file | jq -r '.data.buildId'`
 if [ "$id" = null ]; then
	 break;
 fi
 #echo "$id, $guid, $uploadDate, $type, $certification, $hostname, $engineVersion, $artifactId, $noOfFiles, $totalLOC, $execLOC, $elapsedTime, $fortifyAnnotationsLOC, $buildId" 
 echo "$id, $guid, $uploadDate, $type, $certification, $hostname, $engineVersion, $artifactId, $noOfFiles, $totalLOC, $execLOC, $elapsedTime, $fortifyAnnotationsLOC, $buildId" >> $filename
done

# clean up
`rm -f temp.file`
