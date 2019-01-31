#!/usr/bin/Rscript

library(refGenome)
library(GRanges)
source("rscripts/tpm_filter.R")

#filtering_results
results_summary<-matrix(,8,1)

#load the feelnc gtf
feelnc_gtf <- rtracklayer::import("lncrna_annotation/FEELnc/feelnc_codpot_out/candidate_lncRNA.gtf.lncRNA.gtf")

# remove mtDNA transcripts
feelnc_gtf<-feelnc_gtf[seqnames(feelnc_gtf) != 'MT']
feelnc_lncrna_transcripts<-unique(feelnc_gtf$transcript_id)

#CPC2 results
cpc2 <- read.table("lncrna_annotation/CPC2/CPC2.analysis.txt",sep="\t")
cpc2<-cpc2[cpc2$V8 == "noncoding",]
cpc2_lncrna_transcripts<-as.character(cpc2$V1)

#CPAT  define coding/non-coding based on mouse (0.44)
cpat <- read.table("lncrna_annotation/CPAT/CPAT.analysis.txt")
cpat<-cpat[cpat$coding_prob < 0.44,]
cpat_lncrna_transcripts<-rownames(cpat)

# overlap results of 3 coding potential calculators
lncrna_all_noncoding<-intersect(intersect(feelnc_lncrna_transcripts, cpc2_lncrna_transcripts), cpat_lncrna_transcripts)

# filter results with a blast hit against SWISSPROT
blastp <- read.table("lncrna_annotation/SWISSPROT/blastp.outfmt6",sep="\t")
protein_hit<-data.frame("data"=as.character(blastp$V1))
protein_hit<-substr(as.character(protein_hit$data),1,nchar(as.character(protein_hit$data))-3)
lncrna_all_noncoding<-lncrna_all_noncoding[!(lncrna_all_noncoding %in% protein_hit)]

# filter results with blast hit against miRBase
blastn_mir <- read.table("lncrna_annotation/MIRBASE/blastn.outfmt6",sep="\t")
mirna_hit<-as.character(blastn_mir$V1)
lncrna_all_noncoding<-lncrna_all_noncoding[!(lncrna_all_noncoding %in% mirna_hit)]

# filter results with PFAM domain
pfam_domain_hit <- read.table("lncrna_annotation/PFAM/pfam_domain_transcripts")
pfam_domain_hit<-as.character(pfam_domain_hit[,1])
lncrna_all_noncoding<-lncrna_all_noncoding[!(lncrna_all_noncoding %in% pfam_domain_hit)]

# filter results with RFAM(-lncRNAs sequences)
blastn_rfam<-read.table("lncrna_annotation/RFAM/blastn.outfmt6",sep="\t")
ncrna_hit<-as.character(blastn_rfam$V1)
lncrna_all_noncoding<-lncrna_all_noncoding[!(lncrna_all_noncoding %in% ncrna_hit)]

# expression filter
tpm_matrix<-read.table("lncrna_annotation/TPM/transcript_tpm_all_samples.tsv", sep="\t", header=T, row.names=1)
lncrna_tpm_matrix<-tpm_matrix[lncrna_all_noncoding,]
sum(apply(lncrna_tpm_matrix[lncrna_all_noncoding,],1,max) > 1)

tpm_filtered_lncrnas<-rownames(lncrna_tpm_matrix[apply(lncrna_tpm_matrix[lncrna_all_noncoding,],1,max) > 1,])
save(tpm_filtered_lncrnas, "lncRNA_filtering.rData")


# remove lncRNA with sense overlap with protein coding genes
feelnc_classifications<-read.table("lncrna_annotation/FEELnc/lncRNA_classes.txt",header=T)
