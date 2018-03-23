x <- list.files( pattern = "*.bam" )
x <- x[1:96] # If there are extra bam files, make sure you just have the ones you want - vectors have to be same size for renaming

info <- read.table( file = "info.csv", sep = " ", header = TRUE, row.names = 1, stringsAsFactors = FALSE )
					
					#ID Label
					#1 Whatever
					#2 Something
					#3 AsYouLike
					#4 OtherStuff
					#
					
y <- paste( info[ ,"Plate1" ], ".bam", sep = "" )

file.rename( x, y )
