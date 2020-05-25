# functions
#library(showtext)
#showtext_auto()
#font_add('SimSun','/Library/Fonts/Microsoft/SimSun.ttf')
library(gplots)
col18 = c('#e6194b', '#3cb44b', '#4363d8', '#f58231', '#911eb4', '#46f0f0', 
	'#f032e6', '#bcf60c', '#fabebe', '#008080', '#e6beff', '#9a6324', 
	'#800000', '#aaffc3', '#808000', '#ffd8b1', '#000075', '#808080', '#000000')
col18.alpha=adjustcolor( col18, alpha.f = 0.5)

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

records2counts = function(dat,count_type,level) {
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

get.us.states = function(count_type = 'cases',level = 'state') {
	nyt=read.csv('from_github/covid-19-data/us-counties.csv')
	
	# format date
	days = as.character(nyt$date)
	days=sapply(days,function(x) unlist(strsplit(x,split='2020-'))[2])
	nyt$day = days

	## key step: get total case number by day
	dat = nyt
	res = records2counts(dat, count_type= count_type, level= level)

	return(res)
}

get.china.provinces = function(count_type = 'province_confirmedCount',level = 'provinceEnglishName') {
	# format dxy
	# or url='https://raw.githubusercontent.com/BlankerL/DXY-COVID-19-Data/master/csv/DXYArea.csv'
	dxy=read.csv('from_github/DXY-COVID-19-Data/csv/DXYArea.csv',as.is=T)

	# format date
	days = sapply(as.character(dxy$updateTime),function(x) unlist(strsplit(x,split=' '))[1] )
	days=sapply(days,function(x) unlist(strsplit(x,split='2020-'))[2])
	levels(as.factor(days))
	dxy$day = days
	
	## province level
	china = subset(dxy, countryEnglishName=='China')
	china = subset(china, provinceEnglishName!='China')
	#china = subset(china, provinceEnglishName!='Taiwan')
	#china_province_case=subset(
		#china,select=c('provinceEnglishName','province_confirmedCount','day'))
	
	## find max for each day
	dat = china
	res = records2counts(dat, count_type= count_type, level= level)
	return(res)	
}

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
	text(x.max, y.max, labels = paste(rownames(cum),y.max),pos=4,col=col,cex=cex.text, offset=0.3)
	mtext(colnames(cum)[x],at=x,side=1,cex=cex.text-0.2,line=0.3)
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
	colnames(cum) = 1:ncol(cum)
	
	# find day1 of each country when cases which align_n
	get_day1 = function(x) {
    		min((1:length(x))[x>= align_n])
	}
	day1 = apply(cum,1,get_day1)
	
	# create a new matrix with new ncol
	max.day1 = max(day1)
	min.day1 = min(day1)
	new.ncol = ncol(cum) - which(colnames(cum)==min.day1) + 1
	
	cum2 = matrix(NA,nrow=nrow(cum),ncol=new.ncol)
	for (i in 1:nrow(cum)) {
	    cum2[i, 1:(ncol(cum)-day1[i]+1)]=cum[i,day1[i]:ncol(cum)]
	}
	rownames(cum2) = rownames(cum)
	colnames(cum2) = 1:ncol(cum2) 
	
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
		cellnote=mat, notecol='white', notecex=0.4, 
		# color key 
		key=F,density.info="none",
		# margin
		lhei=c(0.8,4),lwid=c(.2,4), margins=c(5,7),
		# separators
		#sepcolor = 'white', colsep=0:ncol(mat), rowsep=0:nrow(mat), sepwidth=c(.1,.1), 
		# text adjust position
		offsetCol = 0, adjCol = c(NA,0.5), 
		# text size, color
		main=main, cexRow=0.7, cexCol=0.7,
		Rowv=F,Colv=F)
		
}

get.csse = function(count_type = 'US.cases') {
	# not finished yet
	if (count_type=='world.cases') {
		url='https://github.com/CSSEGISandData/COVID-19/raw/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv'
		csse=read.table(url(url),check.names=F,fill=T,header=T,sep=',',quote="\"")
		rownames(csse) = csse[,'Country/Region']
		csse=csse[,c(-1,-2,-3,-4)] # remove latitude and longitude
	} 
	if (count_type=='world.deaths') {
		url='https://github.com/CSSEGISandData/COVID-19/raw/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv'
		csse=read.table(url(url),check.names=F,fill=T,header=T,sep=',',quote="\"")
		rownames(csse) = csse[,'Country/Region']
		csse=csse[,c(-1,-2,-3,-4)] # remove latitude and longitude
	} 
	if (count_type=='US.cases') {
		url='https://github.com/CSSEGISandData/COVID-19/raw/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_US.csv'
		csse=read.table(url(url),check.names=F,fill=T,header=T,sep=',',quote="\"")
		rownames(csse) = csse[,'Province_State']
		csse=csse[,12:ncol(csse)] # remove latitude and longitude
	} 
	if (count_type=='US.deaths') {
		url='https://github.com/CSSEGISandData/COVID-19/raw/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_US.csv'
		csse=read.table(url(url),check.names=F,fill=T,header=T,sep=',',quote="\"")
		
		rownames(csse) = csse[,'Province_State']
		csse=csse[,12:ncol(csse)] # remove latitude and longitude
	} 

	
	# correct date
	dates = colnames(csse)
	dates = as.Date(dates,"%m/%d/%y")
	dates = as.character(dates)
	
	new = cumulative2new(counts)
	cum = t(apply(new,1,cumsum))
	
	# sorting
	mat = cum
	ix=sort(mat[,ncol(mat)],de=T,index.return=T)$ix # sort according to last day cumulative count
	cum =mat[ix,]
	new =new[ix,]
	return(list(cum=cum,new=new))
}

get.world.provinces = function(count_type = 'province_confirmedCount',level = 'provinceEnglishName') {
	# format dxy
	dxy=read.csv('from_github/DXY-COVID-19-Data/csv/DXYArea.csv',as.is=T)

	# format date
	days = sapply(as.character(dxy$updateTime),function(x) unlist(strsplit(x,split=' '))[1] )
	days=sapply(days,function(x) unlist(strsplit(x,split='2020-'))[2])
	levels(as.factor(days))
	dxy$day = days
	
	## province level
	#china = subset(dxy, countryEnglishName=='China')
	#china = subset(china, provinceEnglishName!='China')
	world = subset(dxy, countryEnglishName!='China')
	world = subset(world, provinceEnglishName!='Taiwan')

	## correct country name	
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
	    x=="Diamond Princess Cruise Ship" ~ "Diamond Princess",
	    x=="Democratic Republic of the Congo" ~ "Congo",
	    x=="The Republic of Equatorial Guinea" ~ "Guinea",
	    x=="The Islamic Republic of Mauritania" ~ "Mauritania",
	    TRUE ~ x
	  )
	}
	world$provinceEnglishName = NameFixR(as.character(world$provinceEnglishName))
	
	
	## find max for each day
	dat = world
	res = records2counts(dat, count_type= count_type, level= level)
	return(res)	
}

cum2matplot = function(cum,n,align_n=100,day1='03-01') {
	
	# from March 1st.
	cum = cum[,which(colnames(cum) == day1):ncol(cum)]
	average = apply(cum,2,mean)
	
	# add total
	if (add.total) {
		total = apply(cum,2,sum)
		cum = rbind(total,cum)
		rownames(cum)[1] = 'Total'		
	}
	
	# add model
	if (add.double) {
		double = round( average[1]*2^( (1:ncol(cum))/3 ) )
		cum = rbind(double, cum)
		rownames(cum)[1] = 'Double every 3 Days'		
	}
	
	matplot.all(cum[1:n,],main,xlab,ylab,cex.text=0.5)
	matplot.1by1(cum[1:n,])
		
}

cum2matplot.aligned = function(cum,n,align_n=100,day1='03-01') {
	
	# from March 1st.
	cum = cum[,which(colnames(cum) == day1):ncol(cum)]

	# align	
	cum = align(cum,align_n=align_n)
	average = apply(cum,2,mean)

	# add total
#	if (add.total) {
#		total = apply(cum,2,sum)
#		cum = rbind(total,cum)
#		rownames(cum)[1] = 'Total'		
#	}
	
	# add model
	if (add.double) {
		double = round( average[1]*2^( (1:ncol(cum))/3 ) )
		cum = rbind(double, cum)
		rownames(cum)[1] = 'Double every 3 Days'		
	}
	
	n=min(c(nrow(cum),n))
	
	xlab=paste('Days since number reaches',align_n)
	matplot.all(cum[1:n,],main,xlab,ylab)
	matplot.1by1(cum[1:n,])
	
}

