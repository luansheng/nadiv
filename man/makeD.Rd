\name{makeD}
\alias{makeD}
\title{Creates the dominance genetic realationship matrix
}
\description{Given a pedigree, the matrix of coefficients of fraternity are returned - the D matrix. Note, inbreeding is not directly incorporated into the calculation of the coefficients (see Details). Will return the inverse of the D matrix by default, otherwise this operation can be skipped if desired.
}
\usage{
makeD(pedigree, parallel = FALSE, ncores = getOption("mc.cores", 2L),
      invertD = TRUE, returnA = FALSE, det = FALSE)
}
\arguments{
  \item{pedigree }{
A pedigree with columns organized: ID, Dam, Sire}

  \item{parallel }{
Logical, indicating whether computation should be run on multiple processors at once. See details for considerations.}

  \item{ncores }{
Number of cores to use when parallel = TRUE.  Default is maximum available.  Otherwise, set with an integer. See details for considerations.}

  \item{invertD }{
A logical indicating whether or not to invert the D matrix}

  \item{returnA }{
Logical, indicating if the numerator relationship matrix (A) should be stored and returned.}

  \item{det }{
Logical, indicating if the determinant of the D matrix should be returned.}

}
\details{
Missing parents (e.g., base population) should be denoted by either 'NA', '0', or '*'.

There exists no convenient method of obtaining the inverse of the dominance genetic relatedness matrix (or the D matrix itself) directly from a pedigree (such as for the inverse of A, i.e., Quaas (1995)). Therefore, this function computes the coefficient of fraternity (Lynch and Walsh, 1998) for every individual in the pedigree with a non-zero additive genetic relatedness. These coefficients are only approximations that assume no inbreeding. The algorithm used here, however, incorporates inbreeding into the calculation of coefficients of coancestry (using `makeA()`) that are used to calculate coefficients of fraternity. Similarly, the diagonals of the D matrix are corrected for inbreeding. Meaning, the diagonals of D are (1-f) so that the overall dominance genetic variance is equal to (1-f)V_D, where f is the coefficient of inbreeding and V_D is dominance genetic variance. This is interpreted as the amount of dominance genetic variance that would be expected if the allele frequencies in the inbred population were representative of a non-inbred, randomly mating population (Shaw et al. 1998; Wolak and Keller 2014). Note, the construction of the D matrix is more computationally demanding (in computing time and space requirements) than is the construction of A.

To overcome the computational difficulties, this function can enable parallel processing (see package \code{parallel} included in the R distribution) to speed up the execution. Note this may not be possible on Windows (See \code{parallel} documentation for further information), therefore \code{parallel} = TRUE should only be used on Linux or Mac operating systems (i.e., not Windows). The default is to use the maximum number of cpus available to the machine, but this can be restricted by indicating the number desired in the argument \code{ncores}. Setting up the multi-processing takes some overhead, so no real advantage is gained for small pedigrees. Also, since all processes are sharing a fixed amount of RAM, very large pedigrees using many processes in parallel may not be feasible due to RAM restrictions (i.e., if each process needs "n" amount of RAM to run, then \code{ncores} should be set to = total RAM/n). Otherwise the machine can become overworked.  

Note, for very large pedigrees \code{returnA} should be set to FALSE to avoid drastically increasing the memory requirements while making D. When this occurs, 'NULL' is returned for the element of 'A' in the output of \code{makeD}.
}

\value{
  \item{A }{the A matrix in sparse matrix form}
  \item{D }{the D matrix in sparse matrix form}
  \item{logDet }{the log determinant of the D matrix}
  \item{Dinv }{the inverse of the D matrix in sparse matrix form}
  \item{listDinv }{the three column form of the non-zero elements for the inverse of the D matrix}
}
\references{
Quaas, R.L. 1995. Fx algorithms. An unpublished note.

Lynch M., & Walsh, B. 1998. Genetics and Analysis of Quantitative Traits. Sinauer, Sunderland, Massachusetts.

Shaw, R.G., D.L. Byers, and F.H. Shaw. 1998. Genetic components of variation in Nemophila menziesii undergoing inbreeding: Morphology and flowering time. Genetics. 150:1649-1661.

Wolak, M.E. and L.F. Keller. 2014. Dominance genetic variance and inbreeding in natural populations. In Quantitative Genetics in the Wild, A. Charmantier, L.E.B. Kruuk, and D. Garant eds. Oxford University Press, pp. 104-127. 
}
\author{\email{matthewwolak@gmail.com}
}

\seealso{
  \code{\link{makeDsim}} 
}


\examples{
  DinvMat <- makeD(Mrode9, parallel = FALSE)$Dinv
}

