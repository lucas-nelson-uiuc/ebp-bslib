PAGE_HOME <- function() {
    
    sidebar <- function() {
        widget_select_analytic <- shiny::selectInput(
            'analytic_selected',
            NULL,
            choices=sprintf("Placeholder #%s", 1:5),
            width='100%'
        )
        widget_confirm_analytic <- shiny::actionButton(
            'analytic_confirmed',
            tags$b('Confirm Selection'),
            width='100%'
        )
        widget_toggle_html <- shiny::checkboxInput(
          'toggle_html',
          'Display HTML Report'
        )
        widget_toggle_memos <- shiny::checkboxInput(
          'toggle_automemo',
          'Generate Memos'
        )
        
        bslib::sidebar(
          tags$b('Analytic Configuration'),
          tags$i(
            'Select analytic you want to complete. Complete on-screen instructions to validate input and accurately generate output.',
            style='font-size: 14px; text-align: justify;'
          ),
          widget_select_analytic,
          widget_confirm_analytic,
          tags$hr(),
          tags$b('Output Configuration'),
          tags$i(
            'Optionally complete on-screen instructions to generate memos along with analytic output.',
            style='font-size: 14px; text-align: justify;'
          ),
          tags$br(),
          widget_toggle_html,
          widget_toggle_memos,
          tags$hr(),
          width='20%'
        )
    }
    
    content <- function() {
        
        analytic_header <- function() {
            bslib::layout_columns(
                bslib::page_fluid(
                    h4(tags$b(textOutput('text_analytic_name'))),
                    tags$i(uiOutput('text_analytic_description'))
                ),
                uiOutput('analytic_details_ui')
            )
        }
        
        bslib::page_fluid(
          analytic_header(),
          bslib::page_navbar(
            bslib::nav_panel("Data Request Form", uiOutput('display_data_request_form_ui')),
            bslib::nav_panel("Analytic Data", uiOutput('display_analytic_data_ui')),
            bslib::nav_panel("Perform Procedures", uiOutput('display_procedures_ui'))
          )
        )
    }
    
    bslib::layout_sidebar(
      sidebar=sidebar(),
      content()
    )
}
