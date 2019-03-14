# CV error plot using R
system("cat admix_*.txt |grep "CV error" > cv.error.txt")
cv<-read.table("cv.error.txt",header=F)
cv$V3<-gsub("\\D","",cv$V3)
cv$V3<-as.numeric(cv$V3)
png("cve.png",width=6,height=6,type="cairo",unit="in",res=600)
plot(cv$V3,cv$V4,ylab="CV error",xlab="K")
points(cv$V3,cv$V4,pch=19)
dev.off()
