server <- function(input, output, session) {
    EBP_CONFIG <- reactiveVal(get_config_obj(YAML_FILE))
    EBP_ANALYTIC <- reactiveVal(NULL)
    
    observe({
        updateSelectInput(
            session,
            'analytic_selected',
            choices=get_analytics(EBP_CONFIG())
        )
    })
    
    observeEvent(
        ignoreNULL=TRUE,
        ignoreInit=TRUE,
        eventExpr = { input$analytic_confirmed },
        handlerExpr = {
            # set analytic name to reactive value
            EBP_ANALYTIC(
                get_analytic_obj(
                    config_obj=EBP_CONFIG(),
                    analytic=input$analytic_selected
                )
            )
            
            output$text_analytic_name <- NULL
            output$text_analytic_description <- NULL
            output$text_analytic_requirements <- NULL
            output$text_analytic_outputs <- NULL
            
            # update placeholders where necessary
            if (!is.null(input$analytic_confirmed)) {
                output$text_analytic_name <- renderText({
                    input$analytic_selected
                })
                output$text_analytic_description <- renderText({
                    get_attribute(EBP_ANALYTIC(), 'description')
                })
                output$ui_analytic_accordion <- renderUI({
                    bslib::accordion(
                        bslib::accordion_panel(
                            title='Analytic Requirements',
                            EBP_ANALYTIC()
                        ),
                        bslib::accordion_panel(
                            title='Analytic Outputs',
                            'description goes here'
                        ),
                        id='accordion',
                        open=FALSE
                    )
                })
                output$text_analytic_requirements <- renderText({
                    get_attribute(EBP_ANALYTIC(), 'requirements')
                })
                output$text_analytic_outputs <- renderText({
                    get_attribute(EBP_ANALYTIC(), 'outputs')
                })
            }
        }
    )
}