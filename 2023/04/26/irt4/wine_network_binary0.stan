/*
  See wine_inter.R for data and fitting.

// Model
B ~ bernoulli(p),
logit(p) <- J[Jid[i]] + W[Wid[i]] + I[Oj[i], Ow[i]],
W ~ normal(mu, 1),
mu <- a[Ow[i]],

// Prior
matrix[2,2]:I ~ normal(0, 1),
J[i] ~ normal( 0, sigma_J ),
vector[2]: a ~ normal(0, 1)
*/
data{
  int N;    // # responses
  int Nj;   // # judged
  int Nw;   // # wines
  array[N] int R;    // Ordinal response
  array[N] int B;    // Binary response
  array[N] int Jid; 
  array[N] int Wid;
  array[N] int Oj;  // judge origin
  array[N] int Ow;  // wine origin
}
parameters{
  vector[2] b;   // mean wine quality (by origin)
  vector[Nj] zJ;
  vector[Nw] zW;
  vector[Nw] muW;
  real<lower=0> sigma_J;
  real<lower=0> sigma_W;
}
transformed parameters {
    vector[Nj] J;
    vector[Nw] W;
    J = zJ * sigma_J;
    W = muW + zW * sigma_W;
}
model{
  // Submodel 1: W ~ normal( mu, sigma_W )
  b ~ normal( 0, 1.5 );
  muW ~ normal( 0, 1 );
  zW ~ normal( 0 , 1 );
  sigma_W ~ exponential( 1 );
  for ( i in 1:N ) {
    W[Wid[i]] ~ normal( b[Ow[i]], 1 );
  }
  
  // Submodel 2: IRT
  vector[N] phi;
  zJ ~ normal( 0 , 1 );
  sigma_J ~ exponential( 1 );
  for ( i in 1:N ) {
    phi[i] = W[Wid[i]] + J[Jid[i]];
  }
  B ~ bernoulli_logit( phi );
}
