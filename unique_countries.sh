#!/bin/bash

grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" /var/log/qeats-server.log | sort | uniq > uniqueIp.txt

if test -f countries.txt; then
  rm countries.txt
fi

regex="\"country_name\"\:\"([A-Za-z]{1,})\""
while IFS= read -r line; do
  url="https://tools.keycdn.com/geo.json?host=$line"
  curl --silent -o cdnapi.txt $url
  country="$(grep -oE "\"country_name\"\:\"[A-za-z]{1,}\"" cdnapi.txt)"

  if [[ $country =~ $regex ]]; then 
    countryFormatted="${BASH_REMATCH[1]}"
    echo $countryFormatted >> countries.txt
  fi
done < uniqueIp.txt

sort countries.txt | uniq > uniqueCountries.txt
cat uniqueCountries.txt
