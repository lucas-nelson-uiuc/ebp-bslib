PAGE_HOME <- function() {
    
    sidebar <- function() {
        widget_select_analytic <- shiny::selectInput(
            'analytic_selected',
            '',
            choices=c('Analytic #1', 'Analytic #2', 'Analytic #3'),
            width='100%'
        )
        widget_confirm_analytic <- shiny::actionButton(
            'analytic_confirmed',
            tags$b('Confirm Selection'),
            width='100%'
        )
        widget_toggle_memos <- shiny::checkboxInput(
            'automemo_confirmed',
            tags$b('Generate Memos?'),
            width='100%'
        )
        bslib::sidebar(
            title = tags$h5(tags$b('Input Widgets')),
            tags$hr(),
            tags$b('EBP Analytic'),
            tags$i(
              'Select analytic you want to complete. Complete on-screen instructions to validate input and accurately generate output.',
              style='font-size: 14px; text-align: justify;'
            ),
            widget_select_analytic,
            widget_confirm_analytic,
            tags$hr(),
            tags$b('Memo Generation'),
            tags$i(
              'Optionally complete on-screen instructions to generate memos along with analytic output.',
              style='font-size: 14px; text-align: justify;'
            ),
            width='20%'
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
        
        analytic_content <- function() {
            bslib::page_fluid(
              tags$h5(tags$b("01. Data Request Form")),
              uiOutput('ui_data_request_form'),
              tags$hr(),
              tags$h5(tags$b("02. Analytic-Specific Data")),
              uiOutput('ui_input_datasets'),
            )
        }
        
        perform_procedures <- function() {
            widget_knit_markdown <- shiny::actionButton(
              'knit_markdown',
              tags$b('Knit Markdown File'),
              width='100%'
            )
            widget_generate_memo <- shiny::actionButton(
              'generate_memo',
              tags$b('Generate Documentation'),
              width='100%'
            )
            bslib::page_fluid(
              tags$h5(tags$b("03. Perform Procedures")),
              p('Knit Markdown & Generate Memos'),
              bslib::layout_columns(
                widget_knit_markdown,
                widget_generate_memo
              )
            )
        }
        
        bslib::page_fluid(
            analytic_header(),
            tags$hr(),
            analytic_content(),
            tags$hr(),
            perform_procedures()
        )
    }
    
    title <- "EBP Analytics Shell"
    bslib::layout_sidebar(
        title=title,
        sidebar=sidebar(),
        content()
    )
}
