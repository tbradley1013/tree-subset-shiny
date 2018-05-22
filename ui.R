#==============================================================================
# This is the ui code for the tree subset shiny app
#
# Tyler Bradley
#==============================================================================

shinyUI(
  tagList(
    useShinyalert(),
    useShinyjs(),
    navbarPage(
      title = "Binning Functionality",
      tabPanel(
        title = "Explore Tree",
        fluidRow(
          class = "inputs",
          column(
            6, 
            selectInput(
              inputId = "file_type",
              label = "Select Tree File Type:",
              choices = c(
                "Tree" = "tree",  
                "Beast" = "beast",  
                # "CodeML" = "codeml",
                "CodeML mlc" = "mlc", 
                # "HYPHY" = "hyphy", 
                "jplace" = "jplace", 
                "MrBayes" = "mrbayes", 
                "NHX" = "nhx", 
                "rst (CODEML/BASEML)" = "rst", 
                "phylip" = "phylip", 
                "r8s" = "r8s",
                "RAxML" = "raxml"
              ),
              selected = "tree"
            )
          ),
          column(
            6,
            fileInput(
              inputId = "upload_tree",
              label = "Select Tree File:"
            )
          )
        ),
        uiOutput("select_node_render"),
        fluidRow(
          uiOutput(
            "subtree_render"
          )
        )
      )
    ) 
  )
)