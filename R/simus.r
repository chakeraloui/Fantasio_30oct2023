
random.msat <- function(N, a, f, map, freq) {

  ## copy paste de la methode initialize
  delta.dist <- diff(map$distance)
  # traiter proprement les changements de chromosomes
  I <- cumsum(rle(map$chr)$length)
  I <- I[-length(I)]
  delta.dist[I+1] <- -1

  a <- rep_len(a, N)
  f <- rep_len(f, N)
  S <- Y <- NULL
  for(i in 1:N) {
    s <- .Call('festim_simu0', PACKAGE = "Fantasio", delta.dist, a[i], f[i])
    S <- cbind(S, s)
    Y <- cbind(Y, .Call('festim_simu_geno', PACKAGE = "Fantasio", s, freq))
  }
 
  list(S = S, 
       X = new("msat.matrix", ncol = nrow(map), nrow = N, ped = data.frame(fam = 1:N, id = 1, father = 0, mother = 0, sex = 1, pheno = 2),
                  msat = Y, map = map, freq = freq))
}


