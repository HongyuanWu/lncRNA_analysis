#!/usr/bin/Rscript
suppressMessages(library("DESeq2"))
suppressMessages(library(biomaRt))
dir.create("DESeq2_results", showWarnings = F)

count_file_names <- grep("counts",list.files("htseq_counts"),value=T)


cell_type <- c("low","low","low","low", "high","high","high","high")
sample_information <- data.frame(sampleName = count_file_names,
                          fileName   = count_file_names,
                          condition  = cell_type)

DESeq_data <- DESeqDataSetFromHTSeqCount(sampleTable = sample_information,
                                  directory          = "htseq_counts",
                                  design             = ~condition)

colData(DESeq_data)$condition <- factor(colData(DESeq_data)$condition,
                                      levels = c('low','high'))


rld <- rlogTransformation(DESeq_data, blind=T)
pdf( file="DESeq2_results/31_v_37.pdf")
plotPCA(rld, intgroup="condition")
dev.off()

# set 37C as the comparator
DESeq_data$condition<-relevel(DESeq_data$condition, "high")

# calculate differential expression using the DESeq wrapper function
suppressMessages(DESeq_data <- DESeq(DESeq_data))

#set differential expression criteria
de_results<-results(DESeq_data,    lfcThreshold=0, independentFiltering =T)
# order results by padj value (most significant to least)
sig_de_results <-subset(de_results,  abs(log2FoldChange)> 0.2630344 & padj < 0.05 & baseMean >= 100 )
sig_de_results <- sig_de_results[order(sig_de_results$log2FoldChange, decreasing=T),]
print("Differentially Expressed Genes +/- 1.2 Fold and P < 0.05 and baseMean >= 100")
print(summary(sig_de_results))
print("10 most upregulated genes")
print(head(as.data.frame(sig_de_results), n = 10))
print("10 most downregulated genes")
print(tail(as.data.frame(sig_de_results), n = 10))

  write.csv(sig_de_results,file="DESeq2_results/31_v_37.csv", row.names=T)
save(list=ls(), file="DESeq2_results/31_v_37.RData")
save(sig_de_results, file="DESeq2_results/sig_de_results.RData")
print("DE gene list saved in results folder")
print("PCA plot saved in results folder")
print("Data saved in results folder")
quit()
######################   END OF SCRIPT ######################################
