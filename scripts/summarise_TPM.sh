#!/usr/bin/env bash

if [ ! -f lncrna_annotation/TPM/stringtie_expression_matrix.pl ]; then
wget https://raw.githubusercontent.com/griffithlab/rnaseq_tutorial/master/scripts/stringtie_expression_matrix.pl \
-P lncrna_annotation/TPM/
fi
chmod +x lncrna_annotation/TPM/stringtie_expression_matrix.pl

lncrna_annotation/TPM/stringtie_expression_matrix.pl \
--expression_metric=TPM \
--result_dirs='lncrna_annotation/TPM/REP31_1/,lncrna_annotation/TPM/REP31_2/,lncrna_annotation/TPM/REP31_3/,lncrna_annotation/TPM/REP31_4/,lncrna_annotation/TPM/REP37_1/,lncrna_annotation/TPM/REP37_2/,lncrna_annotation/TPM/REP31_3/,lncrna_annotation/TPM/REP31_4/' \
--transcript_matrix_file=transcript_tpm_all_samples.tsv \
--gene_matrix_file=gene_tpm_all_samples.tsv
