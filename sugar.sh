#!/bin/bash

export LC_NUMERIC="en_US.UTF-8"

# Medtrum EasyView credentials
user="<email>"
pass="<password>"
fcm="123" # Set any string here

# mg/dL thresholds
minval=80
maxval=140

cookie=`curl -si -X POST  -H "Content-Type: application/x-www-form-urlencoded" -d "user_type=M&user_name=$user&password=$pass&deviceToken=$fcm&platform=google&apptype=Follow&push_platform=google&app_version=1.2.70%28112%29&device_name=sdk_gphone_x86&bundleID=com.medtrum.easyfollowforandroidmg" https://easyview.medtrum.eu/mobile/ajax/login -o /dev/null -w '%header{Set-Cookie}' | awk '{ print \$1; }' | sed -e 's/;$//'`
mmol=`curl -sq -H "Cookie: $cookie" https://easyview.medtrum.eu/mobile/ajax/logindata | /usr/local/bin/jq '.monitorlist[0].sensor_status.glucose'`
mg=`printf "%.0f" $(echo "$mmol / 0.0555" | bc -l)`

if [ "$mg" -lt "$minval" ];
then
    echo "$mg mg/dL | color=red"
elif [ "$mg" -gt "$maxval" ];
then
    echo "$mg mg/dL | color=orange"
else
    echo "$mg mg/dL"
fi
