
library(tidyverse)
library(homodatum)

# This is for adding tables as fringes

# Pull created pins for wikipedia dsuser
## Save a local copy

# pull wikitable pins that are not already fringes

# pull local list of wikitables

catalogue <- read_csv("data-raw/catalogue.csv")
#write_csv(catalogue %>% arrange(slug), "data-raw/catalogue.csv")
catalogue_list <- transpose(catalogue)

# append wikitable pins to catalogue to create dictionary

# create dictionary for missing dics of tables in catalogue

dictionaries <- gsub("_dic.csv","",list.files("data-raw/dics/"))

no_dic <- which_not_in(catalogue %>% pull(slug), dictionaries)
message(paste0(no_dic, collapse = "\n"))
lapply(no_dic, function(x){
  #x <- no_dic[[1]]
  l <- catalogue_list %>% keep(~ .$slug == x) %>% .[[1]]
  d <- wikitables::get_wikitable(l$url, l$table)
  dic <- create_dic(d)
  write_csv(dic, file.path("data-raw", "dics", paste0(l$slug,"_dic.csv")))
})



dics <- list.files("data-raw/dics/")
dic_names<- gsub("_dic.csv","",dics)
dics <- lapply(dics, read_csv) %>% set_names(dic_names)

usethis::use_data(catalogue, dics, internal = TRUE, overwrite = TRUE)


