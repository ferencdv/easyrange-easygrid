   M.t <- function(bt.i,tm,m0.i,dmdt.i,parms){
        #Isp0.i= parms$Isp0 # #Isp0[1]
        #dmdt.i= parms$dmdt #dmdt[1]
        #m0.i = parms$m0#  m0[1]
        #bt.i= parms$burntime #burntime[1]
#      Can't import more data into function
       M.t=0.
       burntime[1]=120.
       burntime[2]=110.
       burntime[3]=40.
       tatburn[1] = burntime[1]
       tatburn[2] = burntime[1]+burntime[2]
       tatburn[3] = burntime[1]+burntime[2]+burntime[3]
       payload=1000 # kg
       shroud=400 # kg
       m0[1]=65900 # kg
       m0[2]=11000 # kg
       m0[3]=1000 # kg
       tshroud=180

       if (tm < tshroud) {
         reentry=payload+shroud
       } else {
         reentry=payload
       }
         
         if (tm<=tatburn[1]) {
           dmdt.i=dmdt[1]
		   #dmdt[stage] = stage.df$fuelmass[stage]/stage.df$burntime[stage] 
		   # Mt =  entire mass at the initial of stage 1 (i.e. mt(at time 0))
		   #Mass of missile =payload+Dry weight[3]+Fuelmass[3]+Dry weight[2]+Fuelmass[2]+Dry weight[1]+dmdt[1]*(bt[1] -t)
		   #m0.i = parms$m0 = payload+Dry weight[3]+Fuelmass[3]+Dry weight[2]+Fuelmass[2]+Dry weight[1]+Fuelmass[1]
           #Mt=m0.i-dmdt.i*tm + m0[2]+m0[3]+reentry #m0[stage] = DryWeight[stage] + FuelMass[stage]
		   Mt=m0.i-dmdt.i*tm  # not correct, m0.i =  Dry weight[1]+Fuelmass[1]
#           cat("m0.i,Mt,dmdt[1]",m0.i,Mt,dmdt.i,"\n")
           
         } else if ((tm>tatburn[1]) & (tm<=tatburn[2])) {
           dmdt.i=dmdt[2]
           Mt=m0.i-dmdt.i*(tm-tatburn[1])+m0[3]+reentry
#           cat("m0.i,Mt,dmdt[2]",m0.i,Mt,dmdt.i,"\n")
           
         }  else if ((tm>tatburn[2]) & (tm<=tatburn[3])) {
           dmdt.i=dmdt[3]
           Mt=m0.i-dmdt.i*(tm-tatburn[2])+reentry
#           cat("m0.i,Mt,dmdt[3]",m0.i,Mt,dmdt.i,"\n")
         }  else {
           Mt=m0.i-dmdt[3]*burntime[3]+reentry
#           cat("END: m0.i,Mt",m0.i,Mt,"\n")
         }
         
# cat("tm,Mt:bt.i,m0.i,dmdt.i",tm,": ",Mt,": ",bt.i,tm,m0.i,dmdt.i,"\n")
         return(Mt)

       }
