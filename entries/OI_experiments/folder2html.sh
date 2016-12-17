#!/bin/bash
ROOT='./20161215_monkey_fovea/'
HTTP_ROOT='.'
OUTPUT="./20161215_monkey_fovea/index.html" 

i=0
echo "<UL>" > $OUTPUT
for filepath in `find "$ROOT" -maxdepth 1 -mindepth 1 -type d| sort`; do
  path=`basename "$filepath"`
  echo "  <LI>$path</LI>" >> $OUTPUT
  echo "  <UL>" >> $OUTPUT
  for i in `find "$filepath" -maxdepth 1 -mindepth 1 -type f| sort`; do
    file=`basename "$i"`
    echo "    <LI><a href=\"$HTTP_ROOT/$path/$file\">$file</a></LI>" >> $OUTPUT
  done
  echo "  </UL>" >> $OUTPUT
done
echo "</UL>" >> $OUTPUT


