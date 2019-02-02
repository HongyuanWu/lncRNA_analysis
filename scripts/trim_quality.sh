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
mkdir -p $OUTDIR/paired $OUTDIR/unpaired

# quality preprocessing; minimum read length = 36nt
java -jar ~/bin/Trimmomatic-0.36/trimmomatic-0.36.jar PE \
                     -threads 32 \
                     $INDIR/"$SAMPLEID"_R1.fastq.gz $INDIR/"$SAMPLEID"_R2.fastq.gz \
                     $OUTDIR/paired/"$SAMPLEID"_R1.fastq.gz $OUTDIR/unpaired/"$SAMPLEID"_R1.fastq.gz \
                     $OUTDIR/paired/"$SAMPLEID"_R2.fastq.gz $OUTDIR/unpaired/"$SAMPLEID"_R2.fastq.gz \
                     SLIDINGWINDOW:4:20 \
                     MINLEN:36 \
                     -trimlog $OUTDIR/"$SAMPLEID".trimmomatic.log

# END
