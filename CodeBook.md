## Getting and Cleaning Data Project

The data source for this project comes from the "Human Activity Recognition Using Smartphones Data Set" which can be downloaded from here
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

### Attribute Information
- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope.
- A 561-feature vector with time and frequency domain variables.
- Its activity label.
- An identifier of the subject who carried out the experiment.

### Section 1. Merge the training and the test sets to create one data set.
After setting the working directory for the files, read the following files to R.
- features.txt
- activity_labels.txt
- subject_train.txt
- x_train.txt
- y_train.txt
- subject_test.txt
- x_test.txt
- y_test.txt

Columns Bind And Row Bind to create one dataset.


### Section 2. Extract only the measurements on the mean and standard deviation for each measurement.
Use of regular expression(grep1) to find only the column names that contain the characters "mean" and "std".

### Section 3. Use descriptive activity names to name the activities in the data set
Merged the dataset from 2 with the ActivityType to add a columns with descriptive activity names.

### Section 4. Appropriately label the data set with descriptive activity names.

Use gsub function for pattern replacement to clean up the data labels.

### Section 5. Create a second, independent tidy data set with the average of each variable for each activity and each subject.

Used aggregate, and merge functions to get dataframe that contains only the means of the features and used dplyr package to arrange data by subjectId and ActivityId.
Saved a txt file of the resulting dataset using the write.table function.
