library(shiny)


ui <- fluidPage(
    uiOutput('test')
)

server <- function(input, output, session) {
    output$test <- renderUI({
        sample <- list('Data #1'='description #1', 'Data#2' = 'description2', 'Data3' = 'third descr')
        tags$ul(
            tags$li(sample)
        )
    })
}