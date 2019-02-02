#!/usr/bin/env bash
while getopts a:g:p: option
  do
    case "${option}"
      in
      a) GTF=${OPTARG};;
      g) FASTA=${OPTARG};;
      p) THREADS=${OPTARG};;
    esac
done

STAR --runThreadN $THREADS\
     --runMode genomeGenerate \
     --sjdbOverhang 124\
     --genomeChrBinNbits 16 \
     --genomeDir $GENOMEDIR/star_index \
     --genomeFastaFiles $FASTA \
     --sjdbGTFfile $GTF
