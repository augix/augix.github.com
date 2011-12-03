dir1="../wiki"
dir2="../new
for i in ../wiki/*.wiki; do
    sed -n 's/<pre>/{{{/p'
done


