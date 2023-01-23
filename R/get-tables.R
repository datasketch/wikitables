



#' @export
get_wikitable <- function(url, table = 1, html_nodes = NULL){

  if(!is_url(url)){
    catalogue_list <- purrr::transpose(wikitables:::catalogue)
    l <- catalogue_list %>% keep(~ .$slug == url) %>% .[[1]]
    url <- l$url
    table <- l$table
  }

  if(is.null(html_nodes)){
    html_nodes <- read_wikitables_html(url)
  }
  tables <- table_range(table)
  data <- purrr::map(tables, function(table){
    rvest::html_table(html_nodes[[table]])
  }) %>% dplyr::bind_rows()
  data
}


#' @export
get_table_count <- function(url, html_nodes = NULL){
  if(is.null(html_nodes)){
    html_nodes <- read_wikitables_html(url)
  }
  length(html_nodes)
}

read_wikitables_html <- function(url){
    xml2::read_html(url) %>%
    rvest::html_nodes("table.wikitable")
}


table_range <- function(table){
  if(is.numeric(table)) return(table)
  # table <- "1-6"
  x <- as.numeric(strsplit(table,"-")[[1]])
  seq(from = x[1], to = x[2])
}

