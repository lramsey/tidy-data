#Getting and Cleaning Data Project

This is a class project the Getting and Cleaning Data coursera class, using a UCI [data set](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) describing data captured from the accelerometers on Samsung Galaxy S smartphones.  Also, [here](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) is a description of the data set.  The goal here is to use R and tidy data principles to turn this complex data set into one that is simple and easy to take in at a glance. I shall list the five requirements below.

1.	Merges the training and the test sets to create one data set.  
2.	Extracts only the measurements on the mean and standard deviation for each measurement.  
3.	Uses descriptive activity names to name the activities in the data set.  
4.	Appropriately labels the data set with descriptive variable names.  
5.	From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.  

##Loading and Configuring Environment

When the run_analysis.R is executed through the source("run_analysis.R") command, the tidyData function is called.  This function begins by attempting to load the R package reshape2, through the loadOrInstallReshape2 function.  This function uses the require function to attempt to load the package.  That function returns false if the package has not been installed, so in that case loadOrInstallReshape2 installs and then loads the package.

After this is done, the next step is to determine if the proper data set currently exists in R's working directory.  The x_Train.txt within the UCI data set is checked to see if it exists.  If that file does not exist, then the data set is downloaded as a zip file and then unzipped.  Now the data set is loaded in the working directory, and we can begin processing the data.

## Joining X data sets and adding headers

Requirement 1 of this assignment is to merge the train and test data sets into one set. Using the bindDataFrames function, I will read the two X data sets and merge them into one data set in memory, xJoined.  Requirement 1 is not complete as of yet, though, because I have not joined the y columns with it at this point. That will occur later though.

Following this step, I then proceed to address requirement 4 from the assignment, adding descriptive headers to the data set following proper R variable styling.  The addFeaturesHeaderToData function reads a features.txt file from the UCI data set and selects the feature names.  Then, the features are run into the removeNonStandardFeatureCharacters, where the gsub function is used to remove non standard R variable characters.  After further processing, the features are joined with the passed in dataFrame.  Now xJoined has descriptive feature headers, completing requirement 4.

## Use Only Mean and Std

The next step in my process addresses requirement 2 for the assignment: removing all measurement columns that do not concern the mean and std.  Looking at the features_info.txt file, I observed that a series of functions are called in the raw UCI data, among which is mean() and std().  To accomplish requirement 2, I called the keepOnlyMeanAndSTD function, passing in data fram xJoined.  After reading the list of features from features.txt, my next goal was to use sapply and function hasMeanOrSTD create a logical vector concerning whether the feature met the rule of only mean or std, or if it did not.  

hasMeanOrSTD uses the grepl function to check if the feature name string contains a substring of "mean" or "std".  However, there is a distinct method listed in the features_info.txt file called "meanFreq."  Since requirement 2 specifically asked for just mean and std, I decided to exclude that value by using grepl to return a boolean True value if meanFreq was not present.  After sapply creates the logical vector, this will be used to subset the passed in data frame xJoined to the new data frame xMeanSTD, which statisfies requirement 2.

## Descriptive Activity Labels

The next step concerns requirement 3, adding descriptive activity labels to the y data set.  For this, I called organizeActivitiesRow, which reads y train and test columns to memory, merges them, and then adds descriptive activity names to as the values of the columns.  With this properly formatted y column saved in variable yFiltered, requirement 3 is complete.

Now, with xMeanSTD and yFiltered in memory, I am in position to finish requirement 1, combining the X and y train and testdata set to one data set.  By adding yFiltered into xMeanSTD tied to variable activity, the xMeanSTD data set now meets all the criteria listed in requirements 1 - 4.

## Second Tidy Data Set

Now I address requirement 5, creating a second data set with the average for each variable, activity, and subject(I interpreted subject to mean feature). I used melt and dcast from the reshape 2 library to change the data set to the required format, passing the mean method to that data set to gain the average.  This creates xAverages, which satisfies requirement 5.

## Conclusion

To conclude the tidyData function, I write xAverages to a txt file named tidyDataSet.txt.  Then, I return xAverages.

This concludes the run_analysis.R script, which has satisfied requirements 1 - 5 and created the required data sets.
