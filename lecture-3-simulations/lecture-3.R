#!/usr/bin/env Rscript

###############################################################################
# -*- encoding: UTF-8 -*-                                                     #
# Description: An Introduction to doing simulations in R                      #
#                                                                             #
#                                                                             #
# Last Modified: 2023-06-19                                                   #
###############################################################################

library(tidyverse)

### Consistent v.s. Unbiased ##################################################

S.square.biased <- function ( samples ) {
  sum((samples-mean(samples))^2) / length(samples)
}

S.square.unbiased <- function ( samples ) {
  sum( ( samples - mean(samples) )^2 ) / ( length(samples) - 1 )
}

sample.size <- 1e5
samples <- 1:sample.size |> lapply( \ (x) rnorm(10) )
1 - sapply(samples, S.square.biased)   |> mean()
1 - sapply(samples, S.square.unbiased) |> mean()

samples <- rnorm(sample.size)
S.square.biased(samples)
S.square.unbiased(samples)

### Maximum Likelihood Estimation #############################################

true.para       <- list()
true.para$mu    <- -2
true.para$sigma <- 5
sample.size     <- 1e3
samples         <- rnorm(sample.size,
                         mean = true.para$mu,
                         sd   = true.para$sigma)

data.frame(x=samples) |>
  ggplot()+
  aes(x=x)+
  geom_density()+
  geom_function(color    = "red",
                linetype = "dashed",
                fun      = \ (x) dnorm(x,
                                       mean = true.para$mu,
                                       sd   = true.para$sigma))+
  labs(y="")

log.likelihood <- function ( para, data=samples ) {
  dnorm(data,
        mean = para$mu,
        sd   = para$sigma) |> log() |> sum()
}

vec2list <- function ( vec ) list(mu=vec[1],sigma=vec[2])
list2vec <- function ( lis ) unlist(lis)

optim(par     = c(0,1),
      fn      = \ ( vec ) -log.likelihood(vec2list(vec)),
      method  = "L-BFGS-B",
      hessian = TRUE,
      control = list(trace=TRUE)) -> output

### MCMC ######################################################################

dtriangle2 <- ( function ( x ) {
  if ( x < 0.00 ) return( 0 )
  if ( x < 0.25 ) return( 8 * x )
  if ( x < 0.50 ) return( 4 - 8 * x )
  if ( x < 0.75 ) return( -4 + 8 * x )
  if ( x < 1.00 ) return( 8 - 8 * x )
  return(0)
} ) |> Vectorize(vectorize.args="x")

mcmc <- function ( trials, target.den ) {
  output <- rep(0, trials)
  x      <- runif(1)
  for ( trial in 1:trials ) {
    y <- runif(1)
    if ( runif(1) < target.den(y) / target.den(x) ) { x <- y }
    output[trial] <- x
  }
  output
}

# compare the MCMC stationary distribution to the theoretical density.
plot.density <- function ( chain, target.den=dtriangle ) {
  plot <- as.data.frame(chain) |> ggplot() +
    aes(x=chain) +
    geom_density() +
    geom_function(fun=target.den,linetype="dashed") +
    xlim(0,1) +
    ylim(0,2.2) +
    ylab("density") +
    labs(title=paste0("MCMC Stationary Distribution: ",length(chain)," samples"))
  return( plot )
}

ggplot() + geom_function(fun=dtriangle2, linetype="dashed")

output.seq <- c(seq(1e0,1e1,1e0),
                seq(1e1,1e2,1e1),
                seq(1e2,1e3,1e3),
                seq(1e3,1e4,1e3),
                1e4)

data <- mcmc(1e4, target.den=dtriangle2)

for ( progress in output.seq ) {
  plot <- plot.density(head(data,n=progress), target.den=dtriangle2)
  ggsave(paste0("mcmc_density/mcmc_density-",progress,".pdf"),
         plot=plot, width=20, height=10, unit="cm")
}
