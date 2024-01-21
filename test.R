library(shiny)
library(bslib)


testUI <- function(id) {
  bslib::navset_card_pill(
    id = NS(id, 'module_id'),
    bslib::nav_panel("Info", "Random text here")
  )
}

testServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    
    panel_names <- paste('Panel', 1:3)
    panel_values <- paste('Content', 1:3)
    
    purrr::walk2(
      panel_names, panel_values,
      \(title, content) bslib::nav_insert(
        id='module_id',
        nav=bslib::nav_panel(title=title, content),
        target='Info',
        position='after'
      )
    )
    
  })
}


ui <- bslib::page_fluid(
  tags$h3('Module Instance #1'),
  uiOutput('data_container'),
  tags$h3('Module Instance #2'),
  uiOutput('data_container_again'),
  tags$h3('Session Instance'),
  bslib::navset_card_pill(
    id='session_id',
    bslib::nav_panel("Info", "Random text here")
  )
)

server <- function(input, output, session) {
  # testing modules
  output$data_container <- renderUI({testUI("Module1")})
  testServer("Module1")
  
  output$data_container_again <- renderUI({testUI("Module2")})
  testServer("Module2")
  
  # "same" code in session
  panel_names <- paste('Panel', 1:3)
  panel_values <- paste('Content', 1:3)
  
  purrr::walk2(
    panel_names, panel_values,
    \(title, content) bslib::nav_insert(
      id='session_id',
      nav=bslib::nav_panel(title=title, content),
      target='Info',
      position='before'
    )
  )
  
  bslib::nav_insert(
    id='session_id',
    nav=bslib::nav_spacer(),
    target='Info',
    position='before'
  )
}

shinyApp(ui, server)
