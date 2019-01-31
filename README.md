# identificaiton and differential expression analysis of CHO cell long non-coding lncRNA

These scripts replicate the results of the following manuscript

## Installation
### Dependancies

## Prerequisites
TBC

# get the ensembl CHOK1 genome and GTF
```bash
././prepare_genome.sh -v 94 -o reference_genome
```

#make a STAR index for alignment
-a = genome fasta file
-g = anntation file
-p = processors
```bash
./make_star_index.sh -a reference_genome/ensembl_chok1_genome.fa -g reference_genome/ensembl_chok1_genome.gtf -p 32
```

### trim adapter sequences
```bash
./trim_adapter.sh -s REP37_1 -i ../data/raw -o ../data/preprocessed/cutadapt&
./trim_adapter.sh -s REP37_2 -i ../data/raw -o ../data/preprocessed/cutadapt&
./trim_adapter.sh -s REP37_3 -i ../data/raw -o ../data/preprocessed/cutadapt&
./trim_adapter.sh -s REP37_4 -i ../data/raw -o ../data/preprocessed/cutadapt&
./trim_adapter.sh -s REP31_1 -i ../data/raw -o ../data/preprocessed/cutadapt&
./trim_adapter.sh -s REP31_2 -i ../data/raw -o ../data/preprocessed/cutadapt&
./trim_adapter.sh -s REP31_3 -i ../data/raw -o ../data/preprocessed/cutadapt&
./trim_adapter.sh -s REP31_4 -i ../data/raw -o ../data/preprocessed/cutadapt
```

### quality trimming
```bash
./trim_quality.sh -s REP37_1 -i ../data/preprocessed/cutadapt -o../data/preprocessed
./trim_quality.sh -s REP37_2 -i ../data/preprocessed/cutadapt -o../data/preprocessed
./trim_quality.sh -s REP37_3 -i ../data/preprocessed/cutadapt -o../data/preprocessed
./trim_quality.sh -s REP37_4 -i ../data/preprocessed/cutadapt -o../data/preprocessed
./trim_quality.sh -s REP31_1 -i ../data/preprocessed/cutadapt -o../data/preprocessed
./trim_quality.sh -s REP31_2 -i ../data/preprocessed/cutadapt -o../data/preprocessed
./trim_quality.sh -s REP31_3 -i ../data/preprocessed/cutadapt -o../data/preprocessed
./trim_quality.sh -s REP31_4 -i ../data/preprocessed/cutadapt -o../data/preprocessed
```

### map to CHOK1 genome
```bash
./star_mapping.sh -s REP37_1  ../data/preprocessed/paired
./star_mapping.sh -s REP37_2  ../data/preprocessed/paired
./star_mapping.sh -s REP37_3  ../data/preprocessed/paired
./star_mapping.sh -s REP37_4  ../data/preprocessed/paired
./star_mapping.sh -s REP31_1  ../data/preprocessed/paired
./star_mapping.sh -s REP31_2  ../data/preprocessed/paired
./star_mapping.sh -s REP31_3  ../data/preprocessed/paired
./star_mapping.sh -s REP31_4  ../data/preprocessed/paired
```

### count for DESeq2
```bash
./htseq_count.sh REP37_1 ../alt_splicing_analysis/mapping/ stringtie_output/rmats_stringtie.gtf&
./htseq_count.sh REP37_2 ../alt_splicing_analysis/mapping/ stringtie_output/rmats_stringtie.gtf&
./htseq_count.sh REP37_3 ../alt_splicing_analysis/mapping/ stringtie_output/rmats_stringtie.gtf&
./htseq_count.sh REP37_4 ../alt_splicing_analysis/mapping/ stringtie_output/rmats_stringtie.gtf&
./htseq_count.sh REP31_1 ../alt_splicing_analysis/mapping/ stringtie_output/rmats_stringtie.gtf&
./htseq_count.sh REP31_2 ../alt_splicing_analysis/mapping/ stringtie_output/rmats_stringtie.gtf&
./htseq_count.sh REP31_3 ../alt_splicing_analysis/mapping/ stringtie_output/rmats_stringtie.gtf&
./htseq_count.sh REP31_4 ../alt_splicing_analysis/mapping/ stringtie_output/rmats_stringtie.gtf
```

### count for DESeq2
```bash
Rscript rscripts/run_deseq2.R
```




### string tie assembly
```bash
./stringtie_star.sh REP37_1 mapping reference_genome/ensembl_chok1_genome.gtf
./stringtie_star.sh REP37_2 mapping reference_genome/ensembl_chok1_genome.gtf
./stringtie_star.sh REP37_3 mapping reference_genome/ensembl_chok1_genome.gtf
./stringtie_star.sh REP37_4 mapping reference_genome/ensembl_chok1_genome.gtf
./stringtie_star.sh REP31_1 mapping reference_genome/ensembl_chok1_genome.gtf
./stringtie_star.sh REP31_2 mapping reference_genome/ensembl_chok1_genome.gtf
./stringtie_star.sh REP31_3 mapping reference_genome/ensembl_chok1_genome.gtf
./stringtie_star.sh REP31_4 mapping reference_genome/ensembl_chok1_genome.gtf
```

### merge individual stringtie assemblies and compare to ENSEMBL annotation
```bash
./stringtie_merge.sh stringtie_output reference_genome/ensembl_chok1_genome.gtf
```


./run_TPM.sh REP37_1
./run_TPM.sh REP37_2
./run_TPM.sh REP37_3
./run_TPM.sh REP37_4
./run_TPM.sh REP31_1
./run_TPM.sh REP31_2
./run_TPM.sh REP31_3
./run_TPM.sh REP31_4


./stringtie_expression_matrix.pl \
--expression_metric=TPM \
--result_dirs='lncrna_annotation/TPM/REP31_1/,lncrna_annotation/TPM/REP31_2/,lncrna_annotation/TPM/REP31_3/,lncrna_annotation/TPM/REP31_4/,lncrna_annotation/TPM/REP37_1/,lncrna_annotation/TPM/REP37_2/,lncrna_annotation/TPM/REP31_3/,lncrna_annotation/TPM/REP31_4/' \
--transcript_matrix_file=lncrna_annotation/TPM/transcript_tpm_all_samples.tsv \
--gene_matrix_file=lncrna_annotation/TPM/gene_tpm_all_samples.tsv
