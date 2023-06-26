#!/usr/bin/env Rscript

###############################################################################
# -*- encoding: UTF-8 -*-                                                     #
# Description: An Introduction to plotting with ggplot                        #
#                                                                             #
#                                                                             #
# Last Modified: 2023-06-19                                                   #
###############################################################################

# In the last part of lecture 1, we used ggplot
#
# All plots are composed of the data, the information you want to visualise,
# and a mapping, the description of how the data’s variables are mapped to
# aesthetic attributes. There are five mapping components:
#
# - data
# - mapping
# - layer
# - facet
# - scale
# - theme
#
# cheat sheet
# https://www.analyticsvidhya.com/blog/2022/03/a-comprehensive-guide-on-ggplot2-in-r/
# https://ggplot2-book.org/

library(tidyverse)

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
