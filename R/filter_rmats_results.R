#!/usr/bin/Rscript
source("rscripts/add_annotation.R")
source("rscripts/coverage_filt.R")

rmats_summary<-matrix(,5,7)
rownames(rmats_summary) <-c("SE","MXE","RI","A5SS","A3SS")
colnames(rmats_summary) <-c("coverage","PSI","PSI&FDR", "protein coding", "lncRNA","Sense Overlapping", "Unannotated")

SE_all_results<-read.table("rMats_results/unfiltered/SE.MATS.JC.txt",
                           header=T,
                           sep="\t",
                           row.names=1)
SE_coverage_filt<-coverage_filt(SE_all_results)
SE_FDR_filt<-SE_coverage_filt[SE_coverage_filt$FDR < 0.05,]
SE_PSI_filt<-SE_FDR_filt[abs(SE_FDR_filt$IncLevelDifference) > 0.1,]
SE_final_annotated<-add_annotation(SE_PSI_filt,"SE")
rmats_summary[1,1]<-dim(SE_coverage_filt)[1]
rmats_summary[1,3]<-dim(SE_PSI_filt)[1]
rmats_summary[1,2]<-dim(SE_FDR_filt)[1]
rmats_summary[1,4]<-sum(SE_final_annotated$Ensembl.Biotype=="protein_coding")
rmats_summary[1,5]<-sum(SE_final_annotated$Ensembl.Biotype=="lincRNA")
rmats_summary[1,6]<-sum(SE_final_annotated$Ensembl.Biotype=="protein_coding|lincRNA" | SE_final_annotated$Ensembl.Biotype=="protein_coding|protein_coding" )
rmats_summary[1,7]<-sum(SE_final_annotated$Gene.Symbol=="Unannotated")
save(SE_all_results,SE_coverage_filt,SE_FDR_filt,SE_PSI_filt,SE_final_annotated, file="rMats_results/SE_filtered_annotated.rData")
write.table(SE_final_annotated,file="rMats_results/SE_filtered_annotated.txt",sep="\t",quote=F)


MXE_all_results<-read.table("rMats_results/unfiltered/MXE.MATS.JC.txt",
                           header=T,
                           sep="\t",
                           row.names=1)
MXE_coverage_filt<-coverage_filt(MXE_all_results)
MXE_FDR_filt<-MXE_coverage_filt[MXE_coverage_filt$FDR < 0.05,]
MXE_PSI_filt<-MXE_FDR_filt[abs(MXE_FDR_filt$IncLevelDifference) > 0.1,]
MXE_final_annotated<-add_annotation(MXE_PSI_filt,"MXE")
rmats_summary[2,1]<-dim(MXE_coverage_filt)[1]
rmats_summary[2,3]<-dim(MXE_PSI_filt)[1]
rmats_summary[2,2]<-dim(MXE_FDR_filt)[1]
rmats_summary[2,4]<-sum(MXE_final_annotated$Ensembl.Biotype=="protein_coding")
rmats_summary[2,5]<-sum(MXE_final_annotated$Ensembl.Biotype=="lincRNA")
rmats_summary[2,6]<-sum(MXE_final_annotated$Ensembl.Biotype=="protein_coding|lincRNA" | MXE_final_annotated$Ensembl.Biotype=="protein_coding|protein_coding" )
rmats_summary[2,7]<-sum(MXE_final_annotated$Gene.Symbol=="Unannotated")
save(MXE_all_results,MXE_coverage_filt,MXE_FDR_filt,MXE_PSI_filt,MXE_final_annotated, file="rMats_results/MXE_filtered_annotated.rData")
write.table(MXE_final_annotated,file="rMats_results/MXE_filtered_annotated.tsv",sep="\t",quote=F)


RI_all_results<-read.table("rMats_results/unfiltered/RI.MATS.JC.txt",
                           header=T,
                           sep="\t",
                           row.names=1)
RI_coverage_filt<-coverage_filt(RI_all_results)
RI_FDR_filt<-RI_coverage_filt[RI_coverage_filt$FDR < 0.05,]
RI_PSI_filt<-RI_FDR_filt[abs(RI_FDR_filt$IncLevelDifference) > 0.1,]
RI_final_annotated<-add_annotation(RI_PSI_filt,"RI")
rmats_summary[3,1]<-dim(RI_coverage_filt)[1]
rmats_summary[3,3]<-dim(RI_PSI_filt)[1]
rmats_summary[3,2]<-dim(RI_FDR_filt)[1]
rmats_summary[3,4]<-sum(RI_final_annotated$Ensembl.Biotype=="protein_coding")
rmats_summary[3,5]<-sum(RI_final_annotated$Ensembl.Biotype=="lincRNA")
rmats_summary[3,6]<-sum(RI_final_annotated$Ensembl.Biotype=="protein_coding|lincRNA" | RI_final_annotated$Ensembl.Biotype=="protein_coding|protein_coding" )
rmats_summary[3,7]<-sum(RI_final_annotated$Gene.Symbol=="Unannotated")
save(RI_all_results,RI_coverage_filt,RI_FDR_filt,RI_PSI_filt,RI_final_annotated, file="rMats_results/RI_filtered_annotated.rData")
write.table(RI_final_annotated,file="rMats_results/RI_filtered_annotated.txt",sep="\t",quote=F)

A5SS_all_results<-read.table("rMats_results/unfiltered/A5SS.MATS.JC.txt",
                           header=T,
                           sep="\t",
                           row.names=1)
A5SS_coverage_filt<-coverage_filt(A5SS_all_results)
A5SS_FDR_filt<-A5SS_coverage_filt[A5SS_coverage_filt$FDR < 0.05,]
A5SS_PSI_filt<-A5SS_FDR_filt[abs(A5SS_FDR_filt$IncLevelDifference) > 0.1,]
A5SS_final_annotated<-add_annotation(A5SS_PSI_filt,"A5SS")
rmats_summary[4,1]<-dim(A5SS_coverage_filt)[1]
rmats_summary[4,3]<-dim(A5SS_PSI_filt)[1]
rmats_summary[4,2]<-dim(A5SS_FDR_filt)[1]
rmats_summary[4,4]<-sum(A5SS_final_annotated$Ensembl.Biotype=="protein_coding")
rmats_summary[4,5]<-sum(A5SS_final_annotated$Ensembl.Biotype=="lincRNA")
rmats_summary[4,6]<-sum(A5SS_final_annotated$Ensembl.Biotype=="protein_coding|lincRNA" | A5SS_final_annotated$Ensembl.Biotype=="protein_coding|protein_coding" )
rmats_summary[4,7]<-sum(A5SS_final_annotated$Gene.Symbol=="Unannotated")
save(A5SS_all_results,A5SS_coverage_filt,A5SS_FDR_filt,A5SS_PSI_filt,A5SS_final_annotated, file="rMats_results/A5SS_filtered_annotated.rData")
write.table(A5SS_final_annotated,file="rMats_results/A5SS_filtered_annotated.txt",sep="\t",quote=F)


A3SS_all_results<-read.table("rMats_results/unfiltered/A3SS.MATS.JC.txt",
                           header=T,
                           sep="\t",
                           row.names=1)
A3SS_coverage_filt<-coverage_filt(A3SS_all_results)
A3SS_FDR_filt<-A3SS_coverage_filt[A3SS_coverage_filt$FDR < 0.05,]
A3SS_PSI_filt<-A3SS_FDR_filt[abs(A3SS_FDR_filt$IncLevelDifference) > 0.1,]
A3SS_final_annotated<-add_annotation(A3SS_PSI_filt,"A3SS")
save(A3SS_all_results,A3SS_coverage_filt,A3SS_FDR_filt,A3SS_PSI_filt,A3SS_final_annotated, file="rMats_results/A3SS_filtered_annotated.rData")
write.table(A3SS_final_annotated,file="rMats_results/A3SS_filtered_annotated.txt",sep="\t",quote=F)

rmats_summary[5,1]<-dim(A3SS_coverage_filt)[1]
rmats_summary[5,3]<-dim(A3SS_PSI_filt)[1]
rmats_summary[5,2]<-dim(A3SS_FDR_filt)[1]
rmats_summary[5,4]<-sum(A3SS_final_annotated$Ensembl.Biotype=="protein_coding")
rmats_summary[5,5]<-sum(A3SS_final_annotated$Ensembl.Biotype=="lincRNA")
rmats_summary[5,6]<-sum(A3SS_final_annotated$Ensembl.Biotype=="protein_coding|lincRNA" | A3SS_final_annotated$Ensembl.Biotype=="protein_coding|protein_coding" )
rmats_summary[5,7]<-sum(A3SS_final_annotated$Gene.Symbol=="Unannotated")
write.table(rmats_summary,file="rMats_results/rmats_summary.txt",sep="\t",quote=F)









