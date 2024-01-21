server <- function(input, output, session) {
    
  EBP_CONFIG_ANALYTICS <- get_config_obj(config_path='config/Analytics.yml')
  EBP_CONFIG_DATASETS <- get_config_obj(config_path='config/Datasets.yml')
  EBP_CONFIG_MEMOS <- get_config_obj(config_path='config/Memos.yml')
  
  EBP_ANALYTIC <- reactiveVal(NULL)
  EBP_ANALYTIC_NAME <- reactiveVal("")

  observe({
    updateSelectInput(
        session,
        'analytic_selected',
        choices=get_analytics(EBP_CONFIG_ANALYTICS)
    )
  })
  
  observeEvent(
    ignoreNULL=TRUE,
    ignoreInit=TRUE,
    eventExpr = { input$analytic_selected },
    handlerExpr = {
      
      temp_config <- get_config_attribute(
        config_obj=EBP_CONFIG_ANALYTICS,
        attribute=input$analytic_selected
      ) |> 
        update_config(type='memos', type_config=EBP_CONFIG_MEMOS)
      
      output$text_analytic_name <- renderText({
        input$analytic_selected
      })
      
      output$text_analytic_description <- renderUI({
        p(
          get_config_attribute(temp_config, 'description'),
          style='text-align: justify'
        )
      })
      
      output$analytic_details_ui <- renderUI({
        render_analytic_details("TempConfig")
      })
      module_analytic_details("TempConfig", analytic_obj=temp_config)
      
      if (EBP_ANALYTIC_NAME() != '') {
        if (EBP_ANALYTIC_NAME() != input$analytic_selected) {
          shiny::showNotification("Selected analytic does not match rendered analytic", type="warning")
        }
      }
      
    }
  )

  observeEvent(
      ignoreNULL=TRUE,
      ignoreInit=TRUE,
      eventExpr = { input$analytic_confirmed },
      handlerExpr = {
        
        RENDER_CONTENT <- reactiveVal(FALSE)
        
        if (EBP_ANALYTIC_NAME() != input$analytic_selected) {
          RENDER_CONTENT(TRUE)
          EBP_ANALYTIC(
            get_config_attribute(
              config_obj=EBP_CONFIG_ANALYTICS,
              attribute=input$analytic_selected
            ) |> 
              update_config(type='datasets', type_config=EBP_CONFIG_DATASETS) |> 
              update_config(type='memos', type_config=EBP_CONFIG_MEMOS)
          )
          EBP_ANALYTIC_NAME(input$analytic_selected)
        }
        
        if (RENDER_CONTENT()) {
          output$text_analytic_name <- renderText({
            EBP_ANALYTIC_NAME()
          })
          
          output$text_analytic_description <- renderUI({
            p(
              get_config_attribute(EBP_ANALYTIC(), 'description'),
              style='text-align: justify'
            )
          })
          
          output$analytic_details_ui <- renderUI({
            render_analytic_details("Analytic")
          })
          module_analytic_details("Analytic", analytic_obj=EBP_ANALYTIC())
          
          output$display_data_request_form_ui <- renderUI({
            render_display_data(
              "DataRequestForm",
              info="Each analytic has a Data Request Form (DRF), a file that specifies important analytic-related material and field mappings for the raw data."
            )
          })
          module_display_data(
            "DataRequestForm",
            analytic_obj=EBP_ANALYTIC()
          )
          
          output$display_analytic_data_ui <- renderUI({
            render_display_data(
              "AnalyticData",
              info="This panel allows you to interact with the data provided for the analytic. Ensure the data looks as expected."
            )
          })
          module_display_data(
            "AnalyticData",
            analytic_obj=EBP_ANALYTIC()
          )
          
          output$display_procedures_ui <- renderUI({
            render_display_procedures("Output")
          })
          module_display_procedures("Output", analytic_obj = EBP_ANALYTIC())
          
        }

      }
  )
}
