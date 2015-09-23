downloadAndUnzip <- function(){
	fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
	destination <- paste(getwd(), "/uci", sep="")
	download.file(fileUrl, destination, "curl")
	files <- unzip(destination)
	return(files)
}

bindDataFrames <- function(path1, path2){
	# path1 <- paste(getwd(),"/uciData/train/X_train.txt",sep="")
	# path2 <- paste(getwd(),"/uciData/test/X_test.txt",sep="")

	dataFrame1 <- read.table(path1)
	dataFrame2 <- read.table(path2)
	joinedDataFrame <- rbind(dataFrame1, dataFrame2)
	return(joinedDataFrame)
}

addFeaturesHeaderToData <- function(dataFrame) {
	featuresPath <- paste(getwd(), "/UCI HAR Dataset/features.txt", sep="")

	features <- read.table(featuresPath)
	names <- as.character(features[[2]])
	colnames(dataFrame) <- names
	return(dataFrame)
}

tidyData <- function() {
	downloadAndUnzip()
	xTrainPath <- paste(getwd(),"/UCI HAR Dataset/train/X_train.txt",sep="")
	xTestPath <- paste(getwd(),"/UCI HAR Dataset/test/X_test.txt",sep="")

	xJoined <- bindDataFrames(xTrainPath, xTestPath)
	xJoined <- addFeaturesHeaderToData(xJoined)

	yTrainPath <- paste(getwd(),"/UCI HAR Dataset/train/y_train.txt",sep="")
	yTestPath <- paste(getwd(),"/UCI HAR Dataset/test/y_test.txt",sep="")

	yJoined <- bindDataFrames(yTrainPath, yTestPath)
	colnames(yJoined) <- c("activity")
	xJoined$activity <- yJoined

	return(xJoined)
}