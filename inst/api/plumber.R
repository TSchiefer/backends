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
      res$status <- 404
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

#' Post something
#'
#' @param content Content of the post
#' @response 200 OK
#' @post /give-feedback
give_feedback <- function(res, content) {
  if (rlang::is_missing(content)) {
    res$status <- 400
    list(
      error =
        "Your POST did not include the content (required)."
    )
  } else {
    if (!is.character(content)) {
      res$status <- 400
      list(
        error =
          paste0(
            "The content you posted is not of class character but of class: ",
            paste0(class(content, collapse = ", "))
          )
      )
    } else {
      list(POST = content)
    }
  }
}

# curl --data-binary "@docs/test.json" -X POST "http://127.0.0.1:8421/file-upload" -H "accept: application/json"
#' Post a file
#'
#' @post /file-upload
function(req) {
  req$postBody
  jsonlite::parse_json(req$postBody, simplifyVector = TRUE)
}
