CodeBook 
This CodeBook describes the variables, the data, and any transformations or work  performed to clean up the data.

#	The Data
This project uses data from:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
A full description is available at the site where the data was obtained:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.
The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

#	The Variables
run_analysis.R imports the train data from '/train/X_train.txt', '/train/y_train.txt', and '/train/subject_train.txt' into featuresTrainDt, activityTrainDt, and subjectTrainDt respectively. 
It imports the test data from '/test/X_test.txt', '/test/y_test.txt', and '/test/subject_test.txt' into featuresTestDt, activityTestDt, and subjectTestDt respectively. 
The activity labels are imported from '/activity_labels.txt' into activities.
 The names of the measurements are imported from '/features.txt' into features.

#	The Transformations
run_analysis.R does the following:
1.	Merges the training and the test sets to create one data set.
2.	Extracts only the measurements on the mean and standard deviation for each measurement.
3.	Uses descriptive activity names to name the activities in the data set
4.	Appropriately labels the data set with descriptive variable names.
5.	From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

1. Merges training and test data
Test data in cbind(subjectTestDt, activityTestDt,   featuresTestDt) and training data in cbind(subjectTrainDt,  activityTrainDt,  featuresTrainDt) are merge together with rbind(), creating a dataset called sensorsData. The columns are renamed "subject", "activityId", and labels from features.

2. Extracts only mean and std measurements
A vector columnsToKeep is created that uses grepl() to find the columns that have features with "subject" or "activityId" or "mean" or "std" in the name. These columns are isolated in now overwritten dataset sensorsData.

3. Use descriptive activity names
A column named activity is populated into the dataset sensorsData by joining both dataset sensorsData and dataset activities based on common field activityId.

4. Label the data set with descriptive variable names
Columns names in sensorsData are cleaned up, removing special characters like '-'.  The columns are renamed with more descriptive names using the function gsub().

5. Independent Tidy Data Set
The average of each variable for each activity and each subject is done via the function ddplyr() calling the function numcolwise(mean).
The tidy data is named ' sensorTidyData.txt'.


