#!/usr/bin/env bash

mkdir lncrna_annotation/SWISSPROT

if [ ! -f lncrna_annotation/SWISSPROT/uniprot_sprot.fasta ]; then
wget ftp://ftp.uniprot.org/pub/databases/uniprot/current_release/knowledgebase/complete/uniprot_sprot.fasta.gz \
-P lncrna_annotation/SWISSPROT
gunzip lncrna_annotation/SWISSPROT/uniprot_sprot.fasta.gz
fi

makeblastdb -in lncrna_annotation/SWISSPROT/uniprot_sprot.fasta -dbtype prot

blastp -query lncrna_annotation/transdecoder/longest_orfs.pep \
-db lncrna_annotation/SWISSPROT/uniprot_sprot.fasta  \
-max_target_seqs 1 \
-outfmt 6 \
-evalue 1e-5 \
-num_threads 16 \
> lncrna_annotation/SWISSPROT/blastp.outfmt6&
