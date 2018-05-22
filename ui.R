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
      uiOutput("select_node_render"),
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