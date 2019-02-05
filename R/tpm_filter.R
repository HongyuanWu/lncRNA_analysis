#filter genes with  TPM < 25
make_tpm_matrix<-function(sample_names, threshold) {
k=0
for (i in 1:length(sample_names)){
  while (k == 0){
    tpm_matrix<-matrix(,dim(gene_abundances)[1],length(sample_names))
    k=k+1
    }
    gene_abundances<-read.table(paste("lncrna_annotation/TPM/",sample_names[i],
                                "/gene_abundances.tsv", sep=""),sep="\t", header=T)
    tpm_matrix[,i]<-gene_abundances$TPM
}
colnames(tpm_matrix)<-sample_names
rownames(tpm_matrix)<-gene_abundances$Gene.ID
tpm_matrix<-tpm_matrix[apply(tpm_matrix, 1, max) >=threshold,]
return(tpm_matrix)
}
