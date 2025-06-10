#!/usr/bin/env Rscript

###############################################################################
# -*- encoding: UTF-8 -*-                                                     #
# Description: An Introduction to dplyr                                       #
#                                                                             #
#                                                                             #
# Last Modified: 2023-06-19                                                   #
###############################################################################
library(tidyverse)
###############################################################################

data_path <- function(file) {
  paste0("../data/", file)
}

# String parsing is a common task when cleaning data. In this homework
# exercise, you will learn more about how to parse strings using the package
# `stringr`. The package `stringr` provides many functions starting with `str_`
# that makes string parsing easy.
#
# In this homework, you will further parse the data set `opendata-107.csv`
# to make further inferences on the data easier. In particular, we will
# introduce you to the most common string parsing functions:
#
# - str_sub:        get subset of string by index
# - str_replace:    replace a substring
# - str_split_i:    split string by some pattern
# - str_detect:     detect whether the string contains a pattern
# - str_extract:    extract some pattern from the string

data <- data_path("opendata-107.csv") |>
  read_csv() |>
  slice(-1) |>
  select(-statistic_yyy, -district_code) |>
  pivot_longer(
    cols = matches("_[mf]$"),
    names_to = "type",
    values_to = "number"
  ) |>
  mutate(number = as.integer(number))

### str_sub ###################################################################

data <- data |>
  mutate(county = str_sub(...)) |> # TODO: get `county` from `site_id`
  relocate(county)

### str_replace ###############################################################

data <- data |>
  mutate(type = str_replace(...)) |> # TODO: remove "_age" from `type`
  mutate(type = str_replace(...)) |> # TODO: replace "15down" to "0_15" in `type`
  mutate(type = str_replace(...)) # TODO: replace "100up" to "100_110" in `type`

### str_split_i ###############################################################

data <- data |>
  mutate(
    marital_status = str_split_i(...), # TODO: get `marital_status` from `type`
    age_lower = str_split_i(...), # TODO: get `age_lower` from `type`
    age_upper = str_split_i(...), # TODO: get `age_upper` from `type`
    sex = str_split_i(...)
  ) |> # TODO: get `sex` from `type`
  select(-type) |>
  mutate(
    age_lower = as.integer(age_lower),
    age_upper = as.integer(age_upper)
  ) |>
  relocate(number, .after = sex)

### str_detect ################################################################

data <- data |>
  mutate(municipality = str_detect(...)) # TODO: get municipality

### str_extract ###############################################################

data <- data |>
  mutate(site_id = str_extract(...)) # TODO: use `str_extract` to remove country from `type`

# After all the wangling, you should get something like this:
#
# # A tibble: 1,179,520 × 9
#    county site_id village marital_status age_lower age_upper sex   number municipality
#    <chr>  <chr>   <chr>   <chr>              <int>     <int> <chr>  <int> <lgl>
#  1 新北市 板橋區  留侯里  single                 0        15 m        118 TRUE
#  2 新北市 板橋區  流芳里  single                 0        15 m        119 TRUE
#  3 新北市 板橋區  赤松里  single                 0        15 m         60 TRUE
#  4 新北市 板橋區  黃石里  single                 0        15 m        113 TRUE
#  5 新北市 板橋區  挹秀里  single                 0        15 m        123 TRUE
#  6 新北市 板橋區  湳興里  single                 0        15 m        351 TRUE
#  7 新北市 板橋區  新興里  single                 0        15 m        169 TRUE
#  8 新北市 板橋區  社後里  single                 0        15 m        318 TRUE
#  9 新北市 板橋區  香社里  single                 0        15 m        248 TRUE
# 10 新北市 板橋區  中正里  single                 0        15 m        313 TRUE

### MORE! #####################################################################

# When using `str_extract`, one often need to use "regular expressions".
# Regular expression (or "regex") is a terse that allow you to describe
# patterns in strings. You can learn more about regex
# [here](https://www.datacamp.com/tutorial/regex-r-regular-expressions-guide).
