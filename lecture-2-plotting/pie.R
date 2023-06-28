#!/usr/bin/env Rscript

###############################################################################
# -*- encoding: UTF-8 -*-                                                     #
# Author:                                                                     #
#                                                                             #
#                                                                             #
# Last Modified: OOOO-OO-OO                                                   #
###############################################################################
library(conflicted)
library(data.table)
library(tidyverse)
###############################################################################

rm(list=ls()); gc()
options(scipen=999999)
options(datatable.verbose=FALSE)
set.seed(1234)

###############################################################################



list(tibble(type     = rep("Winner Pay", 5),
            variable = c("(1st, 2nd)",
                         "(2nd, 1st)",
                         "(1st, Low)",
                         "(2nd, Low)",
                         "(Low, Other)"),
            mean     = c(71.8, 11.8, 11.4, 2.7, 2.3)),
     tibble(type     = rep("All Pay", 5),
            variable = c("(1st, 2nd)",
                         "(2nd, 1st)",
                         "(1st, Low)",
                         "(2nd, Low)",
                         "(Low, Other)"),
            mean     = c(37.0, 12.2, 28.8, 9.0, 13))) %>% rbindlist() -> data

library(ggrepel)

data %>%
  ggplot()+
  aes(x="", y=mean, fill=variable)+
  geom_bar(stat="identity")+
  geom_text_repel(aes(label=mean),
                  position      = position_stack(vjust=0.5),
                  color         = "white",
                  segment.color = "transparent",
                  force_pull    = 10)+
  coord_polar("y", start=0)+
  facet_wrap(~type)+
  labs(x="", y="")
