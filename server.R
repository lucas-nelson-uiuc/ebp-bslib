server <- function(input, output, session) {
    EBP_CONFIG <- reactiveVal(get_config_obj(YAML_FILE))
    EBP_ANALYTIC <- reactiveVal(NULL)
    EBP_ANALYTIC_NAME <- reactiveVal(NULL)

    # observe({
    #     updateSelectInput(
    #         session,
    #         'analytic_selected',
    #         choices=get_analytics(EBP_CONFIG())
    #     )
    # })
    # 
    # observeEvent(
    #     ignoreNULL=TRUE,
    #     ignoreInit=TRUE,
    #     eventExpr = { input$analytic_confirmed },
    #     handlerExpr = {
    #         EBP_ANALYTIC_NAME(input$analytic_selected)
    #         EBP_ANALYTIC(
    #             get_analytic_obj(
    #                 config_obj=EBP_CONFIG(),
    #                 analytic=input$analytic_selected
    #             )
    #         )
    #         
    #         output$text_analytic_name <- renderText({
    #             EBP_ANALYTIC_NAME()
    #         })
    #         output$text_analytic_description <- renderText({
    #             get_attribute(EBP_ANALYTIC(), 'description')
    #         })
    #         output$ui_analytic_accordion <- renderUI({
    #             bslib::accordion(
    #                 bslib::accordion_panel(
    #                     title='Required Datasets',
    #                     format_prompt(EBP_ANALYTIC_NAME()),
    #                     tags$ul(
    #                       format_nested_attribute(EBP_ANALYTIC(), 'inputs')
    #                     )
    #                 ),
    #                 bslib::accordion_panel(
    #                     title='Generated Outputs',
    #                     tags$ul(
    #                       format_nested_attribute(EBP_ANALYTIC(), 'outputs')
    #                     )
    #                 ),
    #                 id='accordion',
    #                 open=FALSE
    #             )
    #         })
    #         output$ui_data_request_form <- renderUI({
    #           format_data_request_form_pill()
    #         })
    #         output$ui_input_datasets <- renderUI({
    #           format_input_data_pill()
    #         })
    #     }
    # )
}
