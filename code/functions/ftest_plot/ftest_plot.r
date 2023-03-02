#Testing and plotting the outcome ###
# filename = "sol-test.csv"
# nameTableBurnout = "bodata.dat"
# p.df - input parameters
ftest_plot <- function(nameSolTest, tt, nameTableBurnout, p.df, stge.df ) {
cat("ftest_plot: p.df =  \n")
print(p.df)
    cat("ftest_plot: line 6: tt = ",tt,"\n")

    #placeholders for vectors that keep the earth  plot
    xre <-vector(mode = "numeric", length = 1)
    yre <-vector(mode = "numeric", length = 1)

	sol_test <- read_csv(nameSolTest)
	cat("ftest_plot: line 13 sol_test= \n")
	print(sol_test)
	cat("ftest_plot: line 15  sol_test[, y1] = \n")
	print(sol_test[, "y1"])
	cat("ftest_plot: line 15  max(sol_test[, y1]) = \n")
	print(max(sol_test[,'y1'])/1000)
	
	#View(sol_test)
	y4=sol_test$y4 # m
	y1=sol_test$y1/1000 # m
	ti=sol_test$time*1.

	x=sin(y4)*(6370+abs(y1))
	y=cos(y4)*(6370+abs(y1))

	mult1 = 10 # scale the frequency of data points on the earth curve on the plot
	for (i in 0:(360*mult1))
	{
		xre[i]=sin(i*pi/(180*mult1))*(6370)
		yre[i]=cos(i*pi/(180*mult1))*(6370)
	}

	# Angle=paste("Angle=",boang," ")
		for (i in 1:tt)
	{
		if (y1[i] == max(sol_test[,'y1'])/1000){
			cat("ftest_plot:Time at Apogee=",ti[i],"\n")
			cat("ftest_plot: Range at Apogee=",abs(y4[i]*6370),"\n")
			tim=ti[i]
			cat("ftest_plot:line 49: tim = \n")
			print(tim)
			ran=abs(y4[i]*6370)
			cat("ftest_plot:line52 ran = \n")
			print(ran)
			cat("ftest_plot:line54 i = ",i,"  tt=",tt,"  length(y1) = ", length(y1),"\n")
			next
		}# end if
    }#end for
	apo=paste("H=",signif(max(sol_test[,'y1'])/1000,5)," km, ")
	tim=paste("T at Apogee=",tim," s")
	ran=paste("Range at Apogee=",signif(ran,4)," km, ")	
	par(mfrow=c(1,1))

	str_main = paste("Model: ",stge.df$Name[1],",  PL = ",p.df$payload[1],sep="")
	
	plot(x, y, main= str_main, col.main="red", sub=paste(ran,  apo, tim, sep=""),#"Range=xxx km, Ap=xxx km",
		xlab="X-axis, km", ylab="y-axis, km",
		xlim=c(exmin, exmax), ylim=c(eymin, eymax),pch=".")
	lines(xre,yre,lwd=4)

	cat("ftest_plot, line 40: Apogee=",max(sol_test[,'y1'])/1000," km\n")
	# for (i in 1:tt)
	# {
		# if (y1[i] == max(sol_test[,'y1'])/1000){
			# cat("ftest_plot:Time at Apogee=",ti[i],"\n")
			# cat("ftest_plot: Range at Apogee=",abs(y4[i]*6370),"\n")
			# tim=ti[i]
			# cat("ftest_plot:line 49: tim = \n")
			# print(tim)
			# ran=abs(y4[i]*6370)
			# cat("ftest_plot:line52 ran = \n")
			# print(ran)
			# cat("ftest_plot:line54 i = ",i,"  tt=",tt,"  length(y1) = ", length(y1),"\n")
			# next
		# }# end if
    # }#end for


    cat("ftest_plot:line 59: \n")
	


	#text(0, 8000, apo, cex=0.8, pos=4, col="blue")
	#text(0, 7800, tim, cex=0.8, pos=4, col="red")
	#text(0, 7600, ran, cex=0.8, pos=4, col="blue")
	cat("Max Range=",max(sol_test[,'y4'])*6370,"\n")

	maxrange = max(sol_test[,'y4'])*6370
	vbocano = 0.9
	conv = pi/180
# Burnout Data
 print("ftest_plot: nameTableBurnout = ")
 print(nameTableBurnout)
	bodata <- read.table(nameTableBurnout)
	BOtm = bodata$x[1]
	BOh = bodata$x[2]
	BOV = bodata$x[3]
	BOrange = bodata$x[4]
	boang = bodata$x[5]
	vbocano = BOV/7.90538
	cat("ftest_plot: BOtm=",BOtm,"\n")
	cat("ftest_plot: BOV=",BOV,"\n")
	cat("ftest_plot: BOrange=",BOrange,"\n")
	cat("ftest_plot: boang=",boang, "\n")
	cat("ftest_plot: vbocano=",vbocano,"\n")

# Velocity at BO in Cannonical Units
# phie=30*conv # degrees
	betae = 120*conv # degrees THIS WILL VARY
	phie = boang*conv # degrees


# Assumed launch point Pukchang Airfield Missile Base:
	lat1 =p.df$lat1 # 39.5048 # deg North
	lon1 = p.df$lon1 # 125.9693 # deg West

	VS=vbocano*cos(phie)*cos(betae)
	VE=vbocano*cos(phie)*sin(betae)+0.0588*cos(lat1)
	VZ=vbocano*sin(phie)
	vmag=(VS^2+VE^2+VZ^2)^(0.5)
	rbo=6378.1+BOh
	phibo=(180/pi)*asin(VZ/vmag)
	betabo=atan(VE/VS)
	Qparam=vmag^2*(rbo/6378.1)
	cat("ftest_plot: VS,VE,VZ=",VS,VE,VZ,"\n")
	cat("ftest_plot: vmag=",vmag,"\n")
	cat("ftest_plot: betabo=",360+betabo*180/pi,"\n")
	cat("ftest_plot: Qparam=",Qparam,"\n")
	cat("ftest_plot: phibo=",phibo,"\n")

	# Angle from North (Beta)
	Beta = 90. # degrees away from North
	Beta = Beta*pi/180

	angdist=(maxrange/6378.1)
	cat("ftest_plot: angdist=",angdist*6378.1,cos(angdist),lat1,"\n")
	lat1=lat1*conv
	lon1=lon1*conv
	cat("ftest_plot: lat1,lon1",lat1,lon1,"\n")

	#lat2 = asin(sin(lat1)*cos(d/R) + cos(lat1)*sin(d/R)*cos(??))
	#lon2 = lon1 + atan2(sin(??)*sin(d/R)*cos(lat1), cos(d/R)???sin(lat1)*sin(lat2))

	lat2 = lat.fn(lat1,angdist,Beta)
	cat("ftest_plot: lat2=",lat2,"\n")
	lon2a = cos(angdist) - sin(lat1)*sin(lat2)
	cat("ftest_plot: lon2a,angdist,lat1,lat2=",lon2a,angdist,lat1,lat2,"\n")
	lon2b = sin(Beta)*sin(angdist)*cos(lat1)
	cat("ftest_plot: lon2b,Beta=",lon2b,Beta,"\n")

	lon2 = lon1 + atan(lon2b/lon2a)  
	cat("ftest_plot: lon2=",lon2,"\n")
	VEast=0.4546*cos(lat2)
	cat("ftest_plot: VEast=",VEast,"\n")
	DEast=VEast*tt # km
	lat3 = lat2
	kmperdeg = (2*pi/360) * 6378.1 * cos(lat2)
	cat("ftest_plot: kmperdeg=",kmperdeg,"\n")
	lon3 = lon2 + (DEast/kmperdeg)*pi/180
	cat("ftest_plot: lat1=",lat1*180/pi,"\n")
	cat("ftest_plot: lon1=",lon1*180/pi,"\n")
	cat("ftest_plot: lat2=",lat2*180/pi,"\n")
	cat("ftest_plot: lon2=",lon2*180/pi,"\n")
	cat("ftest_plot: lat3=",lat3*180/pi,"\n")
	cat("ftest_plot: lon3=",lon3*180/pi,"\n")
# d = acos( sin ??1 ??? sin ??2 + cos ??1 ??? cos ??2 ??? cos ???? ) ??? R

	Range = acos(sin(lat1)*sin(lat3)+cos(lat1)*cos(lat3)*(cos(lon3-lon1)))*6378.1
	cat("ftest_plot: As crow flies Range=",Range,"km \n")
	cat("ftest_plot: Non-rotating earth Range=",maxrange,"km \n")
	cat("ftest_plot: Time of Flight=",tt/60," min \n")
	cat("ftest_plot: Apogee = ",max(sol_test[,'y1'])/1000,"km \n")
	df <- read.table(bodata,"bodata.dat")
  print(df)}