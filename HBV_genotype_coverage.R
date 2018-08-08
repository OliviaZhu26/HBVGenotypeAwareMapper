##Author: ZHU O. Yuan 2017
##Script name: HBV_genotype_coverage.R
##Rscript to generate coverage plot and SNP locations
##Usage: Rscript HBV_genotype_coverage.R $ID $MEAN $COV $VCF $Rout
##Example output pdf see HBVmap-example-pdf_AHB772_B...pdf at https://github.com/YuanOZhu/HBVGenotypeAwareMapper

args<-commandArgs(TRUE)
id<-args[1] #sample name
aveCov<-args[2] #sample mean coverage

pdf(args[5]) #pdf file name

data<-read.table(file=args[3],sep="\t",header=TRUE) #coverage file
data_pos<-do.call(rbind,strsplit(as.character(data[,1]),":"))
header<-paste(id," Mean Coverage: ", aveCov, sep="")
#plot log coverage against base position
plot(as.numeric(data_pos[,2]),log10(data[,2]),main=header,ylab="Log10(cov)",xlab="Pos",ylim=c(0,7),pch=20) 

vcf<-read.table(file=args[4],sep="\t",header=FALSE) #vcf file
vcf_filter<-vcf[which(vcf[,6]>1000),]
vcf_data<-do.call(rbind,strsplit(as.character(vcf_filter[,8]),";"))
vcf_freq<-do.call(rbind,strsplit(as.character(vcf_data[,2]),"="))
vcf_dp<-do.call(rbind,strsplit(as.character(vcf_data[,1]),"="))
#plot SNP frequency against base position
points(vcf_filter[,2],as.numeric(vcf_freq[,2])*max(log10(data[,2])),col="red",pch=20)
dev.off()
