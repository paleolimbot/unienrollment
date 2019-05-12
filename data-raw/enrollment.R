
library(tidyverse)

# Methodology:
# Postsecondary Student Information System (PSIS)
# http://www23.statcan.gc.ca/imdb/p2SV.pl?Function=getSurvey&SDDS=5017
#
# Table: 37-10-0011-01 (formerly: CANSIM 477-0029)
# https://www150.statcan.gc.ca/t1/tbl1/en/tv.action?pid=3710001101

# this is an 800 MB download
# curl::curl_download(
#   "https://www150.statcan.gc.ca/n1/tbl/csv/37100011-eng.zip",
#   "data-raw/37100011-eng.zip"
# )
# utils::unzip("data-raw/37100011-eng.zip", exdir = "data-raw")

enrollment_raw <- read_csv("data-raw/37100011.csv")

enrollment_all <- enrollment_raw %>%
  separate(REF_DATE, c("year", "end_year"), convert = TRUE) %>%
  select(
    year,
    province = GEO,
    inst_type = `Institution type`,
    prog_type = `Program type`,
    cred_type = `Credential type`,
    program_class = `Classification of Instructional Programs, Primary Grouping (CIP_PG)`,
    reg_status = `Registration status`,
    gender = Sex,
    n_students = VALUE
  )

enrollment <- enrollment_all %>%
  filter(
    province != "Canada",
    !str_detect(inst_type, "Total"),
    !str_detect(prog_type, "Total"),
    !str_detect(cred_type, "Total"),
    !str_detect(program_class, "Total"),
    !str_detect(reg_status, "Total"),
    !str_detect(gender, "Total")
  ) %>%
  mutate(
    reg_status = str_remove(reg_status, "\\s*student"),
    gender = str_replace(gender, "Sex unknown", "Unknown")
  ) %>%
  filter(!is.na(n_students))

# list.files("data-raw", "^37100011", full.names = TRUE) %>% unlink()

usethis::use_data(enrollment, overwrite = TRUE)
