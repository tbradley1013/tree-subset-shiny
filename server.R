#============================================================================
# This is the server code for the tree subset app
#
# Tyler Bradley
#============================================================================

shinyServer(
  function(input, output, session){
    session$onSessionEnded(stopApp)
    
    # reactive values are used to reset the file input when the 
    # file type is changed. This is done to prevent errors from
    # popping up before a new file can be uploaded.
    rv <- reactiveValues(
      data = NULL,
      clear = FALSE
    )
    
    observeEvent(input$upload_tree, {
      rv$clear <- FALSE
    }, priority = 1000)
    
    observeEvent(input$file_type, {
      rv$data <- NULL
      rv$clear <- TRUE
      reset('upload_tree')
    }, priority = 1000)
    
    # This reactive value reads in the tree object using one of the
    # treeio import functions. If the function called, based on input$file_type
    # fails, NULL is returned
    tree <- reactive({
      req(input$upload_tree, input$file_type,
          input$upload_tree, !rv$clear)
      
      file <- input$upload_tree$datapath
      
      output <- switch(
        input$file_type,
        tree = possibly(read.tree, otherwise = NULL)(file),
        beast = possibly(read.beast, otherwise = NULL)(file),
        # codeml = possibly(read.beast, otherwise = NULL)(file),
        mlc = possibly(read.codeml_mlc, otherwise = NULL)(file),
        # hyphy = possibly(read.hyphy, otherwise = NULL)(file),
        jplace = possibly(read.jplace, otherwise = NULL)(file),
        mrbayes = possibly(read.mrbayes, otherwise = NULL)(file),
        nhx = possibly(read.nhx, otherwise = NULL)(file),
        rst = possibly(read.paml_rst, otherwise = NULL)(file),
        phylip = possibly(read.phylip, otherwise = NULL)(file),
        r8s = possibly(read.r8s, otherwise = NULL)(file),
        raxml = possibly(read.raxml, otherwise = NULL)(file)
        
      )
      
      # read.tree(input$upload_tree$datapath)
      
      return(output)
    })
    
    
    # This tree_df function 
    tree_df <- reactive({
      req(tree())
      output <- tree() %>% 
        as_data_frame()
    })
    
    observe({
      req(input$upload_tree)
      
      if (is.null(tree())) {
        shinyalert("Tree import error", paste("There was an error when trying to read your tree!",
                                              "Did you select the correct file format?"),
                   type = "error")
      }
    })
    
    
    # Rendering the ui elements to select the node to subset, 
    # how far back to subset, and tree options (text size, height, width)
    output$select_node_render <- renderUI({
      req(input$upload_tree, tree())
      output <- tagList(
        fluidRow(
          column(
            12,
            selectizeInput(
              inputId = "select_node",
              label = "Select Node:",
              choices = tree_df() %>% 
                select(label) %>% 
                arrange(label) %>% 
                pull(label),
              width = "100%"
            )
          )
        ),
        fluidRow(
          column(
            3, 
            numericInput(
              inputId = "subtree_levels_back",
              label = "Select Number of Levels:",
              min = 1,
              value = 5
            )
          ), 
          column(
            3,
            numericInput(
              inputId = "subtree_text_size",
              label = "Select label text size:",
              min = 2,
              value = 3
            )
          ),
          column(
            3,
            numericInput(
              inputId = "subtree_plot_height",
              label = "Select plot height",
              value = 1200
            )
          ),
          column(
            3, 
            numericInput(
              inputId = "subtree_width_multiply",
              label = "Select plot width multiplier:",
              value = 1.4,
              min = 1,
              step = 0.1
            )
          )
        )
        
        
      )
      

      return(output)
    })

    # creating the subtree
    output$subtree <- renderPlot({
      req(input$select_node, tree(), 
          input$subtree_width_multiply, 
          input$subtree_text_size,
          input$subtree_plot_height)

      # getting the subtree phylo or treedata object
      sub_tree <- tree_subset(tree(), node = input$select_node,
                  levels_back = input$subtree_levels_back)
      
      # extracting the tip labels from the sub tree
      if (isS4(sub_tree)) {
        labels <- sub_tree@phylo$tip.label
      } else {
        labels <- sub_tree$tip.label
      }
      
      # doing some basic manipulation on labels 
      # this will only really work for labels of the format
      # ;k__;p__;c__;o__;f__;g__;s__
      labels_df <- tibble(
        label = labels,
        genus = str_extract(label, "[^;]+;[^;]+$") %>% str_replace(";[^;]+$", ""),
        species = str_extract(label, "[^;]+$")
      )  %>% 
        mutate(
          species = if_else(is.na(genus), "", str_replace(species, "s__", "")),
          genus = if_else(is.na(genus), label, str_replace(genus, "g__", ""))
        )
      
      # creating the plot
      p <- sub_tree %>% 
        ggtree(aes(color = group))  %<+% labels_df +
        geom_tiplab(aes(label = paste(genus, species)), 
                    size = input$subtree_text_size) +
        theme_tree2() +
        scale_color_manual(values = c(`1` = "red", `0` = "black"))
      
      p + lims(x = c(0, max(p$data$x) * input$subtree_width_multiply))
    })

    # creating the ui element for the subtree 
    output$subtree_render <- renderUI({
      req(input$subtree_plot_height, tree())
      plotOutput("subtree", height = input$subtree_plot_height)
    })
    
    
  }
)