// #include "ngssm.h"
// #include "ng_bsm.h"
// #include "svm.h"
// #include "backtrack.h"
// #include "summary.h"
// #ifdef _OPENMP
// #include <omp.h>
// #endif
// 
// template <typename T>
// void is_correction_bsf_summary(T mod, const arma::mat& theta,
//   const arma::vec& ll_store, const arma::uvec& counts, unsigned int nsim_states,
//   unsigned int n_threads, arma::vec& weights_store, arma::mat& alphahat, arma::cube& Vt, 
//   arma::mat& mu, arma::cube& Vmu, bool const_m, const arma::uvec& seeds) {
//   
//   unsigned n_iter = theta.n_cols;
//   
//   alphahat.zeros();
//   Vt.zeros();
//   mu.zeros();
//   Vmu.zeros();
//   arma::cube Valpha(mod.m, mod.m, mod.n, arma::fill::zeros);
//   arma::cube Vmu2(1, 1, mod.n, arma::fill::zeros);
//   double cumsumw = 0;
//   
// #pragma omp parallel num_threads(n_threads) default(none)                      \
//   shared(n_threads, ll_store, n_iter, nsim_states, theta, \
//     weights_store, counts, alphahat, Vt, Valpha, mu, Vmu, Vmu2, cumsumw, const_m, seeds) firstprivate(mod)
//     {
// #ifdef _OPENMP
//       if (n_threads > 1) {
//         mod.engine = std::mt19937(seeds(omp_get_thread_num()));
//       }
// #endif
// #pragma omp for schedule(static)
//       for (unsigned int i = 0; i < n_iter; i++) {
//         
//         arma::vec theta_i = theta.col(i);
//         mod.update_model(theta_i);
//         
//         unsigned int m = nsim_states;
//         if (!const_m) {
//           m *= counts(i);
//         }
//         arma::cube alpha(mod.m, mod.n, m);
//         arma::mat w(m, mod.n);
//         arma::umat ind(m, mod.n - 1);
//         double ll = mod.particle_filter(m, alpha, w, ind);
//         backtrack_pf(alpha, ind);
//         weights_store(i) = exp(ll - ll_store(i));
//         
//         arma::mat alphahat_i(mod.m, mod.n);
//         arma::cube Vt_i(mod.m, mod.m, mod.n);
//         running_weighted_summary(alpha, alphahat_i, Vt_i, w.col(mod.n - 1));
//         arma::mat mu_i(1, mod.n);
//         arma::cube Vmu_i(1, 1, mod.n);
//         running_weighted_summary(mod.invlink(alpha), mu_i, Vmu_i, w.col(mod.n - 1));
// #pragma omp critical
// {
//   double w =  weights_store(i) * counts(i);
//   
//   
//   arma::mat diff = alphahat_i - alphahat;
//   arma::mat diff_mu = mu_i - mu;
//   
//   
//   double tmp = w + cumsumw;
//   alphahat += diff * w / tmp;
//   for (unsigned int t = 0; t < diff.n_cols; t++) {
//     Valpha.slice(t) +=  w * diff.col(t) * (alphahat_i.col(t) - alphahat.col(t)).t();
//   }
//   Vt += (Vt_i - Vt) * w / tmp;
//   
//   mu += diff_mu * w / tmp;
//   for (unsigned int t = 0; t < diff_mu.n_cols; t++) {
//     Vmu2.slice(t) +=  w * diff_mu.col(t) * (mu_i.col(t) - mu.col(t)).t();
//   }
//   Vmu += (Vmu_i - Vmu) * w / tmp;
//   cumsumw = tmp;
// }
// 
//       }
//     }
//   Vt = Vt + Valpha/cumsumw;
//   Vmu = Vmu + Vmu2/cumsumw;
// }
// 
// template void is_correction_bsf_summary<ngssm>(ngssm mod, const arma::mat& theta, 
//   const arma::vec& ll_store, const arma::uvec& counts, unsigned int nsim_states,
//   unsigned int n_threads, arma::vec& weights_store, arma::mat& alphahat, arma::cube& Vt, 
//   arma::mat& mu, arma::cube& Vmu, bool const_m, const arma::uvec& seeds);
// template void is_correction_bsf_summary<ng_bsm>(ng_bsm mod, const arma::mat& theta,
//   const arma::vec& ll_store, const arma::uvec& counts, unsigned int nsim_states,
//   unsigned int n_threads, arma::vec& weights_store, arma::mat& alphahat, arma::cube& Vt, 
//   arma::mat& mu, arma::cube& Vmu, bool const_m, const arma::uvec& seeds);
// template void is_correction_bsf_summary<svm>(svm mod, const arma::mat& theta,
//   const arma::vec& ll_store, const arma::uvec& counts, unsigned int nsim_states,
//   unsigned int n_threads, arma::vec& weights_store, arma::mat& alphahat, arma::cube& Vt, 
//   arma::mat& mu, arma::cube& Vmu, bool const_m, const arma::uvec& seeds);