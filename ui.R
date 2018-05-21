#==============================================================================
# This is the ui code for the tree subset shiny app
#
# Tyler Bradley
#==============================================================================

shinyUI(
  navbarPage(
    title = "Binning Functionality",
    tabPanel(
      title = "Explore Tree",
      fluidRow(
        class = "inputs",
        column(
          6,
          fileInput(
            inputId = "upload_tree",
            label = "Select Tree File:"
          )
        )
      ),
      fluidRow(
        column(
          12,
          uiOutput("select_node_render")
        )
      ),
      fluidRow(
        column(
          4, 
          numericInput(
            inputId = "subtree_levels_back",
            label = "Select Number of Levels:",
            min = 1,
            value = 5
          )
        ), 
        column(
          4,
          numericInput(
            inputId = "subtree_text_size",
            label = "Select label text size:",
            min = 2,
            value = 3
          )
        ),
        column(
          4,
          numericInput(
            inputId = "subtree_plot_height",
            label = "Select plot height",
            value = 1200
          )
        )
        
      ),
      fluidRow(
        uiOutput(
          "subtree_render"
        )
        # textOutput("file_info"),
        # br(),
        # tableOutput("tree_tbl")
      )
    )
  )
)