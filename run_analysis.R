#Environment Setup
install.packages("tidyr")
install.packages("readr")
install.packages("dplyr")
install.packages("lubridate")
install.packages("data.table")
library(tidyr) 
library(readr)
library(dplyr)
library(lubridate)
library(data.table)


#File Downloads from site.
URL1<- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(URL1,destfile = "data1.zip", method = 'curl')
unzip("data1.zip")-> data1


#Reading text file to table
subtest<- read.table("./UCI HAR Dataset/test/subject_test.txt")                       
xtest<- read.table("./UCI HAR Dataset/test/X_test.txt")                         
ytest<- read.table("./UCI HAR Dataset/test/y_test.txt")                            
subtrain<- read.table("./UCI HAR Dataset/train/subject_train.txt")                 
xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt")                         
ytrain <- read.table("./UCI HAR Dataset/train/y_train.txt")
features <- read.table("./UCI HAR Dataset/features.txt")
activity<- read.table("./UCI HAR Dataset/activity_labels.txt")


#Merges the training and test sets to create one data set
subject<- rbind(subtrain,subtest)
x<- rbind(xtrain,xtest)
y<- rbind(ytrain, ytest)


#Extracts only the measurements on the mean and standard deviation for each measurement.
meanNsd <- grep("-mean\\(\\)|-std\\(\\)", features[, 2])
xmeanNsd<- x[, meanNsd]


#Descriptive activity names to name the activities in the data set
names(xmeanNsd) <- toupper(features[meanNsd, 2])
names(xmeanNsd)<- sub("\\(|\\)","", names(xmeanNsd))
activity[, 2] <- sub("_", "", activity[, 2])
y[, 1] = activity[y[, 1], 2]
colnames(y) <- 'Activity'
colnames(subject) <- 'Subject'

#Appropriately labels the data set with descriptive variable names
fdata <- cbind(subject, xmeanNsd, y)

# Creates a second, independent tidy data set with the average of each variable for each activity and each subject

avgdata<- aggregate(fdata, by= list(ACTIVITY=fdata$Activity, SUBJECT=fdata$Subject), FUN = mean)
avgdata <- avgdata[, !(colnames(avgdata) %in% c("Subject", "Activity"))]

#OutPut
View(fdata)
View(avgdata)


#Thanks you.



