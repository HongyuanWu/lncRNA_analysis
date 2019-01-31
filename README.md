# alt_splicing_analysis

These scripts replicate the results of the following manuscript

## Installation

### Dependancies 




## Prerequisites 
Trimmomatic [modify the code to add to path]
Cutadpat
STAR
R
Samtools

# get the ensembl CHOK1 genome and GTF
```bash
bash prepare_genome.sh
```

#make the STAR index
```bash
make_star_index.sh
```


### trim adapter sequences
```bash
bash trim_adapter.sh REP37_1 ../data/raw ../data/preprocessed/cutadapt& 
bash trim_adapter.sh REP37_2 ../data/raw ../data/preprocessed/cutadapt& 
bash trim_adapter.sh REP37_3 ../data/raw ../data/preprocessed/cutadapt& 
bash trim_adapter.sh REP37_4 ../data/raw ../data/preprocessed/cutadapt& 
bash trim_adapter.sh REP31_1 ../data/raw ../data/preprocessed/cutadapt& 
bash trim_adapter.sh REP31_2 ../data/raw ../data/preprocessed/cutadapt& 
bash trim_adapter.sh REP31_3 ../data/raw ../data/preprocessed/cutadapt& 
bash trim_adapter.sh REP31_4 ../data/raw ../data/preprocessed/cutadapt 
```

### quality trimming
```bash
bash trim_quality.sh REP37_1 ../data/preprocessed/cutadapt ../data/preprocessed
bash trim_quality.sh REP37_2 ../data/preprocessed/cutadapt ../data/preprocessed
bash trim_quality.sh REP37_3 ../data/preprocessed/cutadapt ../data/preprocessed
bash trim_quality.sh REP37_4 ../data/preprocessed/cutadapt ../data/preprocessed
bash trim_quality.sh REP31_1 ../data/preprocessed/cutadapt ../data/preprocessed
bash trim_quality.sh REP31_2 ../data/preprocessed/cutadapt ../data/preprocessed
bash trim_quality.sh REP31_3 ../data/preprocessed/cutadapt ../data/preprocessed
bash trim_quality.sh REP31_4 ../data/preprocessed/cutadapt ../data/preprocessed
```

### map to CHOK1 genome
```bash
bash star_mapping.sh REP37_1  ../data/preprocessed/paired
bash star_mapping.sh REP37_2  ../data/preprocessed/paired
bash star_mapping.sh REP37_3  ../data/preprocessed/paired
bash star_mapping.sh REP37_4  ../data/preprocessed/paired
bash star_mapping.sh REP31_1  ../data/preprocessed/paired
bash star_mapping.sh REP31_2  ../data/preprocessed/paired
bash star_mapping.sh REP31_3  ../data/preprocessed/paired
bash star_mapping.sh REP31_4  ../data/preprocessed/paired
```

### count for DESeq2
```bash
bash htseq_count.sh REP37_1 mapping reference_genome/ensembl_chok1_genome.gtf&
bash htseq_count.sh REP37_2 mapping reference_genome/ensembl_chok1_genome.gtf&
bash htseq_count.sh REP37_3 mapping reference_genome/ensembl_chok1_genome.gtf&
bash htseq_count.sh REP37_4 mapping reference_genome/ensembl_chok1_genome.gtf&
bash htseq_count.sh REP31_1 mapping reference_genome/ensembl_chok1_genome.gtf&
bash htseq_count.sh REP31_2 mapping reference_genome/ensembl_chok1_genome.gtf&
bash htseq_count.sh REP31_3 mapping reference_genome/ensembl_chok1_genome.gtf&
bash htseq_count.sh REP31_4 mapping reference_genome/ensembl_chok1_genome.gtf
```

### count for DESeq2
```bash
Rscript rscripts/run_deseq2.R
```




### string tie assembly
```bash
bash stringtie_star.sh REP37_1 mapping reference_genome/ensembl_chok1_genome.gtf
bash stringtie_star.sh REP37_2 mapping reference_genome/ensembl_chok1_genome.gtf
bash stringtie_star.sh REP37_3 mapping reference_genome/ensembl_chok1_genome.gtf
bash stringtie_star.sh REP37_4 mapping reference_genome/ensembl_chok1_genome.gtf
bash stringtie_star.sh REP31_1 mapping reference_genome/ensembl_chok1_genome.gtf
bash stringtie_star.sh REP31_2 mapping reference_genome/ensembl_chok1_genome.gtf
bash stringtie_star.sh REP31_3 mapping reference_genome/ensembl_chok1_genome.gtf
bash stringtie_star.sh REP31_4 mapping reference_genome/ensembl_chok1_genome.gtf
```

### merge individual stringtie assemblies and compare to ENSEMBL annotation
```bash
bash stringtie_merge.sh stringtie_output reference_genome/ensembl_chok1_genome.gtf 
```



### trim data for rMATs
```bash
bash rmats_trim.sh REP37_1  ../data/preprocessed/paired
bash rmats_trim.sh REP37_2  ../data/preprocessed/paired
bash rmats_trim.sh REP37_3  ../data/preprocessed/paired
bash rmats_trim.sh REP37_4  ../data/preprocessed/paired
bash rmats_trim.sh REP31_1  ../data/preprocessed/paired
bash rmats_trim.sh REP31_2  ../data/preprocessed/paired
bash rmats_trim.sh REP31_3  ../data/preprocessed/paired
bash rmats_trim.sh REP31_4  ../data/preprocessed/paired
```


### filter and annotate the rmats results
```bash
Rscript rscripts/filter_rmats_results.R
```

bash rmats_run 

```bash
bash make_sashimi.sh input_bams.tsv stringtie_output/rmats_stringtie.gtf 47046 SE
bash make_sashimi.sh input_bams.tsv stringtie_output/rmats_stringtie.gtf 12207 SE
bash make_sashimi.sh input_bams.tsv stringtie_output/rmats_stringtie.gtf 23432 SE
bash make_sashimi.sh input_bams.tsv stringtie_output/rmats_stringtie.gtf 6999  SE
bash make_sashimi.sh input_bams.tsv stringtie_output/rmats_stringtie.gtf 50250 SE
bash make_sashimi.sh input_bams.tsv stringtie_output/rmats_stringtie.gtf 21371 SE
bash make_sashimi.sh input_bams.tsv stringtie_output/rmats_stringtie.gtf 11430 SE

bash make_sashimi.sh input_bams.tsv stringtie_output/rmats_stringtie.gtf 1884 MXE
bash make_sashimi.sh input_bams.tsv stringtie_output/rmats_stringtie.gtf 5617 MXE
bash make_sashimi.sh input_bams.tsv stringtie_output/rmats_stringtie.gtf 3173 MXE
```






