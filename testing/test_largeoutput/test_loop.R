
# Testing FlexTable and Word Output ---------------------------------------

pacman::p_load(tidyverse, foreach, rmarkdown, rlang)


# Base Case ---------------------------------------------------------------

time_render <- system.time({
  render("testing/test_largeoutput/test_big_data.Rmd",
         params = list(n = 100),
         quiet = TRUE)
})[[3]]


df_render <-
  tibble(label = "render",
         rows = 100,
         runtime = time_render)

# A Loop ------------------------------------------------------------------
# 48 pages / 1000 rows

# i_list <- 1:10
i_list <- seq(80, 100, by = 10)
# i_list <- c(100, 500, 1000, 1500, 2000)
# i_list <- c(2500, 3000, 3500, 4000)

render_runtime <-
  foreach(i = i_list, .combine = "rbind") %do% {

    str_c("----------", i, "----------") %>% inform()

    .time_render <- system.time({
      render("testing/test_largeoutput/test_big_data.Rmd",
             params = list(n = i),
             quiet = TRUE)
    })[[3]]


    tibble(label = "render",
           rows = i,
           runtime = .time_render)

  }

write_csv(render_runtime,
          path = "testing/test_largeoutput/runtime.csv",
          append = TRUE)


# View Table --------------------------------------------------------------

read_csv("testing/test_largeoutput/runtime.csv") %>%
  group_by(label, rows) %>%
  summarise(runtime = mean(runtime, na.rm = TRUE)) %>%
  pivot_wider(names_from = "label", values_from = "runtime") %>%
  rename(flextable_fx_sec = flextable,
         render_sec = render) %>%
  mutate(render_mins = render_sec/60)

