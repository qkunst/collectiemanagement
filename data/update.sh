#!/usr/bin/env bash
# rm *.zip
echo "Downloading files..."
wget -q -N http://download.geonames.org/export/dump/NL.zip
wget -q -N http://download.geonames.org/export/dump/admin2Codes.txt
wget -q -N http://download.geonames.org/export/dump/admin1CodesASCII.txt
wget -q -N http://download.geonames.org/export/dump/cities5000.zip
wget -q -N http://download.geonames.org/export/dump/alternateNames.zip
wget -q -N http://download.geonames.org/export/dump/countryInfo.txt
echo "  done."
echo "Unzipping files..."
unzip -o -qq NL.zip
unzip -o -qq cities5000.zip
unzip -o -qq alternateNames.zip
echo "  done."
echo "Processing alternateNames..."
cat alternateNames.txt | grep "\tnl\t" > nl_alternateNames.txt
echo "  done."

rm *.zip
rm alternateNames.txt

echo "Finished!"
