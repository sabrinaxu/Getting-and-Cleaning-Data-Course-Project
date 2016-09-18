

####################################################
library(plyr)
library(dplyr)
library(data.table)


#load data#
path <- setwd("~/Repositories/Getting-and-Cleaning-Data-Course-Project")

features <- read.table("./UCI HAR Dataset/features.txt")
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

extract_features <- grepl("mean|std", features)

X_test <- read.table("./UCI HAR Dataset/test/X_test.txt") 
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt") 
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt") 

X_train <- read.table("./UCI HAR Dataset/train/X_train.txt") 
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt") 
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt") 


#1.Merges the training and the test sets to create one data set.#
joined_data <- rbind(X_train,X_test) 
joined_labels <- rbind(y_train,y_test) 
joined_subjects <- rbind(subject_train,subject_test) 

colnames(X_train) <- t(features[2])
colnames(X_test) <- t(features[2])
names(y_test) = c("Activity_ID", "Activity_Label")
names(y_train) = c("Activity_ID", "Activity_Label")

names(joined_data) = features[[2]] 
names(joined_labels) = c("activityid") 
names(joined_subjects) = c("subjects") 



#2.Extracts only the measurements on the mean and standard deviation for each measurement. #
means <- grep("mean",features[[2]])
std <- grep("std",features[[2]])
merge <- unique(c(means,std)) 

revised_joined_data <- joined_data[merge]



#3.Uses descriptive activity names to name the activities in the data set#

names(activity_labels) = c("activityid","activityname")
activities <- merge(activity_labels,joined_labels,"activityid") 
revised_joined_data$activities <- activities[[2]] 
revised_joined_data$subjects <- joined_subjects[[1]] 



#4.Appropriately labels the data set with descriptive variable names. #

names(revised_joined_data) <- gsub("\\(\\)","",names(revised_joined_data)) 
names(revised_joined_data) <- gsub("std","Std",names(revised_joined_data)) 
names(revised_joined_data) <- gsub("mean","Mean",names(revised_joined_data)) 
names(revised_joined_data) <- gsub("-","",names(revised_joined_data)) 





#5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.#

second_data <- aggregate(revised_joined_data, by=list(activity = revised_joined_data$activities, subject=revised_joined_data$subjects), mean) 


write.table(revised_joined_data, "TidyData.txt") 
write.table(second_data,"SecondData.txt",row.name=FALSE) 





