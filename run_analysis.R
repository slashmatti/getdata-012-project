library(dyplr)

## Read in data and remove unnecessary objects from memory
activityLabels <- read.table("./UCI HAR Dataset/activity_labels.txt")

    ## Activity data set
testActivity <- read.table("./UCI HAR Dataset/test/y_test.txt")
trainingActivity <- read.table("./UCI HAR Dataset/train/y_train.txt")
activity <- bind_rows(testActivity, trainingActivity)
rm(list = c("testActivity", "trainingActivity"))

    ## Subject data set
testSubject <- read.table("./UCI HAR Dataset/test/subject_test.txt")
trainingSubject <- read.table("./UCI HAR Dataset/train/subject_train.txt")
subject <- bind_rows(testSubject, trainingSubject)
rm(list = c("testSubject", "trainingSubject"))

    ## Measurement data set
testSet <- read.table("./UCI HAR Dataset/test/X_test.txt")
trainingSet <- read.table("./UCI HAR Dataset/train/X_train.txt")
data <- bind_rows(testSet, trainingSet)
rm(list = c("testSet", "trainingSet"))

features <- read.table("./UCI HAR Dataset/features.txt", stringsAsFactor = FALSE)

## Only keep variables that correspond with mean and standard deviation
## measurements
features <- filter(features, grepl("mean\\(", V2) | grepl("std\\(", V2))

## Remove symbols from variable names to improve readability
features$V2 <- gsub("-", "", features$V2)
features$V2 <- gsub("\\(", "", features$V2)
features$V2 <- gsub("\\)", "", features$V2)

## With relevant data filtered, discard unneeded data and insert descriptive
## variable names
data <- select(data, features$V1); colnames(data) <- features$V2
rm("features")

## Unify activity, subject and measurement data into one data set
data <- full_join(activity, activityLabels) %>% select(V2) %>%
    bind_cols(subject, data) %>% rename(subject = V1, activity = V2)
rm(list = c("activity", "activityLabels", "subject"))

## Independant tidy data set grouped by subject and activity, then compute
## the mean for each grouping
tidy_df <- data %>% group_by(subject, activity) %>% summarise_each(funs(mean))

## Save tidy data set as text file
write.table(tidy_df, file = "tidydata.txt", row.names = FALSE)