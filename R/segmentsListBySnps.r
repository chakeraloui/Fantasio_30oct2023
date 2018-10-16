#' Creation of a list of segments 
#' 
#' Creates a list of segments delimited by gaps in the genome.
#' 
#' @param bedmatrix a bed.matrix object 
#' @param gap the minimum gap after which a segment is created
#' @param minMarkers the minimum number of markers in a mini-segment
#' @param nbSegments the number of mini-segments which the segment will be splitted 
#' @param unit the \code{gap} unit, "cM" or "Bases" "cM" 
#' @param verbose if \code{TRUE}, displays information on the process
#' 
#' @details This function is used to create an object of class snpsSegments. It contains a list of segments 
#' delimited by gaps between available markers. Each segment is splitted in nbSegments mini-segments.
#' @details A segment is not splitted if it would result in mini-segments shorter that minMarkers.
#' The indices in the mini-segemnts correspond to SNPs in bedmatrix.

#' @return an snpsSegments object
#' 
#' @seealso \code{\link{Fantasio}}, \code{\link{segmentsListBySnps}}
#' 
#' @examples  
#' #Please refer to vignette 
#'
#' @export
segmentsListBySnps <- function(bedmatrix, gap=0.5, minMarkers=50, nbSegments=20, unit="cM", verbose=TRUE)
{
  if(class(bedmatrix)[1] != "bed.matrix" )
  {
    stop("Need a bed.matrix")
  }
  
  
  if( unit != "Bases" & unit != "cM")
    stop("Error only cM or Bases are accepted")
  if(unit =="Bases")
    gap <- gap * 1e6
  
  # start and end of a segments
  if(verbose) cat("Finding segments for the genome : ")
  VI <- list()
  for(i in getOption("gaston.autosomes"))
  {
    cat(".")
    chr_distances <- bedmatrix@snps$dist[which(bedmatrix@snps$chr==i)]
    if(length(chr_distances) == 0)
      next()
    
    k <- c()
    for(j in 1:length(chr_distances))
    {
      if(j == length(chr_distances))
        next()
      if(chr_distances[j+1] - chr_distances[j] > gap)
        k <- c(k, j, (j+1) )
    }
    
    segment <- cbind( c(0, k[c(FALSE,TRUE)]), 
                      c(k[c(TRUE,FALSE)],Inf))  
    
    
    
    VI[[i]] <- segment
  }
  VI <- VI[!sapply(VI,is.null)]
  
  if(verbose) cat("\n")
  # number of snps in a chr
  VII <- table(bedmatrix@snps$chr)
  VII <- VII[getOption("gaston.autosomes")]
  
  
  #find the marker of a segment
  if(verbose) cat("Finding which markers are between two segments: ")
  shift <- sapply(getOption("gaston.autosomes"), function(i) which(bedmatrix@snps$chr == i)[1]) - 1L
  
  VIII <- list()
  for(i in 1:length(VI))
  {
    cat(".")
    chr_segments <- VI[[i]]
    mkr <- seq(1, VII[i])
    chr <- list()
    for(j in 1:nrow(chr_segments))
    {
      b <- which(mkr >= chr_segments[j,1] & mkr <= chr_segments[j,2])
      if(length(b)==0) next()
      chr[[j]] <- b + shift[[i]]
    }
    VIII[[i]] <- chr
  }
  if(verbose) cat("\n")
  
  for(i in 1:length(VIII))
    VIII[[i]] <- null.remover(VIII[[i]])
  
  #finding the mini segments
  if(verbose) cat("Finding mini segments ")
  VIV <- list()
  for(i in 1:length(VIII))
  {
    cat(".")
    temp <- list()
    for(j in 1:length(VIII[[i]]))
    {
      if((length(VIII[[i]][[j]]) / nbSegments) >= minMarkers ) #>= minMarkers in one segments 
      {
        #decouper le segment en N (=nbSegments) mini-segments de taille T (=length(VIII[[i]][[j]])/nbSegments) marqueurs.
        #si T est un entier, la taille du mini-segment est exactement T
        #si T n'est pas un entier, la taille est round(T) ou round(T)+1 en fonction des resultats de ceiling(...)
        #La proportion de mini-segments de taille round(T)+1 augmente lorsque T approche de round(T)+1
        #Note: cette commande donne toujours exactement N (=nbSegments) mini-segments (commentaire en section details egalement)
        l <- split(VIII[[i]][[j]], ceiling(seq_along(VIII[[i]][[j]])/(length(VIII[[i]][[j]])/nbSegments))) 
        temp[[j]] <- l
      }else{
        temp[[j]] <- VIII[[i]][[j]]
      }
    }
    VIV[[i]] <- temp
    VIV[[i]] <- null.remover(VIV[[i]])
  }
  if(verbose) cat("\n")
  
  new("snpsSegments", gap, unit, VIV)
}
