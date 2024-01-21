library(shiny)
library(bslib)


# testUI <- function(id) {
#   bslib::navset_card_pill(
#     id = NS(id, 'module_id'),
#     bslib::nav_panel("Info", "Random text here")
#   )
# }
# 
# testServer <- function(id) {
#   moduleServer(id, function(input, output, session) {
#     
#     panel_names <- paste('Panel', 1:3)
#     panel_values <- paste('Content', 1:3)
#     
#     purrr::walk2(
#       panel_names, panel_values,
#       \(title, content) bslib::nav_insert(
#         id='module_id',
#         nav=bslib::nav_panel(title=title, content),
#         target='Info',
#         position='after'
#       )
#     )
#     
#   })
# }
# 
# 
# ui <- bslib::page_fluid(
#   tags$h3('Module Instance #1'),
#   uiOutput('data_container'),
#   tags$h3('Module Instance #2'),
#   uiOutput('data_container_again'),
#   tags$h3('Session Instance'),
#   bslib::navset_card_pill(
#     id='session_id',
#     bslib::nav_panel("Info", "Random text here")
#   )
# )
# 
# server <- function(input, output, session) {
#   # testing modules
#   output$data_container <- renderUI({testUI("Module1")})
#   testServer("Module1")
#   
#   output$data_container_again <- renderUI({testUI("Module2")})
#   testServer("Module2")
#   
#   # "same" code in session
#   panel_names <- paste('Panel', 1:3)
#   panel_values <- paste('Content', 1:3)
#   
#   purrr::walk2(
#     panel_names, panel_values,
#     \(title, content) bslib::nav_insert(
#       id='session_id',
#       nav=bslib::nav_panel(title=title, content),
#       target='Info',
#       position='before'
#     )
#   )
#   
#   bslib::nav_insert(
#     id='session_id',
#     nav=bslib::nav_spacer(),
#     target='Info',
#     position='before'
#   )
# }



fileuploadUI <- function(id) {
  bslib::page_fluid(
    shiny::fileInput(NS(id, 'file'), 'GIMME A FILE'),
    bslib::layout_columns(
      DT::dataTableOutput(NS(id, 'table')),
      DT::dataTableOutput(NS(id, 'mtcars'))
    )
  )
}

fileuploadServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    data <- reactive({
      req(input$file)
      
      ext <- tools::file_ext(input$file$name)
      switch(ext,
             csv = vroom::vroom(input$file$datapath, delim = ","),
             tsv = vroom::vroom(input$file$datapath, delim = "\t"),
             validate("Invalid file; Please upload a .csv or .tsv file")
      )
    })
    
    observeEvent(
      ignoreInit=TRUE,
      ignoreNULL=TRUE,
      eventExpr = {input$file}, 
      handlerExpr = {
        print('yo render this file')
        output$table <- DT::renderDataTable(datatable(data()))
        output$mtcars <- DT::renderDataTable(datatable(mtcars))
      }
    )
  })
}

ui <- bslib::page_fluid(
  fileuploadUI('test1'),
  fileuploadUI('test2'),
  fileuploadUI('test3')
)

server <- function(input, output, session) {
  fileuploadServer('test1')
  fileuploadServer('test2')
  fileuploadServer('test3')
}

shinyApp(ui, server)
