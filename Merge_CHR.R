hmp<-NULL
for(i in 1:10){
    tmp<-read.delim(paste0("imp_chr",i,".hmp.txt"),header=T,sep="\t")
    hmp<-rbind(hmp,tmp)
    cat("chr ",i, " was done!\n")
}
nam<-names(hmp)
nam<-gsub("[.].+","",nam)
names(hmp)<-nam
names(hmp)[1:6]<-c("rs#","alleles","chrom","pos","strand","assembly#")
write.table(hmp,"/bulk/zhenbin/sorghum_adaptation/origin_data/SNP_2735.txt",row.names=F,quote=F,sep="\t")
