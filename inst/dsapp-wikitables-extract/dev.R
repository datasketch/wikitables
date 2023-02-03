
library(tidyverse)
library(txttools)

url <- "https://en.wikipedia.org/wiki/List_of_presidents_of_the_United_States"

t_count <- get_table_count(url)

if(t_count > 1){
  message("More tables")
  sel_table <- 2
} else{
  sel_table <- 1
}

tab <- get_wikitable(url = url, table = sel_table)

