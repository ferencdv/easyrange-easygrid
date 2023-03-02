 ##############################################
 ## Thrust function                         ###
 ############################################## 
 T.h <- function(z,t,Isp0.i,dmdt.i,parms) {
       #the first argument is y1 not y2
#      Can't import more data into function
       #Th= 0.
       #fra = parms$fra  #1
	   #anozzle.i= parms$anozzle
       #burntime[1] = parms$burntime #150.
# NOTE ISSUE WITH BT IF BT[2] set to 40 it works?
       #tatburn[1] = burntime[1]
       #payload = parms$payload   #205. # kg
	   Isp0 = parms$Isp0
       #m0[1] =  parms$m0  #2050+27230+payload # kg
	   stage = parms$stage
       #dmdt = parms$dmdt
       anozzle = parms$anozzle
       tatburn = parms$tatburn	   
	   
	    

 
         p0 = standard_atmosphere(0,vout=2)
         if (z > 0) {
           ph = standard_atmosphere(z,vout=2)
         } else {
           ph = p0   
         }
         g0 = 9.8
         #anozzle.i.new=(0.2/2)^2*3.141592*4 # This variable seems to be different from anozzle.i defined in the previous functions
         
		 if(t <= tatburn[ length(tatburn)]){

			Th = g0 * Isp0.i * dmdt.i + anozzle * (p0-ph)
		    cat("t_h: line 30: Th = ",Th," tm = ",t,"  tatburn[ length(tatburn)]=",tatburn[ length(tatburn)],"\n")			
		 } else{
		    Th = 0. # this is a place holder for a small number. powered flight is over so not burning fuel anymore 
		    cat("t_h: line 35: Th = ",Th," tm = ",t,"  tatburn[ length(tatburn)]=",tatburn[ length(tatburn)],"\n")	
		 }
         


         return(Th)
       }