#!/bin/bash
cd `dirname $0`

dir1="../mediawiki"
dir2="../wiki"
dir3="../tmp1"
dir4="../tmp2"
[ -d $dir2 ] || mkdir $dir2
[ -d $dir3 ] || mkdir $dir3
[ -d $dir4 ] || mkdir $dir4

IFS="
"

for old in $dir1/*.wiki; do
    new=$dir2/`basename $old`
    tmp1=$dir3/`basename $old`
    tmp2=$dir4/`basename $old`
    python ./convert.line.starts.with.a.whitespace.py "$old" "$tmp1"
    python ./convert.emphasize.quotes.py "$tmp1" "$tmp2"
    perl -pe \
        's|<bash>|{{{class="brush: bash"\n|g;
         s|</bash>|\n}}}|g;
         s|<java>|{{{class="brush: java"\n|g;
         s|</java>|\n}}}|g;
         s|<perl>|{{{class="brush: perl"\n|g;
         s|</perl>|\n}}}|g;
         s|<php>|{{{class="brush: php"\n|g;
         s|</php>|\n}}}|g;
         s|<python>|{{{class="brush: python"\n|g;
         s|</python>|\n}}}|g;
         s|<R>|{{{class="brush: R"\n|g;
         s|</R>|\n}}}|g;
         s|<latex>|{{{class="brush: latex"\n|g;
         s|</latex>|\n}}}|g;
         s|<applescript>|{{{\n|g;
         s|</applescript>|\n}}}|g;
         s|<pre>|{{{\n|g;
         s|</pre>|\n}}}|g;
         s|<code>|{{{\n|g;
         s|</code>|\n}}}|g;
         s|<t>|{{{\n|g;
         s|</t>|\n}}}|g;
         s|\*\*\*|\t\t\*|g;
         s|\*\*|\t\*|g;
         ' <"$tmp2"\
    | sed '/{{{/ { N; s/\n$//; }'\
    | sed '/^$/ { N; s/\n}}}/}}}/; }' >"$new" 
done  

[ -d $dir3 ] && rm -rf $dir3
[ -d $dir4 ] && rm -rf $dir4
cd -

