#!/usr/bin/Rscript
coverage_filt<-function(rmats_data_frame){
  merged_counts<-paste(rmats_data_frame$IJC_SAMPLE_1,
                       rmats_data_frame$SJC_SAMPLE_1,
                       rmats_data_frame$IJC_SAMPLE_2,
                       rmats_data_frame$SJC_SAMPLE_2,
                       sep=",")
  counts <- as.matrix(cbind(data.frame(do.call('rbind',
  strsplit(as.character(merged_counts),',',fixed=TRUE)))))

  class(counts)<-"numeric"
  rownames(counts)<-rownames(rmats_data_frame)
  selected_IDs<-rownames(counts[rowMeans(counts) >= 10,])
  rmats_data_frame<-rmats_data_frame[selected_IDs,]
  return(rmats_data_frame)
}
