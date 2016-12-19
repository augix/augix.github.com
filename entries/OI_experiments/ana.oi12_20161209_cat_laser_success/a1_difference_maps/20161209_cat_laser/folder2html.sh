#!/bin/bash

ROOT='./'
HTTP_ROOT='.'
OUTPUT="$ROOT/index.html" 

SAVEIFS=$IFS
IFS=$(echo -en "\n\b")

i=0
echo "<UL>" > $OUTPUT
for a in `find "$ROOT" -maxdepth 1 -mindepth 1 -type d| sort`; do
    b=`basename "$a"`
    echo "  <LI>$b</LI>" >> $OUTPUT
    echo "  <UL>" >> $OUTPUT

    for filepath in `find "$b" -maxdepth 1 -mindepth 1 -type d| sort`; do
      path=`basename "$filepath"`
      echo "  <LI>$path</LI>" >> $OUTPUT
      echo "  <UL>" >> $OUTPUT
      for i in `find "$filepath" -maxdepth 1 -mindepth 1 -type f| sort`; do
        file=$(basename -a "$i")
        url="$HTTP_ROOT/$b/$path/$file\">$file</a></LI>"
        #url=$(echo $url | sed 's/ /%20/g')
        echo "    <LI><a href=\"$url" >> $OUTPUT
      done
      echo "  </UL>" >> $OUTPUT
    done
    echo "</UL>" >> $OUTPUT

done
echo "  <UL>" >> $OUTPUT
