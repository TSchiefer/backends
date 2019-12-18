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
        "Your request did not include the package name (required)."
    ))
  } else {
    path <- file.path("docs/by-package", paste0(name, ".json"))
    file_exists <- file.exists(path)
    if (!base::all(file_exists)) {
      res$status <- 500
      jsonlite::toJSON(list(
        error =
          paste0(
            "Please verify package name: ",
            paste0(name[!file_exists], collapse = ", ")
          )
      ))
    } else {
      jsonlite::toJSON(setNames(purrr::map(name, by_package_impl), name), pretty = TRUE, auto_unbox = TRUE)
    }
  }
}

by_package_impl <- function(name) {
  path <- file.path("docs/by-package", paste0(name, ".json"))
  jsonlite::read_json(path)
}
