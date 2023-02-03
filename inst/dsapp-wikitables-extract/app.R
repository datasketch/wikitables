
library(tidyverse)
library(shinypanels)
library(shiny)
library(DT)
library(shinyinvoer)
library(dsmodules)
library(hotr)
library(txttools)
library(wikitables)

css <- "
.infomessage{
max-width: 600px;
}

"

sample_urls <- c(
  "https://en.wikipedia.org/wiki/List_of_presidents_of_the_United_States",
  "https://en.wikipedia.org/wiki/List_of_international_goals_scored_by_Diego_Maradona"
)
names(sample_urls) <- c("Presidents of the United States",
                        "Maradonas' International goals")

ui <- panelsPage(styles = css,
  # tags$head(
  #   tags$link(rel="stylesheet", type="text/css", href="custom.css")
  # ),
  panel(title = "Carga datos",
        collapse = FALSE,
        collapsable = TRUE,
        width = 400,
        body = div(
          verbatimTextOutput("debug"),
          textInput("url", "Input URL", placeholder = "http://wikipedia.com/..."),
          p("- OR -"),
          br(),
          selectInput("sample_url", "Select a sample wikipedia URL",
                      choices = sample_urls),
          uiOutput("controls")
        )
  ),
  panel(title = "Table",
        collapse = FALSE,
        width = 800,
        body = div(
          dataTableOutput("dataset"),
        )
  ),
  showDebug(hosts = c("127.0.0.1","randommonkey.shinyapps.io"))
)


server <-  function(input, output, session) {

  # DEBUG ----------------------------------------------------------------------

  output$debug <- renderPrint({
    input$sample_url
    input_url()
    t_count()
    sel_table()
  })



  # Valores de URL -------------------------------------------------------------

  par <- list(user_name = "test",
              org_name = "cesa",
              plan = "basic")
  url_par <- reactive({
    url_params(par, session)
  })

  org_name <- reactive({
    url_par()$inputs$org_name
  })

  input_url <- reactive({
    if(input$url == ""){
      return(input$sample_url)
    }
    input$url
  })

  t_count <- reactive({
    url <- input_url()
    t_count <- get_table_count(url)
    t_count
  })

  sel_table <- reactive({
    if(t_count() == 1){}
      return(1)
    input$sel_table
  })

  scrapped_table <- reactive({
    req(input_url())
    url <- input_url()
    sel_table <- sel_table()
    get_wikitable(url, sel_table)
  })




  # Modulo de carga de datos ---------------------------------------------------

  output$controls <- renderUI({
    l <- NULL
    n <- t_count()
    if(sel_table() > 1){
      l <- list(
        infomessage(glue::glue("{n} tables found"), type = "info"),
        shinyinvoer::numberInput("sel_table", "", min = 1, max = t_count())
      )
    }
    l
  })


  # Viz ------------------------------------------------------------------------

  output$dataset <- renderDataTable({

    d <- scrapped_table()
    d
  },
  options = list(
    dom = 'Bftsp',
    buttons = c('copy', 'csv'),
    #language = list(url = '//cdn.datatables.net/plug-ins/1.10.11/i18n/Spanish.json'),
    scrollX = TRUE,
    fixedColumns = TRUE,
    fixedHeader = TRUE,
    searching = TRUE,
    info = TRUE
    #scrollY = "700px",
    # initComplete = JS(
    #   "function(settings, json) {",
    #   "$(this.api().table().header()).css({'background-color': '#4ad3ac', 'color': '#ffffff'});",
    #   "}")
  ))


}

shinyApp(ui, server)
