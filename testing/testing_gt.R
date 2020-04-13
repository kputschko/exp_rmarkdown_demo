
# Testing GT Package ------------------------------------------------------

# remotes::install_github("rstudio/gt")

pacman::p_load(tidyverse, gt)



# Data in GT --------------------------------------------------------------

gt::countrypops
gt::sza
gt::gtcars
gt::sp500
gt::pizzaplace
gt::exibble

# Example 1 ---------------------------------------------------------------

start_date <- "2010-06-07"
end_date <- "2010-06-14"

# Create a gt table based on preprocessed `sp500` table data
sp500 %>%
  filter(date >= start_date & date <= end_date) %>%
  select(-adj_close) %>%
  gt() %>%
  tab_header(title = "S&P 500",
             subtitle = glue::glue("{start_date} to {end_date}")) %>%
  fmt_date(columns = vars(date),
           date_style = 3) %>%
  fmt_currency(columns = vars(open, high, low, close),
               currency = "USD") %>%
  fmt_number(columns = vars(volume),
             suffixing = TRUE)


# Example 2 ---------------------------------------------------------------

data(islands)

test_table <-
  islands %>%
  enframe("name", "size") %>%
  arrange(-size) %>%
  slice(1:10) %>%
  print()

target_largeest <-
  test_table %>%
  filter(size == max(size)) %>%
  print() %>%
  pull(name)

test_table %>%
  gt(rowname_col = "name") %>%
  tab_stubhead("Land~")

test_table %>%
  gt() %>%
  tab_header(title = "**Large Landmasses of the World**" %>% md(),
             subtitle = "*Top ten* largest are presented" %>% md()) %>%
  tab_source_note("Source: Facts, p406") %>%
  tab_source_note("Reference: Smith 75 **Bolder**" %>% md()) %>%
  tab_footnote(footnote = "The Americas",
               locations = cells_data(
                 columns = vars(name),
                 rows = 3:4)) %>%
  tab_footnote(footnote = "Largest Size",
               locations = cells_data(
                 columns = vars(size),
                 rows = name == target_largeest)) %>%
  tab_footnote(footnote = "Smallest Size",
               locations = cells_data(
                 columns = vars(size),
                 rows = size == min(size)))
