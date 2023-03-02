################################################
cd.V <- function(y2_v) {
         #****Drag function for V2*************
         #This function is taken from Sutton, "Rocket Propulsion Elements" (3rd ed)
         #pg. 119, which is data for a V-2.
         v = y2_v
         vratio = v/300.
         if (vratio > 5)  {
           Cdrag = .15
         } else if ((vratio > 1.8) & (vratio <= 5)) {
           Cdrag = .25 - .0312 * (vratio - 1.8)
         } else if ((vratio > 1.2) & (vratio <= 1.8)) {
           Cdrag = .42 - .283 * (vratio - 1.2)
         } else if ((vratio > .8) & (vratio <= 1.2)) {
           Cdrag = .15 + .675 * (vratio - .8)
         } else {
           Cdrag = .15
         }
         
         v = y2_v
         vratio = v/300.
         if (vratio > 4)  {
           Cdrag = .15
         } else if ((vratio > 1.05) & (vratio <= 4)) {
           Cdrag = 0.0271*vratio^2-0.22*vratio+0.6039
         } else if ((vratio > 1.0) & (vratio <= 1.05)) {
           Cdrag = 3*vratio-2.75
         } else if (vratio <= 1.05) {
           Cdrag = .25
         } else {
           Cdrag = .25
         }
         
         v=y2_v
         ratio = v/300.
         
         if ((vratio >= 1.) & (vratio <= 3)) {
           Cdrag = -0.0375*vratio + 0.3125
         } else {
           Cdrag = 0.2
         }
         
         if (vratio < 1.) {
           Cdrag = 0.2
         }
         
         
         v = y2_v
         vratio = v/300.
         if (vratio > 3)  {
           Cdrag = .2
         } else if ((vratio > 1.) & (vratio <= 1.25)) {
           Cdrag = 0.32*vratio-0.12
         } else if ((vratio > 1.25) & (vratio <= 3)) {
           Cdrag = -0.0457*vratio + 0.3371
         } else {
           Cdrag = .2
         }
         
         Cdrag=Cdrag*1.
         
         return(Cdrag)
       }# end cd.V



#############################################

      Rho.h <- function(y1){
         #H=y1
         rhoh=0.
		 cat("Rho.h: line 41: y1=",y1,"Rho=",rhoh,"\n")
         rhoh = standard_atmosphere(y1,vout=3)
         cat("Rho.h: line 43: y1=",y1,"Rho=",rhoh,"\n")
         return(rhoh)
       }
############################################ 
 
       P.h <- function(y1,tm){
         H=y1
         ph=standard_atmosphere(H,vout=2)*tm
         return(ph)
       }
###########################################
      g.h <- function(y1,parms){
	     #cat("functions.r:g.h: line 54 \n ")
         H=y1
         g0=9.8
         Rearth=parms$Rearth  #6370000
         gh=g0*(Rearth/(Rearth+H))^2
		 #cat("functions.r:g.h: line 59: gh=",gh," \n ")
         return(gh)
       }
############################################	   
       
       Eta.t <- function(tm, parms){
         # 2 Eta Periods: t1 then eta 1 t2 then eta 2
         #    'TWO PERIODS OF LATERAL THRUST DURING BOOST FROM 
         #    TIME tmin TO tmax
         #    etad1 = .25: tmin1 = 8: tmax1 = 28! 
         #    etad2 = 0!: tmin2 = 231!: tmax2 = 270!
		 etat = 0
		 if((tm>= parms$tMinAbsTime)& (tm <= parms$tMaxAbsTime )){
		  etat = parms$eta_change
		  cat("Eta.t: line 73 etat=",etat," tm = ", tm,"parms$tMinAbsTime=",parms$tMinAbsTime,"  parms$tMaxAbsTime=",parms$tMaxAbsTime,"\n" )
		 }
		 
         # t1min = 20  # in sec
         # t1max = 61  # in sec
         # t2min = 9200
         # t2max = 9220
		 # #cat(" Eta.t: line 74 tm=",tm,"\n")
         # if (tm <  t1min)  {
           # etat = 0.
         # } else if ((tm > t1min) & (tm <= t1max)) {
           # etat = -9 #-9. # degrees -.252
           # #cat("Eta.t line 78: Lateral Thrust on!",etat,"\n")
         # } else if ((tm > t2min) & (tm <= t2max)) {
           # etat = 0. # degrees
           # #cat("Eta.t line 81: Lateral Thrust on!",etat,"\n")
         # } else {
          # etat=0.  
		  # #cat("Eta.t line 85: Lateral Thrust on!",etat,"\n")
         #} 
         
         etat=etat*pi/180.
         return(etat)

         }
################################################

lat.fn <- function(lat,angdist,Beta) {
  # this outputs the lattitude for second point given
  # lat and long of initial point. 
  # lat2 = asin(sin(lat1)*cos(d/R) + cos(lat1)*sin(d/R)*cos(??))
  #cat("function.r: lat.fn: line 94, lat=",lat," \n")
  out=asin(sin(lat)*cos(angdist) + cos(lat)*sin(angdist)*cos(Beta))
  return(out)
}
#######################

###################################################################
##### Axiliary definitions for input data variables            ####
###################################################################
lengthvector = 1
fuelmass <-vector(mode = "numeric", length = lengthvector)
DryWeight <-vector(mode = "numeric", length = lengthvector)
m0 <-vector(mode = "numeric", length = lengthvector)
Isp0 <-vector(mode = "numeric", length = lengthvector)  
burntime <-vector(mode = "numeric", length = lengthvector) 
dmdt <-vector(mode = "numeric", length = lengthvector) 
thrust0 <-vector(mode = "numeric", length = lengthvector)
anozzle <-vector(mode = "numeric", length = lengthvector) 
across  <-vector(mode = "numeric", length = lengthvector)
tatburn <-vector(mode = "numeric", length = lengthvector)

bodata<-vector(mode = "numeric", length = lengthvector)


		 
	   