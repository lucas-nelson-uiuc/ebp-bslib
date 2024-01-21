#' Render content for performing procedures
#' 
#' @author Lucas Nelson
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


#' Create procedure panels
#' 
#' Not much going on in here really - just creating the objects to later be
#' referenced/handled by the parent session.
#' 
#' @author Lucas Nelson
module_display_procedures <- function(id, analytic_obj=NULL) {
  moduleServer(id, function(input, output, session) {
    
    #' Render cards in consistent manner
    #' 
    #' TODO: add more here to handle representation?
    #' TODO: move text to constants.R files? (YAML for configuration only!)
    #' 
    #' @author Lucas Nelson
    create_card <- function(..., header=NULL, footer=NULL) {
      bslib::card(
        bslib::card_header(tags$b(header)),
        ...,
        bslib::card_footer(tags$b('Note'), ':', footer)
      )
    }
    
    # content for Knit Markdown
    output$knit_markdown <- renderUI({
      button <- actionButton('knit_markdown_confirmed', 'Knit Markdown', width='100%')
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
        style='text-align: justify; display: inline;'
      )
      create_card(
        button,
        bslib::accordion(
          bslib::accordion_panel("What happens when I press this button?", description),
          bslib::accordion_panel("How do I handle errors?", description),
          open=FALSE
        ),
        header='Knit Markdown File',
        footer='Please confirm that all information above is complete and accurate.'
      )
    })
    
    # content for Generate Memos
    output$generate_memos <- renderUI({
      button <- actionButton('generate_memos_confirmed', 'Generate Memos', width='100%')
      description <- tags$div(
        "The following memos will output to the `Output/` directory:",
        tags$ol(
          purrr::map(
            names(analytic_obj[['memos']]), ~ tags$li(.x)
          )
        ),
        style='text-align: justify; display: inline;'
      )
      
      create_card(
        button,
        bslib::accordion(
          bslib::accordion_panel("What happens when I press this button?", description),
          bslib::accordion_panel("How do I handle errors?", description),
          open=FALSE
        ),
        header='Generate Memos',
        footer='Edits can be made by reupdating values in-app or within the generated documents.'
      )
      
    })
    
  })
}
