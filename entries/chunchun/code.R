data=read.table('./data.txt',header=T,sep='\t')
data = data[,-1]
d <- dist(t(data))
pdf('./trees.pdf')
library(phangorn)
# nj tree
tree <- nj(d)
plot(tree,main="nj tree, rooted")
plot(tree,'u',main='nj tree, unrooted')
# upgma tree
tree = upgma(d)
plot(tree,main="upgma tree")
dev.off()
