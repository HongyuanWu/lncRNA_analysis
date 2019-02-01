#!/usr/bin/env bash
if (($# == 0)); then
        echo "Usage:"
        echo "-t = assembled transcript directory"
        echo "-g = path to reference annotation"
        exit 2
fi
while getopts t:g: option
  do
    case "${option}"
      in
      t) TRANSCRIPTDIR=${OPTARG};;
      g) GTF=${OPTARG};;
    esac
done

readlink -f $TRANSCRIPTDIR/*.gtf >> $TRANSCRIPTDIR/mergelist.txt

stringtie --merge $TRANSCRIPTDIR/mergelist.txt \
-o $TRANSCRIPTDIR/stringtie.gtf \
-f 0.1  \
-c 10

gffcompare \
-o $TRANSCRIPTDIR/gffcompare \
-r $GTF $TRANSCRIPTDIR/stringtie.gtf \
-N \
-M
