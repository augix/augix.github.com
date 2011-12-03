#!/bin/bash
dir1="../wiki"
dir2="../new"
IFS="
"
for i in ../wiki/*.wiki; do
    grep -H "<pre>" $i
    sed -n 's/<pre>/{{{/p' $i
done


