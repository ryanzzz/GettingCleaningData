# CodeBook

This is a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data.

## Data Source

- [Original data](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)
- [Original description of the dataset](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

## Data Set Information

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

## Files in Original Dataset

The dataset includes the following files:

- **'README.txt'**: General information.
- **'features_info.txt'**: Shows information about the variables used on the feature vector.
- **'features.txt'**: List of all features.
- **'activity_labels**.txt': Links the class labels with their activity name.
- **'train/X_train.txt'**: Training set.
- **'train/y_train.txt'**: Training labels.
- **'test/X_test.txt'**: Test set.
- **'test/y_test.txt'**: Test labels.

The following files are available for the train data. 

- **'train/subject_train.txt'**: Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.
- **'train/Inertial Signals/total_acc_x_train.txt'**: The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis.
- **'train/Inertial Signals/body_acc_x_train.txt'**: The body acceleration signal obtained by subtracting the gravity from the total acceleration.
- **'train/Inertial Signals/body_gyro_x_train.txt'**: The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second.

Equivalent files can be found in the test data.

## Data Operation

The project expects to realize following data manipulation via an R script called *run_analysis.R*:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive activity names.
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Procedures to Run the Script

Please refer to the **'Readme.md'** file in the same repo of this CookBook.

## Code Implementation Explanation

This part of codes downloads data and stores in a designated folder
```
wdpath <- getwd()
if (!file.exists("data")) {
    message(c("Creating data directory in ", wdpath))
    dir.create("data")
}
if (!file.exists("data/UCI HAR Dataset")) {
    # download the data
    fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    zipfile="data/UCI_HAR_data.zip"
    message("Downloading data")
    download.file(fileURL, destfile=zipfile, method="curl", quiet=TRUE) 
    unzip(zipfile, exdir="data")
}
```

This part of codes merges the training and the test sets to create one data set
```
message("Please wait while reading...")
training.x <- read.table("data/UCI HAR Dataset/train/X_train.txt")
training.y <- read.table("data/UCI HAR Dataset/train/y_train.txt")
training.subject <- read.table("data/UCI HAR Dataset/train/subject_train.txt")
test.x <- read.table("data/UCI HAR Dataset/test/X_test.txt")
test.y <- read.table("data/UCI HAR Dataset/test/y_test.txt")
test.subject <- read.table("data/UCI HAR Dataset/test/subject_test.txt")
message("Reading completed")
merged.x <- rbind(training.x, test.x)
merged.y <- rbind(training.y, test.y)
merged.subject <- rbind(training.subject, test.subject)
lsdf <- list(x=merged.x, y=merged.y, subject=merged.subject) 
```

This part of codes extracts only the measurements on the mean and standard deviation for each measurement
```
features <- read.table("data/UCI HAR Dataset/features.txt")
mean.col <- sapply(features[,2], function(x) grepl("mean()", x, fixed=TRUE))
std.col <- sapply(features[,2], function(x) grepl("std()", x, fixed=TRUE))
ed_x <- lsdf$x[, (mean.col | std.col)]
message("Feature extraction completed")
```

This part of codes labels the data set with descriptive variable names, and uses descriptive activity names to name the activities in the data set
```
colnames(ed_x) <- features[(mean.col | std.col), 2]
colnames(lsdf$y) <- "activity"
lsdf$activity[lsdf$activity == 1] = "WALKING"
lsdf$activity[lsdf$activity == 2] = "WALKING_UPSTAIRS"
lsdf$activity[lsdf$activity == 3] = "WALKING_DOWNSTAIRS"
lsdf$activity[lsdf$activity == 4] = "SITTING"
lsdf$activity[lsdf$activity == 5] = "STANDING"
lsdf$activity[lsdf$activity == 6] = "LAYING"
colnames(lsdf$subject) <- c("subject")
message("Renaming variables completed")
newdf <- cbind(ed_x, lsdf$y, lsdf$subject)
message("Rebuilding data complete")
```

This part of codes creates a second, independent tidy data set with the average of each variable for each activity and each subject
```
tidy <- ddply(newdf, .(subject, activity), function(x) colMeans(x[,1:60]))
```

This part of codes writes tidy dataset into a csv file
```
write.csv(tidy, "./data/UCI_HAR_tidy.csv", row.names=FALSE)
write.table(tidy, "./data/UCI_HAR_tidy.txt", row.names=FALSE, sep=",")
message("Tidy CSV/TXT data file creation completed")
```
