grep pid: dump.txt | grep -Eo "\-?\d+" > proc.txt &&  gnuplot -p -e  'set term png; plot "proc.txt" with lines' > plot.png && open plot.png