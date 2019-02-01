#!/usr/bin/env bash
if (($# == 0)); then
        echo "Usage:"
        echo "-s = sample ID"
        echo "-i = input directory"
        echo "-o = output directory"
        exit 2
fi
while getopts s:i:o: option
  do
    case "${option}"
      in
      s) SAMPLEID=${OPTARG};;
      i) INDIR=${OPTARG};;
      o) OUTDIR=${OPTARG};;
    esac
done

mkdir -p $OUTDIR

# trim adapter using cut adapt
cutadapt \
-A AGATCGGAAGAGC  \
-a AGATCGGAAGAGC \
-o $OUTDIR/"$SAMPLEID"_1_sequence.cutadapt.txt.gz \
-p $OUTDIR/"$SAMPLEID"_2_sequence.cutadapt.txt.gz \
$INDIR/"$SAMPLEID"_1_sequence.txt.gz \
$INDIR/"$SAMPLEID"_2_sequence.txt.gz

mkdir -p $OUTDIR/paired $OUTDIR/unpaired

java -jar ~/bin/Trimmomatic-0.36/trimmomatic-0.36.jar PE \
-threads 32 \
$OUTDIR/"$SAMPLEID"_1_sequence.cutadapt.txt.gz \
$OUTDIR/"$SAMPLEID"_2_sequence.cutadapt.txt.gz \
$OUTDIR/unpaired/"$SAMPLEID"_1_sequence.txt.gz \
$OUTDIR/unpaired/"$SAMPLEID"_2_sequence.txt.gz \
$OUTDIR/paired/"$SAMPLEID"_1_sequence.txt.gz \
$OUTDIR/paired/"$SAMPLEID"_2_sequence.txt.gz \
SLIDINGWINDOW:4:20 \
MINLEN:36 \
-trimlog $OUTDIR/"$SAMPLEID".trimmomatic.log

# END
