# plot venn diagram for lists of genes expressed in different cell types
load('./number.of.expressed.genes.RData')
library(VennDiagram)

do.venn <- function(l,main) {
    grid.obj = venn.diagram(l, category.names=names(l), euler.d=T, filename=NULL, cex=2,cat.cex=2, main=main)
    pdf(paste('./venn/', main, '.pdf',sep=''))
    grid.draw(grid.obj)
    dev.off()
}

list2number <- function(aList) {
    A = aList[[1]]
    N = aList[[2]]
    O = aList[[3]]
    ANO = length(intersect(intersect(A,N),O))
    AN = length(setdiff(intersect(A,N), O))
    AO = length(setdiff(intersect(A,O), N))
    NO = length(setdiff(intersect(N,O), A))
    A.specific = length(setdiff(setdiff(A, N), O))
    N.specific = length(setdiff(setdiff(N, O), A))
    O.specific = length(setdiff(setdiff(O, N), A))
    A = A.specific; N=N.specific; O=O.specific;
    n = c(A,N,O,AN,AO,NO,ANO)
    category = c('A','N','O','AN','AO','NO','ANO')
    res = cbind(category, n)
    return(res)
}

do.sim <- function(n.whole.set, n1, n2, n3) {
    all = 1:n.whole.set
    A = sample(all, n1)
    N = sample(all, n2)
    O = sample(all, n3)
    res = list2number(list(A,N,O))
    return(res)
}

#symbols = read.table('/mnt/expressions/augix/database/annotation/ensembl62/human.gene.lifted/ensg2name.tsv',header=T,as.is=T)[,2]
#n.whole.set = length(symbols)

main = 'genes detected in > 2 individuals in > 2 species'
l = detected.genes.in.2.libs
n.whole.set = length(unique(unlist(l)))
#do.venn(l,main)
real = list2number(l)
main = 'sim1'
ns = unlist(lapply(l,length))
sim = matrix(,nrow=0,ncol=2)
for (i in 1:100) {
    n = do.sim(n.whole.set, ns[1], ns[2], ns[3])
    sim = rbind(sim,n)
}

print(real/apply(sim,2,mean))
s = apply(sim,2,mean)
m = rbind(s, real)
#barplot(m, beside=T,col=c('grey','black'),log='y')
#legend('topleft',legend=c('simulation','real'),col=c('grey','black'),pch=15)
library(sciplot)
x.factor
response
res = bargraph.CI(x.factor, response)

#main = 'genes detected in > 2 individuals in 3 cell types'
#l = detected.genes.in.3.cell.types
##do.venn(l,main)
#main = 'sim2'
#ns = unlist(lapply(l,length))
##l = do.sim(n.whole.set, ns[1], ns[2], ns[3])
##do.venn(l,main)

#main = 'genes detected in all libraries in each cell type'
#l = detected.genes.in.all.libs
##do.venn(l,main)
#main = 'sim3'
#ns = unlist(lapply(l,length))
##l = do.sim(n.whole.set, ns[1], ns[2], ns[3])
##do.venn(l,main)

