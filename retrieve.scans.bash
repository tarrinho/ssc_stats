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
   echo "Token generated in Administration + Token Management from SSC"
   echo
   echo "Don't forget to add a Environment Variable : FORTIFY_URL"
   echo "URL for the SSC instance"
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
declare -a nulls=1;
declare -a fortify_token=$FORTIFY_TOKEN
declare -a fortify_url=$FORTIFY_URL

if [ -z "$fortify_token" ]; then
 echo "No FORTIFY_TOKEN environment variable provided, try -h"
 exit;
fi

if [ -z "$fortify_url" ]; then
 echo "No FORTIFY_URL environment variable provided, try -h"
 exit;
fi
echo "id, guid, uploadDate, type, certification, hostname, engineVersion, artifactId, noOfFiles, totalLOC, execLOC, elapsedTime, fortifyAnnotationsLOC, buildId" > $filename

while true
do
 ((i=i+1))

 #number_scans=`curl -X GET "https://$fortify_url:443/api/v1/scans/$i" -H  "accept: application/json" -H  "Authorization: FortifyToken $fortify_token" -o temp.file 2> /dev/null `
 scan=`curl -X GET "https://$fortify_url:443/api/v1/scans/$i" -H  "accept: application/json" -H  "Authorization: FortifyToken $fortify_token" 2> /dev/null `
 #echo $scan
 id=`echo $scan | jq -r '.data.id'`
 guid=`echo $scan | jq -r '.data.guid'`
 uploadDate=`echo $scan | jq -r '.data.uploadDate'`
 type=`echo $scan | jq -r '.data.type'`
 certification=`echo $scan | jq -r '.data.certification'`
 hostname=`echo $scan | jq -r '.data.hostname'`
 engineVersion=`echo $scan | jq -r '.data.engineVersion'`
 artifactId=`echo $scan | jq -r '.data.artifactId'`
 noOfFiles=`echo $scan | jq -r '.data.noOfFiles'`
 totalLOC=`echo $scan | jq -r '.data.totalLOC'`
 execLOC=`echo $scan | jq -r '.data.execLOC'`
 elapsedTime=`echo $scan | jq -r '.data.elapsedTime'`
 fortifyAnnotationsLOC=`echo $scan | jq -r '.data.fortifyAnnotationsLOC'`
 buildId=`echo $scan | jq -r '.data.buildId'`
 if [ "$id" = null ]; then
	 ((nulls=$nulls+1))
 fi
 if [ "$nulls" -gt 4 ]; then
        echo $nulls
	break
 fi
	
 #echo "$id, $guid, $uploadDate, $type, $certification, $hostname, $engineVersion, $artifactId, $noOfFiles, $totalLOC, $execLOC, $elapsedTime, $fortifyAnnotationsLOC, $buildId" 
 echo "$id, $guid, $uploadDate, $type, $certification, $hostname, $engineVersion, $artifactId, $noOfFiles, $totalLOC, $execLOC, $elapsedTime, $fortifyAnnotationsLOC, $buildId" >> $filename
done

