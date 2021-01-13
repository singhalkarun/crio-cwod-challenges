#!/bin/bash

if test -f formatted_cities.txt; then
  rm formatted_cities.txt
fi

grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" /var/log/qeats-server.log > access_ips.txt

regex="\"city\"\:\"([A-Za-z]{1,})\""
while IFS= read -r line;do
    url="https://tools.keycdn.com/geo.json?host=$line"
    curl --silent -o ~/cdnapi.txt $url
    city="$(grep -oE "\"city\"\:\"[A-za-z]{1,}\"" ~/cdnapi.txt)"


 if [[ $city =~ $regex ]]; then
    formatted_city="${BASH_REMATCH[1]}"

    echo $formatted_city >> formatted_cities.txt
  fi
done < access_ips.txt

sort formatted_cities.txt | uniq -c | awk '{print$2","$1}'
