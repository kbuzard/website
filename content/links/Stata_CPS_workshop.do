*Reference for Stata Also try google stata tutorial
*https://www.princeton.edu/~otorres/StataTutorial.pdf

*Clean
clear

*Close 
capture log close

*Create a log file
log using IntroClass.log, replace

*This is where my data file is located
*Use quotes if the new directory has blank spaces, for example
*cd “h:\stata and data”
cd "The folder where you put the datase"

*Import data
use "CPS_2017.dta", clear

*If in Excel or text format, use insheet command :
*insheet using "C:\Users\jorge\Desktop\STATA\CPS_2017.cvs"
*insheet using "C:\Users\jorge\Desktop\STATA\CPS_2017.txt" 

*Describe the data
describe


*Descriptive statistics
summarize
sum age, detail

*Frequencies
tabulate age
tabulate age, plot // to get a bar chart with the %

*Correlations
corr earn hours

*Visualize the earnings-hours correlation
scatter earn hours
scatter earn hours,title("Earnings vs hours worked") xlabel(0(10)100) ylabel(0(500)3500) msymbol(o)
gr7 earn hours

*Add indicator for female (dfemale=1) to correlation output
corr earn hours dfemale 
corr earn hours wage dfemale 

*Use histogram to see how the earnings data is distributed
histogram earn

* is earnings variable "top coded"?
sort earn
* open data viewer: we see the smallest values for "earn" at the top
* we can scroll to the bottom to see the highest values of "earn"
* OR use gsort to sort "earn" descending (high values at top)
gsort -earn

histogram earn, kdensity
* overlay normal density
histogram earn, normal kdensity kdenopts(lc(red))


*check earning by gender
histogram earn, by(dfemale) 

*Label our variable so we can clearly see what 0 and 1 mean
*There's no output from the "label" commands. We see the impact when we re-run the histogram command
label define dfemale 1 "Female" 0 "Male"
label values dfemale dfemale
histogram earn, by(dfemale) 

histogram earn, kdensity by(dfemale) 

*Create a variable for the number of children
gen children = dch02+ dch35+ dch613
*Look to see how many people have children in the three age categories
tabulate children

*Create a dummy variable that is 1 if someone has any child; 0 otherwise
gen dchild = 0
replace dchild = 1 if children > 0
tabulate dchild

*Label the variable
label define dchild 1 "Children" 0 "No Children"
label values dchild dchild

*Check the wages by gender, then by whether they have a child
histogram wage, by(dfemale) xlabel(0(20)100)
histogram wage if dfemale==1, by(dchild, title ("Female")) xlabel(0(20)90) ylabel(0(0.02)0.07) saving("female1.gph", replace)
histogram wage if dfemale==0, by(dchild, title ("Male")) xlabel(0(20)90) ylabel(0(0.02)0.07) saving("male1.gph", replace)

*The "saving" option on the last two histograms lets us see both graphs at once
*The "xlabel" and "ylabel" commands let us choose the label spacing so both graphs have the same scale
graph combine female1.gph male1.gph


*Check the hours worked by gender, then by whether they have a child
histogram hours, by(dfemale) 
histogram hours if dfemale==1, by(dchild, title ("Female")) xlabel(0(20)90) ylabel(0(0.05)0.25) saving("femaleh.gph", replace)
histogram hours if dfemale==0, by(dchild, title ("Male")) xlabel(0(20)90) ylabel(0(0.05)0.25) saving("maleh.gph", replace)

graph combine femaleh.gph maleh.gph

*Does education level play a role?
corr educ wage dchild

*Basic Regression
regress lnwage lnhours educ dnevmar dcitizen dmetro dfemale dchild


close log
