## One of the most exciting areas in all of data science right now is wearable 
## computing - see for example this article . Companies like Fitbit, Nike, and 
## Jawbone Up are racing to develop the most advanced algorithms to attract new 
## users. The data linked to from the course website represent data collected from 
##the accelerometers from the Samsung Galaxy S smartphone. A full description is 
## available at the site where the data was obtained:

## http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

## Here are the data for the project:
## https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

## You should create one R script called run_analysis.R that does the following.
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names.
## 5. From the data set in step 4, creates a second, independent tidy data set 
##    with the average of each variable for each activity and each subject.

setwd("~/R/Getting_and_cleaning_data")
library(dplyr)

## 1. Read the files
subjectsTest <- read.table("./data/subject_test.txt")
xTest <- read.table("./data/X_test.txt")
yTest <- read.table("./data/Y_test.txt")
subjectsTraining <- read.table("./data/subject_train.txt")
xTraining <- read.table("./data/X_train.txt")
yTraining <- read.table("./data/Y_train.txt")
features <- read.table("./data/features.txt")
activityLabels <- read.table("./data/activity_labels.txt")

## 2. Merge the datasets and label columns
xDataset <- rbind(xTest, xTraining)
names(xDataset) = as.character(features[,2])
yDataset <- rbind(yTest, yTraining)
names(yDataset) = "activityID"
subjectsDataset <- rbind(subjectsTest, subjectsTraining)
names(subjectsDataset) = "subjectID"
entireDataset <- cbind(subjectsDataset, yDataset, xDataset)

## 3. Generate a new dataset with means and standard deviations

selectedNames <- features$V2[grepl("mean\\(\\)|std\\(\\)", features$V2)]
selectedNames<-c("subjectID", "activityID", as.character(selectedNames))
newDataset <- subset(entireDataset, select = selectedNames)

## 4. Tidy the dataset

tidyData <- aggregate(. ~subjectID + activityID, newDataset, mean)
tidyData$activityID <- factor(tidyData$activityID, labels=c("Walking","Walking Upstairs", "Walking Downstairs", "Sitting", "Standing", "Laying"))
write.table(tidyData, "AcceleroData.txt", sep = "")


