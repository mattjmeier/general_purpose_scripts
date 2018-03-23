# Provide two arguments: 1) file to run Fisher's exact test on, and 2) output file name

args<-commandArgs(TRUE)
file=args[1]
data <- read.table(args[1])
pvals <- apply(data[,c(5,6,7,8)],1, function(x) fisher.test(matrix(x,nr=2))$p.value)
data[,"p-vals"] <-  format(round(pvals, 5))
write.table(data, file=args[2], sep= "\t", col.names=FALSE, row.names=FALSE, quote=FALSE)

