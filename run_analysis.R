tidyData <- function() {
	# load reshape 2 package, or install if package not found
	loadOrInstallReshap2()

	xTrainPath <- paste(getwd(),"/UCI HAR Dataset/train/X_train.txt",sep="")
	xTestPath <- paste(getwd(),"/UCI HAR Dataset/test/X_test.txt",sep="")
	# if file does not exist, then dataset probably not downloaded, so download and unzip
	if(!(file.exists(xTrainPath))){
		downloadAndUnzip()
	}
	# merge train and test X data sets
	xJoined <- bindDataFrames(xTrainPath, xTestPath)
	# add descriptive variable names to headers for xJoined
	xJoined <- addFeaturesHeaderToData(xJoined)
	# remove all columns that do not arise from a mean() or std() variable
	xMeanSTD <- keepOnlyMeanAndSTD(xJoined)

	yFiltered <- organizeActivitiesRow()

	#finish steps 1-4, by adding labeled activities to tr
	xMeanSTD$activity <- yFiltered

	xMelted <- melt(xMeanSTD, id.vars <-"activity")
	xAverages <- dcast(xMelted, ... ~ "average_measurements", mean)

	write.table(xAverages, row.names=FALSE,file="/Users/luke/rWorkspace/project/output")
	return(xAverages)

}

loadOrInstallReshap2 <- function(){
	if(!require("reshape2")){
		install.packages("reshape2")
		require(reshape2)
	}
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
	#remove non-standard variable name characters, replacing - with _ and () with ""
	properFeatures <- removeNonStandardFeatureCharacters(features[[2]])
	names <- as.character(properFeatures)
	colnames(dataFrame) <- names
	return(dataFrame)
}

removeNonStandardFeatureCharacters <- function(features) {
	noHyphenParamsFeature <- gsub("[[:punct:]]", "_", features)
	removeExtraUnderscoreFeature <- gsub("__", "_", noHyphenParamsFeature)
	removeExtraUnderscoreAgainFeature <- gsub("__", "_", removeExtraUnderscoreFeature)
	removeBadCharactersAfterSTD <- gsub("std_", "std", removeExtraUnderscoreAgainFeature)
	removeBadCharactersAfterMean <- gsub("mean_", "mean", removeBadCharactersAfterSTD)
	return (removeBadCharactersAfterMean)
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
