% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/setSummary.r
\name{setSummary}
\alias{setSummary}
\title{Creation summary statistic files}
\usage{
setSummary(
  atlas,
  list.id,
  probs = TRUE,
  recap.by.segments = FALSE,
  q = 1e-04,
  HBD.threshold = 0.5,
  quality = 95,
  n.consecutive.markers = 5,
  phen.code = c("plink", "R")
)
}
\arguments{
\item{atlas}{a atlas object}

\item{list.id}{you can either :
- ignore this parameter if you want to compute HBD, FLOD and HFLOD 
  for individuals who are considerated inbred and with a quality
  greater or equal to 95%}
- enter a list of individual for a computation of HBD, FLOD score HFLOD score for them
- use "all" for a computation of HBD, FLOD score and HFLOD score for every individual}

\item{probs}{a flag indicating if the HBD probabilities and FLOD score has been computed for the submaps (default is TRUE)}

\item{recap.by.segments}{if the summary files has to be computed considering segments or snps (defaut is FALSE) 
(more information in the documentation of `makeAtlasByHotspots` or`makeAtlasByDistance` functions)}

\item{q}{Allows the user to choose the assumed frequency of the mutation involved in the disease for each individual (default is 0.0001)}

\item{HBD.threshold}{value of the HBD probability threshold used to determine whether a segment is HBD or not (default is 0.5)}

\item{quality}{The minimum percentage use to assume if a submap is valid (default is 95)}

\item{n.consecutive.markers}{the number of consecutive markers with a probability equal or greater to the value of the threshold, to be used to find HBDsegments (default is 5)}
}
\value{
return an atlas containing every summary created
}
\description{
This function is uses to ouput all the summary files after the creation of the atlas by the following two functions : 
`makeAtlasByHotspots` and `makeAtlasByDistance` is over.
}
\details{
the function add content to the atlas object.

- summary for likelihood0/likelihood1

- summary for estimation of a and f

- summary for the submaps

- summary for HBD probabilities

- summary for HFLOD

- comutation of HBDsegments
}
\seealso{
\code{\link{Fantasio}}

\code{\link{makeAtlasByDistance}}

\code{\link{segmentsListByHotspots}}

\code{\link{festim}}

\code{\link{setHBDProbAndFLOD}}

\code{\link{setHBDProbAndFLODBySnps}}

\code{\link{setHFLOD}}

\code{\link{submapLikelihood}}

\code{\link{submapEstim}}

\code{\link{submapSummary}}
}
