# Tree Subset Shiny
This repository contains the code for a shiny app that allows for the visualization of subset phylogentic trees. This feature is useful as some phylogentic trees can be very hard to inspect as a whole, especially when there are extremely large number of nodes. This app uses a function named `tree_subset` (currently in development to be added to the `treeio` package). This app allows for tree objects to be uploaded to the app and then for different tips to be selected to view the phylogentic relatives of that tip. 


Currently, this application is not being hosted anywhere, so to use it you will need to clone this repo and run the application locally. This intro assumes that you have R, RStudio, and git installed on your computer. If you do not please see [here](http://stat545.com/block000_r-rstudio-install.html) for R and RStudio and [here](http://happygitwithr.com/) for git. 

To get this app up and running locally, follow these steps:

  1. Open a new session of RStudio and click the light blue cube with the green plus sign in the top left corner of the window. 
  2. Select Version Control in the pop up window and then select Git on the next screen. 
  3. Copy and paste the url from this repos home page into the top box and select where on your computer you would like the contents of this repo to be saved. The resulting folder will likely be named `tree-subset-shiny` by default, but if not, it is recommneded you name it that.
  4. Select Create Project. This will clone the entire repo into a folder of your choice (see #4).
  5. Open either the `ui.R`, `server.R`, or `global.R` file. 
  6. No matter which of these files you open, you should see a button in the top right portion of the Source pane that says "Run App". Click this button!
  7. A pop-up window will appear. You can either view the app in this window or in the web browser by clicking the "Open in Browser" button in the top left of the pop-up window. Personally, I prefer to view it in the browser. 
  8. Now, you should be off and running! Select a `.tree` file on your computer and subset away!
  
  
  
  

