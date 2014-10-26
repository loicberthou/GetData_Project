Code Book

We use as input files:
- subject_train.txt
- X_train.txt
- y_train.txt
- subject_test.txt
- X_test.txt
- y_test.txt
- features.txt
- activity_labels.txt
to produce the following files:
- meanStdActivities.txt
- averages.txt

Transformation Steps
1 - Perform a column-merge on the the Train data (subject_train.txt, X_train.txt, y_train.txt)
2 - Perform a column-merge on the the Test data (subject_test.txt, X_test.txt, y_test.txt)
3 - Perform a row-merge on the results of step 1 & 2
4 - Appropriately labels the data set with descriptive variable names (loaded from features.txt).
5 - Filter the data to extract only the measurements on the mean and standard deviation for each measurement
6 - Replace the Activity id with the activity names to name the activities in the data set
7 - Save the result file (meanStdActivities.txt)
8 - Reshape the data to be able to calculate the average for each variable, grouped by Activity and Subject
9 - Save the result file (averages.txt)
