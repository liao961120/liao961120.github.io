logistic = function(x) 1 / (1 + exp(-x))
rbern = function( p, n=length(p) ) rbinom( n=n, size=1, prob=p )


sim_data = function(n_item=20, n_subj=80, seed=13) {
  set.seed(seed)
  A = rnorm( n=n_subj, mean=0, sd=1 )  # Subjects' ability
  D = seq( -1.6, 1 , length=n_item )  # Items' difficulty
  d = expand.grid( S=1:n_subj, I=1:n_item, KEEP.OUT.ATTRS = FALSE )
  d$R = rbern( logistic(A[d$S] - D[d$I]) )
  d$S = factor(d$S)
  d$I = factor(d$I)
  return(list(
    A=A,
    D=D,
    dat=d
  ))
}


plot_estimate = function(D, A, item_eff, subj_eff) {
  n_item = length(item_eff)
  n_subj = length(subj_eff)
  n_param = n_item + n_subj
  true_eff = c(D, A)
  est_eff = c(-item_eff, subj_eff)
  y_lim = c( min(true_eff, est_eff)-.3, max(true_eff, est_eff)+.3 )
  cols = c( rep(2, n_item), rep(4, n_subj) )
  plot( 1, type="n", ylim=y_lim, xlim=c(1, n_param+1), ylab="Effect" )
  abline( h=0, lty="dashed", col="grey" )
  abline( v=n_item+0.5, col="grey")
  points( true_eff, pch=19, col=cols )
  points( est_eff, col=cols )
  for (i in 1:n_param)
    lines( c(i, i), c(true_eff[i], est_eff[i]), col=cols[i] )
  item = paste0("Items (", n_item, ")")
  subj = paste0("Subjects (", n_subj, ")")
  mtext( c(item, subj), at=c(n_item/2-1, (n_item+n_param)/2+1 ), 
         padj = -.5, col=c(2, 4) )
}
