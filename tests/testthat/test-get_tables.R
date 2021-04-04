test_that("multiplication works", {

  url <- "https://en.wikipedia.org/wiki/List_of_international_goals_scored_by_Diego_Maradona"
  get_wikitable(url, table = 1)

  url <- "presidentes-de-colombia"
  d <- get_wikitable(url)

})





