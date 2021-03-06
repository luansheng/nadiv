\name{prepPed}
\alias{prepPed}
\title{Prepares a pedigree by sorting and adding 'founders'
}
\description{
This function takes a pedigree, adds missing founders, and then sorts the pedigree.
}
\usage{
prepPed(pedigree, gender = NULL, check = TRUE)
}
\arguments{
  \item{pedigree }{
An object, where the first 3 columns correspond to: ID, Dam, & Sire. See details.
}
  \item{gender }{
An optional character for the name of the column in \code{pedigree} that corresponds to the gender/sex of individuals.  If specified, \code{prepPed} will assign a gender to any founders it adds to the pedigree. 
}
  \item{check }{
A logical argument indicating if checks on the validity of the pedigree structure should be made
}
}
\details{
Many functions (both in nadiv and from other programs) dealing with pedigrees must first sort a pedigree such that individuals appear in the ID column in rows preceeding where they appear in either the Dam or Sire column.  Further, these functions and programs require that all individuals in the dam and sire columns of a pedigree also have an entry in the ID column.  This function easily prepares data sets to accommodate these requirements using a very fast topological sorting algorithm.
   
NOTE: more columns than just a pedigree can be passed in the \code{pedigree} argument.  In the case of missing founders, these columns are given NA values for all rows where founders have been added to the pedigree.  The entire object supplied to \code{pedigree} is ordered, ensuring that all information remains connected to the individual 

Missing parents (e.g., base population) should be denoted by either 'NA', '0', or '*'.

When a non-null argument is given to \code{gender}, dams without an entry in the ID column (that are subsequently added to the pedigree) are given the gender designated for other dams (and similarly for sires). 

The \code{check} argument performs checks on the format of the pedigree supplied to try and identify any issues regarding the notation of missing values and validity of the basic pedigree for further processing.
}

\seealso{\code{\link[nadiv]{genAssign}}, \code{\link[nadiv]{prunePed}}}


\value{
The pedigree object (can have more columns than just ID, Dam, and Sire), where: (1) the ID column cotains an ID for all individuals from the original pedigree object's ID, Dam, and Sire columns (i.e., founders are added) and (2) the pedigree is now sorted so that individuals are not in rows preceding either their Dam or Sire. 
}

\examples{

# First create an unordered pedigree with (4) missing founders
  warcolak_unsuitable <- warcolak[sample(seq(5, nrow(warcolak), 1),
	size = (nrow(warcolak) - 4), replace = FALSE), ]
  nrow(warcolak)
  nrow(warcolak_unsuitable)
# Fix and sort the pedigree
## Automatically assign the correct gender to the added founders
### Also sort the data accompanying each individual
  warcolak_fixed_ordered <- prepPed(warcolak_unsuitable, gender = "sex")
  head(warcolak_fixed_ordered)
}



