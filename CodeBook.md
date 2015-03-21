The features selected for this database come from the smartphone accelerometer and gyroscope 3-axial raw signals. For detailed information refer to `features_info.txt` of the UCI HAR Data Set.

The tidy data set contains mean and standard deviation measurements of the following variables:
* tBodyAccXYZ
* tGravityAccXYZ
* tBodyAccJerkXYZ
* tBodyGyroXYZ
* tBodyGyroJerkXYZ
* tBodyAccMag
* tGravityAccMag
* tBodyAccJerkMag
* tBodyGyroMag
* tBodyGyroJerkMag
* fBodyAccXYZ
* fBodyAccJerkXYZ
* fBodyGyroXYZ
* fBodyAccMag
* fBodyAccJerkMag
* fBodyGyroMag
* fBodyGyroJerkMag
 
'XYZ' is used to denote 3-axial signals in the X, Y and Z directions (three separate variables). To clean up the data set and make it tidy, the script extracts only measurements on the mean and standard deviation for each measurement. As per the explanations given in `features_info.txt`, it is determined that the mean and standard deviation measurements correspond to the variable names that include the strings: "mean()" and "std()". Other variables including the string "Mean" do not actually seem to indicate mean measurements. Thus, the script selects for the relevant variables with 
```{R}
features <- filter(features, grepl("mean\\(", V2) | grepl("std\\(", V2))
```
The resulting variables that are kept from the data set are 33 measurements for mean and 33 measurements for standard deviation. Along with the two variables for 1) activity performed by 2) subject, the number of variables in the tidy data set are 68 in total. With 30 subjects performing 6 activities, this makes the number of observations in the tidy data set 180 (30*6) in total. Thus, the tidy data frame has dimension 180 x 68.

dplyr package is used to create the indpendent tidy data set, grouped by subject and activity, then average the measurements for each grouping:
```{R}
tidy_df <- data %>% group_by(subject, activity) %>% summarise_each(funs(mean))
```