render_display_procedures <- function(id) {
  knit_markdown_content <- uiOutput(NS(id, 'knit_markdown'))
  generate_memos_content <- uiOutput(NS(id, 'generate_memos'))
  
  bslib::page_fluid(
    bslib::layout_columns(
      knit_markdown_content,
      generate_memos_content,
    ),
    tags$hr()
  )
}


module_display_procedures <- function(id, analytic_obj=NULL) {
  moduleServer(id, function(input, output, session) {
    
    output$knit_markdown <- renderUI({
      description <- tags$div(
        "Given the inputs above, pressing this button will do the following:",
        tags$ol(
          tags$li(
            tags$b("Create analytic directory."),
            "Using the path provided, the shell will populate the analytic",
            "directory with the input files provided. Additionally, this is",
            "where the outputs will generate."
          ),
          tags$li(
            tags$b("Knit markdown file."),
            "After populating the analytic directory, the markdown file will",
            "run as expected. If you are experiencing errors, please confirm",
            "that the previous step executes correctly."
          ),
          tags$li(
            tags$b("Display HTML report."),
            "Should the previous two steps succeed, the markdown file will",
            "render and display an HTML report of the analytic's procedures.",
            "Please verify the information you see aligns with the raw data."
          ),
        ),
        "Please confirm that all information above is complete and accurate.",
        style='text-align: justify; display: inline;'
      )
      bslib::page_fluid(
        actionButton('knit_markdown_confirmed', 'Knit Markdown', width='100%'),
        tags$br(),
        bslib::accordion(
          bslib::accordion_panel("What happens when I press this button?", description),
          bslib::accordion_panel("How do I handle errors?", description),
          open=FALSE
        )
      )
    })
    
    output$generate_memos <- renderUI({
      description <- tags$div(
        "The following memos will output to the `Output/` directory:",
        tags$ol(
          purrr::map(
            names(analytic_obj[['memos']]), ~ tags$li(.x)
          )
        ),
        "Edits can be made within the app or within the generated documents.",
        style='text-align: justify; display: inline;'
      )
      bslib::page_fluid(
        bslib::accordion(
          bslib::accordion_panel("What happens when I press this button?", description),
          bslib::accordion_panel("How do I handle errors?", description),
          open=FALSE
        ),
        tags$br(),
        actionButton('generate_memos_confirmed', 'Generate Memos', width='100%')
      )
    })
    
  })
}
