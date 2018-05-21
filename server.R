#============================================================================
# This is the server code for the tree subset app
#
# Tyler Bradley
#============================================================================

shinyServer(
  function(input, output, session){
    session$onSessionEnded(stopApp)
    
    # output$file_info <- renderText({
    #   output <- paste0("File Name: ", input$upload_tree$name, 
    #                    "<br>File Size: ", input$upload_tree$size,
    #                    "<br>File Type: ", input$upload_tree$type,
    #                    "<br>File Path: ", input$upload_tree$datapath)
    # })
    # 
    # output$tree_tbl <- renderTable({
    #   req(input$upload_tree)
    #   
    #   read.tree(input$upload_tree$datapath) %>% 
    #     as_data_frame()
    # })
    
    tree <- reactive({
      req(input$upload_tree)
      output <- read.tree(input$upload_tree$datapath)
      
      return(output)
    })
    
    tree_df <- reactive({
      output <- tree() %>% 
        as_data_frame()
    })
    
    
    
    output$select_node_render <- renderUI({
      req(input$upload_tree)
      output <- tagList(
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
      

      return(output)
    })

    output$subtree <- renderPlot({
      req(input$select_node)

      sub_tree <- tree_subset(tree(), node = input$select_node,
                  levels_back = input$subtree_levels_back)
      
      labels_df <- tibble(
        label = sub_tree$tip.label,
        genus = str_extract(label, "[^;]+;[^;]+$") %>% str_replace(";[^;]+$", ""),
        species = str_extract(label, "[^;]+$")
      )  %>% 
        mutate(genus = if_else(is.na(genus), label, str_replace(genus, "g__", "")),
               species = if_else(str_detect(species, "Algae\\.bin"), "", str_replace(species, "s__", "")))
      
      p <- sub_tree %>% 
        ggtree(aes(color = group))  %<+% labels_df +
        geom_tiplab(aes(label = paste(genus, species)), 
                    size = input$subtree_text_size) +
        theme_tree2() +
        scale_color_manual(values = c(`1` = "red", `0` = "black"))
      
      p + lims(x = c(0, max(p$data$x) * 1.4))
    })

    output$subtree_render <- renderUI({
      plotOutput("subtree", height = input$subtree_plot_height)
    })
    
    
  }
)