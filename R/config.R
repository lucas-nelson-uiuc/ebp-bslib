# Configuration Objects are the most important aspect of this Shiny application.
# Defined in the "config/" directory as YAML files, they provide the necessary
# information for successfully completing the procedures offered in the
# application. The application should only be viewed as a way of displaying
# configuration objects rather than as a way of defining them.


#' Read YAML file
#' 
#' Additional checks to ensure YAML file is configured correctly.
#' 
#' @author Lucas Nelson
read_config <- function(config_path=NULL) {
    stopifnot(file.exists(config_path))
    yaml::read_yaml(config_path)
}

#' Read and filter YAML file
#' 
#' Given path to YAML file, read the file and remove all top-level objects
#' that do not begin with an uppercase letter. If the YAML file is configured
#' according to this naming convention, the function should discard any anchors
#' created in the YAML files.
#' 
#' @author Lucas Nelson
get_config_obj <- function(config_path=NULL) {
    config_obj <- read_config(config_path=config_path)
    config_instances <- names(config_obj) |>
      purrr::keep(~ substr(.x, 1, 1) == toupper(substr(.x, 1, 1)))
    config_obj[config_instances]
}

#' Attach object defintions to YAML objects
#'
#' Updates a specific section of the Analytics Object with a separate
#' Configuration Object (e.g. Memos Object, Datasets Object).
#'
#' @author Lucas Nelson
update_config <- function(analytics_obj=NULL, type=NULL, type_config=NULL) {
  analytics_obj[[type]] <- purrr::map(analytics_obj[[type]], ~ type_config[[.x]]) |> 
    purrr::set_names(analytics_obj[[type]])
  analytics_obj
}


#' Utility function for subsetting Configuration Object
#' 
#' @author Lucas Nelson
get_config_attribute <- function(config_obj=NULL, attribute=NULL) {
  config_obj[[attribute]]
}


#' Get top-level components
#'
#' TODO: rename to be Configuration Object agnostic?
get_analytics <- function(analytics_obj=NULL) {
  names(analytics_obj)
}
