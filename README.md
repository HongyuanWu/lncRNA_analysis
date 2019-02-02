# identificaiton and differential expression analysis of CHO cell long non-coding lncRNA

These scripts replicate the results of the following manuscript

## Installation
### Dependancies

## RNASeq read QC, alignment and genome guided transcriptome assembly
TBC

### get the ensembl CHOK1 genome and GTF
```bash
./scripts/prepare_genome.sh -v 94 -o reference_genome
```

###make a STAR index for alignment
-a = genome fasta file
-g = anntation file
-p = processors

```bash
./scripts/make_star_index.sh -a reference_genome/ensembl_chok1_genome.fa -g reference_genome/ensembl_chok1_genome.gtf -p 32
```

### create a list of sample sample_names
```bash
ls ../data/raw/ | sed -n 's/\.fastq.gz$//p' | cut -d_ -f1-2 | uniq > ../data/sample_names.txt
```

### trim adapter sequences
```bash
cat ../data/sample_names.txt | while read sample; do
./scripts/trim_adapter.sh -s $sample  -i ../data/raw -o ../data/preprocessed/cutadapt&
done
```

### quality trimming
```bash
cat ../data/sample_names.txt | while read sample; do
./scripts/trim_quality.sh -s $sample -i ../data/preprocessed/cutadapt -o../data/preprocessed
done
```

### map to CHOK1 genome
```bash
cat ../data/sample_names.txt | while read sample; do
./scripts/star_mapping.sh -s $sample -i ../data/preprocessed/paired -g reference_gene/star_index -o mapped -p 32
done
```

### string tie assembly
```bash
cat ../data/sample_names.txt | while read sample; do
./scripts/stringtie_star.sh -s $sample mapping -i mapped -g reference_genome/ensembl_chok1_genome.gtf -o stringtie_output -p 32
done
```
### merge individual stringtie assemblies and compare to ENSEMBL annotation
```bash
./scripts/stringtie_merge.sh -t stringtie_output reference_genome/ensembl_chok1_genome.gtf
```

#### calculate TPM expression values
```bash
cat ../data/sample_names.txt | while read sample; do
./scripts/run_TPM.sh -s $sample -g  stringtie_output/stringtie_merged.gtf -o lncrna_annotation/TPM -b ../alt_splicing_analysis/mapping/
done
```

####  aggregate expression for each sample
./scripts/make_TPM_matrix.sh -s ../data/sample_names.txt -o lncrna_annotation/TPM

## Long non-coding RNA identification
The stringtie transcriptome assembly is used to predict lncRNAs using FEELNc
#### make a directory for the lncRNA annotation steps
```bash
mkdir -p lncrna_annotation
```

#### FEELNc analysis
The stringtie transcriptome assembly is used to predict lncRNAs using FEELNc
```bash
./scripts/run_FEELnc.sh -G reference_genome/ensembl_chok1_genome.gtf -g stringtie_output/stringtie_merged.gtf -f reference_genome/ensembl_chok1_genome.fa -o lncrna_annotation/FEELnc
```

#### Use transdecoder to create a cDNA fasta file identify the longest ORF for each candidate lncRNA
```bash
./scripts/run_Transdecoder.sh -g lncrna_annotation/FEELnc/candidate_lncRNA.nocodpot.gtf -f reference_genome/reference_genome/ensembl_chok1_genome.fa -o lncrna_annotation/TRANSDECODER
```

#### CPAT coding prediction for FEELNc candidate lncRNAs
```bash
./scripts/run_CPAT.sh -f lncrna_annotation/TRANSDECODER/candidate_lncRNA.nocodpot.cdna.fa -o lncrna_annotation/CPAT
```

#### CPC2 coding prediction for FEELnc candidate lncRNAs
```bash
./scripts/run_CPC2.sh -f lncrna_annotation/TRANSDECODER/candidate_lncRNA.nocodpot.cdna.fa -o lncrna_annotation/CPC2
```

### Assess FEELnc candiate lncRNAs for the presence of protein domains
```bash
./scripts/run_HMMscan.sh -t 32 -e 1e-5 -p lncrna_annotation/TRANSDECODER/longest_orfs.pep -o lncrna_an  notation/PFAM
```

### Assess FEELnc candiate lncRNAs for the presence of proteins, miRNAs, and other non-coding RNAs (e.g. snoRNAs) using BLAST
```bash
./scripts/run_BLAST.sh  -t 32 -e 1e-5 -s lncrna_annotation/SWISSPROT -p lncrna_annotation/transdecoder/longest_orfs.pep -m lncrna_annotation/MIRBASE -r lncrna_annotation/RFAM -l lncrna_annotation/TRANSDECODER/candidate_lncRNA.nocodpot.cdna.fa
```
#### Filter FEELNc output using additional protein potential calculators, PFAM search and BLAST against protein and RNA databases

```bash
Rscript R/filter_lncrna.R \
"lncrna_annotation/FEELnc/candidate_lncRNA.nocodpot.gtf" \
"lncrna_annotation/CPC2/CPC2.analysis.txt" \
"lncrna_annotation/CPAT/CPAT.analysis.txt" \
"lncrna_annotation/SWISSPROT/blastp.outfmt6" \
"lncrna_annotation/MIRBASE/blastn.outfmt6" \
"lncrna_annotation/PFAM/pfam_domain_transcripts" \
"lncrna_annotation/RFAM/blastn.outfmt6" \
"lncrna_annotation/TPM/transcript_tpm_all_samples.tsv" \
"lncrna_annotation/FEELnc/lncRNA_classes.txt" \
"lncrna_annotation"
```

## Differential expression analysis

```bash
cat ../data/sample_names.txt | while read sample; do
./scripts/htseq_count.sh -s $sample ../alt_splicing_analysis/mapping/ -g stringtie_output/stringtie_merged.gtf -o htseq_count&
done
```

### count for DESeq2
```bash
Rscript R/run_deseq2.R
```
