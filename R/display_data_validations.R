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

#' Render validations for given Dataset Object
#' 
#' @author Lucas Nelson
render_display_validations <- function(id) {
  htmlOutput(NS(id, 'validations'))
}


#' Populate HTML_VALIDATIONS text with respective number of flags per topic
#' 
#' TODO: build out validation report functionality
#' 
#' @author Lucas Nelson
module_display_validations <- function(id) {
  moduleServer(id, function(input, output, session) {
    # validation_report <- get_validation_report(data=data)
    # n_errors <- length(validation_report$errors)
    # n_warnings <- length(validation_report$warnings)
    # n_suggestions <- length(validation_report$suggestions)
    # 
    # output$validations <- renderText({
    #   sprintf(HTML_VALIDATIONS, n_errors, n_warnings, n_suggestions)
    # })
  })
}
