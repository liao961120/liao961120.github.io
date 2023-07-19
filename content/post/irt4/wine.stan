/*
    See wine0.R for data and fitting.
      
      // Model
      R ~ ordered_logistic( phi, cutpoints )
      phi = J[Jid] + W[Wid]
      
      // Prior
      cutpoints ~ normal( 0, 1 )
      W ~ normal( 0, sigma_W )
      J ~ normal( 0, sigma_J )
      sigma_W ~ exponential( 1 )
      sigma_J ~ exponential( 1 )
*/
data{
    int N;    // # responses
    int Nj;   // # judged
    int Nw;   // # wines
    int Nc;   // # cutpoints
    array[N] int R;
    array[N] int Jid;
    array[N] int Wid;
}
parameters{
    ordered[Nc] cutpoints;
    vector[Nw] zW;
    vector[Nj] zJ;
    real<lower=0> sigma_W;
    real<lower=0> sigma_J;
}
transformed parameters {
    vector[Nw] W;
    vector[Nj] J;
    W = zW * sigma_W;
    J = zJ * sigma_J;
}
model{
    vector[N] phi;
    zW ~ normal( 0 , 1 );
    zJ ~ normal( 0 , 1 );
    sigma_W ~ exponential( 1 );
    sigma_J ~ exponential( 1 );
    cutpoints ~ normal( 0 , 1 );
    for ( i in 1:N ) {
        phi[i] = W[Wid[i]] + J[Jid[i]];
    }
    R ~ ordered_logistic( phi, cutpoints );
}
generated quantities{
    vector[N] log_lik;
    {
        vector[N] phi;
        for ( i in 1:N ) {
            phi[i] = W[Wid[i]] + J[Jid[i]];
            log_lik[i] = ordered_logistic_lpmf( R[i] | phi[i] , cutpoints );
        }
    }
}
