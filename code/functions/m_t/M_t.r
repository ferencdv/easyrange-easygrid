########################################################################
# Weight of the missile at each possible stages as a function of time  #
########################################################################
#Input:
#    tm - current time
#    m0.i = payload+Dry weight[3]+Fuelmass[3]+Dry weight[2]+Fuelmass[2]+Dry weight[1] + Fuelmass[1]  - at stage 1
#    m0.i = payload+Dry weight[2]+Fuelmass[2]+Dry weight[3] + Fuelmass[3]  - at stage 2
#    m0.i = payload+Dry weight[3] + Fuelmass[3]  - at stage 3
#    dmdt.i = change in the mass (of fuel) per unit of time
#    params - regular parameters that are composed in the main.r

# Note, that bt.i is not needed, and later must be deleted
# Output:
#    Mt - mass of the missile at a given time tm (changes due to use of the fuel)

M.t <- function(bt.i, tm, m0.i, dmdt.i, parms){

	   tatburn = parms$tatburn
	   stage = parms$stage
	   
	   if(stage == 1)
	   {
			#dmdt[stage] = stage.df$fuelmass[stage]/stage.df$burntime[stage] 
			# Mass of missile =payload+Dry weight[3]+Fuelmass[3]+Dry weight[2]+Fuelmass[2]+Dry weight[1]+dmdt[1]*t
			#m0.i = =payload+Dry weight[3]+Fuelmass[3]+Dry weight[2]+Fuelmass[2]+Dry weight[1] + Fuelmass[1]
			# Mt = m0.i - dmdt.i*tm
			#Mt = m0.i - dmdt.i*(burntime - tm)
			if(tm <= tatburn[1]){
					Mt = m0.i - dmdt.i*tm
			}else{ # relevant if the missile has only one stage
					Mt = m0.i - dmdt.i*tatburn[1]	
			}			
        cat("M_t.r: line 22: M.t stage = ", stage, " Mt = ",Mt, "  tm = ",tm,    "  dmdt.i=",dmdt.i, "m0.i = ",m0.i, " \n")			
	  }#if(stage = 1)
	  
	   if(stage == 2)
	   {
			#dmdt[stage] = stage.df$fuelmass[stage]/stage.df$burntime[stage] 
			# Mass of missile =payload+Dry weight[3]+Fuelmass[3]+Dry weight[2]+Fuelmass[2]+Dry weight[1]+dmdt[1]*t
			#m0.i = =payload+Dry weight[3]+Fuelmass[3]+Dry weight[2]+Fuelmass[2]+Dry weight[1] + Fuelmass[1]
			# Mt = m0.i - dmdt.i*tm
			#Mt = m0.i - dmdt.i*(burntime - tm)
			if(tm <= tatburn[2]){
				Mt = m0.i - dmdt.i*(tm - tatburn[1])	 
			}else{ #relevant if the missile has only two stages
				Mt = m0.i - dmdt.i*(tatburn[2] - tatburn[1])	
			}
        cat("M_t.r: line 33: stage = ", stage, " Mt = ",Mt, "  tm = ",tm, " tatburn[stage - 1] = ",tatburn[stage - 1],  "  dmdt.i=",dmdt.i, "m0.i = ",m0.i,  "  parms= \n")		
	   }#if(stage = 1)
	   
	   if(stage == 3 )
	   {
			#dmdt[stage] = stage.df$fuelmass[stage]/stage.df$burntime[stage] 
			# Mass of missile =payload+Dry weight[3]+Fuelmass[3]+Dry weight[2]+Fuelmass[2]+Dry weight[1]+dmdt[1]*t
			#m0.i = =payload+Dry weight[3]+Fuelmass[3]+Dry weight[2]+Fuelmass[2]+Dry weight[1] + Fuelmass[1]
			# Mt = m0.i - dmdt.i*tm
			#Mt = m0.i - dmdt.i*(burntime - tm)
			if(tm <= tatburn[3]){
				Mt = m0.i - dmdt.i*(tm - tatburn[2])
			}else{ #relevant if the missile has only three stages
			    Mt = m0.i - dmdt.i*(tatburn[3] - tatburn[2])
			}#end if(tm <= tatburn[3]){		
        cat("M_t.r: line 48: stage = ", stage, " Mt = ",Mt, "  tm = ",tm, " tatburn[stage -1] = ",tatburn[stage - 1],  "  dmdt.i=",dmdt.i,  "m0.i = ",m0.i, "  parms= \n")			
	   }#if(stage = 3)
	 
        return(Mt)

}# end of m.t