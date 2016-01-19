#!/bin/bash

# get file information
# replace $1 with your CSV filename to run from command line or use ./convert-ing-ynab-json.sh _FILENAME"
pathandfile=$1
filename=$(basename $pathandfile)
extension=${filename##*.}
filename=${filename%.*}

# copy file for modification
csv=$filename"-ing-for-ynab."$extension
cp -v $pathandfile $csv

# convert dates
perl -i -pe "s/^\"(\d{4})(\d{2})(\d{2})/\3\/\2\/\1/g" $csv
# convert amounts for income
perl -i -pe "s/\"(Af)\"(,\")/\"\1\",\"-/gi" $csv
# convert amounts for expenses
perl -i -pe "s/\"(Bij)\"(,\")/\"\1\",\"+/gi" $csv
# rename header titles
sed -i '' "1s/Datum/Date/g" $csv
sed -i '' "1s/Naam \/ Omschrijving/Payee/g" $csv
sed -i '' "1s/Mededelingen/Check/g" $csv
sed -i '' "1s/Bedrag (EUR)/Amount/g" $csv
sed -i '' "1s/MutatieSoort/Memo/g" $csv