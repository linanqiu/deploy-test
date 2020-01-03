tryOrString <- function(func) {
  tryCatch({
    func
  }, error = function(e) {
    c(list('Error' = toString(e), 'Traceback' = traceback()))
  })
}
