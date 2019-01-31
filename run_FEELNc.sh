#!/usr/bin/env bash
mkdir lncrna_annotation/FEELnc

# filter transcripts overlapping with sense protein coding exons. Keeping monoex to deal with misc_RNA biotype
FEELnc_filter.pl -i stringtie_output/stringtie_merged.gtf -a reference_genome/ensembl_chok1_genome.gtf \
-b transcript_biotype=protein_coding --monoex=1 -p 32 > lncrna_annotation/FEELnc/candidate_lncRNA.gtf

# create a gtf for known protein coding transcripts
awk '{ if ($0 ~ "transcript_id") print $0; else print $0" transcript_id \"\";"; }' reference_genome/ensembl_chok1_genome.gtf| \
grep 'protein_coding' > lncrna_annotation/FEELnc/known_mrna.gtf

#determine protein coding potential
FEELnc_codpot.pl -i lncrna_annotation/FEELnc/candidate_lncRNA.gtf -m shuffle -a lncrna_annotation/FEELnc/known_mrna.gtf \
-g reference_genome/ensembl_chok1_genome.fa

# classify putative lncRNA transcripts
FEELnc_classifier.pl -i feelnc_codpot_out/candidate_lncRNA.gtf.lncRNA.gtf -a reference_genome/ensembl_chok1_genome.gtf > lncrna_annotation/FEELnc/lncRNA_classes.txt
