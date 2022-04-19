#! /bin/bash

Help() {
  # Display Help
  echo "Add description of the script functions here."
  echo
  echo "Syntax: scriptTemplate [-g|h|v|V]"
  echo "options:"
  echo "-h     Print this Help."
  echo "-i     Instance name or IP. Example 127.0.0.1"
  echo "-d     List of db name seperate with comma(,). Example coWorkingSpace_test,smartCity,..."
  echo
}

IFS=','
while getopts ":d:i:h" option; do
  case $option in
  h) # display Help
    Help
    exit
    ;;
  i) # Enter instance name
    InstanceName=$OPTARG ;;
  d) # Enter a name
    Name=$OPTARG ;;
  \?) # Invalid option
    Help
    echo "Error: Invalid option"
    exit
    ;;
  esac
done

source /home/may3/Desktop/ETL/etl-demo/venv/bin/activate
CURRENTYEAR="$(date +%Y)"
CURRENTMONTH="$(date +%m)_"
CURRENTDAY="$(date +%d)_"
CURRENTFILENAME=$CURRENTDAY$CURRENTMONTH$CURRENTYEAR

read -a strarr <<<"$Name"
for val in "${strarr[@]}"; do
  mssql-scripter -S $InstanceName -d $val -U sa -P 123456a@ --display-progress --schema-and-data -f /home/may3/Desktop/ETL/etl-demo/$val$CURRENTFILENAME.sql
  python drive_upload.py $val$CURRENTFILENAME.sql
  echo "$val$CURRENTFILENAME.sql" >> /home/may3/Desktop/ETL/etl-demo/log.txt
done

