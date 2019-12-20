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
  # req$postBody contains the body of the posted file converted to "character".
  # It is as of yet unclear where exactly this conversion happens.
  # like it is implemented now we can convert req$postBody to "raw", but e.g. in case
  # of an uploaded pdf file, during the conversion of pdf->"character" already
  # some information gets lost, so it's not as easy as writing/saving it as a pdf file,
  # cause it then will be corrupted.
  # The question if the behavior will be the same for spectra-files would need
  # to be investigated.
  raw <- charToRaw(req$postBody)
  writeBin(raw, "test_new")
}
