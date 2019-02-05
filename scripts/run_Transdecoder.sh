#!/usr/bin/env bash
if (($# == 0)); then
        echo "Usage:"
        echo "-f = Reference genome sequence "
        echo "-g = Stringtie GTF"
        echo "-o = Output directory"
        exit 2
fi
while getopts f:g:o: option
  do
    case "${option}"
      in
      f) REFSEQ=${OPTARG};;
      g) FEELNCGTF=${OPTARG};;
      o) OUTDIR=${OPTARG};;
    esac
done

if [ ! -d $OUTDIR ]; then
mkdir -p $OUTDIR
fi

~/bin/TransDecoder-TransDecoder-v5.5.0/util/gtf_genome_to_cdna_fasta.pl $FEELNCGTF $REFSEQ > $OUTDIR/candidate_lncRNA.nocodpot.cdna.fa

TransDecoder.LongOrfs \
-t $OUTDIR/candidate_lncRNA.nocodpot.cdna.fa \
-S \
-O $OUTDIR
