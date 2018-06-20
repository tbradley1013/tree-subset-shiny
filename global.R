#===============================================================================
# This is the global.R script for the subset tree shiny app
#
# Tyler Bradley
#===============================================================================

if (!"treeio" %in% installed.packages()) {
  if (!"devtools" %in% installed.packages()) install.packages("devtools")
  devtools::install_github("GuangchuangYu/treeio")
} else if (packageVersion("treeio") < "1.5.1.2") {
  if (!"devtools" %in% installed.packages()) install.packages("devtools")
  devtools::install_github("GuangchuangYu/treeio")
}

if (!"purrr" %in% installed.packages()) install.packages("purrr")


purrr::walk(c("shiny", "shinyjs", "tidyverse", 
              "ggtree", "tidytree", "shinyalert"), ~{
  if (!.x %in% installed.packages()) install.packages(.x)
})
  

suppressWarnings({
  suppressPackageStartupMessages({
    library(shiny)
    library(shinyjs)
    library(tidyverse)
    library(ggtree)
    library(tidytree)
    library(treeio)
    library(shinyalert)
  })
})



