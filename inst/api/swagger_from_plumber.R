# library(magrittr)
#
# plumber <- plumber::plumb("inst/api/plumber.R")
# plumber$run(swagger = TRUE)

# openapi.json comes from saving the swagger-file that is accessible
# at http://127.0.0.1:8961/openapi.json when running
# `plumber$run(port = 8961, swagger = TRUE)`

# converting json to yaml:
# jsonlite::read_json("inst/api/openapi.json") %>%
#   yaml::write_yaml("inst/api/openapi.yaml")

# by default the produced swagger/openapi-file is (currently) one
# of version 3.0.2 if an earlier version is required, a manual
# conversion is necessary

# The swagger file can be altered and -- as long as the
# specifications of the endpoints is still given -- then used
# as the swagger-file to host the API.
#
# The file openapi.yaml was renamed to swagger.yaml, since the older version swagger is being used here.
base_path <- yaml::read_yaml("inst/api/swagger.yaml")$basePath
root <- plumber::plumber$new()

plum <- plumber::plumber$new("inst/api/plumber.R")
root$mount(base_path, plum)

# plumber <- plumber::plumb("inst/api/plumber.R")
root$run(swagger = function(pr, spec, ...) {
  spec <- yaml::read_yaml("inst/api/swagger.yaml")
  spec
}, port = 8421)
