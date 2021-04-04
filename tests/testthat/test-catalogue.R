test_that("catalogue is well formed", {

  cat <- wikitables:::catalogue

  # all catalogue tables are defined
  expect_true(nrow(cat %>% filter(is.na(table)) == 0))

  # all catalogue tables have dictionaries

})
