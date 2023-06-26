#!/usr/bin/env Rscript

###############################################################################
# -*- encoding: UTF-8 -*-                                                     #
# Description: An Introduction to tidyverse and dplyr                         #
# Note: This lecture is based heavily on a homework problem from ECON5166     #
#       in fall 2020.                                                         #
#                                                                             #
# Last Modified: 2023-06-25                                                   #
###############################################################################

# In lecture 0, you learnt the bare minimum about R, which is not very useful
# if you want to do any thing useful.  In this lecture, you will learn the,
# arguably, most popular "grammar" when it comes to data manipulation: `dplyr`.
#
# This lecture has three main parts:
#
# 1. DPLYR "VERBS":
#    Functions (or "verbs") that are used to manipulate a single data.frame are
#    introduced here. These verbs are:
#      - Row Operations:
#          - slice()       Select, remove, or duplicate rows.
#          - filter()      Filter out rows.
#          - arrange()     Rearrange rows.
#      - Column Operations:
#          - select()      Select columns.
#          - rename()      Rename columns.
#          - mutate()      Create new columns.
#          - relocate()    Rearrange columns.
#      - Collapse Rows and Columns:
#          - summarize()   Summarize data.
#    Two extra "group" verbs are introduced that is used to group or un-group
#    the data in support of the verbs mentioned above:
#      - group_by()
#      - ungroup()
#
# 2. RESHAPING DATA:
#    One task that is not easily achievable simply operating row-wise or
#    column-wise is reshaping wide and long forms of data (explained later).
#    There are two functions related to this:
#      - gather()          wide form to long form
#      - spread()          long form to wide form
#
# 3. JOINING DATA:
#    When manipulating data, one often needs to combine two or more data.frames
#    by matching some values. The following functions are often used to achieve
#    such goals:
#      - left_join()
#      - right_join()
#      - inner_join()
#      - full_join()
#
# Before we start, make sure to install the package `tidyverse` first. In fact,
# `tidyverse` is a collection of useful packages, and `dplyr` is one of the
# packages. Almost all modern R users installs `tidyverse`.
#
# - [dplyr grammar](https://dplyr.tidyverse.org/)
# - [vignette](https://dplyr.tidyverse.org/articles/dplyr.html)

install.packages("tidyverse")
library(tidyverse)

data.path <- function ( file ) { paste0("./data/",file) }

### DPLYR VERBS ###############################################################

# This data set `opendata-107.csv` is about the marital status in Taiwan in
# year 2018. When using tidyverse, we use `read_csv` to read from `.csv` files,
# rahter than `read.csv`. You will find that many more modern R functions uses
# underscores rather than dots. This is a way you can tell these functions
# apart from functions provided by base R.

open.data <- read_csv(data.path("opendata-107.csv"))
colnames(open.data)
names(open.data)

## VERB: slice()

open.data %>% slice(1:5)
open.data %>% slice(-1) -> open.data

## VERB: select()

# Often we do not need all the columns in the data, `select()` helps us
# "select" the ones we want. You can also change the column name with select.

open.data %>%
  select(statistic_yyy,
         site_id,
         village,
         single_age_20_24_m,
         single_age_20_24_f) -> open.data.20.24

open.data %>%
  select(A = statistic_yyy,
         B = site_id,
         C = village,
         D = single_age_20_24_m,
         E = single_age_20_24_f)

## VERB: mutate()

# The verb `mutate()` is used to generate new (or replace old) columns. If you
# have used STATA before, `mutate()` is like `gen` or `egen`, but more
# flexible.
#
# Note: In this lecture, you will see a lot of string manipulating funtions
# that starts with `str_`. These functions are provided by the package
# `stringr`, which is included in `tidyverse`. In the homework, you will learn
# more about `stringr`.

open.data.20.24 <- open.data.20.24 %>%
  mutate(statistic_yyy      = as.integer(statistic_yyy),
         single_age_20_24_m = as.integer(single_age_20_24_m),
         single_age_20_24_f = as.integer(single_age_20_24_f))

open.data.20.24 %>%
  mutate(statistic_yyyy = statistic_yyy + 1911) -> open.data.20.24

open.data.20.24 %>% mutate(balance = single_age_20_24_f == single_age_20_24_m)
open.data.20.24 %>% mutate(county = str_sub(site_id,1,3))

## VERB: relocate()

open.data.20.24 %>% relocate(statistic_yyyy, .before = statistic_yyy)
open.data.20.24 %>% relocate(statistic_yyyy, .after  = statistic_yyy)
open.data.20.24 %>% select(-statistic_yyy, -statistic_yyyy) -> open.data.20.24

## VERB: rename()

open.data.20.24 %>%
  rename(single_m_20_24_m = single_age_20_24_m,
         single_f_20_24_f = single_age_20_24_f)

## VERB: filter()

# This verb "filters" the row by some criterion. Any expression that returns
# a logical type can serve as a criterion.

open.data.20.24 %>% filter(site_id=="臺北市大安區")
open.data.20.24 %>% filter(single_age_20_24_m >= 500)

## VERB: arrange()

open.data.20.24 %>%
  filter(single_age_20_24_m >= 500) %>%
  arrange(-single_age_20_24_m)

### RESHAPING DATA ############################################################

# The open data set contains more than 100 columns, which is difficult to deal
# with. In these cases where there are many columns, we often want to re-shape
# these data set from "wide" form to "long" form.
#
# WIDE FORM:
#
# | site_id | male | female |
# |---------|------|--------|
# | A       | 1    | 6      |
# | B       | 2    | 7      |
# | C       | 3    | 8      |
# | D       | 4    | 9      |
# | E       | 5    | 1      |
#
# LONG FORM:
#
# | site_id | key    | value |
# |---------|--------|-------|
# | A       | male   | 1     |
# | B       | male   | 2     |
# | C       | male   | 3     |
# | D       | male   | 4     |
# | E       | male   | 5     |
# | A       | female | 6     |
# | B       | female | 7     |
# | C       | female | 8     |
# | D       | female | 9     |
# | E       | female | 1     |

open.data %>%
  mutate(site_id = str_replace(site_id, "三民一", "三民區"),
         site_id = str_replace(site_id, "三民二", "三民區"),
         site_id = str_replace(site_id, "鳳山一", "鳳山區"),
         site_id = str_replace(site_id, "鳳山二", "鳳山區")) %>%
  mutate(site_id = str_replace(site_id, "東　區", "東區"),
         site_id = str_replace(site_id, "西　區", "西區"),
         site_id = str_replace(site_id, "南　區", "南區"),
         site_id = str_replace(site_id, "中　區", "中區"),
         site_id = str_replace(site_id, "北　區", "北區")) %>%
  select(-statistic_yyy, -district_code) %>%
  gather(key="type", value="number", 3:ncol(.)) %>%
  mutate(number = as.integer(number)) -> open.data

open.data %>%
  filter(site_id=="臺北市大安區") %>%
  spread(key="type", value="number")

### GROUP, UNGROUP, SUMMARIZE #################################################

## VERB: group_by() and ungroup()

# The verb `group()` is very intuitive, it simply groups the data by some
# criteria. By grouping the data, we can calculate group level values easily.

once_married_types <- c("married", "divorced", "widowed")
open.data %>%
  mutate(marital_status = str_split_i(type, "_", 1)) %>%
  group_by(site_id, marital_status) %>%
  summarize(number = sum(number)) %>%
  ungroup() %>%
  group_by(site_id) %>%
  mutate(population   = sum(number),
         once_married = sum(number[marital_status %in% once_married_types]),
         once_married_percentage = once_married / population) %>%
  ungroup() -> open.data

### JOINING DATA ##############################################################

# When dealing with multiple data sets, it is common that we join the data by
# some column. `dplyr` provides 4 functions to join data frames: `left_join`,
# `right_join`, `inner_join`, and `full_join`.
#
# The syntax of joining data frames is
#
#     something_join(X, Y, by = column)
#
# or
#
#     X %>% something_join(Y, by = column)
#
# where `X` and `Y` are data frames. The data frame `X` is called the "left
# data frame" and `Y` is called the "right data frame". The four different
# "join" functions differ by the following ways:
#
# - A `left_join()`  keeps all observations in `X`.
# - A `right_join()` keeps all observations in `Y`.
# - A `inner_join()` keeps only the observations appearing in both `X` and `Y`
# - A `full_join()`  keeps all observations in `X` and `Y`.
#
# Note: You almost never want to use `full_join()`, as it often leads to
# unexpected results if the column by which you join contains non-unique
# values entries.

read_csv(data.path("referendum-2018-number-10.csv")) %>%
  select(county           = 縣市,
         town             = 鄉鎮市區,
         agree            = 同意票數,
         disagree         = 不同意票數,
         legal_vote       = 有效票數,
         illegal_vote     = 無效票數,
         legal_population = 投票權人數,
         vote             = 投票數) %>%
  filter(!is.na(town)) %>%
  mutate(site_id = paste0(county, town)) %>%
  relocate(site_id, .before=county) %>%
  select(-county, -town) -> referendum.data

open.data.temp <- open.data %>%
  filter(site_id=="臺北市大安區" | site_id=="臺北市文山區") %>%
  mutate(site_id = str_replace(site_id, "文山區", "？？區"))

referendum.data %>% left_join (open.data.temp, by="site_id")
referendum.data %>% right_join(open.data.temp, by="site_id")
referendum.data %>% inner_join(open.data.temp, by="site_id")
referendum.data %>% full_join (open.data.temp, by="site_id")

referendum.data %>%
  left_join(open.data, by="site_id") %>%
  mutate(agree_percentage = agree / legal_vote) %>%
  spread(marital_status, number) %>%
  select(site_id,
         once_married_percentage,
         agree_percentage,
         agree,
         legal_vote,
         legal_population,
         population) -> referendum.data

### Results ###################################################################

with(referendum.data,  cor(agree_percentage, once_married_percentage))
with(referendum.data, plot(agree_percentage, once_married_percentage))

referendum.data %>%
  filter(agree_percentage < 0.67)

referendum.data %>%
  filter(once_married_percentage <= 0.55) %>%
  filter(agree_percentage >= 0.77) %>%
  arrange(site_id)

### Plot Results ##############################################################

# Better plots using `ggplot`, next lecture :)

indigenous_sites <- read_csv(data.path("indigenous-sites.csv"))$site_id
municipalities   <- c("臺北市","新北市","桃園市","臺中市","臺南市","高雄市")
county_types     <- c(municipalities, "其他")
chinese_font     <- "Noto Sans CJK KR"

referendum.data %>%
  mutate(county       = str_extract(site_id, "^...")) %>%
  mutate(indigenous   = site_id %in% indigenous_sites) %>%
  mutate(indigenous   = if_else(indigenous, "是", "否")) %>%
  mutate(indigenous   = factor(indigenous, levels=c("是", "否"))) %>%
  mutate(municipality = county  %in% municipalities) %>%
  mutate(municipality = if_else(municipality, county, "其他")) %>%
  mutate(municipality = factor(municipality, levels=county_types)) %>%
  select(site_id,
         agree_percentage,
         once_married_percentage,
         municipality,
         indigenous) %>%
  ggplot()+
  aes(x     = agree_percentage,
      y     = once_married_percentage,
      color = municipality,
      shape = indigenous,
      label = site_id)+
  geom_point(alpha=0.9, size=2)+
  geom_text(family = chinese_font,
            color  = "black",
            size   = 0.8,
            alpha  = 0.1)+
  theme(text = element_text(size=12, family=chinese_font))+
  scale_color_brewer(palette="Spectral")+
  scale_shape_manual(values=c("是"=1, "否"=19))+
  labs(x     = "同意比例",
       y     = "結婚比例",
       color = "直轄市",
       shape = "原住民鄉鎮市區",
       title = "2018 公投：第 10 案「同意比例」對「結婚比例」") -> output
output

ggsave(filename = "output-plot.pdf",
       plot     = output,
       width    = 25,
       height   = 20,
       unit     = "cm",
       device   = cairo_pdf)
