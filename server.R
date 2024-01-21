# Server is responsible for handling all logic surrounding user requests
#
# Given use of modules, server should be seen as a conductor, orchestrating
# events based on the outputs of related events.

server <- function(input, output, session) {
    
  # create Configuration Objects
  EBP_CONFIG_ANALYTICS <- get_config_obj(config_path='config/Analytics.yml')
  EBP_CONFIG_DATASETS <- get_config_obj(config_path='config/Datasets.yml')
  EBP_CONFIG_MEMOS <- get_config_obj(config_path='config/Memos.yml')
  
  # instantiate Analytic values
  EBP_ANALYTIC <- reactiveVal(NULL)
  EBP_ANALYTIC_NAME <- reactiveVal("")

  # update EBP Analytic options with analytics in EBP_CONFIG_ANALYTICS
  observe({
    updateSelectInput(
        session,
        'analytic_selected',
        choices=get_analytics(EBP_CONFIG_ANALYTICS)
    )
  })
  
  # handle user selecting - but not yet confirming - analytic from dropdown
  observeEvent(
    ignoreNULL=TRUE,
    ignoreInit=TRUE,
    eventExpr = { input$analytic_selected },
    handlerExpr = {
      
      # store value in Temporary Configuration Object; this will be used to
      # check if the rendered - if rendered - Configuration Object is different
      # than the one in the dropdown, prompting the user with a warning that the
      # on-screen content is not consistent with the current dropdown option
      temp_config <- get_config_attribute(
        config_obj=EBP_CONFIG_ANALYTICS,
        attribute=input$analytic_selected
      ) |> 
        update_config(type='memos', type_config=EBP_CONFIG_MEMOS)
      
      # this invokes the analytic header (content above page's navbar) to render
      # such that users can toggle between analytics freely to learn about their
      # information without having to commit to rendering the rest of the page
      #
      # TODO: maybe update such that this only changes the first time?
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
      
      # after the user has confirmed their analytic (observed in other chunk) we
      # then track when the confirmed analytic differs from the analytic
      # currently selected in the dropdown; if they differ, warn the user that
      # there is a difference
      if (EBP_ANALYTIC_NAME() != '') {
        if (EBP_ANALYTIC_NAME() != input$analytic_selected) {
          shiny::showNotification(
            "Selected analytic does not match rendered analytic",
            type="warning"
          )
        }
      }
      
    }
  )

  # handler for user confirming analytic selection from dropdown
  observeEvent(
      ignoreNULL=TRUE,
      ignoreInit=TRUE,
      eventExpr = { input$analytic_confirmed },
      handlerExpr = {
        
        RENDER_CONTENT <- reactiveVal(FALSE)
        
        # do not render content again if analytic name has not changed
        #
        # TODO: maybe include reset button for users who want to work with
        # new instance of same analytic?
        # >>>>> no user can just restart shiny application
        if (EBP_ANALYTIC_NAME() != input$analytic_selected) {
          
          RENDER_CONTENT(TRUE)
          
          # subset Analytics Configuration Object based on selected analytic
          # then update YAML attributes with their respective configurations
          EBP_ANALYTIC(
            get_config_attribute(
              config_obj=EBP_CONFIG_ANALYTICS,
              attribute=input$analytic_selected
            ) |> 
              update_config(type='datasets', type_config=EBP_CONFIG_DATASETS) |> 
              update_config(type='memos', type_config=EBP_CONFIG_MEMOS)
          )
          
          # update analytic name for convenient referencing later on
          EBP_ANALYTIC_NAME(input$analytic_selected)
          
        }
        
        if (RENDER_CONTENT()) {
          
          # render contents for Analytic Header section
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
          
          # render contents for Data Request Form section
          output$display_data_request_form_ui <- renderUI({
            render_display_data_container(
              "DataRequestForm",
              info="Each analytic has a Data Request Form (DRF), a file that specifies important analytic-related material and field mappings for the raw data."
            )
          })
          module_display_data_container(
            "DataRequestForm",
            analytic_obj=EBP_ANALYTIC()
          )
          
          # render contents for Analytic-Specific Data section
          output$display_analytic_data_ui <- renderUI({
            render_display_data_container(
              "AnalyticData",
              info="This panel allows you to interact with the data provided for the analytic. Ensure the data looks as expected."
            )
          })
          module_display_data_container(
            "AnalyticData",
            analytic_obj=EBP_ANALYTIC()
          )
          
          # render contents for Perform Procedures section
          output$display_procedures_ui <- renderUI({
            render_display_procedures("Output")
          })
          module_display_procedures("Output", analytic_obj = EBP_ANALYTIC())
          
        }

      }
  )
}
