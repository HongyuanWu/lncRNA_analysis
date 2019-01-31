#!/usr/bin/env bash

mkdir lncrna_annotation/PFAM

if [ ! -f lncrna_annotation/PFAM/Pfam-A.hmm ]; then
wget ftp://ftp.ebi.ac.uk/pub/databases/Pfam/current_release/Pfam-A.hmm.gz \
-P lncrna_annotation/PFAM
gunzip lncrna_annotation/PFAM/Pfam-A.hmm.gz
fi

hmmpress lncrna_annotation/PFAM/Pfam-A.hmm
hmmscan \
--cpu 16 \
-E 1e-5 \
--domtblout lncrna_annotation/PFAM/pfam.domtblout \
lncrna_annotation/PFAM/Pfam-A.hmm \
lncrna_annotation/transdecoder/longest_orfs.pep
