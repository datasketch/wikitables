
which_not_in <- function (x, y) x[!x %in% y]

is_url <- function(x) grepl("^http", x)
