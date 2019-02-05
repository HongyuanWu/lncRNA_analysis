#!/usr/bin/env bash
if (($# == 0)); then
        echo "Usage:"
        echo "-s = SAmple ID "
        echo "-g = Stringtie GTF"
        echo "-b = star bam directory"
        echo "-p = num processors"
        echo "-o = Output directory"
        exit 2
fi
while getopts s:b:g:p:o: option
  do
    case "${option}"
      in
      s) SAMPLEID=${OPTARG};;
      b) BAMDIR=${OPTARG};;
      g) STRGTF=${OPTARG};;
      p) THREADS=${OPTARG};;
      o) OUTDIR=${OPTARG};;
    esac
done

if [ ! -d $OUTDIR ]; then
mkdir -p $OUTDIR/"$SAMPLEID"
fi


stringtie \
-p $THREADS \
-G $STRGTF \
-e \
-B \
-o $OUTDIR/"$SAMPLEID"/transcripts.gtf \
-A $OUTDIR/"$SAMPLEID"/gene_abundances.tsv \
$BAMDIR/"$SAMPLEID"Aligned.sortedByCoord.out.bam
