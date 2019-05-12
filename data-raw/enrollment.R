
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
  distinct() %>%
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
    !str_detect(prog_type, "Total"),
    !str_detect(cred_type, "Total"),
    !str_detect(program_class, "Total"),
    !str_detect(gender, "Total"),

    # some values
    str_detect(cred_type, "[Dd]egree"),
    prog_type != "Non-program (credit, undergraduate)",

    # one value
    province == "Canada",
    str_detect(reg_status, "Total"),
    str_detect(inst_type, "Total"),
  ) %>%
  select(-province, -reg_status, -inst_type) %>%
  # recoding the values in prog_type, cred_type to match income$degree_type
  mutate(
    degree_type = prog_type %>%
      fct_recode(
        "Doctoral" = "Graduate program (third cycle)",
        "Master's" = "Graduate program (second cycle)",
        "Undergraduate" = "Undergraduate program",
        "Professional" = "Post-baccalaureate non-graduate program",
        "Professional" = "Health-related residency program",
        "Professional" = "Other programs"
      ) %>%
      as.character() %>%
      if_else(cred_type == "Associate degree", "Associate", .),
    gender = str_replace(gender, "Sex unknown", "Unknown")
  ) %>%
  filter(!is.na(n_students)) %>%
  # this completes the "degree_type" recode, ditching prog_type and cred_type
  group_by(year, degree_type, program_class, gender) %>%
  summarise(n_students = sum(n_students)) %>%
  ungroup()

# list.files("data-raw", "^37100011", full.names = TRUE) %>% unlink()

usethis::use_data(enrollment, overwrite = TRUE)
