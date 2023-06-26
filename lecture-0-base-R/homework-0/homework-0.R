#!/usr/bin/env Rscript

###############################################################################
# -*- encoding: UTF-8 -*-                                                     #
# Description: Hoemwork 0 - The `lapply` function.                            #
#                                                                             #
#                                                                             #
# Last Modified: 2023-06-19                                                   #
###############################################################################

# In `lecture-0.R`, I demonstrated that functions in R can be passed around as
# arguments. In R, it is very common to pass function around as arguments,
# especially in the context of using functions such as `lapply` and its
# variants. This also relates to the comment I mode in `lecture-0.R` that you
# should probably not iterate through lists.
#
# In this homework, I will provide you with two scenarios in which the use
# `lapply` is very natural. The first is about arithmetics, the second is about
# data wrangling.
#
# Before you start, take a look and the documentation for `lapply` and answer
# the question: What is the difference between `lapply` and `sapply` in terms
# of output type?

?lapply

### Problem 1 #################################################################

# In econometrics, there is a function called `logit`. The logit takes a number
# between 0 and 1 as input, and outputs the logarithm of the corresponding
# odds. The definition of logit can be found on Wikipedia:
# `https://en.wikipedia.org/wiki/Logit`.
#
# In this problem, you tasked to implement the `logit` function and learn to
# use `sapply` and `lapply`.

# 1. Implement the `logit` function.

logit <- function ( prob ) {
  # TODO: implement the logit function
}

# 2. Apply the logit function to the list of probabilities provided below with
#    vectorization.
#
#    You should get `-Inf -1.386294 1.386294 Inf` as the answer.

probabilities <- c(0, 0.2, 0.8, 1)
logits.vectorized <- logit(probabilities)

# 3. Apply the logit function to the list of probabilities with `sapply`. Check
#    that the result you get is identical to the result obtain in 2. by using
#    `all`.

logits.sapply <- sapply(
                        # TODO: what should the syntax be here?
                        )
all( logits.sapply == logits.vectorized )

### Problem 2 #################################################################

# When you are dealing with data, you are often presented with a lot of files
# that are named systematically. In this scenario, you are presented with 100
# files that are all named with prefix "data-" and with extension ".csv". Each
# file contains different numbers of rows. You are tasked to find the maximum
# number of rows in all the files.
#
# In reality, finding the number of rows is not that interesting, but this
# problem shows you how to efficiently apply functions to a large number of
# data.frames.  In the next lecture, I will show you how to actually manipulate
# data.frames.

# 1. Create a vector of filenames with funtion `paste0`: `paste0` is used to
#    concatenate strings, so you can use it to create the vector of filenames
#    that all starts with "data-" and ends with ".csv".  Make sure to use R's
#    vectorization to make the code simple.

?paste0

vector.of.filenames <- # TODO: use `paste0` to generate a vector of filenames

# 2. Read all the files in `vector.of.filenames` and store them in a list: In
#    this step you will use the function `lapply` and `read.csv`. That is, you
#    will "apply" the function `read.csv` to all the filenames in
#    `vector.of.filenames`. The output should be a list of length 100 in which
#    each element is a data.frame.
#
#    Notice that this step can also be achieved by using a for-loop, but by
#    using `lapply`, you make the code more readable and less error-prone.

?read.csv

list.of.data.frames <- # TODO: use `lapply` to read the files

# 3. Get the number of rows for each data.frame in `list.of.data.frames` and
#    find the maximum: In this step you should use `sapply` to obtain the row
#    numbers as a vector, and then pass it to `max()` using the pipe `|>`.
#
#    You should get 104 as the answer.

max.number.of.rows <- # TODO: use `sapply` and `nrow`, then pipe it to `max`

# 4. Bonus: Chain all previous three steps with `|>` and obtain the answer
#    directly. Something like:
#
#    (generate filenames) |>
#      (read the files as data.frames) |>
#      (get number of rows for each data.frame) |>
#      (get max number)
