\name{makeAstarMult}
\alias{makeAstarMult}
\title{
Creates the inverse additive genetic relationship matrix with genetic groups
}
\description{
This returns the invers of the additive genetic relationship matrix with genetic groups (A*). The matrix is set up through matrix multiplication of two sub-matrices instead of directly (as \code{\link{makeAinv}} does).
}
\usage{
makeAstarMult(pedigree, ggroups, fuzz = NULL, gOnTop = FALSE)
}

\arguments{
  \item{pedigree }{
A pedigree where the columns are ordered ID, Dam, Sire
}
  \item{ggroups }{
Either a vector with the unique name of each genetic group, or a numeric indicating the number of unique genetic groups. See Details for different ways to specify. Note, cannot be NULL.
}
  \item{fuzz }{
A matrix containing the fuzzy classification of individuals into genetic groups.
}
  \item{gOnTop }{
A logical indicating if the A-inverse should be constructed with the `g` genetic groups located in the first `g` rows and columns if TRUE, else the `g` genetic groups are located in the last `g` rows and columns of A-inverse
}
}

\details{
Missing parents (e.g., base population) should be denoted by either 'NA', '0', or '*'.

The function implements the matrix multiplication, using sub-matrices \code{Q} and \code{A^-1}, as detailed in Quaas (1988, pp. 1342-1343).

Genetic groups can be incorporated into the A-inverse by providing a value to the \code{ggroups} argument. The value supplied to \code{ggroups} can either be (1) a single integer indicating the number of unique genetic groups or (2) a character vector containing the name for each genetic group. These are referred to as pedigree types "A" and "D", respectively, and further details follow below.
  (Type="A") the pedigree contains unique IDs for the 'g' genetic groups in the first 'g' lines of the pedigree. The dam and sire of the genetic group rows should contain missing values (e.g., NA, "0", or "*"). All individuals in the pedigree should then have one of the 'g' genetic groups instead of an unknown parent.
  (Type="D") the pedigree contains only individuals in the ID column (no genetic groups have an ID) and there should be no missing values for any dams or sires. Instead, individuals for whom the dam and/or sire is unknown should have one of the genetic groups identified in the vector supplied to \code{ggroups} as the dam or sire.
  
Fuzzy classification of genetic groups is implemented when \code{fuzz} is non-NULL.

The argument to \code{gOnTop} specifies if the elements in the A-inverse should come at the beggining (\code{gOnTop = TRUE}) or end (\code{gOnTop = FALSE}) of the matrix. Depending on how the software implementing an animal model solves the mixed model equations, the equations for the genetic groups (and thus the elements in the augmented A-inverse) should be the first or last set of equations.

See function \code{\link{makeAinv}} for directly obtaining the inverse of the additive genetic relationship matrix with genetic groups.
}

\value{
Returns A*, or the inverse of the numerator relationship with groups, in sparse matrix form.
}

\references{
Quaas, R.L. 1988. Additive genetic model with groups and relationships. Journal of Dairy Science. 71:1338-1345.
}

\author{\email{matthewwolak@gmail.com}}

\seealso{\code{\link{makeAinv}}, \code{\link{ggcontrib}}}

\examples{
 # Using the Q1988 dataset in nadiv
 ## assign a null fuzzy classification matrix
 QfuzzNull <- matrix(c(1,0,0,1,0, 0,1,1,0,1), nrow = 5, ncol = 2,
	dimnames = list(letters[1:5], c("g1", "g2")))

 # Type A
 ## no fuzzy classification
  Astar_A <- makeAstarMult(Q1988[-c(3:7), c(1,4,5)], ggroups = 2)
 ## with fuzzy classification
  Astar_Afuzzy <- makeAstarMult(Q1988[, c(1, 6, 7)],
	ggroups = 2, fuzz = QfuzzNull)

 # Type D
 ## no fuzzy classification
  Astar_D <- makeAstarMult(Q1988[-c(1:7), c(1, 4, 5)], ggroups = c("g1", "g2"))
 ## with fuzzy classification
  Astar_Dfuzzy <- makeAstarMult(Q1988[-c(1:2), c(1, 6, 7)],
	ggroups = c("g1", "g2"), fuzz = QfuzzNull)


 # Obtain the matrix directly 
 ## no fuzzy classification
 Astar_direct <- makeAinv(Q1988[-c(3:7), c(1,4,5)], ggroups = 2)$Ainv
 stopifnot(length(drop0(round(Astar_direct
	- (Astar_A - Astar_Afuzzy)
	- (Astar_D - Astar_Dfuzzy)
	- Astar_direct, 10))@x) == 0)

 ## with fuzzy classification
 Astar_directF <- makeAinv(Q1988[-c(1:2), c(1, 6, 7)], fuzz = QfuzzNull)$Ainv
 stopifnot(length(drop0(round(Astar_directF
	- (Astar_A - Astar_Afuzzy)
	- (Astar_D - Astar_Dfuzzy)
	- Astar_direct, 10))@x) == 0)
 
}


