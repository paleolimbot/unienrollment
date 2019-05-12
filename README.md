
<!-- README.md is generated from README.Rmd. Please edit that file -->

# unienrollment

<!-- badges: start -->

<!-- badges: end -->

The goal of unienrollment is to provide an engaging dataset for
University professors and administrators who are learning R, the
[tidyverse](http://tidyverse.org), and
[ggplot2](http://ggplot2.tidyverse.org/). The package contains two
datasets: `enrollment` and `income`. Both are derived from Statistics
Canada data products that rely on the [Postsecondary Student Information
System
(PSIS)](http://www23.statcan.gc.ca/imdb/p2SV.pl?Function=getSurvey&SDDS=5017).

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("paleolimbot/unienrollment")
```

If you can load the package, you’re all set\!

``` r
library(unienrollment)
```

## Canadian postsecondary enrollment

The `enrollment` dataset contains counts of the number of students
enrolled in Canada with a given degree type and program class. The
dataset is also divided by year and gender. Each row represents a cohort
of students who share an enrollment year, a degree type, a program
class, and a gender.

``` r
enrollment
#> # A tibble: 2,760 x 5
#>     year degree_type program_class                        gender n_students
#>    <int> <chr>       <chr>                                <chr>       <dbl>
#>  1  1992 Doctoral    Agriculture, natural resources and … Femal…        234
#>  2  1992 Doctoral    Agriculture, natural resources and … Males         633
#>  3  1992 Doctoral    Architecture, engineering and relat… Femal…        372
#>  4  1992 Doctoral    Architecture, engineering and relat… Males        3210
#>  5  1992 Doctoral    Business, management and public adm… Femal…        216
#>  6  1992 Doctoral    Business, management and public adm… Males         441
#>  7  1992 Doctoral    Education                            Femal…       1476
#>  8  1992 Doctoral    Education                            Males         963
#>  9  1992 Doctoral    Health and related fields            Femal…        555
#> 10  1992 Doctoral    Health and related fields            Males         675
#> # … with 2,750 more rows
```

## Employment income of postsecondary graduates

The `income` dataset contains the median empoyment income of
postsecondary students who graduated in 2010 and 2011 after 2 years and
5 years. Each row represents a cohort of students who share a graduation
year, a degree type, a program class, and a gender.

``` r
income
#> # A tibble: 480 x 7
#>     year degree_type program_class  gender income_5yr income_2yr n_students
#>    <dbl> <chr>       <chr>          <chr>       <dbl>      <dbl>      <dbl>
#>  1  2010 Doctoral    Aboriginal an… Femal…      60000      58100         30
#>  2  2010 Doctoral    Agriculture, … Femal…      76800      60200         20
#>  3  2010 Doctoral    Agriculture, … Males       60500      38600         30
#>  4  2010 Doctoral    Agriculture, … Femal…      70100      55900         50
#>  5  2010 Doctoral    Agriculture, … Males       70000      51300         60
#>  6  2010 Doctoral    Architecture,… Femal…      71200      53500        145
#>  7  2010 Doctoral    Architecture,… Males       87100      74700        510
#>  8  2010 Doctoral    Biological an… Femal…      56600      41700        275
#>  9  2010 Doctoral    Biological an… Males       58100      37500        225
#> 10  2010 Doctoral    Business, man… Femal…     105200      96300         60
#> # … with 470 more rows
```
