#!/bin/bash

ROOT='.'
HTTP_ROOT='.'
OUTPUT="$ROOT/index.html" 

SAVEIFS=$IFS
IFS=$(echo -en "\n\b")

# list files and folders in root
echo "<UL>" > $OUTPUT

#for file in `find "$ROOT" -maxdepth 1 -mindepth 1 -type f| sort`; do
    #base=$(basename -a "$file")
    #url="$HTTP_ROOT/$file\">$base</a></LI>"
    #echo "    <LI><a href=\"$url" >> $OUTPUT
#done

# list folders in root
for a in `find "$ROOT" -maxdepth 1 -mindepth 1 -type d| sort`; do
    echo 'a='
    echo $a
    base=$(basename -a "$a")
    echo 'base='
    echo $base
    echo "  <LI>$base</LI>" >> $OUTPUT

    # list files and folders in a
    echo "  <UL>" >> $OUTPUT

    # list files in a
    for file in `find "$a" -maxdepth 1 -mindepth 1 -type f| sort`; do
        base=$(basename -a "$file")
        url="$HTTP_ROOT/$file\">$base</a></LI>"
        echo "    <LI><a href=\"$url" >> $OUTPUT
    done

    # list folders in a
    for b in `find "$a" -maxdepth 1 -mindepth 1 -type d| sort`; do
        echo $b
        base=`basename "$b"`
        echo "  <LI>$base</LI>" >> $OUTPUT

        # list files and folder in b
        echo "  <UL>" >> $OUTPUT

        # list files in b
        for file in `find "$b" -maxdepth 1 -mindepth 1 -type f| sort`; do
            base=$(basename -a "$file")
            url="$HTTP_ROOT/$file\">$base</a></LI>"
            echo "    <LI><a href=\"$url" >> $OUTPUT
        done

        # list folders in b
        for c in `find "$b" -maxdepth 1 -mindepth 1 -type d| sort`; do
          echo $c
          base=`basename "$c"`
          echo "  <LI>$base</LI>" >> $OUTPUT

          # list files in c
          echo "  <UL>" >> $OUTPUT
          for file in `find "$c" -maxdepth 1 -mindepth 1 -type f| sort`; do
                base=$(basename -a "$file")
                url="$HTTP_ROOT/$file\">$base</a></LI>"
                echo "    <LI><a href=\"$url" >> $OUTPUT
          done
          echo "  </UL>" >> $OUTPUT
          # end files in c

        done
        echo "</UL>" >> $OUTPUT
        # end files and folders in b

    done
    echo "  </UL>" >> $OUTPUT
    # end files and folders in a

done
echo "  </UL>" >> $OUTPUT
# end files and folders in root

