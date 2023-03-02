########################################
## function for solving ode          ###
########################################
eqRG = function(tm, state, parms){
  
  
  with(as.list(c(tm, state, parms)),
       {

	    #############################################################
		## Temporal: If y1 is negative then return list(-1,0,0,0)  ###
		#############################################################

        Isp0.i= parms$Isp0 # #Isp0[1]
        dmdt.i= parms$dmdt #dmdt[1]
        anozzle.i= parms$anozzle #anozzle[1]
        across.i= parms$across #across[1]
        m0.i = parms$m0#  m0[1]
        bt.i= parms$burntime #burntime[1]

       #This is an intermediate output to the console
	   	true_tatburn = FALSE
	    for(i in 1:length(parms$tatburn) ){
		    #cat("eqRG: line 33: parms$tatburn[",i,"] -1=",(parms$tatburn[i]-1)," tm=",tm,"\n")
			if (tm == (parms$tatburn[i] -1)  ){ 
			   true_tatburn = TRUE
			}
			#else{
			#true_tatburn = FALSE}   
	    }#for(i = 1:length(parms$tatburn) )
	    
		
        #if ((tm == parms$tatburn[1]) || (tm == parms$tatburn[2]) || (tm == parms$tatburn[3])) 
		if(true_tatburn)
        #if ((tm == parms$tatburn[1]) || (tm == parms$tatburn[2]) || (tm == parms$tatburn[3])) 
		{
	        #print("eqRG: line 32")
			BOtm=tm
			BOh=y1/1000
			BOV=y2/1000
			cat("eqRG:  _________________________\n")
			cat("eqRG: CONDITIONS AT BURNOUT:\n")
			cat("eqRG: y1,y2,y3,y4",y1,y2,y3,y4,"\n")
			cat("eqRG: Time=",BOtm," s\n")
			cat("eqRG: Height=",BOh," km\n")
			cat("eqRG: Velocity=",BOV," km/s\n")
			cat("eqRG: Range=",6370*y4," km\n")
			cat("eqRG: Angle=",y3*180/pi," deg\n")
			bodata = c(BOtm,BOh,BOV,6378.1*y4,y3*180/pi )
			#print("eqRG: line 44")
			write.table(bodata,"bodata.dat")
			#print("eqRG: line 46")
			cat("eqRG: _________________________\n")
        
        }else{
		   write.table(c("NA","NA","NA","NA"),"bodata.dat")
		} # end if ((tm == parms$tatburn[1]) || (tm == parms$tatburn[2]) || (tm == parms$tatburn[3])) 
             
       #  FOR SOME REASON y1 is negative even though y2 is positive
       # Also note that eta has been converted to radians
       
       ## ODE system
	   a1_tm = T.h(y1,tm,Isp0.i,dmdt.i,parms)/M.t(bt.i,tm,m0.i,dmdt.i,parms)	   
	   cd.V_tm = cd.V(y2)
	   Rho.h_y1 = Rho.h(y1)
	   M.t_print = M.t(bt.i,tm,m0.i,dmdt.i,parms)
	   a2_tm = cd.V(y2)*across.i*Rho.h(y1)/(2*M.t(bt.i,tm,m0.i,dmdt.i,parms)) #change tm to y2 in cd.V
	   cat("eqRG.r: line 92, a2_tm=",a2_tm,  "cd.V(tm)=",cd.V_tm , " across.i=",across.i,"Rho.h(y1)=",Rho.h_y1,"M.t_print = ",M.t_print, " \n")
       a3_tm = g.h(y1, parms)
       b1_tm = (1/(Rearth+y1))	   
	   
       dy1 =  y2*sin(y3) # Height
	   g.h = g.h(y1,parms)
	   cos_Eta.t = cos(Eta.t(tm,parms))
	   dy2 =  a1_tm*cos(Eta.t(tm,parms)) - a2_tm *(y2*y2) - g.h(y1,parms) * sin(y3) # V
	   
	   y2_sqr_eqlbr=(a1_tm*cos(Eta.t(tm,parms)) -  g.h(y1,parms) * sin(y3))/a2_tm #equilibrim y2, at which dy2 = 0
	   y2_sqr_eqlb_dy3.eq = (g.h(y1,parms)*cos(y3) - a1_tm*sin(Eta.t(tm,parms))/cos(y3) )*(Rearth + y1)
	   
	   
	   
	   cat("eqRG: line 104: y2 = ",y2, "  dy2 = ",dy2, "y1 = ",y1, "\n")
	   #if( (y2 + dy2) < 0){
	   #dy2 = -y2+10 }
	   cat("eqRG:line 99 dy2 =  a1_tm*cos(Eta.t(tm,parms)) - a2_tm *(y2^2) - g.h(y1,parms) * sin(y3) \n")
	   if(y2_sqr_eqlbr>0){
	   cat("eqRG:line 100 tm = ",tm , "y1 = ",y1, " y2 = ",y2," y3 = ",y3, "y4 =",y4," dy1=",dy1," dy2=",dy2,
	          "  sqrt(y2_sqr_steady_State)= ", sqrt(y2_sqr_eqlbr),"sqrt(y2_sqr_eqlb_dy3.eq)=",
			  sqrt(y2_sqr_eqlb_dy3.eq), " a1_tm=",a1_tm," a2_tm=",a2_tm," cos(Eta.t(tm,parms))=",cos_Eta.t,
			  " g.h(y1,parms)=",g.h, " sin(y3)=",sin(y3)," g.h(y1,parms)*sin(y3)=", (g.h*sin(y3)),"a2_tm*(y2^2) = ",
			  a2_tm *(y2^2),"m0.i=",m0.i,  "\n")
	   
	   }else{
	  cat("eqRG:line 100 tm = ",tm, "y1 = ",y1, " y2 = ",y2," y3 = ",y3, "y4 =",y4," dy1=",dy1, " dy2=",dy2,
	  "  y2_sqr_steady_State = ", y2_sqr_eqlbr, "y2_sqr_eqlb_dy3.eq=",(y2_sqr_eqlb_dy3.eq), 
	  " a1_tm=",a1_tm," a2_tm=",a2_tm," cos(Eta.t(tm,parms))=",cos_Eta.t," g.h(y1,parms)=",g.h, " sin(y3)=",sin(y3),
	  " g.h(y1,parms)*sin(y3)=", (g.h*sin(y3)),"a2_tm*(y2^2) = ",a2_tm *(y2^2),"m0.i=",m0.i,  "\n")
	    
	   }
	   
	   cos_Eta.t.tmp = cos(Eta.t(tm,parms))
	   #cat("eqRG: line 83 after cos(Eta.t(tm)) = ", cos_Eta.t.tmp ,"\n")
       dy4 =  y2*cos(y3)/(Rearth + y1) # Psi
       #if(y2 != 0){
			dy3 =  dy4 + (a1_tm /y2)*sin(Eta.t(tm,parms))- (g.h(y1,parms)/y2)*cos(y3) # Gamma  
	   #}else{
		#	dy3 = 0
	   #}
       sin_Eta.t.tmp = sin(Eta.t(tm,parms))
	   #cat("eqRG: line 88 after sin_Eta.t.tmp = ", sin_Eta.t.tmp ,"\n")
	   
	   ##########################################################################################
	   ## When y1<0 that means the ground is reached and further calculations are not needed  ###
	   ##########################################################################################
	   if(y1<0){
	   dy1 = -1
	   dy2 = 0
	   dy3 = 0
	   dy4 = 0
	   }
	   out = list(c(dy1, dy2, dy3, dy4))
	   
	   cat("eqRG.r: line 57: out = \n")
	   print(out)
       
	   return(out)
          
       })#end with
  } # end eqRG 