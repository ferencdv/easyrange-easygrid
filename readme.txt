#To run:
# 1. assume your R.exe is located at "C:\Program Files\R\R-3.1.1\bin\x64\R.exe"
# if not, then change  in the following line the directory (in " ") accordingly.
# 2. Open the window prompt (cmd) in the folder where GlobalManager.r is located
# 3. In the windows prompt (cmd) enter:
# "C:\Program Files\R\R-3.1.1\bin\x64\R.exe" CMD BATCH --vanilla --slave GlobalManager.r


# How to run the *GlobalManager.R* code

> cd C:\Users\feren\Dropbox\OLD\PROJECTS-FUNDED\missiles\MissleModel\feb10\new5\new5
> 
> "C:\Program Files\R\R-4.1.0\bin\R.exe" CMD BATCH --vanilla --slave GlobalManager.r

# How to run the *GridManager.R* code

Note that the *TargetCharacteristics* are the test results we want to reproduce in the simulation.

## How to find the best Eta to fit the test results.

- Go to input parameters sheet
- Go to SelectedVariables sheet and add ete_change as a variable. This is what we plan to change.
- Modify default variable *eta_change* in *MC_stageParam_Mean* sheet and in the the *MC_stageParam_StDev* sheet.
- Now run the line: "C:\Program Files\R\R-3.6.0\bin\R.exe" CMD BATCH --vanilla --slave GlobalManagerGrid.r
- Which ever *eta_change* was found is now entered into the *StageParam* sheet. This is the default result to reproduce the test results.

## How to find the best input parameters to fit the test results.

- Go to input paramaters sheet
- Go to GeneralParamaters sheet and modify time steps and nstep=n. This means that there are n+1 values. Where n/2 = $\sigma$ the dispersion.
- Go to SelectedVarables sheet and enter the variable names in StageParam. Let the number of parameters to vary be N. Then remember that the number of runs = (n+1)*N!

# How to run the *findMaxRange.R* code

- Now that we have found a set of parameters that satisfy the test results, accept ones which are in the periphery which satisfy the test results within say 10%.
- Modify the InputParameters spreadsheet so that the expected input paramaters are used.
- Run the *findMaxRange.R to determine the maximum range with the line: "C:\Program Files\R\R-3.4.3\bin\R.exe" CMD BATCH --vanilla --slave findMaxRange.r

# 3/5/2018

## Units

| Variable | Units | Description | Source |
| --- | --- | --- | --- |
| exmin | km  | plot range | Sheet |
| exmax | km  | plot range | Sheet |
| eymin | km  | plot range | Sheet |
| eymax | km  | plot range | Sheet |
| Rearth | m   | Radius | Sheet |
| dtprint | ?   | ?   | Sheet |
| tm.step | sec | Integration Step | Main.r |
| fuelmass[stage] | kg  | Fuel Mass | Sheet |
| dryweight[stage] | kg  | Dry Weight | Sheet |
| m0_tmp[stage+1] | ?   | not sure how computed | Main.r |
| Isp0[stage] | sec | Specific Impulse | Sheet |
| burntime[stage] | sec | Burn Time | Sheet |
| dmdt[stage] | kg/sec | `{.katex}{dM \over dt}` | Main.r |
| anozzle[stage] | `{.katex} m^2` | Area of Nozzle | Sheet |
| across[stage] | `{.katex} m^2` | Cross-sectional Area of the missile stage | Sheet |
| eta | deg | Lateral Thrust | Sheet |
| tMinRelTime | sec | Relative time wrt start of burn that lateral thrusters turned on | Sheet |
| tMaxRelTime | sec | Relative time wrt start of burn that lateral thrusters turned off | Sheet |

# Missile Data

id: b4ed07e4285e409fa09f82062b7e79ce
parent_id: e064d3a2abaf4c76b686f0bc7086eb94
created_time: 2018-03-06T08:05:03.337Z
updated_time: 2019-11-10T21:17:03.436Z
is_conflict: 0
latitude: 36.62490000
longitude: -121.82570000
altitude: 0.0000
author:
source_url:
is_todo: 0
todo_due: 0
todo_completed: 0
source: joplin-desktop
source_application: net.cozic.joplin-desktop
application_data:
order: 0
user_created_time: 2018-03-06T08:05:03.337Z
user_updated_time: 2019-11-10T21:17:03.436Z
encryption_cipher_text:
encryption_applied: 0
type_: 1
