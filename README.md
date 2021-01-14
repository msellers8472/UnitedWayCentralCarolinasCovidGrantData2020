# UnitedWayCentralCarolinasCovidGrantData2020
The R Shiny app showing the distribution of Covid-19 grant money in Mecklenburg County in 2020. 

Hi! Welcome to my Shiny app.

First- a few things to know. Before you use this app, you need to have R and RStudio installed. 
These are both free and open-source.

Second. Line 66 of the file CovidApp.R tells the app where to find the file containing the grant 
data, FundAwardsNoArts.xlsx. In order for the app to work on your computer, you need to change the 
file path to wherever FundAwardNoArts.xlsx is stored on your computer. 

In the original code, the line is 

fund_data_meck <- read_excel("~/Documents/COVID Fund Map Folder//CovidGrantDistributions/FundAwardsNoArts.xlsx").

For the app to work on your computer, you need to change the line to 
fund_data_meck <- read_excel("file path on your computer.")

You place the filepath of FundAwardsNoArts.xlsx on your computer between the quotation marks. 

To get the filepath, click the FILES tab in RStudio. (Check Screenshot 1 to see where this is.)

The FILES tab basically acts like the file explorer utility on your computer. It will allow you to 
access files in R.

Navigate to the folder where you keep FundAwardsNoArts.xlsx in the FILES tab, just as you would in
the file explorer utility on your computer. Open this folder.

Click on FundAwardsNoArts.xlsx. You will have the option to either view the file or import the dataset.
Check Screenshot 2 for what you should see on your screen.

Click Import Dataset. In the File/URL window at the top of the window that appears, you will see the  
filepath. (Check Screenshot 3 to see where this is.)

Copy the filepath. Then, paste it between the quotation marks in Line 66 of CovidApp.R and 
save the file.

To run the app, click the RUN APP button in RStudio. (Check Screenshot 4 to see where this is.)
