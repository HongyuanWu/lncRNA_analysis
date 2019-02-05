  suppressMessages(library(ggplot2))
  
  qPCR_data<-read.table("qPCR_data.txt",header=T, sep="\t", stringsAsFactors=F)
  
  goi <-c("Dnm1l", "Gpx8", "Dnajc15", "Mff", "Hikeshi", "Immp1l", "Fars2","Rnf34","Ubr2")
  event_type<-c("SE", "SE", "SE", "SE", "SE", "SE", "MXE","MXE","MXE")
  cell_lines<-c("CHOK1_16F","CHODP12","CHOK1_ATCC")
  
  
  for (i in 1:length(goi)){
  	for(j in 1:length(cell_lines)){
  	qPCR_goi<-qPCR_data[qPCR_data[,1] %in% cell_lines[j],c(1:3, grep(goi[i], 		colnames(qPCR_data)))]
          	
     output_values = data.frame(matrix(vector(), 3, 2,
                   dimnames=list(c("Constant", "Skipped", "Included"), c("Fold Change", "pvalue"))),
                  stringsAsFactors=F)
  		
  		groupA1<-as.numeric(qPCR_goi[qPCR_goi[,3] %in% "37",6])
      groupA2<-as.numeric(qPCR_goi[qPCR_goi[,3] %in% "31",6])
  		groupB1<-as.numeric(qPCR_goi[qPCR_goi[,3] %in% "37",5])
      groupB2<-as.numeric(qPCR_goi[qPCR_goi[,3] %in% "31",5])
  		groupC1<-as.numeric(qPCR_goi[qPCR_goi[,3] %in% "37",4])
      groupC2<-as.numeric(qPCR_goi[qPCR_goi[,3] %in% "31",4])
  		output_values$pvalue[1]<-t.test(groupA1,groupA2, alternative="two.sided", var.equal=T)$p.value
  		output_values$pvalue[2]<-t.test(groupB1,groupB2, alternative="two.sided", var.equal=T)$p.value
  		output_values$pvalue[3]<-t.test(groupC1,groupC2, alternative="two.sided", var.equal=T)$p.value		
  
      output_values$Fold.Change[1]<-mean(groupA2)/mean(groupA1)
  		output_values$Fold.Change[2]<-mean(groupB2)/mean(groupB1)
  		output_values$Fold.Change[3]<-mean(groupC2)/mean(groupC1)
  		          
  
      groupA1_norm<-groupA1/mean(groupA1)
      groupA1_sem<-sd(groupA1_norm)/sqrt(length(groupA1_norm))
      groupA2_norm<-groupA2/mean(groupA1)
      groupA2_sem<-sd(groupA2_norm)/sqrt(length(groupA2_norm))
    
                  groupB1_norm<-groupB1/mean(groupB1)
                  groupB1_sem<-sd(groupB1_norm)/sqrt(length(groupB1_norm))
                  groupB2_norm<-groupB2/mean(groupB1)
                  groupB2_sem<-sd(groupB2_norm)/sqrt(length(groupB2_norm))
      
  		groupC1_norm<-groupC1/mean(groupC1)
                  groupC1_sem<-sd(groupC1_norm)/sqrt(length(groupC1_norm))
                  groupC2_norm<-groupC2/mean(groupC1)
                  groupC2_sem<-sd(groupC2_norm)/sqrt(length(groupC2_norm))
      
                  m <- c(mean(groupA1_norm, na.rm=T), mean(groupA2_norm, na.rm=T),mean(groupC1_norm, na.rm=T), mean(groupC2_norm, na.rm=T),mean(groupB1_norm, na.rm=T), mean(groupB2_norm, na.rm=T))	
                  sem <-c(groupA1_sem, groupA2_sem,groupC1_sem, groupC2_sem,groupB1_sem, groupB2_sem)
                  d <-data.frame(V=c("Constant exon", "Constant exon","Skipped Exon", "Skipped Exon","Included Exon", "Included Exon"), mean=m, sem=sem, ID=c("37Deg","31Deg","37Deg", "31Deg","37Deg","31Deg"))
  # d <-data.frame(V=c("Constant exon", "Skipped Exon", "Included Exon"), mean_37=m[c(1,3,5)], mean_31=m[c(2,4,6)] )
  
  	output_values$max.amount[1]<-max(groupA1_norm,groupA2_norm)
  	output_values$max.amount[2]<-max(groupB1_norm,groupB2_norm)
  	output_values$max.amount[3]<-max(groupC1_norm,groupC2_norm)
    output_values$type<-event_type[i]
    output_values$goi<-goi[i]
  
          p<-plot_bar(d,output_values)
         ggsave(paste("barplots/",goi[i],".",cell_lines[j],".tiff"), plot=p, height=5, width=5, units='in', dpi=600)     
  	}	
  } 


plot_bar<-function(d,max_rel_amount){
		p <- ggplot(d, aes(V, mean, fill=factor(ID,levels(ID)[c(2,4,6,1,3,5)])
, width=0.5))
		p <- p + geom_errorbar(aes(ymin=mean, ymax=mean+sem, width=.2), 
                position=position_dodge(width=.6))
		p <-p + geom_bar(stat="identity", position=position_dodge(width=.6), colour="black")
		p <- p + scale_fill_manual(values=c("indianred2", "royalblue2","indianred2", "royalblue2","indianred2", "royalblue2"))
    if (output_values$type[1]=="SE"){
		p <- p + scale_x_discrete(labels= c("Constant Exon", "Skipped Exon", "Included Exon"))
    } else if (output_values$type[1]=="MXE") { 
    p <- p + scale_x_discrete(labels= c("Constant Exon", "Exon 1", "Exon 2"))
    }
		p <- p + theme_bw() + theme(legend.position="none",panel.grid.major =element_blank(),panel.grid.minor = element_blank()) + xlab("") + ylab("Relative Normalised RNA copies\n") +theme(plot.margin=unit(c(1,1,1.5,1.2),"cm"))
		p <- p + theme(axis.text.x = element_text( size=10), axis.text.y = element_text(size=10), axis.title=element_text(size=12))
		y_limit=max(output_values$max.amount) *1.25
	
		p <- p+scale_y_continuous(expand=c(0,0), limits=c(0,y_limit), breaks=seq(0,y_limit, by=1)) 

		
    if (output_values$pvalue[1] < 0.05){
		p <- p+geom_segment(aes(x=0.85, y=m[1]+sem[1]+0.05, xend=0.85, 				yend=output_values$max.amount[1]*1.15))
		p <- p+geom_segment(aes(x=1.15, y=m[2]+sem[2]+0.05, xend=1.15, 				yend=output_values$max.amount[1]		*1.15))
		p <- p+geom_segment(aes(x=0.85, y=output_values$max.amount[1]*1.15, xend=1.15, 		yend=output_values$max.amount[1] 		*1.15))
		if (output_values$pvalue[1] < 0.01){
    p <- p + annotate("text", x = 1, y=(output_values$max.amount[1]*1.25)*0.95, label="* *")
    } else { 
    p <- p + annotate("text", x = 1, y=(output_values$max.amount[1]*1.25)*0.95, label="*")
    }
    }
		
    if (output_values$pvalue[2] < 0.05){
		p <- p+geom_segment(aes(x=1.85, y=m[5]+sem[5]+0.05, xend=1.85, 				yend=output_values$max.amount[2]		*1.15))
		p <- p+geom_segment(aes(x=2.15, y=m[6]+sem[6]+0.05, xend=2.15, 				yend=output_values$max.amount[2] 		*1.15))
		p <- p+geom_segment(aes(x=1.85, y=output_values$max.amount[2]*1.15, xend=2.15, 		yend=output_values$max.amount[2] 		*1.15))
		if (output_values$pvalue[2] < 0.01){
    p <- p + annotate("text", x = 2, y=(output_values$max.amount[2]*1.25)*0.95, label="* *")
    } else { 
    p <- p + annotate("text", x = 2, y=(output_values$max.amount[2]*1.25)*0.95, label="*")
    }
    }
     if (output_values$pvalue[3] < 0.05){
		p <- p+geom_segment(aes(x=2.85, y=m[3]+sem[3]+0.05, xend=2.85, 				yend=output_values$max.amount[3] 		*1.15))
		p <- p+geom_segment(aes(x=3.15, y=m[4]+sem[4]+0.05, xend=3.15, 				yend=output_values$max.amount[3] 		*1.15))
		p <- p+geom_segment(aes(x=2.85, y=output_values$max.amount[3]*1.15, xend=3.15, 		yend=output_values$max.amount[3] 		*1.15))
		if (output_values$pvalue[3] < 0.01){
    p <- p + annotate("text", x = 3, y=(output_values$max.amount[3]*1.25)*0.95, label="* *")
    } else { 
    p <- p + annotate("text", x = 3, y=(output_values$max.amount[3]*1.25)*0.95, label="*")
    }
    }
		return(p) 
  
}


