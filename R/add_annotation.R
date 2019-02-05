#!/usr/bin/Rscript
add_annotation<-function(rmats_data_frame, event){

  chok1_entrez<-readLines("reference_genome/chok1_ncbi_ids.txt")

  suppressMessages(library(biomaRt))
  ensembl=useMart("ensembl")
  ensembl = useDataset("ccrigri_gene_ensembl",mart=ensembl)
  filters = listFilters(ensembl)
  attributes=listAttributes(ensembl)

  if (event=="RI"){
     coordinate_string1="riExonStart_0base"
     coordinate_string2="riExonEnd"
     } else if (event=="SE"){
     coordinate_string1="exonStart_0base"
     coordinate_string2="exonEnd"
     } else if (event=="A5SS"|event=="A3SS"){
     coordinate_string1="longExonStart_0base"
     coordinate_string2="longExonEnd"
     } else if (event=="MXE") {
     coordinate_string1="X1stExonStart_0base"
     coordinate_string2="X1stExonEnd"
     }

  coordinates<-cbind(as.character(rmats_data_frame$chr),
                   rmats_data_frame[,coordinate_string1],
                   rmats_data_frame[,coordinate_string2],
                   as.character(rmats_data_frame$strand))
  coordinates[,1]<-gsub("chr", "", coordinates[,1],fixed=T)
  coordinates[,4]<-gsub("+", "+1", coordinates[,4],fixed=T)
  coordinates[,4]<-gsub("-", "-1", coordinates[,4],fixed=T)
  rownames(coordinates)<-rownames(rmats_data_frame)

  annotations<- matrix(,dim(rmats_data_frame)[1], ncol=6)
  rownames(annotations)<-rownames(rmats_data_frame)
  colnames(annotations)<-c("ensembl_gene_id",
                                  "entrezgene",
                                  "external_gene_name",
                                  "description",
                                  "gene_biotype",
                                  "Sense Overlapping")
   pb <- txtProgressBar(min = 0, max = dim(rmats_data_frame)[1], style = 3)
  for(i in 1:dim(rmats_data_frame)[1]){
  Sys.sleep(0.1)
   # update progress bar
   setTxtProgressBar(pb, i)
    biomart.out<-getBM(
                       attributes=c('ensembl_gene_id','entrezgene',
                                    'external_gene_name', 'description',
                                    'gene_biotype'),
                       filters = c('chromosome_name', 'start',
                                    'end','strand'),
                       values = list(coordinates[i,1],coordinates[i,2],
                                     coordinates[i,3],coordinates[i,4]),
                       mart = ensembl,
                       uniqueRows = TRUE)

  if (dim(biomart.out)[1] == 1) {
      annotations[i,]<-cbind(as.matrix(biomart.out),"No")
  } else if(dim(biomart.out)[1] == 0) {
      annotations[i,] <-rep("Unannotated",6)
  } else if (dim(biomart.out)[1] > 1) {
          if (biomart.out$ensembl_gene_id[1]==biomart.out$ensembl_gene_id[2]){
          annotations[i,]<-cbind(as.matrix(biomart.out[1,]),"No")
          } else if (is.na(biomart.out$entrezgene) == 1){
          annotations[i,]<-cbind(as.matrix(biomart.out[!is.na(biomart.out$entrezgene),])
                                 ,"No")
          } else {
          annotations[i,] <-cbind(paste(biomart.out[,1],collapse="|"),
                              paste(biomart.out[,2],collapse="|"),
                              paste(biomart.out[,3],collapse="|"),
                              paste(biomart.out[,4],collapse="|"),
                              paste(biomart.out[,5],collapse="|"),
                              "Yes")}
  }

  if (is.na(annotations[i,3])){
    annotations[i,3] <-strsplit(chok1_entrez[grep(annotations[i,2],chok1_entrez, fixed=T)], "\t")[[1]][3]
  if (is.na(annotations[i,3])){annotations[i,2:6]<-"Unannotated"}
  }
 }

if(event=="MXE"){
annotated_rmats_data_frame<-cbind(rmats_data_frame,annotations)[,c(3,4,1,25,26,27,28,29,30,23,22,24,20,21,5:12,14:19)]
colnames(annotated_rmats_data_frame)<-c("Scaffold", "Strand", "GTF.gene.ID", "Ensembl.Gene.ID",
              "NCBI.Gene.ID", "Gene.Symbol", "Gene.Name","Ensembl.Biotype",
              "Sense.Overlapping","Normalised.Counts.@37",
              "Normalised.Counts @31", "Delta.PSI", "P.value", "FDR",
              "1stExonStart_0base","1stExonEnd","2ndExonStart_0base","2ndExonEnd",
              "upstreamES","upstreamEE","downstreamES","downstreamEE","IJC_SAMPLE_1","SJC_SAMPLE_1",
              "IJC_SAMPLE_2", "SJC_SAMPLE_2","IncFormLen","SkipFormLen")
} else {
annotated_rmats_data_frame<-cbind(rmats_data_frame,annotations)[,c(3,4,1,23,24,25,26,27,28,21,20,22,18,19,5:10,12:17)]
colnames(annotated_rmats_data_frame)<-c("Scaffold", "Strand", "GTF.gene.ID", "Ensembl.Gene.ID",
              "NCBI.Gene.ID", "Gene.Symbol", "Gene.Name","Ensembl.Biotype",
              "Sense.Overlapping","Normalised.Counts.@37",
              "Normalised.Counts @31", "Delta.PSI", "P.value", "FDR",
              "exonStart_0base","exonEnd","upstreamES","upstreamEE",
              "downstreamES","downstreamEE","IJC_SAMPLE_1","SJC_SAMPLE_1",
              "IJC_SAMPLE_2", "SJC_SAMPLE_2","IncFormLen","SkipFormLen")
}

annotated_rmats_data_frame[,1]<-gsub("chr", "", annotated_rmats_data_frame[,1],fixed=T)
annotated_rmats_data_frame<-annotated_rmats_data_frame[order(annotated_rmats_data_frame$Delta.PSI,decreasing = TRUE),]
return(annotated_rmats_data_frame)
close(pb)
}
