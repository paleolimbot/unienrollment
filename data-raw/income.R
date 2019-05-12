
library(tidyverse)

# Methodology:
# Postsecondary Student Information System (PSIS)
# http://www23.statcan.gc.ca/imdb/p2SV.pl?Function=getSurvey&SDDS=5017
#
# Table: 37-10-0115-01
# https://www150.statcan.gc.ca/t1/tbl1/en/tv.action?pid=3710011501

# this is a 10 MB download
# curl::curl_download(
#   "https://www150.statcan.gc.ca/n1/tbl/csv/37100115-eng.zip",
#   "data-raw/37100115-eng.zip"
# )
# utils::unzip("data-raw/37100115-eng.zip", exdir = "data-raw")

income_raw <- read_csv("data-raw/37100115.csv", na = c("", "NA", "x"))

income_all <- income_raw %>%
  select(-VECTOR, -COORDINATE) %>%
  distinct() %>%
  select(
    year = REF_DATE,
    province = GEO,
    degree_type = `Educational qualification`,
    program_class = `Field of study`,
    gender = Sex,
    age_group = `Age group`,
    immigration_status = `Student status in Canada`,
    income_group = `Characteristics after graduation`,
    variable = `Graduate statistics`,
    value = VALUE
  )

income <- income_all %>%
  filter(
    # no totals for these
    !str_detect(degree_type, "^Total"),
    !str_detect(program_class, "^Total"),
    !str_detect(gender, "^Total"),

    # only one value for these
    province == "Canada",
    age_group == "15 to 64 years",
    immigration_status == "Canadian and international students",
    income_group == "Graduates reporting employment income",
  ) %>%
  select(-province, -age_group, -immigration_status, -income_group) %>%
  mutate(
    variable = fct_recode(
      variable,
      "n_students" = "Number of graduates",
      "income_2yr" = "Median employment income two years after graduation",
      "income_5yr" = "Median employment income five years after graduation"
    )
  ) %>%
  spread(variable, value) %>%
  filter(
    # further restrictions
    n_students > 15,
    str_detect(degree_type, "degree")
  ) %>%
  mutate(
    degree_type = degree_type %>%
      str_remove("\\s*degree$") %>%
      str_replace("Undergraduate associate", "Associate")
  )

# list.files("data-raw", "^37100115", full.names = TRUE) %>% unlink()

usethis::use_data(income, overwrite = TRUE)
