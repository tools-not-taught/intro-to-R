#!/usr/bin/env Rscript

###############################################################################
# -*- encoding: UTF-8 -*-                                                     #
# Description: An Introduction to Base R                                      #
#                                                                             #
#                                                                             #
# Last Modified: 2023-06-19                                                   #
###############################################################################

### Getting Started ###########################################################

# This file is a R script file. R script files has extension `.R` or `.r`.
#
# The R language uses `<-` or `->` to assign variables.

2 -> something
something <- 1
something

### Basic Data Types ##########################################################

# There are four basic data types:
#
# - logical:   boolean
# - character: character string
# - double:    double-precision floating point numbers
# - integer:   integer
#
# In R, there is no strict differentiation between integer and floating point
# numbers, the integer type is not often specified.
#
# Use function `typeof()` to check the data type of a variable.
#
# There are corresponding functions starting with `as.` to coerce between
# different data types. Only use type coercion when the coercion is
# unambiguous.

## LOGICAL

something <- TRUE
something <- FALSE
something <- NA
typeof(something)

## CHARACTER

something <- "hello, world"
something <- NA_character_
typeof(something)

## NUMERIC

something <- 1.0
something <- 1
something <- 1e10
something <- NaN
typeof(something)

## INTEGER

something <- 1L
something <- NA_integer_
typeof(something)

## TYPE COERCION

as.logical(1) # TRUE
as.logical(0) # FALSE
as.character(1L)
as.numeric("1")
as.integer(1)

### Data Structures ###########################################################

# In most use cases, you are going to deal with data structures, the following
# are the most common ones:
#
# - vector
# - matrix
# - list
# - data.frame
#
# Instead of `typeof()`, use `class()` to check for the type of data
# structures.
#
# In R, everything is a vector. That is, e.g., a single integer is considered
# to be a vector of length one. And since everything is a vector, `typeof()`
# will never say that a variable is a vector, instead it will tell you what
# type is contained in the vector.
#
# The `matrix` class is actually a special case of the `array` class, which
# can be high-dimensional tensors.

## VECTOR

something <- c("a", "b", "c", "d")
something <- letters
something <- LETTERS
something <- c(1,2,3,4,5)
something <- 1:5
something <- c(something, 6)

length(something)
something[1]
something[2:4]

names(something) <- letters[1:length(something)]

## MATRIX

something <- matrix(1:6,  nrow=3)
something <- matrix(1:9,  nrow=3)
something <- matrix(1:9,  ncol=3)
something <- matrix(1:16, ncol=4, byrow=TRUE)
class(something) # "matrix" "array"

dim(something)
nrow(something)
ncol(something)
something[2,3]
something[1:2,]
something[1:2,3:4]
something[5]

## LIST

something <- list("a", c(1,2,3), TRUE)
something <- c(something, "haha")

length(something)

something[1]
class(something[1])

something[[1]]
class(something[[1]])

## DATA.FRAME

data.frame(col1 = 1:20,
           col2 = 2*(1:20),
           col3 = 3*(1:20)) -> something

dim(something)
nrow(something)
ncol(something)
class(something[1,])
class(unlist(something[1,]))

### Syntax: The Pipe ##########################################################

# For R versions after 4.1.0, an operator `|>` is introduced. It is used to
# compose functions and simplify the syntax.
#
# Before R version 4.1.0, an operator `%>%` is provided by the package
# `magrittr`, which performs basically the same functionality as `|>`. This
# package is very popular, so most R users still uses `%>%`.

unlist(something[1,])
something[1,] |> unlist()

### Arithmetics ###############################################################

0L + 66L  # addition
53.2 - 4  # subtraction
2.0 * 2L  # multiplication
3L / 4    # division
9 %% 2    # remainder
9 %/% 2   # integer division

min(1:10)
max(1:10)
sum(1:10)
mean(1:10)
sd(1:10)

sqrt(2)
log(2)
exp(2)

### Linear Algebra ############################################################

something <- matrix(c(1,0,0,1,1,0,1,1,1), nrow=3)

t(something)
something %*% t(something)
solve(something)
solve(something) %*% something

diag(1:3)
diag(something)
diag(something) <- 9

### Vectorization #############################################################

# One feature that makes R particularly useful (and sometimes frustrating) when
# it comes to statistical computation is "vectorization". "Vectorization" means
# that functions that can take single-argument inputs can also take in a vector
# as input and output a vector of outputs. In other languages, "vectorization"
# needs to be explicitly implemented, e.g., in python, one needs to use `map()`
# to vectorize a function (or use packages like `pandas`).
#
# However, implicit vectorization can be dangerous since it is "implicit". That
# is, R will not throw an error when you pass a vector to a function when you
# only intend to pass a single value. So be careful.

1:10 * 2

1:10 + 11:20

1:10 + c(0,1)

log(1:10)
sqrt(1:10)

something <- 1:10 |> sqrt() |> log()
something <- exp(something*2)
something

### Comparisons ###############################################################

# Comparing numbers in R is more intuitive than most other languages, since R
# does not differentiate between floating point and integer values most of the
# time. However, this can also lead to some troubles when you want "exact"
# comparisons. Nevertheless, since R is mostly used to do statistical
# computations rather than general programming, this is rarely a problem.

1.0 == 1
1.0 != 1
1   >  2
1   >= 2
1   <  2
1   <= 2

TRUE  | FALSE
FALSE | FALSE
TRUE  & TRUE
FALSE & TRUE

# If you really need to differentiate a "double" from an "integer":
identical(1L,1.0)

any(1:10 %% 2 == 0)
all(1:10 %% 2 == 0)

c(2,4,6,12) %in% 1:10

### Control Flow ##############################################################

# Control flow syntax is very intuitive in R.
#
# One special thing about `if` in R is that it can be used as a function that
# returns a value. So you can use `<-` to assign a value with the value
# returned by `if`.
#
# In R, you can iterate through "vectors" or "lists". In most cases you iterate
# through vectors. If you are iterating through a list, it almost always means
# that you are doing something wrong.

something <- 105
if ( something %% 2 == 0 ) {
  cat("The number", something, "is divisible by 2.", fill=TRUE)
} else if ( something %% 3 == 0 ) {
  cat("The number", something, "is divisible by 3 but not by 2.", fill=TRUE)
} else {
  cat("The number", something, "is not divisible by 2 or 3.", fill=TRUE)
}

something <- if ( something %% 2 == 0 ) { something } else { something + 1 }

for ( i in 1:10 ) {
  something <- something - i
}

while ( TRUE ) {
  something <- something - 1
  if ( something < 50 ) break
}

### Functions #################################################################

# In R, you declare a function by using the `function` keyword (`\` is simply a
# shorthand for `function` introduced in version 4.1.0).
#
# Technical note: Notice that we use the same assignment syntax `<-` with
# functions, this means that the so called "functions" are actually all
# function references. This shows that R is, in essence, a functional
# programming language. This feature makes passing functions around very easy.

double.it <- function ( number ) {
  number * 2
}

double.it <- \ ( number ) {
  number * 2
}

apply.function <- function ( number, func ) { func(number) }

double.it(1)
apply.function( number = 1,    func = double.it )
apply.function( number = 1,    func = \ ( x ) { x + 3 } )
apply.function( number = 1:10, func = \ ( x ) { x + 3 } )
1:10 |> apply.function( \ ( x ) { x + 3 } )

# In fact, the `apply.function` above is implemented in base R. In the homework
# problem, you will be asked to use the function `lapply` and its variants
# provided by base R that doe essentially the same thing.

### Install Packages ##########################################################

# For most people, using R means installing many specialized packages. In this
# course, I will introduce you to a set of packages --- tidyverse --- that are
# considered by a plurality of R users as "essential," regardless of whether
# you are working in biostatistics, econometrics, etc.

install.packages("magrittr")
library(magrittr)

1:9 |>  sqrt() |>  log() |>  sum()
1:9 %>% sqrt() %>% log() %>% sum()

### Getting Help ##############################################################

# The above are the bare minimum you need to start using R. If you have any
# questions about a particular function, R offerers a pretty good documentation
# system.

?mean
?`|>`
