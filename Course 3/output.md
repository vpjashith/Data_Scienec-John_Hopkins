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

Downloading and unziping the files

``` r
#url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
#download.file(url, file.path("./dataset/", "dataFiles.zip"))
#unzip(zipfile = "./dataset/dataFiles.zip")
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
knitr::kable(head(tidy_data), "pandoc")
```

|  Subject\_Num| Activity            |  tBodyAcc-mean()-X|  tBodyAcc-mean()-Y|  tBodyAcc-mean()-Z|  tBodyAcc-std()-X|  tBodyAcc-std()-Y|  tBodyAcc-std()-Z|  tGravityAcc-mean()-X|  tGravityAcc-mean()-Y|  tGravityAcc-mean()-Z|  tGravityAcc-std()-X|  tGravityAcc-std()-Y|  tGravityAcc-std()-Z|  tBodyAccJerk-mean()-X|  tBodyAccJerk-mean()-Y|  tBodyAccJerk-mean()-Z|  tBodyAccJerk-std()-X|  tBodyAccJerk-std()-Y|  tBodyAccJerk-std()-Z|  tBodyGyro-mean()-X|  tBodyGyro-mean()-Y|  tBodyGyro-mean()-Z|  tBodyGyro-std()-X|  tBodyGyro-std()-Y|  tBodyGyro-std()-Z|  tBodyGyroJerk-mean()-X|  tBodyGyroJerk-mean()-Y|  tBodyGyroJerk-mean()-Z|  tBodyGyroJerk-std()-X|  tBodyGyroJerk-std()-Y|  tBodyGyroJerk-std()-Z|  tBodyAccMag-mean()|  tBodyAccMag-std()|  tGravityAccMag-mean()|  tGravityAccMag-std()|  tBodyAccJerkMag-mean()|  tBodyAccJerkMag-std()|  tBodyGyroMag-mean()|  tBodyGyroMag-std()|  tBodyGyroJerkMag-mean()|  tBodyGyroJerkMag-std()|  fBodyAcc-mean()-X|  fBodyAcc-mean()-Y|  fBodyAcc-mean()-Z|  fBodyAcc-std()-X|  fBodyAcc-std()-Y|  fBodyAcc-std()-Z|  fBodyAccJerk-mean()-X|  fBodyAccJerk-mean()-Y|  fBodyAccJerk-mean()-Z|  fBodyAccJerk-std()-X|  fBodyAccJerk-std()-Y|  fBodyAccJerk-std()-Z|  fBodyGyro-mean()-X|  fBodyGyro-mean()-Y|  fBodyGyro-mean()-Z|  fBodyGyro-std()-X|  fBodyGyro-std()-Y|  fBodyGyro-std()-Z|  fBodyAccMag-mean()|  fBodyAccMag-std()|  fBodyBodyAccJerkMag-mean()|  fBodyBodyAccJerkMag-std()|  fBodyBodyGyroMag-mean()|  fBodyBodyGyroMag-std()|  fBodyBodyGyroJerkMag-mean()|  fBodyBodyGyroJerkMag-std()|
|-------------:|:--------------------|------------------:|------------------:|------------------:|-----------------:|-----------------:|-----------------:|---------------------:|---------------------:|---------------------:|--------------------:|--------------------:|--------------------:|----------------------:|----------------------:|----------------------:|---------------------:|---------------------:|---------------------:|-------------------:|-------------------:|-------------------:|------------------:|------------------:|------------------:|-----------------------:|-----------------------:|-----------------------:|----------------------:|----------------------:|----------------------:|-------------------:|------------------:|----------------------:|---------------------:|-----------------------:|----------------------:|--------------------:|-------------------:|------------------------:|-----------------------:|------------------:|------------------:|------------------:|-----------------:|-----------------:|-----------------:|----------------------:|----------------------:|----------------------:|---------------------:|---------------------:|---------------------:|-------------------:|-------------------:|-------------------:|------------------:|------------------:|------------------:|-------------------:|------------------:|---------------------------:|--------------------------:|------------------------:|-----------------------:|----------------------------:|---------------------------:|
|             1| WALKING             |          0.2773308|         -0.0173838|         -0.1111481|        -0.2837403|         0.1144613|        -0.2600279|             0.9352232|            -0.2821650|            -0.0681029|           -0.9766096|           -0.9713060|           -0.9477172|              0.0740416|              0.0282721|             -0.0041684|            -0.1136156|             0.0670025|            -0.5026998|          -0.0418310|          -0.0695300|           0.0849448|         -0.4735355|         -0.0546078|         -0.3442666|              -0.0899975|              -0.0398429|              -0.0461309|             -0.2074219|             -0.3044685|             -0.4042555|          -0.1369712|         -0.2196886|             -0.1369712|            -0.2196886|              -0.1414288|             -0.0744718|           -0.1609796|          -0.1869784|               -0.2987037|              -0.3253249|         -0.2027943|          0.0897127|         -0.3315601|        -0.3191347|         0.0560400|        -0.2796868|             -0.1705470|             -0.0352255|             -0.4689992|            -0.1335866|             0.1067399|            -0.5347134|          -0.3390322|          -0.1030594|          -0.2559409|         -0.5166919|         -0.0335082|         -0.4365622|          -0.1286235|         -0.3980326|                  -0.0571194|                 -0.1034924|               -0.1992526|              -0.3210180|                   -0.3193086|                  -0.3816019|
|             1| WALKING\_UPSTAIRS   |          0.2554617|         -0.0239531|         -0.0973020|        -0.3547080|        -0.0023203|        -0.0194792|             0.8933511|            -0.3621534|            -0.0754029|           -0.9563670|           -0.9528492|           -0.9123794|              0.1013727|              0.0194863|             -0.0455625|            -0.4468439|            -0.3782744|            -0.7065935|           0.0505494|          -0.1661700|           0.0583595|         -0.5448711|          0.0041052|         -0.5071687|              -0.1222328|              -0.0421486|              -0.0407126|             -0.6147865|             -0.6016967|             -0.6063320|          -0.1299276|         -0.3249709|             -0.1299276|            -0.3249709|              -0.4665034|             -0.4789916|           -0.1267356|          -0.1486193|               -0.5948829|              -0.6485530|         -0.4043218|         -0.1909767|         -0.4333497|        -0.3374282|         0.0217695|         0.0859566|             -0.4798752|             -0.4134446|             -0.6854744|            -0.4619070|            -0.3817771|            -0.7260402|          -0.4926117|          -0.3194746|          -0.4535972|         -0.5658925|          0.1515389|         -0.5717078|          -0.3523959|         -0.4162601|                  -0.4426522|                 -0.5330599|               -0.3259615|              -0.1829855|                   -0.6346651|                  -0.6939305|
|             1| WALKING\_DOWNSTAIRS |          0.2891883|         -0.0099185|         -0.1075662|         0.0300353|        -0.0319359|        -0.2304342|             0.9318744|            -0.2666103|            -0.0621200|           -0.9505598|           -0.9370187|           -0.8959397|              0.0541553|              0.0296504|             -0.0109720|            -0.0122839|            -0.1016014|            -0.3457350|          -0.0350782|          -0.0909371|           0.0900850|         -0.4580305|         -0.1263492|         -0.1247025|              -0.0739592|              -0.0439903|              -0.0270461|             -0.4870273|             -0.2388248|             -0.2687615|           0.0271883|          0.0198844|              0.0271883|             0.0198844|              -0.0894475|             -0.0257877|           -0.0757413|          -0.2257244|               -0.2954638|              -0.3065106|          0.0382292|          0.0015499|         -0.2255745|         0.0243308|        -0.1129637|        -0.2979279|             -0.0276639|             -0.1286672|             -0.2883347|            -0.0863279|            -0.1345800|            -0.4017215|          -0.3524496|          -0.0557023|          -0.0318694|         -0.4954225|         -0.1814147|         -0.2384436|           0.0965845|         -0.1865303|                   0.0262185|                 -0.1040523|               -0.1857203|              -0.3983504|                   -0.2819634|                  -0.3919199|
|             1| SITTING             |          0.2612376|         -0.0013083|         -0.1045442|        -0.9772290|        -0.9226186|        -0.9395863|             0.8315099|             0.2044116|             0.3320437|           -0.9684571|           -0.9355171|           -0.9490409|              0.0774825|             -0.0006191|             -0.0033678|            -0.9864307|            -0.9813720|            -0.9879108|          -0.0453501|          -0.0919242|           0.0629314|         -0.9772113|         -0.9664739|         -0.9414259|              -0.0936794|              -0.0402118|              -0.0467026|             -0.9917316|             -0.9895181|             -0.9879358|          -0.9485368|         -0.9270784|             -0.9485368|            -0.9270784|              -0.9873642|             -0.9841200|           -0.9308925|          -0.9345318|               -0.9919763|              -0.9883087|         -0.9796412|         -0.9440846|         -0.9591849|        -0.9764123|        -0.9172750|        -0.9344696|             -0.9865970|             -0.9815795|             -0.9860531|            -0.9874930|            -0.9825139|            -0.9883392|          -0.9761615|          -0.9758386|          -0.9513155|         -0.9779042|         -0.9623450|         -0.9439178|          -0.9477829|         -0.9284448|                  -0.9852621|                 -0.9816062|               -0.9584356|              -0.9321984|                   -0.9897975|                  -0.9870496|
|             1| STANDING            |          0.2789176|         -0.0161376|         -0.1106018|        -0.9957599|        -0.9731901|        -0.9797759|             0.9429520|            -0.2729838|             0.0134906|           -0.9937630|           -0.9812260|           -0.9763241|              0.0753767|              0.0079757|             -0.0036852|            -0.9946045|            -0.9856487|            -0.9922512|          -0.0239877|          -0.0593972|           0.0748008|         -0.9871919|         -0.9877344|         -0.9806456|              -0.0996092|              -0.0440628|              -0.0489505|             -0.9929451|             -0.9951379|             -0.9921085|          -0.9842782|         -0.9819429|             -0.9842782|            -0.9819429|              -0.9923678|             -0.9930962|           -0.9764938|          -0.9786900|               -0.9949668|              -0.9947332|         -0.9952499|         -0.9770708|         -0.9852971|        -0.9960283|        -0.9722931|        -0.9779373|             -0.9946308|             -0.9854187|             -0.9907522|            -0.9950738|            -0.9870182|            -0.9923498|          -0.9863868|          -0.9889845|          -0.9807731|         -0.9874971|         -0.9871077|         -0.9823453|          -0.9853564|         -0.9823138|                  -0.9925425|                 -0.9925360|               -0.9846176|              -0.9784661|                   -0.9948154|                  -0.9946711|
|             1| LAYING              |          0.2215982|         -0.0405140|         -0.1132036|        -0.9280565|        -0.8368274|        -0.8260614|            -0.2488818|             0.7055498|             0.4458177|           -0.8968300|           -0.9077200|           -0.8523663|              0.0810865|              0.0038382|              0.0108342|            -0.9584821|            -0.9241493|            -0.9548551|          -0.0165531|          -0.0644861|           0.1486894|         -0.8735439|         -0.9510904|         -0.9082847|              -0.1072709|              -0.0415173|              -0.0740501|             -0.9186085|             -0.9679072|             -0.9577902|          -0.8419292|         -0.7951449|             -0.8419292|            -0.7951449|              -0.9543963|             -0.9282456|           -0.8747595|          -0.8190102|               -0.9634610|              -0.9358410|         -0.9390991|         -0.8670652|         -0.8826669|        -0.9244374|        -0.8336256|        -0.8128916|             -0.9570739|             -0.9224626|             -0.9480609|            -0.9641607|            -0.9322179|            -0.9605870|          -0.8502492|          -0.9521915|          -0.9093027|         -0.8822965|         -0.9512320|         -0.9165825|          -0.8617676|         -0.7983009|                  -0.9333004|                 -0.9218040|               -0.8621902|              -0.8243194|                   -0.9423669|                  -0.9326607|
