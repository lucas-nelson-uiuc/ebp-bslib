#' Render container per Dataset Object
#' 
#' Defined as a placeholder navigation container that is later populated in the
#' module's server function.
#' 
#' @author Lucas Nelson
render_display_data_container <- function(id, info) {
  bslib::navset_card_pill(
    bslib::nav_panel("Info", info),
    id=NS(id, "navset_container")
  )
}


#' Handle all logic related to a Dataset Object
#'
#' @author Lucas Nelson
module_display_data_container <- function(id, analytic_obj=NULL) {
  moduleServer(id, function(input, output, session) {
    
    analytic_obj_datasets <- analytic_obj[['datasets']]
    
    if (id == 'DataRequestForm') {
      panel_names <- analytic_obj_datasets[['Data Request Form']][['sheets']]
      panel_values <- c('random shit 1', 'random shit 2')
    } else {
      analytic_obj_datasets <- purrr::discard_at(analytic_obj_datasets, 1)
      panel_names <- names(analytic_obj_datasets)
      panel_values <- purrr::map_chr(
        names(analytic_obj_datasets), ~sprintf("Content for %s", .x)
      )
    }
    
    purrr::walk2(
      panel_names, panel_values,
      \(title, content) bslib::nav_insert(
        id="navset_container",
        target="Info",
        position="before",
        bslib::nav_panel(title=title, content)
      )
    )
    
    # instantiate servers - no spaces in name
    
    bslib::nav_insert(
      id="navset_container",
      target="Info",
      position="before",
      bslib::nav_spacer()
    )

  })
}
