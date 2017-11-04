#!/usr/bin/env bash

dialog --title 'Wappalyzer' \
         --backtitle 'Conflabs Dev Team' \
         --no-cancel \
         --inputbox "Enter a URL:" 8 40 \
         https:// \
         2>url.$$

URL=$(<url.$$)

rm -f url.$$

DATETIME=$(date +%Y%m%d%H%M)

docker run --rm wappalyzer/cli $URL 1>>log-${URL#????????}-$DATETIME.txt

RESULT=`cat log-${URL#????????}-$DATETIME.txt`

dialog --title "Wappalyzer" \
        --msgbox "$RESULT" 30 60

chown $USER:$USER log-${URL#????????}-$DATETIME.txt
