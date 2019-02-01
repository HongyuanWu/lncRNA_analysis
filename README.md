# identificaiton and differential expression analysis of CHO cell long non-coding lncRNA

These scripts replicate the results of the following manuscript

## Installation
### Dependancies

## Prerequisites
TBC


# get the ensembl CHOK1 genome and GTF
```bash
./prepare_genome.sh -v 94 -o reference_genome
```

#make a STAR index for alignment
-a = genome fasta file
-g = anntation file
-p = processors

```bash
./make_star_index.sh -a reference_genome/ensembl_chok1_genome.fa -g reference_genome/ensembl_chok1_genome.gtf -p 32
```

### create a list of sample sample_names
```bash
ls ../data/raw/ | sed -n 's/\.fastq.gz$//p' | cut -d_ -f1-2 | uniq > ../data/sample_names.txt
```

### trim adapter sequences
```bash
cat ../data/sample_names.txt | while read sample; do
./trim_adapter.sh -s $sample  -i ../data/raw -o ../data/preprocessed/cutadapt&
done
```

### quality trimming
```bash
cat ../data/sample_names.txt | while read sample; do
./trim_quality.sh -s $sample -i ../data/preprocessed/cutadapt -o../data/preprocessed
done
```

### map to CHOK1 genome
```bash
cat ../data/sample_names.txt | while read sample; do
./star_mapping.sh -s $sample -i ../data/preprocessed/paired -g reference_gene/star_index -o mapped -p 32
done
```

### string tie assembly
```bash
cat ../data/sample_names.txt | while read sample; do
./stringtie_star.sh -s $sample mapping -i mapped -g reference_genome/ensembl_chok1_genome.gtf -o stringtie_output -p 32
done
```
### merge individual stringtie assemblies and compare to ENSEMBL annotation
```bash
./stringtie_merge.sh -t stringtie_output reference_genome/ensembl_chok1_genome.gtf
```

### count for DESeq2
```bash
cat ../data/sample_names.txt | while read sample; do
./htseq_count.sh $sample ../alt_splicing_analysis/mapping/ stringtie_output/rmats_stringtie.gtf&
done
```

### count for DESeq2
```bash
Rscript rscripts/run_deseq2.R
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
