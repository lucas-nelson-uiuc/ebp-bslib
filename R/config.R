library(shiny)

# config object functions
read_config <- function(config_path=NULL) {
    stopifnot(file.exists(config_path))
    yaml::read_yaml(config_path)
}

get_config_obj <- function(config_path=NULL) {
    config_obj <- read_config(config_path=config_path)
    config_obj[['EBP Shiny']]
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
