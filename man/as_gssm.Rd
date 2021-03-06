% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/as_gssm.R
\name{as_gssm}
\alias{as_gssm}
\alias{as_ngssm}
\title{Convert SSModel Object to gssm or ngssm Object}
\usage{
as_gssm(model, kappa = 1e+05, ...)

as_ngssm(model, kappa = 1e+05, phi_prior, ...)
}
\arguments{
\item{model}{Object of class \code{SSModel}.}

\item{kappa}{For \code{SSModel} object, a prior variance for initial state
used to replace exact diffuse elements of the original model.}

\item{...}{Additional arguments to \code{gssm} and \code{ngssm}.}

\item{phi_prior}{For non-Gaussian model, prior for parameter phi.}
}
\value{
Object of class \code{gssm} or \code{ngssm}.
}
\description{
Converts \code{SSModel} object of \code{KFAS} package to 
\code{gssm} or \code{ngssm} object.
}
