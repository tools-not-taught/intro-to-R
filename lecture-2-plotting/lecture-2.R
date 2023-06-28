#!/usr/bin/env Rscript

###############################################################################
# -*- encoding: UTF-8 -*-                                                     #
# Description: An Introduction to plotting with ggplot                        #
#                                                                             #
#                                                                             #
# Last Modified: 2023-06-26                                                   #
###############################################################################

# In the last part of lecture 1, we used `ggplot` to visualize the relation
# between referendum and marital status data. In this lecture, you will learn
# how to produce such plots with `ggplot`.
#
# In this lecture, we will introduce you to the following topics.
#
# 1. Basics: 
#     - mapping: (aesthetics) the mapping between data and attributes of plot
#     - layer:   (geom's) the realization of graphics according to attributes
#     - facet:   (facet) plot stratified plots
#     - stat:    (stat's) alternative to layers
#     - coord:   (coor's) coordinate systems
#
# 2. Visuals:
#     - scale: change the look of what is plotted by the layers (manually)
#     - theme: use of predefined themes to make you plot look pretty
#
# The first part "Basics" is about how data is mapped to specific plots, e.g.,
# scatter plot, bar plot, density plot, etc; the second part "Visuals" is
# about how to change the 'looks', e.g., color, size, font, etc, of the plots.

library(tidyverse)
chinese_font <- "Noto Sans CJK KR"

### Read Clean Referendum Data ################################################

data.path        <- function ( file ) { paste0("./data/",file) }
indigenous_sites <- read_csv(data.path("indigenous-sites.csv"))$site_id
municipalities   <- c("臺北市","新北市","桃園市","臺中市","臺南市","高雄市")
county_types     <- c(municipalities, "其他")
chinese_font     <- "Noto Sans CJK KR"

data <- data.path("referendum-cleaned.csv") %>% read_csv() %>%
  mutate(county       = str_extract(site_id, "^...")) %>%
  mutate(indigenous   = site_id %in% indigenous_sites) %>%
  mutate(indigenous   = if_else(indigenous, "是", "否")) %>%
  mutate(indigenous   = factor(indigenous, levels=c("是", "否"))) %>%
  mutate(municipality = county  %in% municipalities) %>%
  mutate(municipality = if_else(municipality, county, "其他")) %>%
  mutate(municipality = factor(municipality, levels=county_types)) %>% 
  relocate(county, site_id) %>% 
  arrange(municipality)

### Basics ####################################################################

# All plots are composed of the three basic parts:
#
# 1. data (the information you want to visualise),
# 2. a mapping (the description of how the data's variables are mapped to
#    aesthetic attributes), and
# 3. layers (specific realizations of graphics).

data %>% # data
  ggplot()+
  aes(x = agree_percentage,
      y = once_married_percentage)+ # mapping
  geom_point() # layer

data %>%
  ggplot()+
  aes(x     = agree_percentage,
      y     = once_married_percentage,
      shape = indigenous,
      color = indigenous,
      label = site_id)+
  geom_point()+
  geom_text(family=chinese_font)+
  theme(text=element_text(size=12, family=chinese_font))

### Layers ####################################################################

## geom_density
## geom_histogram

approximate_density <- function (x) dnorm(x, mean=0.765, sd=0.033)
data %>% 
  ggplot()+
  aes(x = agree_percentage)+
  geom_density()+
  geom_function(fun=approximate_density, color="red")

data %>% 
  ggplot()+
  aes(x     = agree_percentage,
      color = municipality,
      fill  = municipality)+
  geom_density(alpha=0.5)+
  theme(text=element_text(size=12, family=chinese_font))

## geom_

data %>% 
  ggplot()+
  aes(x = agree_percentage,
      y = once_married_percentage,
      color = indigenous
      )+
  geom_point()+
  geom_rug(sides="b", color="red",  alpha=0.2)+
  geom_rug(sides="l", color="blue", alpha=0.2)+
  geom_smooth(method="lm", se=FALSE)+
  theme(text=element_text(size=12, family=chinese_font))

# geom_function(fun = \ (x){10*x^2})

data %>% 
  ggplot()+
  aes(x = municipality,
      y = once_married_percentage)+
  geom_col()+
  theme(text=element_text(size=12, family=chinese_font))

data %>% 
  ggplot()+
  aes(x = municipality,
      y = agree_percentage)+
  geom_boxplot()+
  theme(text=element_text(size=12, family=chinese_font))

data %>% 
  ggplot()+
  aes(x = agree_percentage,
      y = once_married_percentage)+
  geom_density_2d()+
  geom_point()

###############################################################################

iris %>% head()

iris %>%
  ggplot()+
  aes(x=Sepal.Width, y=Sepal.Length, color=Species)+
  geom_jitter()

mpg %>%
  ggplot()+
  aes(x=displ, y=hwy)+
  geom_jitter(color="red", alpha=0.2)+
  facet_wrap(vars(class))
