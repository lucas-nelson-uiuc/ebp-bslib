HTML_VALIDATIONS <- '
    <ul class="list-group">
      <li class="list-group-item list-group-item-danger d-flex justify-content-between align-items-center">
        Errors
        <span class="badge bg-dark rounded-pill">%s</span>
      </li>
      <li class="list-group-item list-group-item-warning d-flex justify-content-between align-items-center">
        Warnings
        <span class="badge bg-dark rounded-pill">%s</span>
      </li>
      <li class="list-group-item list-group-item-info d-flex justify-content-between align-items-center">
        Suggestions
        <span class="badge bg-dark rounded-pill">%s</span>
      </li>
    </ul>
'

render_display_validations <- function(id) {
  htmlOutput(NS(id, 'validations'))
}

module_display_validations <- function(id) {
  moduleServer(id, function(input, output, session) {
    output$validations <- renderText({
      sprintf(HTML_VALIDATIONS, 0, 0, 0)
    })
  })
}
