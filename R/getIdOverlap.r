#' @param pheno : c("case", "control", "all") 
#' @param phen.code : c("plink", "R") 
#' @export

get_id_overlap <- function(bedmatrix, lim, chr, pheno = "all", phen.code = "plink") {
  
  HFLOD <- bedmatrix@HFLOD
  HFLOD_chr <- HFLOD[(HFLOD$chr == chr & HFLOD$HFLOD >= lim),]
  HFLOD_snps <- as.character(HFLOD_chr$snps)
  start <- HFLOD_chr$pos_cM[1]
  end <- HFLOD_chr$pos_cM[nrow(HFLOD_chr)]
  
  HBD_segments <- bedmatrix@HBDsegments
  HBDsegments_rbind <- do.call(rbind, HBD_segments)
  HBD <- subset(HBDsegments_rbind, HBDsegments_rbind$chromosome==chr)
  
  if(phen.code == 'plink') {
    if(pheno == "case"){
      HBD <- subset(HBD, HBD$pheno == 2)
    }else if(pheno == "control"){
      HBD <- subset(HBD, HBD$pheno == 1)
    }
  }else {
    if(pheno == "case"){
      HBD <- subset(HBD, HBD$pheno == 1)
    }else if(pheno == "control"){
      HBD <- subset(HBD, HBD$pheno == 0)
    }
  }
  
  list_id <- unique(unlist(lapply(rownames(HBD), function(x) HBDOverlap(x, HBD, start, end))))
  
  return(list_id)
}
