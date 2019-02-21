# Load libraries
library(plyr);library(dplyr)

# Download Data
if(!file.exists("./data")){dir.create("./data")}
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile = "./data/Dataset.zip")

# Unzip data
unzip(zipfile = "./data/Dataset.zip", exdir = "./data" )
filePath <- file.path("./data", "UCI HAR Dataset")
files <- list.files(filePath, recursive = TRUE)
files

# Read data
activityTestDt <- read.table(file.path(filePath, "test", "Y_test.txt"), header = FALSE)
subjectTestDt <- read.table(file.path(filePath, "test", "subject_test.txt"), header =FALSE)
featuresTestDt <- read.table(file.path(filePath , "test", "X_test.txt"), header = FALSE)

activityTrainDt <- read.table(file.path(filePath, "train", "Y_train.txt"), header = FALSE)
subjectTrainDt <- read.table(file.path(filePath, "train", "subject_train.txt"), header =FALSE)
featuresTrainDt <- read.table(file.path(filePath , "train", "X_train.txt"), header = FALSE)

# Data properties
str(activityTestDt)
str(subjectTestDt)
str(featuresTestDt)
# ...

# read activity labels
activities <- read.table(file.path(filePath, "activity_labels.txt"))
colnames(activities) <- c("activityId", "activityLabel")

# read features
features <- read.table(file.path(filePath, "features.txt"), as.is = TRUE)
features

#################
# 1.	Merges the training and the test sets to create one data set.

# concate individual datasets
sensorsData <- rbind(cbind(subjectTestDt, activityTestDt,   featuresTestDt),
                      cbind(subjectTrainDt,  activityTrainDt,  featuresTrainDt))

# assign column names
colnames(sensorsData) <- c("subject", "activityId", features[,2] )

#################
# 2.	Extracts only the measurements on the mean
#      and standard deviation for each measurement. 

# determine columns to be kept on column name...
columnsToKeep <- grepl("subject|activityId|mean|std", colnames(sensorsData) )

# ... and keep data in the columns only
sensorsData <- sensorsData[, columnsToKeep]

#################
# 3.	Uses descriptive activity names to name the activities in the data set

sensorsData <- join(sensorsData, activities, by = "activityId", match="first")

#################
# 4.	Appropriately labels the data set with descriptive variable names. 

# Remove parentheses
names(sensorsData) <- gsub('[\\(|\\)-]',"",names(sensorsData), perl=TRUE)

# Rename columns with more interpretable names
names(sensorsData) <- gsub("Acc", "Acceleration", names(sensorsData))
names(sensorsData) <- gsub("Mag", "Magnitude", names(sensorsData))
names(sensorsData) <- gsub("Gyro", "AngularSpeed", names(sensorsData))
names(sensorsData) <- gsub("GyroJerk", "AngularAcceleration", names(sensorsData))
names(sensorsData) <- gsub("^t", "Time", names(sensorsData))
names(sensorsData) <- gsub("^f", "Frequency", names(sensorsData))
names(sensorsData) <- gsub("Freq", "Frequency", names(sensorsData))
names(sensorsData) <- gsub("mean", "Mean", names(sensorsData))
names(sensorsData) <- gsub("std", "StandardDeviation", names(sensorsData))

###############
# 5.	From the data set in step 4, creates a second, independent tidy data set 
#     with the average of each variable for each activity and each subject.

sensorAvg <- ddply(sensorsData, c("subject", "activityLabel"), numcolwise(mean))
write.table(sensorAvg, file="sensorTidyData.txt", row.name=FALSE)