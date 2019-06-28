# genomic heritability 
library(vcfR)
library(rrBLUP)

snp <- read.vcfR("/bulk/zhenbin/sorghum_adaptation/ADMIXTURE/SNP.recode.vcf") 
e_data<-read.table("/bulk/zhenbin/sorghum_adaptation/IBE/e_data_filtered.txt",header=T)

snp_matrix<-snp@gt[,-1]
snp_matrix[snp_matrix=="0/0"]<-"-1"
snp_matrix[snp_matrix=="1/1"]<-"1"
snp_matrix[snp_matrix=="1/0" |snp_matrix=="0/1" ]<-"0"

snp_matrix<-as.matrix(snp_matrix)
tmp<-apply(snp_matrix,2,as.numeric)
snp_matrix<-t(tmp)
k<-A.mat(snp_matrix)
row.names(e_data)<-e_data$Taxa
e_data$ide<-e_data$id
e_data$idd<-e_data$id

for (i in 2:dim(e_data)[2]){
    y<-e_data[,i]
    ans<-mixed.solve(y,K=k)
    h2<-ans$Vu/(ans$Vu+ans$Ve)
    cat("The heritability of ",names(e_data)[i]," is: ",h2,"\n")
}


