#!/usr/bin/env bash
if (($# == 0)); then
        echo "Usage:"
        echo "-f = lncRNA fasta sequence"
        echo "-o = Output directory"
        exit 2
fi
while getopts f:o: option
  do
    case "${option}"
      in
      f) LNCRNASEQ=${OPTARG};;
      o) OUTDIR=${OPTARG};;
    esac
done

if [ ! -d $OUTDIR ]; then
mkdir -p $OUTDIR
fi

/home/colin/bin/CPC2-beta/bin/CPC2.py \
  -i $LNCRNASEQ -o $OUTDIR/CPC2.analysis.txt

#grep noncoding lncrna_annotation/FEELnc/CPC.FEELNc.analysis.txt | awk '{print $1}' | sort |uniq > lncrna_annotation/CPC2/cpc2_noncoding_ids.txt

#awk -F'"' 'FNR==NR {block[$0];next} $2 in block' \
#lncrna_annotation/CPC2/cpc2_noncoding_ids.txt lncrna_annotation/FEELnc/candidate_lncRNA.gtf


#grep '^>' lncrna_annotation/FEELnc/feelnc_codpot_out/candidate_lncRNA.gtf.lncRNA.fasta | sed 's/>//g' | sort | uniq > feelnc_predicted_ids.txt
