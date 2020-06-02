#Adding the required libraries
library(data.table)
library(dplyr)

#Downloading and unziping the files
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, file.path("./dataset/", "dataFiles.zip"))
unzip(zipfile = "./dataset/dataFiles.zip")

# Reading activity label
activity_label <- read.table(file = "./UCI HAR Dataset/activity_labels.txt", col.names = c("class","activity_name"))

# Reading the features and subsetting features of mean and standard deviation
feature <- read.table(file = "./UCI HAR Dataset/features.txt",col.names = c("index","feature_name"))
wanted_index <- grepl('mean[()]|std[()]', feature$feature_name)
feature_wanted <- feature[wanted_index,]

# Reading the training dataset, activities and train subjects and creating a dataframe called train
train <- fread(file =  "UCI HAR Dataset/train/X_train.txt",drop = which(!wanted_index))
colnames(train) <- as.character(feature_wanted$feature_name)
trainActivities <- fread(file = "UCI HAR Dataset/train/Y_train.txt", col.names = c("Activity"))
trainSubjects <- fread(file = "UCI HAR Dataset/train/subject_train.txt", col.names = c("Subject_Num"))
train <- cbind(trainSubjects, trainActivities, train)

# Reading the testing dataset, activities and test subjects and creating a dataframe called test
test <- fread(file =  "UCI HAR Dataset/test/X_test.txt",drop = which(!wanted_index))
colnames(test) <- as.character(feature_wanted$feature_name)
testActivities <- fread(file = "UCI HAR Dataset/test/Y_test.txt", col.names = c("Activity"))
testSubjects <- fread(file = "UCI HAR Dataset/test/subject_test.txt", col.names = c("Subject_Num"))
test <- cbind(testSubjects, testActivities, test)

# Merging the test and drain as dataset
dataset <- rbind(test,train)

# Labeling the data set with descriptive variable names.
dataset$Activity <- factor(dataset$Activity,levels = activity_label$class, labels = activity_label$activity_name)

# Creating tidy data set with the average of each variable for each activity and each subject
tidy_data <- dataset %>% group_by(Subject_Num,Activity) %>% summarise_all(.funs = mean)
fwrite(x = tidy_data,file = "./UCI HAR Dataset/tidy_data")
