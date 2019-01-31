#!/usr/bin/env bash

mkdir lncrna_annotation/CPAT

#get mouse CPAT data if needed
if [ ! -f lncrna_annotation/CPAT/Mouse_logitModel.RDat ]; then
wget https://ayera.dl.sourceforge.net/project/rna-cpat/v1.2.2/prebuilt_model/Mouse_logitModel.RData \
-P lncrna_annotation/CPAT
fi

if [ ! -f lncrna_annotation/CPAT/Mouse_Hexamer.tsv ]; then
wget https://ayera.dl.sourceforge.net/project/rna-cpat/v1.2.2/prebuilt_model/Mouse_Hexamer.tsv \
-P lncrna_annotation/CPAT
fi

gffread \
-w lncrna_annotation/FEELnc/feelnc_codpot_out/candidate_lncRNA.gtf.lncRNA.fasta \
-g reference_genome/ensembl_chok1_genome.fa \
lncrna_annotation/FEELnc/feelnc_codpot_out/candidate_lncRNA.gtf.lncRNA.gtf

cpat.py \
-g lncrna_annotation/FEELnc/feelnc_codpot_out/candidate_lncRNA.gtf.lncRNA.fasta \
-o lncrna_annotation/CPAT/CPAT.analysis.txt \
-x lncrna_annotation/CPAT/Mouse_Hexamer.tsv \
-d lncrna_annotation/CPAT/Mouse_logitModel.RData

awk '{if($6 < 0.44){print $1}}' lncrna_annotation/CPAT/CPAT.analysis.txt | \
tail -n +2 | sort > lncrna_annotation/CPAT/cpat.low_coding_potential

awk '{if($6 >= 0.44){print $1}}' lncrna_annotation/CPAT/CPAT.analysis.txt | \
tail -n +2 | sort > lncrna_annotation/CPAT/cpat.high_coding_potential

awk '{if($8=="coding"){print $0}}' lncrna_annotation/FEELnc/CPC.CPAT.analysis.txt | wc -l
