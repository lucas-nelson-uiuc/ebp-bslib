library(DT)
library(shiny)


format_prompt <- function(analytic=NULL) {
  sprintf("Please provide following details to run the %s:", analytic)
}

format_nested_attribute <- function(analytic_obj=NULL, attribute=NULL) {
  analytic_inputs <- get_attribute(analytic_obj, attribute)
  purrr::map2(
    analytic_inputs, names(analytic_inputs),
    \(info, dataset) tags$li(
      tags$div(
        tags$b(dataset),
        tags$b("(", info[["abbr"]], ")"),
        ":",
        info[["description"]],
        style='display: inline;'
      )
    )
  )
}


format_data_table <- function(frame) {
  if (is.character(frame)) {
    return("Demo data for now")
  }
  DT::datatable(
    data=frame,
    options=list(
      style='foundation',
      rownames=FALSE,
      escape=FALSE,
      options=list(dom='t', ordering=FALSE, pageLength=100)
    )
  )
}


format_pill <- function(pill_panels=NULL, description=NULL) {
  bslib::navset_card_pill(
    nav_panel("Input Parameters", format_data_table(frame=get_drf_tab("Input Parameters"))),
    nav_panel("Mapping Parameters", format_data_table(frame=get_drf_tab("Mapping Parameters"))),
    nav_spacer(),
    nav_panel(title=shiny::icon("info-sign", lib="glyphicon"), description),
    selected=shiny::icon("info-sign", lib="glyphicon")
  )
}


format_data_request_form_pill <- function() {
  pills <- list(
    "Input Parameters" = format_data_table(frame=get_drf_tab("Input Parameters")),
    "Mapping Parameters" = format_data_table(frame=get_drf_tab("Mapping Parameters"))
  )
  format_pill(
    pill_panels=pills,
    description="The Data Request Form comes with two tabs that must be populated: Input Parameters & Mapping Parameters."
  )
}


format_input_data_pill <- function() {
  pills <- list(
    "Input Parameters" = format_data_table(frame=get_drf_tab("Input Parameters")),
    "Mapping Parameters" = format_data_table(frame=get_drf_tab("Mapping Parameters"))
  )
  format_pill(
    pill_panels=pills,
    description="The Data Request Form comes with two tabs that must be populated: Input Parameters & Mapping Parameters."
  )
}
