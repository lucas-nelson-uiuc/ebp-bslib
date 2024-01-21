library(shiny)

# config object functions
read_config <- function(config_path=NULL) {
    stopifnot(file.exists(config_path))
    yaml::read_yaml(config_path)
}

get_config_obj <- function(config_path=NULL) {
    config_obj <- read_config(config_path=config_path)
    config_instances <- names(config_obj) |>
      purrr::keep(~ substr(.x, 1, 1) == toupper(substr(.x, 1, 1)))
    config_obj[config_instances]
}

update_config <- function(analytics_obj=NULL, type=NULL, type_config=NULL) {
  analytics_obj[[type]] <- purrr::map(analytics_obj[[type]], ~ type_config[[.x]]) |> 
    purrr::set_names(analytics_obj[[type]])
  analytics_obj
}

get_analytics <- function(config_obj=NULL) {
    names(config_obj[['analytics']])
}

get_markdown_path <- function(config_obj=NULL) {
    config_obj[['path']]
}

# analytic object functions
get_analytic_obj <- function(config_obj=NULL, analytic=NULL) {
    config_obj[['analytics']][[analytic]]
}

get_attribute <- function(analytic_obj=NULL, attribute=NULL) {
    analytic_obj[[attribute]]
}

get_drf_tab <- function(tab) {
  if (is.character(tab)) {
    return( "Demo data for now" )
  }
}
