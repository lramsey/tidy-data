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

tidyData <- function() {
	
	xTrainPath <- paste(getwd(),"/UCI HAR Dataset/train/X_train.txt",sep="")
	xTestPath <- paste(getwd(),"/UCI HAR Dataset/test/X_test.txt",sep="")
	
	if(!(file.exists(xTrainPath))){
		downloadAndUnzip()
	}

	xJoined <- bindDataFrames(xTrainPath, xTestPath)
	xJoined <- addFeaturesHeaderToData(xJoined)

	yTrainPath <- paste(getwd(),"/UCI HAR Dataset/train/y_train.txt",sep="")
	yTestPath <- paste(getwd(),"/UCI HAR Dataset/test/y_test.txt",sep="")

	yFiltered <- organizeActivitiesRow()

	xJoined$activity <- yFiltered

	return(xJoined)
}

organizeActivitiesRow <- function() {
	activitiesPath <- paste(getwd(),"/UCI HAR Dataset/activity_labels.txt",sep="")
	yTrainPath <- paste(getwd(),"/UCI HAR Dataset/train/y_train.txt",sep="")
	yTestPath <- paste(getwd(),"/UCI HAR Dataset/test/y_test.txt",sep="")

	yJoined <- bindDataFrames(yTrainPath, yTestPath)
	activities <- read.table(activitiesPath)
	addInActivities <- function(value){
		return(activities[value,2])
	}

	yFiltered <- sapply(yJoined,addInActivities)
	colnames(yFiltered) <- c("activity")

	return(yFiltered)
}
