###############################################
         standard_atmosphere<-function(z,vout=3,T0=288.15,P0=101325,R0=1.225){
           #function developed with information provided from:
           # http://scipp.ucsc.edu/outreach/balloon/atmos/1976 Standard Atmosphere.htm
           #
           # z is altitude over sea level
           #
           # parameter vout has default value 3
           #  1 for temperature, 2 for pressure, 3 for density
		   cat("standard_atmosphere: line 10 z=", z ," vout = ", vout," T0=",T0, " P0=", P0,"  R0=",R0, "\n")
           
           level0<-c(0,11,20,32,47,51,100000) *1000.
           level1<-c(11,20,32,47,51,71,100000)*1000.
           
           func<-vector("list",length=3)#ncol=3,nrow=3)
           func[[1]]<-vector("list",length=7)#ncol=3,nrow=3)
           func[[2]]<-vector("list",length=7)#ncol=3,nrow=3)
           func[[3]]<-vector("list",length=7)
           
           func[[1]][[1]]<-function(z,T0=288.15){return(T0*(1.-z/44329))}
           func[[1]][[2]]<-function(z,T0=288.15){return(T0*(0.751865))}
           func[[1]][[3]]<-function(z,T0=288.15){return(T0*(0.682457 + z/288136))}
           func[[1]][[4]]<-function(z,T0=288.15){return(T0*(0.482561 + z/102906))}
           func[[1]][[5]]<-function(z,T0=288.15){return(T0*(0.939268))}
           func[[1]][[6]]<-function(z,T0=288.15){return(T0*(1.434843 - z/102906))}
           func[[1]][[7]]<-function(z,T0=288.15){return(T0*(1.434843 - z/102906))}
           
           func[[2]][[1]]<-function(z,P0=101325){return(P0*(1. - z/44329)^5.255876)}
           func[[2]][[2]]<-function(z,P0=101325){return(P0*(0.223361)*exp((10999-z)/6341.4))}
           func[[2]][[3]]<-function(z,P0=101325){return(P0*(0.988626 + z/198903)^(-34.16319))}
           func[[2]][[4]]<-function(z,P0=101325){return(P0*(0.898309 + z/55280)^(-12.20114))}
           func[[2]][[5]]<-function(z,P0=101325){return(P0*(0.00109456)*exp((46998-z)/7922))}
           func[[2]][[6]]<-function(z,P0=101325){return(P0*(0.838263 - z/176142)^(12.20114))}
           func[[2]][[7]]<-function(z,P0=101325){return(5.84E+1*z^(-1.05E+01))}
           
           func[[3]][[1]]<-function(z,R0=1.225){return(R0*(1. - z/44329)^4.255876)}
           func[[3]][[2]]<-function(z,R0=1.225){return(R0*(0.297076)*exp((10999-z)/6341.4))}
           func[[3]][[3]]<-function(z,R0=1.225){return(R0*(0.978261 + z/201010)^(-35.16319))}
           func[[3]][[4]]<-function(z,R0=1.225){return(R0*(0.857003 + z/57944)^(-13.20114))}
           func[[3]][[5]]<-function(z,R0=1.225){return(R0*(0.00116533)*exp((46998-z)/7922 ))}
           func[[3]][[6]]<-function(z,R0=1.225){return(R0*(0.79899 - z/184800)^11.20114)}
           func[[3]][[7]]<-function(z,R0=1.225){return(1.75E18*z^(-1.23E+01))}
                      
           out<-z
           for(i in 1:length(z)){
             n_level<-min(which(level1>=z[i]),na.rm=TRUE)
             #   print(c(vout,n_level))
             out[i]<-func[[vout]][[n_level]](z[i])
           }
#             if (z<0) { 
#             out=1.} else {
#             # not Z<0   
#             }
           cat("standard_atmosphere: line 53 z=", z ," out = ", out, "\n")
           return(out)
         }
         
###############################################