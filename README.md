# ing-to-ynab-json-converter
Easily convert your ING JSON data with transaction for You Need A Budget compatible JSON

# How to use
* download [Automator OS X App](https://github.com/dive/ing-to-ynab-json-converter/releases/download/1.2/ING.to.YNAB.JSON.Converter.app.zip);
* download your ING JSON data ([instruction from ING](https://www.ing.nl/particulier/mobiel-en-internetbankieren/internetbankieren/afdrukken-af-en-bijschrijvingen/index.html)). Please, use ``Kommagescheiden (jjjjmmdd)`` format for your data;
* drag your downloaded ING JSON file to ``ING to YNAB JSON Converter.app``;
* when convertion will be completed you'll see new file on your Desktop with filename ``'original_filename-ing-for-ynab.csv'``;
* that's all. Export your new JSON to '[You Need A Budget](http://www.youneedabudget.com)' app.

# Information
No magick here. Just a bash script with some regular expressions wrapped into nice Automator app. You can found plain Automator workflow to run it inside Automator app and the script in the repo.

[Script](https://github.com/dive/ing-to-ynab-json-converter/blob/master/convert-ing-to-ynab-json.sh) is very simple:
```bash
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
```
