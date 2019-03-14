library(lfmm)
setwd("/home/zhenbin/sorghum_adaptation/sorghum_adaptation/gea")
SNP<-read.table("SNP_2735.lfmm")
SNP<-as.matrix(SNP)
Phen<-read.table("e_data_filtered.txt",header=T)
Y<-SNP

for (i in 8:10){
 X<-data.frame(Phen[,i])
 X<-as.matrix(X)
 mod.lfmm <- lfmm_lasso(Y = Y,
                        X = X, 
                           K = 6,
                           nozero.prop = 0.01)
    pv <- lfmm_test(Y = Y, 
                    X = X, 
                    lfmm = mod.lfmm, 
                    calibrate = "gif")
    save(pv,file=paste0("pv",names(Phen)[i],".rda"))
}


# make manhattan plot for lfmm results
Phen<-read.table("e_data_filtered.txt",header=T)
library(vcfR)
library(qqman)
vcf<-read.vcfR("/home/zhenbin/sorghum_adaptation/sorghum_adaptation/origin_data/SNP_2735.recode.vcf")
snp_info<-as.data.frame(vcf@fix)
CHR<-snp_info$CHROM
SNP<-snp_info$ID
BP<-snp_info$POS
file<-names(Phen)[2:34]

for(i in file){
    load(paste0("pv",i,".rda"))
    P<-pv$calibrated.pvalue
    GWAS<-data.frame(SNP,CHR,BP,P)
    GWAS$CHR<-as.numeric(as.character(GWAS$CHR))
    GWAS$BP<-as.numeric(as.character(GWAS$BP))
    names(GWAS)<-c("SNP","CHR","BP","P")
    png(paste0(i,"_gea.png"),width=12,height=4,unit="in",res=600)
    par(mai=c(0.7,0.8,0.2,0.2),mgp=c(1.5,0.5,0))
    manhattan(GWAS,suggestiveline = F,genomewideline = -log10(0.1/dim(GWAS)[1]),cex=0.5,tck=-0.01,cex.axis=1.2,cex.lab=1.5) 
    dev.off()
    write.table(GWAS,paste0(i,".txt"),quote=F, row.names=F,sep="\t")
    cat(i," was done!\n")
}
