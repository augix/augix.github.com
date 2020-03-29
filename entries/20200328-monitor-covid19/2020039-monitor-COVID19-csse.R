# goal: show county result

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

col18 = c('#e6194b', '#3cb44b', '#4363d8', '#f58231', '#911eb4', 
	'#46f0f0', '#f032e6', '#bcf60c', '#fabebe', '#008080', '#e6beff', 
	'#9a6324', '#800000', '#aaffc3', '#808000', '#ffd8b1', '#000075', 
	'#808080', '#000000')

matplot.all = function(mat,main,xlab,ylab,cex.text=0.5) {
	#par(mfrow=c(1,1))
	cum = mat
	#lines(x,2^(x/3),col='gray')
	lwd=rep(1,nrow(cum))
	if (!exists('col')) {
		col18 = c('#e6194b', '#3cb44b', '#4363d8', '#f58231', '#911eb4', '#46f0f0', '#f032e6', 
			'#bcf60c', '#fabebe', '#008080', '#e6beff', '#9a6324', '#800000', '#aaffc3', '#808000', 
			'#ffd8b1', '#000075', '#808080', '#000000')
		col=c('gray',col18)
	}
	
	par(xaxt='n',las=2)
	lty=1
	xlim=c(0,ncol(cum)+7)
	x=1:ncol(cum)
	x.max=apply(cum,1,function(x) max(which(x==max(x,na.rm=T))))
	y.max=apply(cum,1,function(x) max(x,na.rm=T))

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
	if (plot.points==T) {
		matpoints(t(cum),log='y',type='p',xlab=xlab,ylab=ylab,
			main=main,col=col,lty=lty,lwd=lwd,xlim=xlim,pch=20,cex=0.5)
	}
	points(x.max, y.max,col=col,pch=20,cex=0.5)

	#legend("bottomright", rownames(cum),cex=0.47,col=col,lty=lty,lwd=lwd)
	text(x.max, y.max, labels = rownames(cum),pos=4,col=col,cex=cex.text, offset=0.3)
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

align = function(cum, align_n =1, chop=T) {
	# remove provinces with too few cases
	cum = cum[ cum[,ncol(cum)] >= align_n, ]
	get_day1 = function(x) {
    		min((1:length(x))[x>= align_n])
	}
	day1 = apply(cum,1,get_day1)
	cum2 = matrix(NA,nrow=nrow(cum),ncol=ncol(cum)+max(day1)-1)
	for (i in 1:nrow(cum)) {
	    cum2[i,(max(day1)-day1[i]+1):(max(day1)-day1[i]+ncol(cum))]=cum[i,1:ncol(cum)]
	}
	rownames(cum2) = rownames(cum)
	colnames(cum2) = c(1:ncol(cum2)) - max(day1) 
	
	if (chop==T) {
		cum2 = cum2[, which(colnames(cum2)=='0'):ncol(cum2)]
	}
	return(cum2)
}

new2heatmap = function(new,n,day1='03-01') {
	mat = new
		
	# from March 1st.
	mat = mat[,which(colnames(mat) == day1):ncol(mat)]

	# add total
	#total = apply(mat,2,sum)
	#mat = rbind(total,mat)
	#rownames(mat)[1] = 'US total'
	
	par(cex.main=2)
	heatmap.2(mat[1:n,],
		# each cell
		breaks = breaks, col=col, trace="none",  
		# cell note
		cellnote=mat, notecol='white', notecex=0.6, 
		# color key 
		key=F,density.info="none",
		# margin
		lhei=c(0.3,4),lwid=c(.2,4), margins=c(5,7),
		# separators
		#sepcolor = 'white', colsep=0:ncol(mat), rowsep=0:nrow(mat), sepwidth=c(.1,.1), 
		# text adjust position
		offsetCol = 0, adjCol = c(NA,0.5), 
		# text size, color
		main=main, cexRow=1, cexCol=1,
		Rowv=F,Colv=F)
		
}

cum2matplot = function(cum,n,align_n=100,day1='03-01') {
	
	# from March 1st.
	cum = cum[,which(colnames(cum) == day1):ncol(cum)]
	total = apply(cum,2,sum)
	#cum = rbind(total,cum)
	#rownames(cum)[1] = 'US total'
	
	# add model
	#cum = rbind(total[1]*2^( (1:ncol(cum))/3 ), cum)
	#rownames(cum)[1] = 'Double every 3 Days'
	
	matplot.all(cum[1:n,],main,xlab,ylab,cex.text=0.5)
	matplot.1by1(cum[1:n,])
		
}

cum2matplot.aligned = function(cum,n,align_n=100,day1='03-01') {
	
	# from March 1st.
	cum = cum[,which(colnames(cum) == day1):ncol(cum)]
	total = apply(cum,2,sum)
	#cum = rbind(total,cum)
	#rownames(cum)[1] = 'US total'
	
	# add model
	#cum = rbind(total[1]*2^( (1:ncol(cum))/3 ), cum)
	#rownames(cum)[1] = 'Double every 3 Days'
		
	aligned = align(cum,align_n=align_n)
	xlab=paste('Days since number reaches',align_n)
	matplot.all(aligned,main,xlab,ylab)
	matplot.1by1(aligned)
	
}

records2counts = function(records,count_type,level) {
	counts = tapply(dat[, count_type], dat[,c('day', level)], max)
	new = cumulative2new(counts)
	cum = t(apply(new,1,cumsum))
	
	# sorting
	mat = cum
	ix=sort(mat[,ncol(mat)],de=T,index.return=T)$ix # sort according to last day cumulative count
	cum =mat[ix,]
	new =new[ix,]
	return(list(cum=cum,new=new))
}

#url='https://github.com/CSSEGISandData/COVID-19/raw/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv'
#csse=read.table(url(url),check.names=F,fill=T,header=T,sep=',',quote="\"")
csse=read.csv('from_github/covid-19-data/us-counties.csv')
days = as.character(csse$date)
days=sapply(days,function(x) unlist(strsplit(x,split='2020-'))[2])
csse$day = days

## key step to get total case number by day
dat = csse
count_type='cases'
level = 'state'
res = records2counts(dat, count_type= count_type, level= level)
new = res$new
cum = res$cum
US.new = new
US.cum = cum

main='US states'
xlab='Days'
ylab='Cumulative'
plot.points=T
adjust.label=T

n=54 # without model line
col=col18
pdf(paste('f4a_US_case_growth',Sys.Date(),'pdf',sep='.'),w=6,h=12)
layout(matrix(c(rep(1,18),2:(n+1)), nrow=12, ncol=6, byrow = TRUE))
cum2matplot(cum, n=n, align_n=100, day1='03-01')
#layout(matrix(1, nrow=1, ncol=1, byrow = TRUE))
dev.off()

# heatmap
library(RColorBrewer)
library(gplots)
breaks=c(0,1,4,16,64,256, 1024, 2048 )-0.1
col=c('white',brewer.pal(5,"Oranges"),'black')
pdf(paste('f4b_US_case_heatmap_3',Sys.Date(),'pdf',sep='.'),w=8,h=16)
n=54
new2heatmap(new,n=n,day1='03-01') 
dev.off()

# combine with China data
# format dxy
dxy=read.csv('from_github/DXY-COVID-19-Data/csv/DXYArea.csv',as.is=T)
days = sapply(as.character(dxy$updateTime),function(x) unlist(strsplit(x,split=' '))[1] )
days=sapply(days,function(x) unlist(strsplit(x,split='2020-'))[2])
levels(as.factor(days))
dxy$day = days

## province level
china = subset(dxy, countryEnglishName=='China')
china = subset(china, provinceEnglishName!='China')
#china = subset(china, provinceEnglishName!='Taiwan')
china_province_case=subset(china,select=c('provinceEnglishName','province_confirmedCount','day'))

## find max for each day
dat = china
count_type = 'province_confirmedCount'
level = 'provinceEnglishName'
China.res = records2counts(dat, count_type= count_type, level= level)
China.new = China.res$new
China.cum = China.res$cum

China = China.new
US = US.new
overlapped.days = intersect(colnames(China),colnames(US))
combined = rbind(China[,overlapped.days],US[,overlapped.days])
new = combined
pdf(paste('f5c_China_vs_US_heatmap',Sys.Date(),'pdf',sep='.'),w=15,h=15)
main='China vs. US'
new2heatmap(new,n=nrow(new),day1='01-22')
dev.off()

China = China.cum
US = US.cum
overlapped.days = intersect(colnames(China),colnames(US))
combined = rbind(China[,overlapped.days],US[,overlapped.days])
cum=combined
col = c(rep('gray',nrow(China)),rep('blue',nrow(US)))
pdf(paste('f5c_China_vs_US_growth1',Sys.Date(),'pdf',sep='.'),w=10,h=30)
main='China vs. US'
n=nrow(cum)
layout(matrix(c(rep(1,24),2:(n+1)), nrow=14, ncol=8, byrow = TRUE))
cum2matplot(cum, n=n, align_n=100, day1='01-22')
dev.off()

pdf(paste('f5c_China_vs_US_growth2',Sys.Date(),'pdf',sep='.'),w=5,h=5)
main='China vs. US'
plot.points=F
adjust.label=F
n1=sum(China[,ncol(China)]>=100)
n2=sum(US[,ncol(US)]>=100)
col = c(rep('gray',n1),rep('blue',n2))
layout(matrix(c(rep(1,16),2:(n1+n2+1)), nrow=4, ncol=4, byrow = TRUE))
cum2matplot.aligned(cum, n=n1+n2, align_n=100, day1='01-22')
dev.off()
