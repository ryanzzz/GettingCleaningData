# Assumes "plyr" package is installed
library(plyr)

# Download data and store in a designated folder
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

# Merges the training and the test sets to create one data set
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

# Extracts only the measurements on the mean and standard deviation for each measurement
features <- read.table("data/UCI HAR Dataset/features.txt")
mean.col <- sapply(features[,2], function(x) grepl("mean()", x, fixed=TRUE))
std.col <- sapply(features[,2], function(x) grepl("std()", x, fixed=TRUE))
ed_x <- lsdf$x[, (mean.col | std.col)]
message("Feature extraction completed")

# Labels the data set with descriptive variable names
colnames(ed_x) <- features[(mean.col | std.col), 2]

# Uses descriptive activity names to name the activities in the data set
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

# Creates a second, independent tidy data set with the average of each variable for each activity and each subject
tidy <- ddply(newdf, .(subject, activity), function(x) colMeans(x[,1:60]))

# Writes tidy dataset into a csv file
write.csv(tidy, "./data/UCI_HAR_tidy.csv", row.names=FALSE)
write.table(tidy, "./data/UCI_HAR_tidy.txt", row.names=FALSE, sep=",")
message("Tidy CSV/TXT data file creation completed")
