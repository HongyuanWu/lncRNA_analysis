#!/usr/bin/env bash
if (($# == 0)); then
        echo "Usage:"
        echo "-f = Reference genome sequence "
        echo "-G = Reference genome GTF"
        echo "-g = Stringtie GTF"
        echo "-o = Output directory"
        exit 2
fi
while getopts f:G:g:o: option
  do
    case "${option}"
      in
      f) REFSEQ=${OPTARG};;
      G) REFGTF=${OPTARG};;
      g) STRGTF=${OPTARG};;
      o) OUTDIR=${OPTARG};;
    esac
done

if [ ! -d $OUTDIR ]; then
mkdir -p $OUTDIR
fi

# filter transcripts overlapping with sense protein coding exons.
# Keeping monoex to deal with misc_RNA biotype
FEELnc_filter.pl \
-i $STRGTF \
-a $REFGTF \
-b transcript_biotype=protein_coding \
--monoex=1 \
-p 32 \
> $OUTDIR/candidate_lncRNA.gtf

# create a gtf for known protein coding transcripts
awk '{ if ($0 ~ "transcript_id") print $0; else print $0" transcript_id \"\";"; }' \
$REFGTF | \
grep 'protein_coding' \
> $OUTDIR/known_mrna.gtf

#determine protein coding potential
FEELnc_codpot.pl \
-i $OUTDIR/candidate_lncRNA.gtf \
-m shuffle \
-a $OUTDIR/known_mrna.gtf \
-g $REFSEQ \
-o candidate_lncRNA.nocodpot.gtf \
--outdir $OUTDIR/feelnc_codpot_out/

cp $OUTDIR/feelnc_codpot_out/candidate_lncRNA.nocodpot.gtf $OUTDIR/candidate_lncRNA.nocodpot.gtf
# classify putative lncRNA transcripts
FEELnc_classifier.pl \
-i $OUTDIR/candidate_lncRNA.nocodpot.gtf \
-a $REFGTF \
> $OUTDIR/lncRNA_classes.txt
