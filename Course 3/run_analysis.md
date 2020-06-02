### Getting and Cleaning Data Course Project

You should create one R script called run\_analysis.R that does the
following.

1.  Merges the training and the test sets to create one data set.  
2.  Extracts only the measurements on the mean and standard deviation
    for each measurement.  
3.  Uses descriptive activity names to name the activities in the data
    set  
4.  Appropriately labels the data set with descriptive variable names.  
5.  From the data set in step 4, creates a second, independent tidy data
    set with the average of each variable for each activity and each
    subject.

Adding the required libraries

``` r
library(data.table)
library(dplyr)
```

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:data.table':
    ## 
    ##     between, first, last

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

Downloading and unziping the files

``` r
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, file.path("./dataset/", "dataFiles.zip"))
unzip(zipfile = "./dataset/dataFiles.zip")
```

Reading activity label

``` r
activity_label <- read.table(file = "./UCI HAR Dataset/activity_labels.txt", col.names = c("class","activity_name"))
```

Reading the features and subsetting features of mean and standard
deviation

``` r
feature <- read.table(file = "./UCI HAR Dataset/features.txt",col.names = c("index","feature_name"))
wanted_index <- grepl('mean[()]|std[()]', feature$feature_name)
feature_wanted <- feature[wanted_index,]
```

Reading the training dataset, activities and train subjects and creating
a dataframe called train

``` r
train <- fread(file =  "UCI HAR Dataset/train/X_train.txt",drop = which(!wanted_index))
colnames(train) <- as.character(feature_wanted$feature_name)
trainActivities <- fread(file = "UCI HAR Dataset/train/Y_train.txt", col.names = c("Activity"))
trainSubjects <- fread(file = "UCI HAR Dataset/train/subject_train.txt", col.names = c("Subject_Num"))
train <- cbind(trainSubjects, trainActivities, train)
```

Reading the testing dataset, activities and test subjects and creating a
dataframe called test.

``` r
test <- fread(file =  "UCI HAR Dataset/test/X_test.txt",drop = which(!wanted_index))
colnames(test) <- as.character(feature_wanted$feature_name)
testActivities <- fread(file = "UCI HAR Dataset/test/Y_test.txt", col.names = c("Activity"))
testSubjects <- fread(file = "UCI HAR Dataset/test/subject_test.txt", col.names = c("Subject_Num"))
test <- cbind(testSubjects, testActivities, test)
```

Merging the test and drain as dataset

``` r
dataset <- rbind(test,train)
```

Labeling the data set with descriptive variable names.

``` r
dataset$Activity <- factor(dataset$Activity,levels = activity_label$class, labels = activity_label$activity_name)
```

Creating tidy data set with the average of each variable for each
activity and each subject

``` r
tidy_data <- dataset %>% group_by(Subject_Num,Activity) %>% summarise_all(.funs = mean)
fwrite(x = tidy_data,file = "./UCI HAR Dataset/tidy_data")
head(tidy_data)
```

    ## # A tibble: 6 x 68
    ## # Groups:   Subject_Num [1]
    ##   Subject_Num Activity `tBodyAcc-mean(~ `tBodyAcc-mean(~ `tBodyAcc-mean(~
    ##         <int> <fct>               <dbl>            <dbl>            <dbl>
    ## 1           1 WALKING             0.277         -0.0174           -0.111 
    ## 2           1 WALKING~            0.255         -0.0240           -0.0973
    ## 3           1 WALKING~            0.289         -0.00992          -0.108 
    ## 4           1 SITTING             0.261         -0.00131          -0.105 
    ## 5           1 STANDING            0.279         -0.0161           -0.111 
    ## 6           1 LAYING              0.222         -0.0405           -0.113 
    ## # ... with 63 more variables: `tBodyAcc-std()-X` <dbl>,
    ## #   `tBodyAcc-std()-Y` <dbl>, `tBodyAcc-std()-Z` <dbl>,
    ## #   `tGravityAcc-mean()-X` <dbl>, `tGravityAcc-mean()-Y` <dbl>,
    ## #   `tGravityAcc-mean()-Z` <dbl>, `tGravityAcc-std()-X` <dbl>,
    ## #   `tGravityAcc-std()-Y` <dbl>, `tGravityAcc-std()-Z` <dbl>,
    ## #   `tBodyAccJerk-mean()-X` <dbl>, `tBodyAccJerk-mean()-Y` <dbl>,
    ## #   `tBodyAccJerk-mean()-Z` <dbl>, `tBodyAccJerk-std()-X` <dbl>,
    ## #   `tBodyAccJerk-std()-Y` <dbl>, `tBodyAccJerk-std()-Z` <dbl>,
    ## #   `tBodyGyro-mean()-X` <dbl>, `tBodyGyro-mean()-Y` <dbl>,
    ## #   `tBodyGyro-mean()-Z` <dbl>, `tBodyGyro-std()-X` <dbl>,
    ## #   `tBodyGyro-std()-Y` <dbl>, `tBodyGyro-std()-Z` <dbl>,
    ## #   `tBodyGyroJerk-mean()-X` <dbl>, `tBodyGyroJerk-mean()-Y` <dbl>,
    ## #   `tBodyGyroJerk-mean()-Z` <dbl>, `tBodyGyroJerk-std()-X` <dbl>,
    ## #   `tBodyGyroJerk-std()-Y` <dbl>, `tBodyGyroJerk-std()-Z` <dbl>,
    ## #   `tBodyAccMag-mean()` <dbl>, `tBodyAccMag-std()` <dbl>,
    ## #   `tGravityAccMag-mean()` <dbl>, `tGravityAccMag-std()` <dbl>,
    ## #   `tBodyAccJerkMag-mean()` <dbl>, `tBodyAccJerkMag-std()` <dbl>,
    ## #   `tBodyGyroMag-mean()` <dbl>, `tBodyGyroMag-std()` <dbl>,
    ## #   `tBodyGyroJerkMag-mean()` <dbl>, `tBodyGyroJerkMag-std()` <dbl>,
    ## #   `fBodyAcc-mean()-X` <dbl>, `fBodyAcc-mean()-Y` <dbl>,
    ## #   `fBodyAcc-mean()-Z` <dbl>, `fBodyAcc-std()-X` <dbl>,
    ## #   `fBodyAcc-std()-Y` <dbl>, `fBodyAcc-std()-Z` <dbl>,
    ## #   `fBodyAccJerk-mean()-X` <dbl>, `fBodyAccJerk-mean()-Y` <dbl>,
    ## #   `fBodyAccJerk-mean()-Z` <dbl>, `fBodyAccJerk-std()-X` <dbl>,
    ## #   `fBodyAccJerk-std()-Y` <dbl>, `fBodyAccJerk-std()-Z` <dbl>,
    ## #   `fBodyGyro-mean()-X` <dbl>, `fBodyGyro-mean()-Y` <dbl>,
    ## #   `fBodyGyro-mean()-Z` <dbl>, `fBodyGyro-std()-X` <dbl>,
    ## #   `fBodyGyro-std()-Y` <dbl>, `fBodyGyro-std()-Z` <dbl>,
    ## #   `fBodyAccMag-mean()` <dbl>, `fBodyAccMag-std()` <dbl>,
    ## #   `fBodyBodyAccJerkMag-mean()` <dbl>, `fBodyBodyAccJerkMag-std()` <dbl>,
    ## #   `fBodyBodyGyroMag-mean()` <dbl>, `fBodyBodyGyroMag-std()` <dbl>,
    ## #   `fBodyBodyGyroJerkMag-mean()` <dbl>, `fBodyBodyGyroJerkMag-std()` <dbl>
