library(seqinr)
GC_ratio<-function(chr)
Chr_GC<-NULL
window_size<-100000
for(i in 1:10){
	chr <- read.fasta(file ="/bulk/zhenbin/Sorghum_GBS/genome/final.Sbicolor_313_v3.1.fa", as.string = TRUE, seqtype = "AA")[[i]]
chr_split<-strsplit(chr,split="")
start<-1
end<-start+window_size-1
for(w in 1:floor(length(chr_split[[1]])/window_size)){
	nt<-chr_split[[1]][start:end]
	GC_content<-GC(nt)
	GC_content<-c(i,start,end,GC_content)
	Chr_GC<-rbind(Chr_GC,GC_content)
	start<-start+window_size
	end<-start+window_size-1
}
print(i)
}

Chr_GC<-as.data.frame(Chr_GC)
row.names(Chr_GC)<-NULL
names(Chr_GC)<-c("Chr","Start","End","GC-content")
write.table(Chr_GC,"chr_gc.txt",quote=F,row.names=F,sep="\t")
