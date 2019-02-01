#!/usr/bin/env bash
if (($# == 0)); then
        echo "Usage:"
        echo "-s = sample ID"
        echo "-i = input directory"
        echo "-p = num processors"
        echo "-g = path to star genome index"
        echo "-o = path for output BAMs"
        exit 2
fi
while getopts s:i:p:g:o: option
  do
    case "${option}"
      in
      s) SAMPLEID=${OPTARG};;
      i) INDIR=${OPTARG};;
      p) THREADS=${OPTARG};;
      g) INDEX=${OPTARG};;
      o) OUTDIR=${OPTARG};;
    esac
done

if [ ! -d $OUTDIR ]; then
mkdir -p $OUTDIR
fi

$star_directory/STAR \
--runThreadN $THREADS \
--readFilesIn $INDIR/"$SAMPLEID"_R1.fastq.gz $INDIR/"$SAMPLEID"_R2.fastq.gz \
--genomeDir $INDEX \
--readFilesCommand gunzip -c \
--outFileNamePrefix $OUTDIR/"$SAMPLEID" \
--outSAMtype BAM SortedByCoordinate \
--twopassMode Basic

# create a BAM index
samtools index $OUTDIR/"$SAMPLEID"Aligned.sortedByCoord.out.bam
