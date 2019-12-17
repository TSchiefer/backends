#' @apiTitle DBI backends
#' @apiDescription Lists all known DBI backends
#' @apiVersion 0.0.1
NULL

#' All backends
#'
#' @serializer contentType list(type="application/json")
#' @response 200 OK
#' @get /all
all <- function() {
  paste(readLines("docs/all.json"), collapse = "\n")
}


#' All backends
#'
#' @param name Package name
#' @serializer contentType list(type="application/json")
#' @response 200 OK
#' @get /by-package
by_package <- function(name) {
  path <- file.path("docs/by-package", paste0(name, ".json"))
  paste(readLines(path), collapse = "\n")
}
