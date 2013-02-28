#!/bin/bash

# An example script that plots results from benchmark.sh using gnuplot

# inpdir  Contains the results from benchmark.sh
# sql     Results from this database will be used
# page    Results for this page will be used
# outdir  The plots are written to this directory (optional)

inpdir=$1
sql=$2
page=$3
outdir=$4

sanitized_page=`echo "$page" | sed 's/[:\/<>|"?]/_/g'`

wars=8
war[1]="noopt" # The name of the war
title[1]="\"0\"" # Label shown at the x-axis
war[2]="hibernatebatch"
title[2]="\"1\""
war[3]="hibernatesubselect"
title[3]="\"2\""
war[4]="hibernatesubwithbatch"
title[4]="\"3\""
war[5]="queryargs"
title[5]="\"4\""
war[6]="querybatch"
title[6]="\"5\""
war[7]="currentnojoins"
title[7]="\"6\""
war[8]="current"
title[8]="\"7\""

plotdta="$inpdir/${sanitized_page}_plot.dta"
cat $inpdir/${war[1]}_${sql}.log | awk 'FNR==1' > $plotdta
for cur in $(seq 1 $wars)
do
  war=${war[$cur]}
  title=${title[$cur]}
  cat $inpdir/${war}_${sql}.log | grep "^${sanitized_page}	" | sed "s/^${sanitized_page}\t/$title\t/;s/[[:digit:]]\+\-\([[:digit:]]\+\)/\1/g" >> $plotdta
done

plot() {
  mode=$1
  fs1="fs solid lc rgb \"gray\""
  fs2="fs pattern 2 lc rgb \"black\""
  fs3="fs solid lc rgb \"white\""
  key=";set key top right inside autotitle columnhead"
  plotscript=""
  ylabeloffset="2.8"
  height="2in"

  if [[ $mode == "sql" ]]; then
    fout="$outdir/queries.tex"
    width="2in"
    key=";set key off autotitle columnheader"
    ylabel="Queries"
    plot="plot \"$plotdta\""
    plot="$plot using 9:xticlabels(1) $fs1;" # Queries
  fi

  if [[ $mode == "stat" ]]; then
    fout="$outdir/stats.tex"
    width="3.3in"
    ylabel="Fetched"
    ylabeloffset="3"
    plot="plot \"$plotdta\""
    plot="$plot using 10:xticlabels(1) $fs1" # Entities
    plot="$plot, '' using 11 $fs2" # Duplicates
    plot="$plot, '' using 12 $fs3;" # Collections
    plotscript=";set ytic 0,200,1200;set yrange [0:1200];set key samplen 2"
  fi

  if [[ $mode == "req" ]]; then
    fout="$outdir/mem_per_req.tex"
    width="2in"
    key=";set key off autotitle columnheader"
    ylabel="Heap memory used (MB)"
    max=`cat $plotdta | cut -f 22 | sort -g | tail -1`
    max=`echo "$max*106/100" | bc`
    plot="plot \"$plotdta\""
    plot="$plot using 22:xticlabels(1) $fs1" # Heap Per Request
    plotscript="; set yrange [0:$max]; set ytic 0,20"
  fi

  script="set style data histogram"
  script="$script;set lmargin 5; set rmargin 1"
  script="$script;set ylabel \"$ylabel\" offset $ylabeloffset"
  script="$script;set xlabel \"Prefetch technique\" offset 0,0.5"
  script="$script$key"
  script="$script;set style histogram cluster gap 1"
  script="$script;set style fill pattern border -1"
  script="$script;set xtic nomirror scale 0"
  script="$script$plotscript"

  if [[ $mode == "timeerr" ]]; then
    fout="$outdir/responsetimeserr.tex"
    width="2in"

    ylabel="Response time (ms)"
    max=`cat $plotdta | cut -f 6 | sort -g | tail -1`
    max=`echo "$max*106/100" | bc`

    script="set boxwidth 1; set style data histogram; set style histogram errorbars gap 1 linewidth 1"
    script="$script;set lmargin 5; set rmargin 1"
    script="$script;set ylabel \"$ylabel\" offset $ylabeloffset;set xlabel \"Prefetch technique\" offset 0,0.5"
    script="$script;set nokey"
    script="$script;set style fill pattern border -1"
    script="$script;set xtic nomirror scale 0"
    script="$script;set yrange [0:$max]; set ytic 0, 50"

    plot="plot \"$plotdta\" every ::1"
    plot="$plot using 3:2:6:xticlabels(1) $fs1"
  fi

  if [[ $outdir == "" ]] ; then
    gnuplot -e "$script; $plot" -persist
  else
    gnuplot -e "set terminal epslatex color solid size $width,$height; set output \"$fout\"; $script; $plot"
  fi
}

plot "timeerr"
plot "sql"
plot "stat"
plot "req"
