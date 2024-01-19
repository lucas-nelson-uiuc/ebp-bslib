PAGE_HOME <- function() {
    
    sidebar <- function() {
        widget_select_analytic <- shiny::selectInput(
            'analytic_selected',
            tags$b('EBP Analytic'),
            choices=c('Analytic #1', 'Analytic #2', 'Analytic #3'),
            width='100%'
        )
        widget_confirm_analytic <- shiny::actionButton(
            'analytic_confirmed',
            tags$b('Confirm Selection'),
            width='100%'
        )
        bslib::sidebar(
            title = div(
                tags$i(
                    'Complete on-screen instructions to validate input and accurately generate output.',
                    style='font-size: 14px; text-align: justify;'
                )
            ),
            tags$hr(),
            widget_select_analytic,
            widget_confirm_analytic
        )
    }
    
    content <- function() {
        
        analytic_header <- function() {
            bslib::layout_columns(
                bslib::page_fluid(
                    h4(tags$b(textOutput('text_analytic_name'))),
                    tags$i(textOutput('text_analytic_description'))
                ),
                uiOutput('ui_analytic_accordion')
            )
        }
        
        bslib::page_fluid(
            analytic_header(
                # analytic_name = textOutput('text_analytic_name'),
                # analytic_description = textOutput('text_analytic_description'),
                # analytic_requirements = textOutput('text_analytic_requirements'),
                # analytic_outputs = textOutput('text_analytic_outputs')
            ),
            tags$hr(),
            p('content')
        )
    }
    
    title <- "EBP Analytics Shell"
    bslib::layout_sidebar(
        title=title,
        sidebar=sidebar(),
        content()
    )
}
