#!/usr/bin/env bash
if (($# == 0)); then
        echo "Usage:"
        echo "-s = SAmple ID "
        echo "-g = Stringtie GTF"
        echo "-b = star bam directory"
        echo "-o = Output directory"
        exit 2
fi
while getopts f:g:o: option
  do
    case "${option}"
      in
      s) SAMPLEID=${OPTARG};;
      b) BAMDIR=${OPTARG};;
      g) STRGTF=${OPTARG};;
      o) OUTDIR=${OPTARG};;
    esac
done

if [ ! -d $OUTDIR ]; then
mkdir -p $OUTDIR/$SAMPLE
fi
mkdir -p $OUTDIR/"$SAMPLEID"

stringtie \
-p 32 \
-G $STRGTF \
-e \
-B \
-o $OUTDIR/"$SAMPLEID"/transcripts.gtf \
-A $OUTDIR/"$SAMPLEID"/gene_abundances.tsv \
$BAMDIR/"$SAMPLEID"Aligned.sortedByCoord.out.bam
