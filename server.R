#============================================================================
# This is the server code for the tree subset app
#
# Tyler Bradley
#============================================================================

shinyServer(
  function(input, output, session){
    session$onSessionEnded(stopApp)
    
    
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
      
      p + lims(x = c(0, max(p$data$x) * subtree_width_multiply))
    })

    output$subtree_render <- renderUI({
      plotOutput("subtree", height = input$subtree_plot_height)
    })
    
    
  }
)