##################################################################################
#This function plots the HBD probabilities by segments                           #
#                                                                                #
#!!! Submaps : the list of object                                                #                                       
#!!! unit : cM or Bases                                                          #
#!!! regions : a region to be emphasize in the plot                              #
#!!! outfile: (optional) a name for the plot                                     #
#!!! famid : the family id                                                   #
#!!! id = the individual id                                           #
#                                                                                #
#*** return a plot                                                               #
##################################################################################

plotHBDSegmentsId <- function(Submaps, unit= "cM", id, famid, regions, outfile, build)
{
  if(!is.character(id))
    return("Need individual id as character")
  if(!is.character(famid))
    return("Need family id as character")
  
  HBD.recap <- Submaps@HBD_recap
  HBDsegments <- Submaps@HBDsegments
  
  # individuals_name <- rownames(HBD.recap)#get the name of the individual
  # individuals_name <- strsplit(individuals_name, "_")
  # individuals_name <- sapply(individuals_name, function(i) match(i[2], Submaps@bedmatrix@ped$id))
  # family_id <- Submaps@bedmatrix@ped$famid[individuals_name]
  # individuals_name <- Submaps@bedmatrix@ped$id[individuals_name]
  
  # id   <- which(individuals_name == id)
  
  # if(length(id) == 0)
  #  stop("No individual found")
  
  HBDsegments_rbind <- do.call(rbind, HBDsegments) #binding lines 
  
  HBD <- HBDsegments_rbind[which(HBDsegments_rbind$id==id & HBDsegments_rbind$famid==famid),]
  
  if(nrow(HBD) == 0)
    if ((id %in% Submaps@submap_summary$id & famid %in% Submaps@submap_summary$famid ) == FALSE)
      stop("No individual found, check spelling of id and famid")
    else if (Submaps@submap_summary$quality[which(Submaps@submap_summary$id == id & Submaps@submap_summary$famid == famid)]<95)
      stop("No HBD segment evaluation for this individual because of low QUALITY (<95)")
    else if(Submaps@submap_summary$inbred[which(Submaps@submap_summary$id == id & Submaps@submap_summary$famid == famid)] == FALSE)
      stop("Individual with good QUALITY (>95) but No HBD segment evaluation because he is not inbred")
  
  #regions options
  if (missing(regions)) 
    myreg <- NULL
  else
    myreg <- regions
  
  #name the file
  if (missing(outfile)) 
    outfile <- paste("HBD_", id,"_",unit,".png",sep="")
  else {
    outfile <- paste(outfile,".png",sep="") 
  }
  
  plotSegmentsId(fileOrSubmaps=HBD, unit = unit, regions = myreg, main=paste("HBDsegments of", uniqueIds(famid, id)), build=build)
}

