inv_logit = function(x) 1 / (1 + exp(-x))  # Real -> P
logistic = inv_logit

logit = function(p) log( p / (1 - p) )

rbern = function(prob, n=length(prob)) 
  rbinom( n=n, size=1, prob=prob )

rordlogit = function (n, cutpoints, phi) {
  # Aggregate cutpoints and phi to cumulative prob
  cutpoints = c( cutpoints, Inf )
  p_cum = inv_logit( cutpoints - phi )
  
  # Convert cumulative prob to prob
  p_shift =  c( 0, p_cum )[1:length(p_cum)]
  p = p_cum - p_shift
  
  # Sample according to prob of each point
  sample( 1:(length(cutpoints) - 1), size=n, replace=T, prob=p )
}

simple_hist = function( x, ylab="Count", lwd=5, col=2, ... ) {
  counts = table(x)
  if ( tolower(ylab) == "prob" )
    counts = counts / length(x)
  plot( counts, ylab=ylab, lwd=lwd, col=col, ... )
}
