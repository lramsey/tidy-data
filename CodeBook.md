# Codebook

This is the codebook for the coursera assignment, where I will discuss the variables in the output file tidyDataSet.txt, and how this data set was constructed.

The data output from run_analysis.R contains three variable columns: activity, variable, and average_measurement.  This data set was gained through manipulations of the UCI [data set](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip), which is briefly described in the readme.

I will now describe each column variable.

## Column Variables

### activity

The values in the activity column consists of the labels listed in the activity_labels.txt file, listed below. These lables describe actioins a person using a cell phone may take.

WALKING  
WALKING_UPSTAIRS  
WALKING_DOWNSTAIRS  
SITTING  
STANDING  
LAYING  

This information is tied to the activity_labels y_train.txt and y_test.txt files in the data set, which are intended to serve as the predictive outcome of a supervised algorithm operating on the X_train and X_test files.  The y files, however, list their results as numbers that map to more identifying labels in the activity_labels.txt file.

### variable  

The variable column contains a subset (mean and std) of the labels of the different physical measurements that were carried out to populate the X_train and X_test files.  The labels, however, are not contained in the X files, but instead in the features.txt file, which must be mapped to the X file values. Using the grepl function to check substrings, I was able to exclude all listed features that did not match my acceptance criteria of only recording mean() and std() operations on physical measurements.  The entire list of operations on physical measurements is recorded in the features_info.txt file.

The variable names have been transformed from the style of name listed in features.txt to a style that is more consistent with R variable naming conventions.  In particular, character combinations such "-" as "()" have been removed.  I used the gsub function to find string patterns and remove them.

### average_measurement  

This column consists of a collection of the average measurement values (as described in the variable column) in the X_train and X_test data sets, when activity appears as it does in the activity column.  For example, an average measurement tied to variable tBodyAcc_meanX and activity WALKING is derived from an average of the set of all tBodyAcc_meanX measurements where the activity is WALKING. This ends the variable description section.

## Data Transformations

I will now expand on how the data transformations that led to the data set's creation, particularly the average_measurement column. To join the X training and test sets together, I used the rBind method for joining to append the test set to the bottom of the training sets.  I then formatted the X feature headers and added them to the joined X data set.  I subsetted the X set to only contain mean and std values.  I then joined together the y training and test sets, mapped the descriptive activity names to my y column in memory, and then appended the y column to the end of the xMeanSTD data frame.

To transform this data frame to the ultimate output described above, I utilized the reshape2 melt function, assigning activity as the id variable.  This transformed the data to only be three columns, and associated an activity to a feature name and measurement value where that activity was found.  Then, using dcast, I collapsed the various measurements for the same activity and feature through the mean function.  Now, I have achieved an "average_measurement", for a given feature "variable" and "activity".
