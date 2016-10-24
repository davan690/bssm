#' Particle Smoothing
#'
#' Function \code{particle_smoother} performs filter-smoother or forward-backward smoother,
#' using a either bootstrap filtering or psi-auxiliary filter with stratification resampling.
#'
#' @param object Model.
#' @param nsim Number of samples.
#' @param smoothing_method Either \code{"fs"} (filter-smoother), or \code{"fbs"} 
#' (forward-backward smoother).
#' @param filter_type Either \code{"bootstrap"} for bootstrap filter, or \code{"psi"}
#' for psi-auxiliary filter. Latter is only applicable for non-Gaussian/non-linear models.
#' @param seed Seed for RNG.
#' @param ... Ignored.
#' @export
#' @rdname particle_smoother
particle_smoother <- function(object, nsim, ...) {
  UseMethod("particle_smoother", object)
}
#' @method particle_smoother gssm
#' @rdname particle_smoother
#' @export
particle_smoother.gssm <- function(object, nsim, smoothing_method = "fs",
  seed = sample(.Machine$integer.max, size = 1), ...) {

  smoothing_method <- match.arg(smoothing_method, c("fs", "fbs"))
  out <- gssm_particle_smoother(object, nsim, seed, smoothing_method == "fs")

  rownames(out$alpha) <- names(object$a1)
  out$alpha <- aperm(out$alpha, c(2, 1, 3))
  out
}

#' @method particle_smoother bsm
#' @export
particle_smoother.bsm <- function(object, nsim, smoothing_method = "fs",
  seed = sample(.Machine$integer.max, size = 1), ...) {

  smoothing_method <- match.arg(smoothing_method, c("fs", "fbs"))
  out <- bsm_particle_smoother(object, nsim, seed, smoothing_method == "fs")

  rownames(out$alpha) <- names(object$a1)
  out$alpha <- aperm(out$alpha, c(2, 1, 3))
  out
}
#' @rdname particle_smoother
#' @method particle_smoother ngssm
#' @export
particle_smoother.ngssm <- function(object, nsim, smoothing_method = "fs", 
  filter_type = "bootstrap", seed = sample(.Machine$integer.max, size = 1), ...) {
  
  smoothing_method <- match.arg(smoothing_method, c("fs", "fbs"))
  filter_type <- match.arg(filter_type, c("bootstrap", "psi"))
  if (smoothing_method == "fbs" && filter_type == "psi") {
    stop("FBS with psi-filter is not yet implemented.")
  }
  object$distribution <- pmatch(object$distribution, c("poisson", "binomial", "negative binomial"))
 
  out <- ngssm_particle_smoother(object, nsim, seed, smoothing_method == "fs", 
    filter_type == "bootstrap", object$init_signal)
  
  rownames(out$alpha) <- names(object$a1)
  out$alpha <- aperm(out$alpha, c(2, 1, 3))
  out
}
#' @method particle_smoother ng_bsm
#' @export
particle_smoother.ng_bsm <- function(object, nsim, smoothing_method = "fs", 
  filter_type = "bootstrap", seed = sample(.Machine$integer.max, size = 1), ...) {
  
  smoothing_method <- match.arg(smoothing_method, c("fs", "fbs"))
  filter_type <- match.arg(filter_type, c("bootstrap", "psi"))
  if (smoothing_method == "fbs" && filter_type == "psi") {
    stop("FBS with psi-filter is not yet implemented.")
  }
  object$distribution <- pmatch(object$distribution, c("poisson", "binomial", "negative binomial"))
  out <- ng_bsm_particle_smoother(object, nsim, seed, smoothing_method == "fs", 
    filter_type == "bootstrap", object$init_signal)
  
  rownames(out$alpha) <- names(object$a1)
  out$alpha <- aperm(out$alpha, c(2, 1, 3))
  out
}
#' @method particle_smoother svm
#' @export
particle_smoother.svm <- function(object, nsim, smoothing_method = "fs", 
  filter_type = "bootstrap", seed = sample(.Machine$integer.max, size = 1), ...) {
  
  smoothing_method <- match.arg(smoothing_method, c("fs", "fbs"))
  filter_type <- match.arg(filter_type, c("bootstrap", "psi"))
  if (smoothing_method == "fbs" && filter_type == "psi") {
    stop("FBS with psi-filter is not yet implemented.")
  }
  out <- svm_particle_smoother(object, nsim, seed, smoothing_method == "fs", 
    filter_type == "bootstrap", object$init_signal)

  rownames(out$alpha) <- names(object$a1)
  out$alpha <- aperm(out$alpha, c(2, 1, 3))
  out
}