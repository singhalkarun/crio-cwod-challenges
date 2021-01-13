#!/bin/bash  

grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" /var/log/qeats-server.log | sort | uniq > ~/uniqueIp.txt  

touch countries.txt  

while IFS= read -r line; do     
  url="https://tools.keycdn.com/geo.json?host=$line"     
  curl --silent -o ~/cdnapi.txt $url     
  grep -oE "\"country_name\"\:\"[A-za-z]{1,}\"" ~/cdnapi.txt >> countries.txt 
done < uniqueIp.txt  

sort countries.txt | uniq > uniqueCountries.txt  

regex="\"country_name\"\:\"([A-Za-z]{1,})\"" 

while IFS= read -r line;do 
  if [[ $line =~ $regex ]] 
    then country="${BASH_REMATCH[1]}" 
    echo $country 
  fi 
done < uniqueCountries.txt
