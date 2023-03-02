#written by Ferenc
#edited by Serguey K.
#Created: December 1, 2017
#Last updated:  December 15, 2017

#Purpose:
#This program solves a system of ode
#This file only reads the files with the functions and data
#The main structure of the code is located in the file main/main.r

#To run:
# 1. assume your R.exe is located at "C:\Program Files\R\R-3.1.1\bin\x64\R.exe"
# if not then change  in the following line the directory (in " ") accordingly.
# 2. In the windows prompt (cmd) enter:
# "C:\Program Files\R\R-3.1.1\bin\x64\R.exe" CMD BATCH --vanilla --slave GlobalManager.r
#######################################
#Program starts here

#Clean up objects
rm(list = ls())

#Loading libraries
library(deSolve) # to solve ode
require(xlsx) #to load .xls files with input parameters

library(readr)

#get warnings
oldw <- getOption("warn")
options(warn = -1)

############################################################
#Redirect sinked output to file SinkedOutput.txt     ###
############################################################
strDateTime = format(Sys.time(), "%Y%b%d%X")
strDateTime.txt = gsub(":","",paste(substring(strDateTime, 1, nchar(strDateTime)-3),"txt",sep="."))
strSinkedOutput = paste("SinkedOutput",strDateTime.txt,sep="")
#sink(file="SinkedOutput.txt")
sink(file = strSinkedOutput)

#sink(file="SinkedOutput.txt")

cat("===========================================================================","\n",sep="")
cat("Date/time when the program started: ",format(Sys.time(),"%B %d, %Y, %X"),"\n",sep="")
cat("===========================================================================","\n",sep="")

############################################################################################################
#Set up Global_rootpath: it indicates the directory relative to which all other directories are located   ##
############################################################################################################
Global_rootpath = getwd()
cat("===========================================================================","\n",sep="")
cat("Global_rootpath=",Global_rootpath,"\n")
cat("===========================================================================","\n",sep="")
###################################
#####    Paths to the files     ###
###################################
path_source_main=file.path(Global_rootpath,'code','main')
path_data_InputParameters = file.path(Global_rootpath,'code','inputparameters')

path_source_functions = file.path(Global_rootpath,'code','functions')
	path_source_standard_atmosphere = file.path(path_source_functions,'standard_atmosphere') 
    path_source_t_h = file.path(path_source_functions,'t_h')
    path_source_m_t	= file.path(path_source_functions,'m_t')
	path_source_eqRG = file.path(path_source_functions ,'eqrg')
	path_source_ftest_plot = file.path(path_source_functions , 'ftest_plot')
#C:\Users\SK\Documents\oDesk\Ferec\code\new1\code\functions\ftest_plot\ftest_plot.r
	

################################
###  Names of the files     ####
################################
code_source_main = 'main.r'
code_source_functions = 'functions.r'
	code_source_standard_atmosphere = 'standard_atmosphere.r'
	code_source_t_h = 't_h.r'
	code_source_M_t = 'M_t.r'
	code_source_eqRG = 'eqRG.r'
	code_source_ftest_plot = 'ftest_plot.r'



#######################################################
##### Input of parameters using an Excel file       ###
#######################################################
code_source_InputParameters = 'InputParam1.xlsx'
# file_input_parameters
##########################################
###  All together to load files        ###
##########################################
file_source_functions = file.path( path_source_functions, code_source_functions, sep = "")
  file_source_standard_atmosphere = file.path( path_source_standard_atmosphere,code_source_standard_atmosphere, sep = "")
  file_source_t_h = file.path( path_source_t_h,code_source_t_h, sep = "")
  file_source_M_t = file.path(path_source_m_t,code_source_M_t, sep = "" )
  file_source_eqRG = file.path(path_source_eqRG ,code_source_eqRG)
  file_source_ftest_plot = file.path( path_source_ftest_plot ,code_source_ftest_plot)
  
file_source_main = file.path(path_source_main,code_source_main,sep = "" )
file_input_parameters =  file.path(path_data_InputParameters, code_source_InputParameters, sep = "" )

#cat("===========================================================================","\n",sep="")
#cat("file_source_functions =",file_source_functions,"\n")
#cat("file_source_main =",file_source_main,"\n")
#cat("file_input_parameters  =",file_input_parameters ,"\n")
#cat("file_source_standard_atmosphere=",file_source_standard_atmosphere,"\n")
#cat("===========================================================================","\n",sep="")

#############################################################
#############################################################
## Loading and running the function codes                ####
#############################################################
#############################################################

source(file_source_functions)
source(file_source_standard_atmosphere)
source(file_source_t_h)
source(file_source_M_t)
source(file_source_eqRG)
source(file_source_ftest_plot)
##############################################
# The file main does all further work       ##
##############################################
source(file_source_main)


#Produce message regarding current time
cat("===========================================================================","\n",sep="")
cat("Date/time when this record was printed out: ",format(Sys.time(),"%B %d, %Y, %X"),"\n",sep="")
cat("===========================================================================","\n","\n",sep="")

cat("Ending program","\n",sep="")


sink()


