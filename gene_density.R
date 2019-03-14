# the gff3 file was downloaded from phytozome
gene<-read.table("/bulk/zhenbin/Sorghum_GBS/genome/Sbicolor_313_v3.1.gene.gff3")
gene<-gene[gene$V3=="gene",]
window_size<-100000
CHR<-unique(gene$V1)
CHR<-as.character(CHR[grep("Chr",CHR)])
Coding_density<-NULL
for(i in CHR){
	gene_chr<-gene[gene$V1==i,]
	coding_dens<-NULL
	start<-1
	Window_number<-round(max(gene_chr$V5)/window_size)	
	for (j in 1:Window_number){
		end<-start+window_size-1
		gene_tmp<-gene_chr[gene_chr$V4 > start & gene_chr$V5<end,]
		gene_number<-dim(gene_tmp)[1]
		coding_den<-sum(gene_tmp$V5-gene_tmp$V4)/window_size		
		coding_density<-c(i,start, end,coding_den,gene_number)
		names(coding_density)<-c("Chr","start","end","coding_density","gene_number")
		coding_dens<-rbind(coding_dens,coding_density)
		start<-end+1
	}
	row.names(coding_dens)<-NULL
	coding_dens<-as.data.frame(coding_dens)
	Coding_density<-rbind(Coding_density,coding_dens)
	
}

write.table(Coding_density,"/bulk/zhenbin/sorghum_adaptation/recombination/Coding_density.txt",quote=F, row.names=F,sep="\t")
