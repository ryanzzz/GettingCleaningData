# Getting and Cleaning Data Project

## Objectives

This project will create an R script called *run_analysis.R* that does the following:
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive activity names.
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Procedures

1. Download the R script *run_analysis.R* onto your hard drive, preferrably your R working directory
2. Run ```source("run_analysis.R")``` in R. The program assumes a folder called *data* exists in your working directory, and a subfolder called *UCI HAR Dataset* folder under the *data* folder containing the unzipped data downloaded from the given web site.
3. If *data* or *UCI HAR Dataset* does not exist in your working directory, the program will create them, download the necessary *UCI_HAR_data.zip* file from the given web site, and then unzip to the *UCI HAR Dataset* subfolder.
4. The program generates two tidy datasets, one in CSV format and the other in TXT format in the *data* folder. The *UCI_HAR_tidy.csv* is easier to read as a spreadsheet, and the *UCI_HAR_tidy.txt* file is for project submission.

## Dependencies

*run_analysis.R* file assumes "plyr" package is already installed.
