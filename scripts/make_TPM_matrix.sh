#!/usr/bin/env bash
if (($# == 0)); then
        echo "Usage:"
        echo "-s = SAmple ID "
        echo "-o = Output directory"
        exit 2
fi
while getopts s:o: option
  do
    case "${option}"
      in
      s) SAMPLELIST=${OPTARG};;
      o) OUTDIR=${OPTARG};;
    esac
done

input_directories=$(sed "s|^|$OUTDIR|" $SAMPLELIST | paste -sd ",")
echo $input_directories

./stringtie_expression_matrix.pl \
--expression_metric=TPM \
--result_dirs=$input_directories \
--transcript_matrix_file=$OUTDIR/transcript_tpm_all_samples.tsv \
--gene_matrix_file=$OUTDIR/gene_tpm_all_samples.tsv
