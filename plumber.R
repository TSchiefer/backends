#' @apiTitle DBI backends
#' @apiDescription Lists all known DBI backends
#' @apiVersion 0.0.1
NULL

#' All backends
#'
#' @serializer contentType list(type="application/json")
#' @response 200 OK
#' @get /all
all <- function(res) {
  paste(readLines("docs/all.json"), collapse = "\n")
}


#' All backends
#'
#' @param name Package name
#' @serializer contentType list(type="application/json")
#' @response 200 OK
#' @get /by-package
by_package <- function(res, name) {
  if (rlang::is_missing(name)) {
    res$status <- 400
    jsonlite::toJSON(list(
      error =
        "Your request did not include the package name (required).")
    )} else {
      path <- file.path("docs/by-package", paste0(name, ".json"))
      tryCatch(
        paste(readLines(path), collapse = "\n"),
        error = function(e) {
          res$status <- 500
          jsonlite::toJSON(
            list(
              error = paste0("Please verify package name: ", name)))
        })
    }
}

