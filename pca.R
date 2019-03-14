library(SNPRelate)

vcf.fn <- "/bulk/zhenbin/sorghum_adaptation/origin_data/SNP_2735.recode.vcf"
scp zhenbin@beocat.cis.ksu.edu:/bulk/zhenbin/sorghum_adaptation/origin_data/SNP_2735.recode.vcf /home/zhenbin/
vcf.fn <- "/home/zhenbin/sorghum_adaptation/sorghum_adaptation/origin_data/SNP_2735.recode.vcf"
snpgdsVCF2GDS(vcf.fn, "pca.gds", method="biallelic.only")
genofile <- snpgdsOpen("pca.gds")

snpset2 <- snpgdsLDpruning(genofile,ld.threshold = 1,maf=0.1)
snpset2.id <- unlist(snpset2)

snp_id<-read.gdsn(index.gdsn(genofile, "snp.rs.id"))
snp_id<-snp_id[snpset2.id]
pca <- snpgdsPCA(genofile,snp.id=snpset2.id,num.thread=4)

SnpLoad <- snpgdsPCASNPLoading(pca, genofile)
pc.percent <- pca$varprop*100

head(round(pc.percent, 2))
# 9.96 7.19 5.29 4.26 3.55 3.28
EV = pca$eigenvect[,1:20]
tab <- data.frame(sample.id = pca$sample.id,EV,stringsAsFactors = FALSE)
write.table(tab,"PCA.txt",quote=F,row.names=F,sep="\t")
save(SnpLoad,file="SnpLoad.rda")



# figures
