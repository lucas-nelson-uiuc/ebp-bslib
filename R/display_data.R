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
  data_panel <- bslib::page_fluid(
    shiny::fileInput(NS(id, 'file'), NULL, buttonLabel = 'Browse Files'),
    bslib::layout_columns(
      DT::dataTableOutput(NS(id, 'table')),
      # DT::dataTableOutput(NS(id, 'validations')),
      # render_data_validations(),
      # does this need to be a module? could just be a helper function that we
      # call and return within the server to render in the UI
      col_widths=c(7, 5)
    )
  )
  
  # title_errors <- tags$div('Errors', HTML('<span class="badge bg-dark rounded-pill justify-content">2</span>'))
  # title_warnings <- tags$div('Warnings', HTML('<span class="badge bg-dark rounded-pill justify-content">4</span>'))
  # title_suggestions <- tags$div('Suggestions', HTML('<span class="badge bg-dark rounded-pill justify-content">1</span>'))
  # 
  # bslib::navset_pill_list(
  #   bslib::nav_panel('Data', data_panel),
  #   bslib::nav_menu(
  #     'Validations',
  #     bslib::nav_panel(title_errors, 'nope'),
  #     bslib::nav_panel(title_warnings, 'nope'),
  #     bslib::nav_panel(title_suggestions, 'nope')
  #   ),
  #   bslib::nav_panel(title_errors, 'nope'),
  #   bslib::nav_panel(title_warnings, 'nope'),
  #   bslib::nav_panel(title_suggestions, 'nope')
  # )
  
  errors_box <- bslib::value_box(
    title='Errors',
    value='3',
    showcase_layout = 'bottom',
    full_screen=TRUE
  )
  
  warnings_box <- bslib::value_box(
    title='Warnings',
    value='5',
    showcase_layout = 'bottom',
    full_screen=TRUE
  )
  
  suggestions_box <- bslib::value_box(
    title='Suggestions',
    value='2',
    showcase_layout = 'bottom',
    full_screen=TRUE
  )
  
  bslib::page_fluid(
    shiny::fileInput(NS(id, 'file'), NULL, buttonLabel = 'Browse Files'),
    bslib::layout_columns(
      errors_box, warnings_box, suggestions_box
    ),
    bslib::layout_columns(
      DT::dataTableOutput(NS(id, 'table')),
      'yuh',
      # DT::dataTableOutput(NS(id, 'validations')),
      # render_data_validations(),
      # does this need to be a module? could just be a helper function that we
      # call and return within the server to render in the UI
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
    
    observe(print(paste('OHHHH SHIITTTTTT', id)))
    
    file_data <- reactive({
      req(input$file)
      ext <- tools::file_ext(input$file$name)
      switch(
        ext,
        csv = vroom::vroom(input$file$datapath, delim=',', show_col_types=FALSE),
        xlsx = readxl::read_excel(input$file$datapath),
        validate("Invalid file extension. Expected one of [csv, xlsx]")
      )
    })
    
    observeEvent(
      ignoreInit=TRUE,
      ignoreNULL=TRUE,
      eventExpr = {input$file}, 
      handlerExpr = {
        output$table <- DT::renderDataTable(
          DT::datatable(
            file_data(),
            style='bootstrap5',
            extensions='Scroller',
            options=list(
              ordering=FALSE,
              'dom'='t',
              deferRender=TRUE,
              scrollY=300,
              scrollX='100%',
              scroller=TRUE
            )
          )
        )
        
        # output$validations <- DT::renderDataTable(
        #   DT::datatable(
        #     head(file_data()[, 1:3], 5),
        #     style='foundation',
        #     options=list('dom'='t', ordering=FALSE)
        #   )
        # )
        # module_data_validations(sprintf("%s-%s", "validate", panel_title))
      }
    )
    
  })
}
