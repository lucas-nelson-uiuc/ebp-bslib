#' Render content within Data Container
#'
#' Components for user to upload data as well as view and interact with the
#' processed data. Data validations render next to the data, allowing users to
#' easily observe invalid data properties within the app.
#' 
#' TODO: offer users ways to "fix" data in-app
#' TODO: specify to user what happens with the data after uploaded
#'
#' @author Lucas Nelson
render_display_data <- function(id) {
  bslib::page_fluid(
    shiny::fileInput(NS(id, 'file'), NULL, buttonLabel = 'Browse Files'),
    bslib::layout_columns(
      DT::dataTableOutput(NS(id, 'table')),
      'placeholder',
      # render_data_validations(),
      col_widths=c(7, 5)
    )
  )
}


#' Server for handling requests within Data Container
#'
#' Processes uploaded files and returns data and validations to be rendered.
#'
#' @author Lucas Nelson
module_display_data <- function(id, panel_title=NULL) {
  moduleServer(id, function(input, output, session) {
    
    file_data <- reactive({
      req(input$file)
      ext <- tools::file_ext(input$file$name)
      switch(
        ext,
        csv = vroom::vroom(input$file$datapath, delim=','),
        xlsx = readxl::read_excel(input$file$datapath),
        validate("Invalid file extension. Expected one of [csv, xlsx]")
      )
    })
    
    observeEvent(
      ignoreInit=TRUE,
      ignoreNULL=TRUE,
      eventExpr = {input$file}, 
      handlerExpr = {
        output$table <- DT::renderDataTable(datatable(data()))
        module_data_validations(sprintf("%s-%s", "validate", panel_title))
      }
    )
    
  })
}
