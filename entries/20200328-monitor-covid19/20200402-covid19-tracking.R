source('./20200402-covid19-tracking-functions.R')
# get data
us.states.case = get.us.states(count_type = 'cases',level = 'state')
us.states.death = get.us.states(count_type = 'deaths',level = 'state')
chinese.provinces.case = get.china.provinces(count_type = 'province_confirmedCount',level = 'provinceEnglishName')
chinese.provinces.death = get.china.provinces(count_type = 'province_deadCount',level = 'provinceEnglishName')
world.provinces.case = get.world.provinces(count_type = 'province_confirmedCount',level = 'provinceEnglishName')
world.provinces.death = get.world.provinces(count_type = 'province_deadCount',level = 'provinceEnglishName')

# make plots

## plot 1a China growth: 2nd wave
pdf(paste('f1a_china_case_growth',Sys.Date(),'pdf',sep='.'),w=5,h=10)
main='China new cases, 2nd wave'
day1='03-01'
xlab='Days since March 01'
ylab='Cumulative'
plot.points=T
adjust.label=F
add.total=T
add.double=T
new = chinese.provinces.case$new
new.2nd = new[,which(colnames(new) == day1):ncol(new)]
#new.2nd = new.2nd[rownames(new.2nd)!='Hubei',]
cum.2nd = t(apply(new.2nd,1,cumsum))
cum = cum.2nd

n=16 # regardless of the regression line
col=c('gray',col18)
layout(matrix(c(rep(1,16),2:(n+1)), nrow=8, ncol=4, byrow = TRUE))
cum2matplot(cum, n=n, align_n=100, day1=day1)
cum2matplot.aligned(cum, n=n, align_n=100, day1=day1)

day1='03-01'
xlab='Days since March 01'
main='China new cases, 2nd wave, except Hubei'
new = chinese.provinces.case$new
new.2nd = new[,which(colnames(new) == day1):ncol(new)]
new.2nd = new.2nd[rownames(new.2nd)!='Hubei',]
cum.2nd = t(apply(new.2nd,1,cumsum))
cum = cum.2nd
layout(matrix(c(rep(1,16),2:(n+1)), nrow=8, ncol=4, byrow = TRUE))
cum2matplot(cum, n=n, align_n=10, day1=day1)
cum2matplot.aligned(cum, n=n, align_n=10, day1=day1)

dev.off()


pdf(paste('f1b_china_case_heatmap',Sys.Date(),'pdf',sep='.'),w=10,h=5)
day1='01-23'
par(cex.main=0.8)
main = 'China confirmed cases'
library(RColorBrewer)
library(gplots)
breaks=c(0,1,4,16,64,256, 1024, 2048 )-0.1
col=c('white',brewer.pal(5,"Oranges"),'black')
new2heatmap(chinese.provinces.case$new,n=nrow(new.2nd),day1=day1)
dev.off()

# US states
pdf(paste('US_states_death',Sys.Date(),'pdf',sep='.'),w=5,h=10)
day1='03-01'
main='US states, deaths'
xlab='Days'
ylab='Cumulative'
plot.points=T
adjust.label=F
add.total=T
add.double=T
cum = us.states.death$cum

n=16 # regardless of the regression line
col=c('gray',col18)
#pdf(paste('f4a_US_case_growth',Sys.Date(),'pdf',sep='.'),w=5,h=10)
layout(matrix(c(rep(1,16),2:(n+1)), nrow=8, ncol=4, byrow = TRUE))
cum2matplot(cum, n=n, align_n=10, day1=day1)
cum2matplot.aligned(cum, n=n, align_n=10, day1=day1)
dev.off()


# figure f5e

pdf(paste('f5e_China_vs_US_case_growth_aligned',Sys.Date(),'pdf',sep='.'),w=5,h=5)
main='China vs. US, cases'

China = chinese.provinces.case$cum
US = us.states.case$cum
overlapped.days = intersect(colnames(China),colnames(US))
combined = rbind(China[,overlapped.days],US[,overlapped.days])
cum=combined
col = c(rep('gray',nrow(China)),rep(col18,nrow(US)))

plot.points=F
adjust.label=F
add.total=F
add.double=F

n1=sum(China[, overlapped.days[length(overlapped.days)]]>=1000)
n2=sum(US[, overlapped.days[length(overlapped.days)]]>=1000)
col = c(rep('gray',n1),rep(col18,n2))
layout(matrix(c(rep(1,16),2:(n1+n2+1)), nrow=4, ncol=4, byrow = TRUE))
cum2matplot.aligned(cum, n=n1+n2, align_n=1000, day1='01-22')
dev.off()

pdf(paste('f5f_China_vs_US_death_growth_aligned',Sys.Date(),'pdf',sep='.'),w=5,h=5)
main='China vs. US, deaths'

China = chinese.provinces.death$cum
US = us.states.death$cum
overlapped.days = intersect(colnames(China),colnames(US))
combined = rbind(China[,overlapped.days],US[,overlapped.days])
cum=combined
col = c(rep('gray',nrow(China)),rep(col18,nrow(US)))

plot.points=F
adjust.label=F
add.total=F
add.double=F

n1=sum(China[, overlapped.days[length(overlapped.days)]]>=10)
n2=sum(US[, overlapped.days[length(overlapped.days)]]>=10)
col = c(rep('gray',n1),rep(col18,n2))
layout(matrix(c(rep(1,16),2:(n1+n2+1)), nrow=4, ncol=4, byrow = TRUE))
cum2matplot.aligned(cum, n=n1+n2, align_n=10, day1='01-22')
dev.off()



pdf(paste('f5g_World_vs_US_case_growth_aligned',Sys.Date(),'pdf',sep='.'),w=5,h=5)
main='World vs. US states, cases'

China = head(world.provinces.death$cum,10)
US = us.states.death$cum
overlapped.days = intersect(colnames(China),colnames(US))
combined = rbind(China[,overlapped.days],US[,overlapped.days])
cum=combined
col = c(rep('gray',nrow(China)),rep(col18,nrow(US)))

plot.points=F
adjust.label=F
add.total=F
add.double=F

n1=sum(China[, overlapped.days[length(overlapped.days)]]>=100)
n2=sum(US[, overlapped.days[length(overlapped.days)]]>=100)
col = c(rep('gray',n1),rep(col18,n2))
layout(matrix(c(rep(1,16),2:(n1+n2+1)), nrow=4, ncol=4, byrow = TRUE))
cum2matplot.aligned(cum, n=n1+n2, align_n=100, day1='01-22')
dev.off()

pdf(paste('f5h_World_vs_US_death_growth_aligned',Sys.Date(),'pdf',sep='.'),w=5,h=5)
main='World vs. US states, deaths'

China = head(world.provinces.death$cum,5)
US = us.states.death$cum
overlapped.days = intersect(colnames(China),colnames(US))
combined = rbind(China[,overlapped.days],US[,overlapped.days])
cum=combined
col = c(rep('gray',nrow(China)),rep(col18,nrow(US)))

plot.points=F
adjust.label=F
add.total=F
add.double=F

n1=sum(China[, overlapped.days[length(overlapped.days)]]>=10)
n2=sum(US[, overlapped.days[length(overlapped.days)]]>=10)
col = c(rep('gray',n1),rep(col18,n2))
layout(matrix(c(rep(1,16),2:(n1+n2+1)), nrow=4, ncol=4, byrow = TRUE))
cum2matplot.aligned(cum, n=n1+n2, align_n=10, day1='01-22')
dev.off()

pdf(paste('f5i_World_death_growth_aligned',Sys.Date(),'pdf',sep='.'),w=5,h=5)
main='World deaths'

cum=world.provinces.death$cum
col=col18
plot.points=F
adjust.label=F
add.total=F
add.double=F
layout(matrix(c(rep(1,16),2:17), nrow=4, ncol=4, byrow = TRUE))
cum2matplot.aligned(cum, n=16, align_n=10, day1='01-22')
dev.off()

pdf('world_total.pdf',w=5,h=5)
total = apply(world.provinces.death$cum,2,sum)
#names(total) = colnames(world.provinces.death$cum)
plot(total,type='l',log='y',cex=.5,pch=19)
days = length(total):1
#lines(days, total[length(total)]*2^((days-length(total))/6.5*2),col='gray')
points(length(total),total[length(total)],cex=.5,pch=19)
dev.off()


# new plot



plot_trend = function(res,min.cum=100,main='',col=col,last.day='',avg.n=7,log.xy='xy') {
	new = res$new; 
	cum = res$cum;
	if (last.day=='') {
		lastday = ncol(new)		
	} else {
		lastday = which(colnames(new)==last.day)
	}
	n=min(avg.n,lastday)
	days = seq(n,lastday,1)
	new.lastweek = new[,n:lastday]
	for (i in 1:(n-1)) {
		shift.i.day = new[,i:(lastday-n+i)]
		new.lastweek = new.lastweek + shift.i.day
	}
	new.lastweek = new.lastweek / (n)
	new.lastweek = cbind(matrix(NA,nrow=nrow(new),ncol=n-1), new.lastweek)
	
	if (ave.cum==T) {
		cum.lastweek = cum[,days]
		for (i in 1:6) {
			shift.i.day = cum[,i:(ncol(cum)-7+i)]
			cum.lastweek = cum.lastweek + shift.i.day
		}
		cum.lastweek = cum.lastweek / 7
	}
	
	x = cum[,days]
	y = new.lastweek[,days]
	x = as.matrix(x,ncol=length(days))
	y = as.matrix(y,ncol=length(days))
	provinces = rownames(x)
	
	#provinces = provinces[x[,ncol(x)]>=min.cum]
	#x = x[provinces,]
	#y = y[provinces,]
	
	col=col[provinces]
	main = paste(main,'on',last.day)
	matplot(t(x), t(y), main=main, log=log.xy,type='l',lty=1,pch=19,cex=0.5,col=col,xlim=xlim,ylim=ylim,xlab='Total',ylab='Weekly new reports')
	text(tail(t(x),1), tail(t(y),1), labels = rownames(y),pos=4,col=col,cex=0.5, offset=.5)
	points(tail(t(x),1), tail(t(y),1), labels = rownames(y),pch=19,pos=4,col=col,cex=1, offset=0.3)
}

ave.cum=F
avg.n=14
pdf('lastweek-case-linear.pdf',w=5,h=5)
china.new = apply(chinese.provinces.case$new,2,sum)
china.cum = apply(chinese.provinces.case$cum,2,sum)
new = rbind(china.new, world.provinces.case$new)
cum = rbind(china.cum, world.provinces.case$cum)
rownames(new)[1] = 'China'
rownames(cum)[1] = 'China'

res = list(new=new,cum=cum)
col=rep(col18,round(nrow(new)/18))
names(col)=rownames(new)

for (last.day in colnames(new)[2:ncol(new)]) {
	ylim=c(10,max(new)*1);xlim=c(10000,max(cum)*1.3)
	plot_trend(res, min.cum=1000,main='Confirmed cases',col=col,last.day=last.day,avg.n=avg.n,log.xy='')
}
dev.off()


ave.cum=F
avg.n=14
pdf('lastweek-case.pdf',w=5,h=5)
china.new = apply(chinese.provinces.case$new,2,sum)
china.cum = apply(chinese.provinces.case$cum,2,sum)
new = rbind(china.new, world.provinces.case$new)
cum = rbind(china.cum, world.provinces.case$cum)
rownames(new)[1] = 'China'
rownames(cum)[1] = 'China'

total.new = apply(new,2,sum)
total.cum = apply(cum,2,sum)
new = rbind(total.new, new)
cum = rbind(total.cum, cum)
rownames(new)[1] = 'Total'
rownames(cum)[1] = 'Total'

res = list(new=new,cum=cum)
col=rep(col18,round(nrow(new)/18))
names(col)=rownames(new)

for (last.day in colnames(new)[2:ncol(new)]) {

	ylim=c(10,max(new)*1);xlim=c(100,max(cum)*1.3)
	plot_trend(res, min.cum=1000,main='Confirmed cases',col=col,last.day=last.day,avg.n=avg.n)
}
dev.off()

pdf('lastweek-death.pdf',w=5,h=5)
china.new = apply(chinese.provinces.death$new,2,sum)
china.cum = apply(chinese.provinces.death$cum,2,sum)
new = rbind(china.new, world.provinces.death$new)
cum = rbind(china.cum, world.provinces.death$cum)
rownames(new)[1] = 'China'
rownames(cum)[1] = 'China'

total.new = apply(new,2,sum)
total.cum = apply(cum,2,sum)
new = rbind(total.new, new)
cum = rbind(total.cum, cum)
rownames(new)[1] = 'Total'
rownames(cum)[1] = 'Total'


res = list(new=new,cum=cum)

for (last.day in colnames(new)[2:ncol(new)]) {

	ylim=c(1,max(new)*1);xlim=c(10,max(cum)*1.3)
	plot_trend(res, min.cum=100,main='Deaths',col=col,last.day=last.day,avg.n=avg.n)
}
dev.off()

avg.n=14
pdf('lastweek-US-case.pdf',w=5,h=5)
new = us.states.case$new
cum = us.states.case$cum

total.new = apply(new,2,sum)
total.cum = apply(cum,2,sum)
new = rbind(total.new, new)
cum = rbind(total.cum, cum)
rownames(new)[1] = 'Total'
rownames(cum)[1] = 'Total'


res = list(new=new,cum=cum)
col=rep(col18,round(nrow(new)/18))
names(col)=rownames(new)
for (last.day in colnames(new)[2:ncol(new)]) {
	ylim=c(1,max(new)*1);xlim=c(1,max(cum)*1.3)
	plot_trend(res, min.cum=0,main='Confirmed cases',col=col,last.day=last.day,avg.n=avg.n)
}
dev.off()


pdf('lastweek-US-death.pdf',w=5,h=5)
new = us.states.death$new
cum = us.states.death$cum


total.new = apply(new,2,sum)
total.cum = apply(cum,2,sum)
new = rbind(total.new, new)
cum = rbind(total.cum, cum)
rownames(new)[1] = 'Total'
rownames(cum)[1] = 'Total'


res = list(new=new,cum=cum)

for (last.day in colnames(new)[2:ncol(new)]) {
	ylim=c(1,max(new)*1);xlim=c(1,max(cum)*1.3)
	plot_trend(res, min.cum=0,main='Deaths',col=col,last.day=last.day,avg.n=avg.n)
}
dev.off()
