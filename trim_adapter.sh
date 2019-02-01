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

# trim adapter using cutadapt
cutadapt  \
-A AGATCGGAAGAGC  -a AGATCGGAAGAGC \
          -o $OUTDIR/"$SAMPLEID"_R1.fastq.gz -p $OUTDIR/"$SAMPLEID"_R2.fastq.gz \
          $INDIR/"$SAMPLEID"_R1.fastq.gz $INDIR/"$SAMPLEID"_R2.fastq.gz

# END
