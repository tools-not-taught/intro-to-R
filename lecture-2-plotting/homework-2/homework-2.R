#!/usr/bin/env Rscript

###############################################################################
# -*- encoding: UTF-8 -*-                                                     #
# Description: An Introduction to plotting with ggplot                        #
#                                                                             #
#                                                                             #
# Last Modified: 2023-06-19                                                   #
###############################################################################

# In the last part of lecture 1, we used ggplot

library(tidyverse)
library(ggrepel)

read_csv("V1.csv") %>%
  filter(is.na(`請問你接觸、學習中文幾年了呢，請以數字作答（ex. 1.5、6）？`)) %>%
  filter(`請問你是中文母語使用者嗎？` == "是") %>%
  select(-Zeitstempel,
         -`聯絡方式（ex. Email or FB or IG or Line or 手機號碼）`,
         -`請問你是中文母語使用者嗎？`,
         -`請問你接觸、學習中文幾年了呢，請以數字作答（ex. 1.5、6）？`) %>%
  gather(key="cat", value="quantifier") %>%
  group_by(cat) %>%
  count(quantifier) %>%
  spread(quantifier, n, fill = 0) %>%
  select("item"=cat,
         "fu"=副,
         "dui"=對,
         "shuang"=雙) %>%
  mutate(item = if_else(str_length(item)>5,
						str_extract(item, "\\[.+\\]") %>% str_remove_all("[\\[\\]]"),
						str_c("[",item,"]"))) %>%
  mutate(mm = if_else(max(fu,dui,shuang)==fu,"fu",
                      if_else(max(fu,dui,shuang)==dui,"dui","shuang"))) %>%
  ungroup() %>% 
  mutate(temp_total = fu + dui + shuang) %>%
  mutate(fu = fu/temp_total,
         dui = dui/temp_total,
         shuang = shuang/temp_total) %>%
  mutate(mm = if_else(mm=="dui","對",if_else(mm=="shuang","雙","副"))) %>%
  ggplot() + aes(x=dui, y=shuang, label=item, color=mm) +
  geom_text_repel(family="Noto Sans CJK KR", max.overlaps = 40) +
  geom_point() +
  labs(color="最多人選什麼？",
       title="「 雙對副」量詞類分群 (有\"[]\"的是圖片)",
       x="對",
       y="雙") +
  theme(text = element_text(family = 'Noto Sans CJK KR')) -> plot.1
ggsave("plot-1.pdf", plot=plot.1, width=15, height=20, unit="cm", device=cairo_pdf)
