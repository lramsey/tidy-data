tidyData <- function() {
	if(!require("reshape2")){
		install.packages("reshape2")
		require(reshape2)
	}

	xTrainPath <- paste(getwd(),"/UCI HAR Dataset/train/X_train.txt",sep="")
	xTestPath <- paste(getwd(),"/UCI HAR Dataset/test/X_test.txt",sep="")
	
	if(!(file.exists(xTrainPath))){
		downloadAndUnzip()
	}

	xJoined <- bindDataFrames(xTrainPath, xTestPath)
	xJoined <- addFeaturesHeaderToData(xJoined)
	xMeanSTD <- keepOnlyMeanAndSTD(xJoined)

	yTrainPath <- paste(getwd(),"/UCI HAR Dataset/train/y_train.txt",sep="")
	yTestPath <- paste(getwd(),"/UCI HAR Dataset/test/y_test.txt",sep="")

	yFiltered <- organizeActivitiesRow()

	xMeanSTD$activity <- yFiltered

	xMelted <- melt(xMeanSTD, id.vars <-"activity")
	xAverages <- dcast(xMelted, ... ~ "average", mean)

	return(xAverages)

}

downloadAndUnzip <- function(){
	fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
	destination <- paste(getwd(), "/uci", sep="")
	download.file(fileUrl, destination, "curl")
	files <- unzip(destination)
	return(files)
}

bindDataFrames <- function(path1, path2){
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

keepOnlyMeanAndSTD <- function(frame){
	featurePath <- paste(getwd(),"/UCI HAR Dataset/features.txt", sep="")
	features <- read.table(featurePath)
	logical <- sapply(features[,2], hasMeanOrSTD)
	smallerFrame <- frame[,logical]
	return(smallerFrame)
}

hasMeanOrSTD <- function(feature){
	return((grepl("mean", feature) | grepl("std", feature)) & (!grepl("meanFreq", feature)))
}

organizeActivitiesRow <- function() {
	
	yTrainPath <- paste(getwd(),"/UCI HAR Dataset/train/y_train.txt",sep="")
	yTestPath <- paste(getwd(),"/UCI HAR Dataset/test/y_test.txt",sep="")

	yJoined <- bindDataFrames(yTrainPath, yTestPath)
	activitiesPath <- paste(getwd(),"/UCI HAR Dataset/activity_labels.txt",sep="")
	activities <- read.table(activitiesPath)

	yFiltered <- sapply(yJoined,addInActivities, activities)
	colnames(yFiltered) <- c("activity")

	return(yFiltered)
}

addInActivities <- function(value, activities){
	return(activities[value,2])
}

tidyData()
