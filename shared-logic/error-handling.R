tryOrString <- function(func) {
  tryCatch({
    func
  }, error = function(e) {
    list('Error' = toString(e), 'Traceback' = traceback())
  })
}