#!/usr/bin/env bash

# compare CPC2 to feelnc
mkdir lncrna_annotation/CPC2

/home/colin/bin/CPC2-beta/bin/CPC2.py -i lncrna_annotation/FEELnc/feelnc_codpot_out/candidate_lncRNA.gtf.lncRNA.fasta \
-o lncrna_annotation/FEELnc/CPC.FEELnc.analysis.txt

grep noncoding lncrna_annotation/FEELnc/CPC.FEELNc.analysis.txt | awk '{print $1}' | sort |uniq > lncrna_annotation/CPC2/cpc2_noncoding_ids.txt

awk -F'"' 'FNR==NR {block[$0];next} $2 in block' \
lncrna_annotation/CPC2/cpc2_noncoding_ids.txt lncrna_annotation/FEELnc/candidate_lncRNA.gtf


grep '^>' lncrna_annotation/FEELnc/feelnc_codpot_out/candidate_lncRNA.gtf.lncRNA.fasta | sed 's/>//g' | sort | uniq > feelnc_predicted_ids.txt
