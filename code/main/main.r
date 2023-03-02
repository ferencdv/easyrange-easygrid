#written by Ferenc
#edited by Serguey K.
#Created: December 1, 2017
#Last updated:  january 7, 2018

#Questions:
#1.
# In eqRG.r: 
# bodata = c(BOtm,BOh,BOV,6378.1*y4,y3*180/pi ) OK
# What is 6378.1? Why in km not in meters?

#2. See function Eta.t at the file functions.r. Should these numbers be hardcoded?
# t1min = 20  # in sec
# t1max = 41  # in sec
# t2min = 200
# t2max = 220
# resolved, see the excel file


#The lines in this file run the main structure of the code

# burntime - (scalar) LENGTH of a time INTERVAL over which a stage burns its fuel
# tatburn - (scalar)  time  when the stage has burned its fuel
# tt - (scalar) maximum time over which the ode is solved
# tm  - (vector) time INTERVAL between two tatburns 



###########################################################
### Read general parameters from an Excel file         ####
### and run ode solution, test and plot the outcome    ####
### .df stands for data-frame                          ####
###########################################################
#p.df =   read.xlsx(file_input_parameters, sheetName = "InputParam1")
constPar.df = read.xlsx(file_input_parameters, sheetName = "InputParam1")
stage.df = read.xlsx(file_input_parameters, sheetName = "StageParam")
p1.df = cbind(constPar.df,stage.df)

print("Input Parameters: constPar.df=")
print(constPar.df)

print("Stage Param = ")
print(stage.df)



stageMax = max(stage.df$stage) #the number of stages
cat("main line 26: stageMax = ", stageMax,"\n")
#####################################################
## Input Parameters are assigned to the variables   #
#####################################################
dtprint = constPar.df$dtprint  #0.
tt = constPar.df$tt# 1270. #2270 -> leads to an error
exmin = constPar.df$exmin
exmax = constPar.df$exmax #6000
eymin = constPar.df$eymin#4000
eymax = constPar.df$eymax #9000
Rearth = constPar.df$Rearth #6370000 #SK

tm.step = 1.0 #0.25 # time step

###########################################
## Further initialization              ####
###########################################
print("main: line 44: stageMax=")
print(stageMax)
# burntime[1] = stage.df$burntime[1]
# if(stageMax > 1){
	# for (stage in 2:stageMax){
		# burntime[stage] = stage.df$burntime[stage] + burntime[stage - 1]
	# }#for (stage in 2:stageMax)
# }# if(stageMax > 1)



sol = 0 #placeholder
################################################
## Compute the mass and other parameters      ##
################################################
m0_tmp <-vector(mode = "numeric", length = stageMax + 1)
m0_tmp[stageMax + 1] = 0

for (stage in stageMax:1){
cat("stage.df$fuelmass[stage]=",stage.df$fuelmass[stage],"\n")
cat("stage.df$DryWeight[stage]=",stage.df$DryWeight[stage],"\n")
cat("m0_tmp[stage + 1]=",m0_tmp[stage + 1],"  stage = ",stage," \n")

 m0_tmp[stage] = stage.df$fuelmass[stage] + stage.df$DryWeight[stage] + m0_tmp[stage + 1]   #stage.df   constPar.df$payload
}#for (stage in 1:stageMax)
m0 = head( m0_tmp, -1) + constPar.df$payload # drop the last element (psudo stage) in vector mo_tmp and add payload to each stage
cat("main: line 62: m0= \n")
print(m0)

#for (stage in 1:stageMax){
# dmdt[1]=Fuelmass[1]/bt[1] 
# Mass of missile =payload+Dry weight[3]+Fuelmass[3]+Dry weight[2]+Fuelmass[2]+Dry weight[1]+dmdt[1]*t
#m0[stage] = fuelmass[stage] + 2050 + constPar.df$payload

# From time t<(t[1]+t[2]) but t>bt[1] then
# dmdt[2]=Fuelmass[2]/bt[2] 
# Mass of missile =payload+Dry weight[3]+Fuelmass[3]+Dry weight[2]+dmdt[2]*(t-t[1])
 
# From time t<(t[1]+t[2]+t[3]) but t>(t[1]+t[2])
# dmdt[3]=Fuelmass[3]/bt[3] 
# Mass of missile =payload+Dry weight[3]+dmdt[3]*(t-t[1]-t[2])


#}#end for (stage in 1:stageMax)

for (stage in 1:stageMax){
    cat("main:line 54: stage = ", stage, "\n")

	#fuelmass[stage] = 27230 * constPar.df$fra     #IN KG
	#fuelmass[stage] = 1 * constPar.df$fra     #IN KG
	#m0[stage] = fuelmass[stage] + 2050 + constPar.df$payload      #TOTAL STAGE MASS = fuelmass/fuelfraction	
	#m0[stage] = fuelmass[stage] + 0 + constPar.df$payload      #TOTAL STAGE MASS = fuelmass/fuelfraction
	Isp0[stage] =stage.df$Isp0[stage] #270.  #sea level value of specific impulse (SINCE I HAVE MULTIPLIED BY g=9.8,

	#THIS IS REALLY THE EXHAUST VELOCITY 
	burntime[stage] = stage.df$burntime[stage] #150. #in secs
	dmdt[stage] = stage.df$fuelmass[stage]/stage.df$burntime[stage]          #FUEL BURN RATE IN KG/S
	anozzle[stage]= stage.df$anozzle[stage]  # (0.23/2)^2*3.141592*4 + (0.85/2)^2*3.141592 #4 nodong clustered engines #Units of m2
	across[stage]= stage.df$across[stage]   #3.14*((1.65/2)^2) # assumed cross section
	eta_change = stage.df$eta_change[stage]
	###############################################################################
	## Need to single out stage 1 to use stage lags in the next sections         ##
	###############################################################################
	
	if(stage == 1){
	# tatburn - time when the stage has burned all its fuel, for stage=1, i.e. it is [0, tatburn[1]=burntime[1]]
		tatburn[stage] =  burntime[stage]
		
	    tMinAbsTime = stage.df$tMinRelTime[stage] # this is absolute time, i.e. relative to the launch time, to compare with tm
	    tMaxAbsTime = stage.df$tMaxRelTime[stage] # this is absolute time, i.e. relative to the launch time, to compare with tm
		
        if(stage == stageMax){
			tm = seq(from=0., max(tt,tatburn[stage] ), tm.step) 
		}else{
			tm = seq(from=0., burntime[stage], tm.step) 
		}#	if(stage == stageMax)
		
		state = c(y1 = 1.0, y2 = 0.1, y3 = pi/2, y4=0.)
		
	}else{	
		tatburn[stage] = tatburn[stage - 1] + burntime[stage]			

	    tMinAbsTime = tatburn[stage - 1]+ stage.df$tMinRelTime[stage] # this is absolute time, i.e. relative to the launch time, to compare with tm
	    tMaxAbsTime = tatburn[stage - 1]+ stage.df$tMaxRelTime[stage] # this is absolute time, i.e. relative to the launch time, to compare with tm

		
		if(stage == stageMax){
			tm = seq(from = (tatburn[stage - 1] + 1), to = max(tt,tatburn[stage] ), tm.step)
		}else{
			tm = seq(from = (tatburn[stage - 1] + 1), to = tatburn[stage], tm.step)
		}#if(stage == stageMax){	
    
	}#end if(stage == 1){
	
	
    cat("main:line 116: stage = ", stage, "\n")
	print("burntime[stage]=")
	print(burntime[stage])
	
	
    sol.ls.parms = list("Isp0" = Isp0[stage], "dmdt" = dmdt[stage], "anozzle" = anozzle[stage], "across" = across[stage], 
                     "m0" = m0[stage],"burntime" = burntime[stage],"tatburn"=tatburn, "payload=" = constPar.df$payload, 
					 "shroud"= constPar.df$shroud,  "Rearth=" = constPar.df$Rearth, "stage" = stage, "tMinAbsTime" = tMinAbsTime, 
					 "tMaxAbsTime" = tMaxAbsTime, "eta_change" = eta_change ) # add here "stage" = stage

	#########################################
	# Solve ode using deSolve               #
	#########################################

	###########################################################################################
	# The last time-moment condition to be used as the initial state for the next stage      ##
	###########################################################################################
    if(stage > 1){
		nrow.sol = nrow(sol)
		state.tmp = sol[nrow.sol,]
		state = state.tmp[2:5]
		
	}# end if(stage > 1)

	#################################
	### Solving the ode          ####
	#################################
	cat("main:line 138: stage = ", stage, "\n")
	print("sol.ls.parms=")
	print(sol.ls.parms)
	cat("main: line 143 tm = ")
	print(tm)
	
	cat("main: line 178: stage = ", stage, " tm = \n")
	print(tm)
	
    sol.tmp <- ode(y = state, times = tm, parms = sol.ls.parms, func = eqRG, method="euler")
	
	cat("main:line 171: stage = ", stage, "\n")
	print("main:line 172:  sol.tmp=")
	print(sol.tmp)
	################################################
	## Merge sol.tmp to the sol                #####
	################################################
	if(stage ==1){
		sol = sol.tmp
	}else{
		nrow.sol.tmp = nrow(sol.tmp) #assume the missile does not fall to the ground at this stage
		sol = rbind(sol, sol.tmp[2:nrow.sol.tmp ,]) # the first row in sol.tmp is used already as the last row in sol
	}#end if(stage ==1){
    
	
	cat("main:line 109: stage = ", stage, "\n")
    print("main: sol = ")
    print(sol)
}# end for (stage in 1:stageMax)

##########################
# if(stage == stageMax){
	     # tm = seq(from = (tatburn[stage - 1] + 1), to = tt, 1.)
		 # }#if(stage == stageMax){

############

####################################################################################
## Now all stages of the engine has been done and the missile moves by inertia   ###
####################################################################################

###############################################################################
## List of parameters and other variables for ode and solution of ode        ##
###############################################################################

#tm = seq(from=0., (burntime[stage]+1), 1.) 
     
   
################################################################
## Cut off the negative y1 elements at the end of the matrix  ##
################################################################

	
length.sol.nonNeg = which(sol[,2]<=0)[1] 

if(!is.na(length.sol.nonNeg)){
		cat("main: line 177 length.sol.nonNeg=",length.sol.nonNeg,"\n")
		#copy a part of sol to a new array, where sol has non-negative y1 except, perhaps, the last element 
		sol.y1.nonNeg = sol[1:length.sol.nonNeg,] 
}else{
		sol.y1.nonNeg = sol
		length.sol.nonNeg = nrow(sol)
}# end if(!is.na(length.sol.nonNeg))

dimnames(sol.y1.nonNeg) = list(list(), list("time","y1","y2","y3","y4"))
 
print("main: line 174: sol.y1.nonNeg=")
print(sol.y1.nonNeg)
###########################################
### Plot the solution of ode             ##
###########################################
#strDateTime - is defined in GlobalManager.r
strRtitle.tmp2=gsub(":","",paste(substring(strDateTime, 1, nchar(strDateTime)-3),"pdf",sep="."))
RplotTitle =  paste("Rplot",strRtitle.tmp2,sep="")
pdf(RplotTitle )

par(mfrow=c(2,2))
plot(sol.y1.nonNeg[,1],sol.y1.nonNeg[,2]/1000, type = "l", xlab="time index", ylab="Altitude [km]") #sol.y1.nonNeg[,1] is time index of sol
plot(sol.y1.nonNeg[,1],sol.y1.nonNeg[,3]/1000, type = "l", xlab="time index", ylab="Speed [km/sec]")
plot(sol.y1.nonNeg[,1],sol.y1.nonNeg[,4], type = "l", xlab="time index", ylab="/gamma [radian]")
plot(sol.y1.nonNeg[,1],sol.y1.nonNeg[,5], type = "l", xlab="time index", ylab="?Range ?")

par(mfrow=c(1,1))
plot(sol.y1.nonNeg[,5]*Rearth/1000, sol.y1.nonNeg[,2]/1000, , type = "l", xlab="range [km]", ylab="Altitude [km]")
par(mfrow=c(1,1))
plot(sol.y1.nonNeg[,5]*Rearth/1000, sol.y1.nonNeg[,3]/1000, , type = "l", xlab="range [km]", ylab="Speed [km/sec]")
##################################################
## Save the numerical solutions of ode system    #
##################################################
setwd("C:/Users/feren/Dropbox/OLD/PROJECTS-FUNDED/missiles/MissleModel/feb10/new5/new5")
write.table(sol.y1.nonNeg, "sol-test", sep = "\t")  # Save as tab delimited 
write.csv(sol.y1.nonNeg,"sol-test.csv")  # or as csv 


##############################################
## Test and plot the output               ####
##############################################
nameSolTest = "sol-test.csv"
nameTableBurnout = "bodata.dat"
tt.sol.y1.nonNeg = length.sol.nonNeg

ftest_plot(nameSolTest, tt.sol.y1.nonNeg, nameTableBurnout, constPar.df,stage.df )

dev.off() #end of output to .pdf
options(warn = oldw)