#Rscript Plot_coverage.R AHB144_B.sorted.grouped.realign.coverage AHB144_B.sorted.grouped.realign.coverage.sample_summary 
#../04_Sample_vcfs/AHB152_B.sorted.grouped.realign.recal.lofreq.vcf

args<-commandArgs(TRUE)
#write(args[],stdout())
id<-args[1]
aveCov<-args[2]

pdf(args[5])

data<-read.table(file=args[3],sep="\t",header=TRUE)
data_pos<-do.call(rbind,strsplit(as.character(data[,1]),":"))
header<-paste(id," Mean Coverage: ", aveCov, sep="")
plot(as.numeric(data_pos[,2]),log10(data[,2]),main=header,ylab="Log10(cov)",xlab="Pos",ylim=c(0,7),pch=20)

vcf<-read.table(file=args[4],sep="\t",header=FALSE)
vcf_filter<-vcf[which(vcf[,6]>1000),]
vcf_data<-do.call(rbind,strsplit(as.character(vcf_filter[,8]),";"))
vcf_freq<-do.call(rbind,strsplit(as.character(vcf_data[,2]),"="))
vcf_dp<-do.call(rbind,strsplit(as.character(vcf_data[,1]),"="))
points(vcf_filter[,2],as.numeric(vcf_freq[,2])*max(log10(data[,2])),col="red",pch=20)
dev.off()
