library(rvest)
library(tidyverse)
library(homodatum)

tables <- read_csv("wikipedia-tables.csv")

tabs <- transpose(tables)

map(tabs, function(x){
  #x <- tabs[[3]]
  tmp <- x$url %>%
    read_html %>%
    html_nodes("table")
  data <- html_table(tmp[[x$position]])
  if(is.na(x$ctypes)){
    ctypes <- NULL
  }else{
    ctypes <- strsplit(x$ctypes, "-")[[1]]
  }
  if(x$new_dic){
    dd <- make_dic(data, ctypes)
    data <- dd$data
    write_csv(dd$dic, paste0("data/", x$id,"-",mop::create_slug(x$title), ".dic.csv"))
  }
  write_csv(dd$data, paste0("data/", x$id, "-", mop::create_slug(x$title), ".csv"))

})

