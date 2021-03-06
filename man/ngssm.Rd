% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/models.R
\name{ngssm}
\alias{ngssm}
\title{General univariate non-Gaussian/non-linear state space models}
\usage{
ngssm(y, Z, T, R, a1, P1, distribution, phi, u = 1, xreg = NULL, beta,
  state_names, Z_prior, T_prior, R_prior, state_intercept)
}
\arguments{
\item{y}{Observations as time series (or vector) of length \eqn{n}.}

\item{Z}{System matrix Z of the observation equation. Either a p x m matrix
or a p x m x n array, or object which can be coerced to such.}

\item{T}{System matrix T of the state equation. Either a m x m matrix or a
m x m x n array, or object which can be coerced to such.}

\item{R}{Lower triangular matrix R the state equation. Either a m x k matrix or a
m x k x n array, or object which can be coerced to such.}

\item{a1}{Prior mean for the initial state as a vector of length m.}

\item{P1}{Prior covariance matrix for the initial state as m x m matrix.}

\item{distribution}{distribution of the observation. Possible choices are
\code{"poisson"}, \code{"binomial"}, and \code{"negative binomial"}.}

\item{phi}{Additional parameter relating to the non-Gaussian distribution.
For Negative binomial distribution this is the dispersion term, and for other
distributions this is ignored.}

\item{u}{Constant parameter for non-Gaussian models. For Poisson and negative binomial distribution, this corresponds to the offset
term. For binomial, this is the number of trials.}

\item{xreg}{Matrix containing covariates.}

\item{beta}{Regression coefficients. Used as an initial
value in MCMC. Defaults to vector of zeros.}

\item{state_names}{Names for the states.}

\item{Z_prior, T_prior, R_prior}{Priors for the NA values in system matrices.}

\item{state_intercept}{Intercept terms for state equation, given as a
m times n matrix.}
}
\value{
Object of class \code{ngssm}.
}
\description{
Construct an object of class \code{ngssm} by defining the corresponding terms
of the observation and state equation:
}
\details{
\deqn{p(y_t | Z_t \alpha_t), (\textrm{observation equation})}
\deqn{\alpha_{t+1} = T_t \alpha_t + R_t \eta_t, (\textrm{transition equation})}

where \eqn{\eta_t \sim N(0, I_k)} and
\eqn{\alpha_1 \sim N(a_1, P_1)} independently of each other, and \eqn{p(y_t | .)}
is either Poisson, binomial or negative binomial distribution.
}
