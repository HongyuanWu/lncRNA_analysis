#!/usr/bin/env bash

mkdir lncrna_annotation/blast_pfam
~/bin/TransDecoder-TransDecoder-v5.5.0/util/gtf_genome_to_cdna_fasta.pl \
lncrna_annotation/FEELnc/feelnc_codpot_out/candidate_lncRNA.gtf.lncRNA.gtf \
reference_genome/ensembl_chok1_genome.fa \
> lncrna_annotation/transdecoder/candidate_lncrna_transcripts.fasta

TransDecoder.LongOrfs \
-t lncrna_annotation/transdecoder/candidate_lncrna_transcripts.fasta \
-O lncrna_annotation/transdecoder/
