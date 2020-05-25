# goals: 1. what to predict about China? 2. about the World? 
# 1a. more cases? 2a. more cases? 2b. more deaths?
# 1a. province-level new case (heatmap and log growth curve about the 2nd wave)
# 2a. country-level new cases (heatmap and log growth)
# 2b. new death (heatmap and log growth)
# plan: 
# - main: china_case_growth, world_case_growth, world_death_growth
# - supp: china_new_case_heatmap, world_new_case_heatmap

# functions
## from cumsum to new cases
cumulative2new = function(cumulative) {
	# part 1: fill NA
	b=cumulative
	b2 = rbind(0,b) # put 0 for 1st day
	for (i in 2:nrow(b2)) {
    	idx = is.na(b2[i,]) # find days of NA
	    b2[i, idx] = b2[i-1, idx]  # fill NA with values from the previous day
	}
	b=b2[-1,] # remove 1st day
	
	# part 2: calculate new case by subtraction
	test2=t(b)
	test2[is.na(test2)]=0 # fill NA with 0
	ix=sort(test2[,ncol(test2)],de=T,index.return=T)$ix # sort according to last day cumulative count
	test2=test2[ix,]
	head(test2)
	newcase = test2
	old = cbind(0, test2[,-ncol(test2)]) # the old is shifted for 1 day relative to the current (test2)
	newcase = newcase - old  # the subtraction
	
	# replace negative values with 0
	newcase[newcase<0] = 0
	return(newcase)
}

matplot.all = function(mat,main,xlab,ylab,cex.text=0.5) {
	#par(mfrow=c(1,1))
	cum = mat
	#lines(x,2^(x/3),col='gray')
	lwd=rep(1,nrow(cum))
	col18 = c('#e6194b', '#3cb44b', '#4363d8', '#f58231', '#911eb4', '#46f0f0', '#f032e6', 
		'#bcf60c', '#fabebe', '#008080', '#e6beff', '#9a6324', '#800000', '#aaffc3', '#808000', 
		'#ffd8b1', '#000075', '#808080', '#000000')
	col=c('gray',col18)
	
	par(xaxt='n',las=2)
	lty=1
	xlim=c(0,ncol(cum)+7)
	x=1:ncol(cum)
	x.max=apply(cum,1,function(x) max(which(x==max(x))))
	y.max=apply(cum,1,max)
	if (adjust.label==T) {
		y = rev( log(y.max) )
		vs.low = y - c(min(y)-0.2,y[-length(y)])
		vs.high = c(y[-1],max(y)+0.2) - y
		#y[ which(vs.low>0.3) ] = y[ which(vs.low<0.3) ] - 0.1
		y[ which(vs.low<0.1) ] = y[ which(vs.low<0.1) ] + 0.1
		#y[ which(vs.high>0.3) ] = y[ which(vs.high>0.3) ] + 0.1
		y[ which(vs.high<0.1) ] = y[ which(vs.high<0.1) ] - 0.1
		y.max = exp(rev(y))
	}
		
	matplot(t(cum),log='y',type='l',xlab=xlab,ylab=ylab,
		main=main,col=col,lty=lty,lwd=lwd,xlim=xlim,pch=20,cex=0.5)
	matpoints(t(cum),log='y',type='p',xlab=xlab,ylab=ylab,
		main=main,col=col,lty=lty,lwd=lwd,xlim=xlim,pch=20,cex=0.5)
	#legend("bottomright", rownames(cum),cex=0.47,col=col,lty=lty,lwd=lwd)
	text(x.max, y.max, labels = paste(rownames(cum),y.max),pos=4,col=col,cex=cex.text,offset=0.3)
	mtext(colnames(cum)[x],at=x,side=1,cex=cex.text-0.1,line=0.3)
}

matplot.1by1 = function(mat) {
	cum = mat
	par0 = par('mar')
	#par(mfrow=c(4,4))
	par(mar=c(1,4,2,1))
	for (i in 1:nrow(mat)) {
		main=rownames(cum)[i]
		matplot(t(cum),log='y',type='l',xlab='',ylab='',
			main=main,col='gray',lty=1)
		lines(cum[i,],col='red')
		points(ncol(cum),cum[i,ncol(cum)],col='red',pch=20,cex=0.5)
	}	
	par(mar=par0)
}

align = function(cum,n=1) {
	# remove provinces with too few cases
	cum = cum[ cum[,ncol(cum)] >=n, ]
	get_day1 = function(x) {
    	min((1:length(x))[x>=n])
	}
	day1 = apply(cum,1,get_day1)
	cum2 = matrix(NA,nrow=nrow(cum),ncol=ncol(cum)+max(day1)-1)
	for (i in 1:nrow(cum)) {
	    cum2[i,(max(day1)-day1[i]+1):(max(day1)-day1[i]+ncol(cum))]=cum[i,1:ncol(cum)]
	}
	rownames(cum2) = rownames(cum)
	colnames(cum2) = c(1:ncol(cum2)) - max(day1) + 1
	return(cum2)
}

# format dxy
dxy=read.csv('from_github/DXY-COVID-19-Data/csv/DXYArea.csv')
days = sapply(as.character(dxy$updateTime),function(x) unlist(strsplit(x,split=' '))[1] )
days=sapply(days,function(x) unlist(strsplit(x,split='2020-'))[2])
levels(as.factor(days))
dxy$day = days


# goal 1a: china case growth
## province level
china = subset(dxy, countryEnglishName=='China')
china = subset(china, provinceEnglishName!='China')
china = subset(china, provinceEnglishName!='Taiwan')
china_province_case=subset(china,select=c('provinceEnglishName','province_confirmedCount','day'))

## find max for each day
dat = china_province_case
count_type = 'province_confirmedCount'
dat[,'provinceEnglishName'] = as.character(dat[,'provinceEnglishName']) # this is neccesary. Factor will cause trouble for tapply below
## key step to get total case number by day
counts = tapply(dat[, count_type], dat[,c('day', 'provinceEnglishName')], max)
cum.china = counts
new.china = cumulative2new(cum.china)
new.china.total = apply(new.china,2,function(x) sum(x,na.rm=T))

## plot 1a China growth: 2nd wave
new.china.2nd = new.china[,which(colnames(new.china) == '03-01'):ncol(new.china)]
new.china.2nd = new.china.2nd[which(rownames(new.china.2nd)!='Hubei'),]
cum.china.2nd = t(apply(new.china.2nd,1,cumsum))
## add the 3day-doubling regression
cum = cum.china.2nd
cum = rbind(2^( (1:ncol(cum))/3 ) , cum)
rownames(cum)[1] = 'Double every 3 Days'
## add total
total = apply(cum,2,sum)
cum = rbind(total, cum)
## sorting
mat = cum
ix=sort(mat[,ncol(mat)],de=T,index.return=T)$ix # sort according to last day cumulative count
cum.china.2nd =mat[ix,]

main='China new cases, 2nd wave'
xlab='Days since March 1'
ylab='Cumulative'
pdf(paste('f1a_china_case_growth',Sys.Date(),'pdf',sep='.'),w=5,h=10)
adjust.label=F
layout(matrix(c(rep(1,16),2:17), 8, 4, byrow = TRUE))
matplot.all(cum.china.2nd[1:16,],main,xlab,ylab,cex.text=0.8)
matplot.1by1(cum.china.2nd[1:16,])

aligned = align(cum.china.2nd,n=20)
matplot.all(aligned,main,xlab,ylab,cex.text=0.5)
matplot.1by1(aligned)

dev.off()


## plot 1b china case heatmap
pdf(paste('f1b_china_case_heatmap',Sys.Date(),'pdf',sep='.'),w=10,h=5)
par(cex.main=0.8)
mat = new.china
main = 'China confirmed cases'
library(RColorBrewer)
library(gplots)
breaks=c(0,1,4,16,64,256,1024,2048)-0.1
col=c('white',brewer.pal(5,"Oranges"),'black')
heatmap.2(mat,
	# each cell
	breaks = breaks, col=col, trace="none",  
	# cell note
	cellnote=mat, notecol='white', notecex=0.4, 
	# color key 
	key=F,density.info="none",
	# margin
	lhei=c(0.8,4),lwid=c(0.2,4), margins=c(3,6),
	# separators
	#sepcolor = 'white', colsep=0:ncol(mat), rowsep=0:nrow(mat), sepwidth=c(.1,.1), 
	# text adjust position
	offsetCol = 0, adjCol = c(NA,0.5), 
	# text size, color
	main=main, cexRow=0.8, cexCol=0.8,
	Rowv=F,Colv=F)
dev.off()


# goal 2a: World case growth
count_type = 'province_confirmedCount'

## province level
chinese_provinces = as.character(subset(dxy, countryEnglishName=='China')[, 'provinceEnglishName'])
chinese_provinces = levels(as.factor(chinese_provinces))
world = dxy[-which(dxy$provinceEnglishName %in% chinese_provinces), ]
world = world[-which(world$provinceEnglishName=="Diamond Princess Cruise Ship"), ]
world = world[-which(world$provinceEnglishName=="Hongkong"), ]
world = world[-which(world$provinceEnglishName=="Macao"), ]
world_case=subset(world,select=c('provinceEnglishName', count_type, 'day'))
library(dplyr)
NameFixR <- function (x){
  case_when(
    x=="Mainland China" ~ "China",
    x=="Viet Nam" ~ "Vietnam",
    x=="Republic of Korea" ~ "S.Korea",
    x=="Republic of Moldova" ~ "Moldova",
    x=="Iran (Islamic Republic of)" ~ "Iran",
    x=="Taipei and environs"~"Taiwan",
    x=="Czechia" ~ "Czech",
    x=="Czech Republic" ~ "Czech",
    x=="Gibralter" ~ "UK",
    x=="Channel Islands" ~ "UK",
    x=="United Kingdom" ~ "UK",
    x=="United Kingdom of Great Britain and Ireland" ~ "UK",
    x=="United States of America" ~ "USA",
    TRUE ~ x
  )
}
world_case$provinceEnglishName = NameFixR(as.character(world_case$provinceEnglishName))

## find max for each day
dat = world_case
dat[,'provinceEnglishName'] = as.character(dat[,'provinceEnglishName']) # this is neccesary. Factor will cause trouble for tapply below
counts = tapply(dat[, count_type], dat[,c('day', 'provinceEnglishName')], max)
cum = counts

# only choose data after March 1
cum = cum[which(rownames(cum) == '03-01'):nrow(cum),]

# correct cum by: total -> new case -> cum
new = cumulative2new(cum)
#China=new.china.total
#new = rbind(China,new)
cum = t(apply(new,1,cumsum))
# sort new according to cum
ix=sort(cum[,ncol(cum)],de=T,index.return=T)$ix # sort according to last day cumulative count
new =new[ix,]


## sorting
mat = cum
ix=sort(mat[,ncol(mat)],de=T,index.return=T)$ix # sort according to last day cumulative count
cum =mat[ix,]

## add the 3day-doubling regression
cum = rbind(2^( (1:ncol(cum))/3 ) , cum)
rownames(cum)[1] = 'Double every 3 Days'


main='World cases'
xlab='Days'
ylab='Cumulative'

n=30
pdf(paste('f2a_world_case_growth',Sys.Date(),'pdf',sep='.'),w=5,h=10)
layout(matrix(c(rep(1,20),2:(n+1)), 10, 5, byrow = TRUE))

matplot.all(cum[1:n,],main,xlab,ylab,cex.text=0.5)
matplot.1by1(cum[1:n,])

aligned = align(cum,n=100)
matplot.all(aligned,main,xlab,ylab)
matplot.1by1(aligned)

dev.off()

## plot 2b world case heatmap
pdf(paste('f2b_wolrd_case_heatmap',Sys.Date(),'pdf',sep='.'),w=10,h=20)
par(cex.main=0.8)
mat = new
main = 'World confirmed cases'
library(RColorBrewer)
library(gplots)
breaks=c(0,1,4,16,64,256,1024,2048)-0.1
#col=c('white',brewer.pal(5,"YlGnBu"),'black')
col=c('white',brewer.pal(5,"Oranges"),'black')
heatmap.2(mat,
	# each cell
	breaks = breaks, col=col, trace="none",  
	# cell note
	cellnote=mat, notecol='white', notecex=0.4, 
	# color key 
	key=F,density.info="none",
	# margin
	lhei=c(0.2,4),lwid=c(0.2,4), margins=c(3,7),
	# separators
	#sepcolor = 'white', colsep=0:ncol(mat), rowsep=0:nrow(mat), sepwidth=c(.1,.1), 
	# text adjust position
	offsetCol = 0, adjCol = c(NA,0.5), 
	# text size, color
	main=main, cexRow=0.8, cexCol=0.8,
	Rowv=F,Colv=F)
dev.off()

pdf(paste('f2b_wolrd_case_heatmap_2',Sys.Date(),'pdf',sep='.'),w=10,h=5)

heatmap.2(mat[1:40,],
	# each cell
	breaks = breaks, col=col, trace="none",  
	# cell note
	#cellnote=mat, notecol='white', notecex=0.4, 
	# color key 
	key=F,density.info="none",
	# margin
	lhei=c(0.1,4),lwid=c(0.2,4), margins=c(3,7),
	# separators
	sepcolor = 'white', colsep=0:ncol(mat), rowsep=0:nrow(mat), sepwidth=c(.15,.1), 
	# text adjust position
	offsetCol = 0, adjCol = c(NA,0.5), 
	# text size, color
	main=main, cexRow=0.8, cexCol=0.8,
	Rowv=F,Colv=F)
dev.off()





# goal 3a: World death growth
count_type = 'province_deadCount'

## province level
chinese_provinces = as.character(subset(dxy, countryEnglishName=='China')[, 'provinceEnglishName'])
chinese_provinces = levels(as.factor(chinese_provinces))
world = dxy[-which(dxy$provinceEnglishName %in% chinese_provinces), ]
world = world[-which(world$provinceEnglishName=="Diamond Princess Cruise Ship"), ]
world = world[-which(world$provinceEnglishName=="Hongkong"), ]
world = world[-which(world$provinceEnglishName=="Macao"), ]
world_case=subset(world,select=c('provinceEnglishName', count_type, 'day'))
library(dplyr)
NameFixR <- function (x){
  case_when(
    x=="Mainland China" ~ "China",
    x=="Viet Nam" ~ "Vietnam",
    x=="Republic of Korea" ~ "S.Korea",
    x=="Republic of Moldova" ~ "Moldova",
    x=="Iran (Islamic Republic of)" ~ "Iran",
    x=="Taipei and environs"~"Taiwan",
    x=="Czechia" ~ "Czech",
    x=="Czech Republic" ~ "Czech",
    x=="Gibralter" ~ "UK",
    x=="Channel Islands" ~ "UK",
    x=="United Kingdom" ~ "UK",
    x=="United Kingdom of Great Britain and Ireland" ~ "UK",
    x=="United States of America" ~ "USA",
    TRUE ~ x
  )
}
world_case$provinceEnglishName = NameFixR(as.character(world_case$provinceEnglishName))

## find max for each day
dat = world_case
dat[,'provinceEnglishName'] = as.character(dat[,'provinceEnglishName']) # this is neccesary. Factor will cause trouble for tapply below
counts = tapply(dat[, count_type], dat[,c('day', 'provinceEnglishName')], max)
cum = counts


# only choose data after March 1
cum = cum[which(rownames(cum) == '03-01'):nrow(cum),]

# correct cum by: total -> new case -> cum
new = cumulative2new(cum)
#China=new.china.total
#new = rbind(China,new)
cum = t(apply(new,1,cumsum))
# sort new according to cum
ix=sort(cum[,ncol(cum)],de=T,index.return=T)$ix # sort according to last day cumulative count
new =new[ix,]


## plot growth

## sorting
mat = cum
ix=sort(mat[,ncol(mat)],de=T,index.return=T)$ix # sort according to last day cumulative count
cum =mat[ix,]

## add the 3day-doubling regression
cum = rbind(2^( (1:ncol(cum))/3 ) , cum)
rownames(cum)[1] = 'Double every 3 Days'


main='World deaths'
xlab='Days'
ylab='Cumulative'

pdf(paste('f3a_world_death_growth',Sys.Date(),'pdf',sep='.'),w=5,h=10)
layout(matrix(c(rep(1,16),2:17), 8, 4, byrow = TRUE))

matplot.all(cum[1:16,],main,xlab,ylab,cex.text=0.5)
matplot.1by1(cum[1:16,])

aligned = align(cum,n=100)
matplot.all(aligned,main,xlab,ylab)
matplot.1by1(aligned)

dev.off()

## plot 3b world death heatmap
pdf(paste('f3b_wolrd_death_heatmap',Sys.Date(),'pdf',sep='.'),w=10,h=20)
par(cex.main=0.8)
mat = new
main = 'World deaths'
library(RColorBrewer)
library(gplots)
breaks=c(0,1,4,16,64,256,512, 1024 )-0.1
col=c(brewer.pal(6,"Blues"),'black')
#col=c('white',brewer.pal(5,"Oranges"),'black')
heatmap.2(mat,
	# each cell
	breaks = breaks, col=col, trace="none",  
	# cell note
	#cellnote=mat, notecol='white', notecex=0.4, 
	# color key 
	key=F,density.info="none",
	# margin
	lhei=c(0.2,4),lwid=c(0.2,4), margins=c(3,7),
	# separators
	#sepcolor = 'white', colsep=0:ncol(mat), rowsep=0:nrow(mat), sepwidth=c(.1,.1), 
	# text adjust position
	offsetCol = 0, adjCol = c(NA,0.5), 
	# text size, color
	main=main, cexRow=0.8, cexCol=0.8,
	Rowv=F,Colv=F)
dev.off()

pdf(paste('f3b_wolrd_death_heatmap_2',Sys.Date(),'pdf',sep='.'),w=8,h=6)
par(cex.main=1)
heatmap.2(mat[1:40,],
	# each cell
	breaks = breaks, col=col, trace="none",  
	# cell note
	cellnote=mat, notecol='white', notecex=0.35, 
	# color key 
	key=F,density.info="none",
	# margin
	lhei=c(0.8,4),lwid=c(.1,4), margins=c(3,7),
	# separators
	#sepcolor = 'white', colsep=0:ncol(mat), rowsep=0:nrow(mat), sepwidth=c(.05,.05), 
	# text adjust position
	offsetCol = 0, adjCol = c(NA,0.5), 
	# text size, color
	main=main, cexRow=0.7, cexCol=0.8,
	Rowv=F,Colv=F)
dev.off()

pdf(paste('f3b_wolrd_death_heatmap_3',Sys.Date(),'pdf',sep='.'),w=8,h=16)
par(cex.main=2)
heatmap.2(mat[1:60,],
	# each cell
	breaks = breaks, col=col, trace="none",  
	# cell note
	cellnote=mat, notecol='white', notecex=0.6, 
	# color key 
	key=F,density.info="none",
	# margin
	lhei=c(0.3,4),lwid=c(.2,4), margins=c(5,7),
	# separators
	sepcolor = 'white', colsep=0:ncol(mat), rowsep=0:nrow(mat), sepwidth=c(.1,.1), 
	# text adjust position
	offsetCol = 0, adjCol = c(NA,0.5), 
	# text size, color
	main=main, cexRow=1, cexCol=1,
	Rowv=F,Colv=F)
dev.off()

