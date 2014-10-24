library(reshape)

# Original data folder
originalDataFolder <- "./data/UCI HAR Dataset/"
# Train sub folder
trainFolder <- paste0(originalDataFolder, "train/")
# Train files
subjectTrainFile <- paste0(trainFolder, "subject_train.txt")
xTrainFile <- paste0(trainFolder, "X_train.txt")
yTrainFile <- paste0(trainFolder, "y_train.txt")
# Test sub folder
testFolder <- paste0(originalDataFolder, "test/")
# Test files
subjectTestFile <- paste0(testFolder, "subject_test.txt")
xTestFile <- paste0(testFolder, "X_test.txt")
yTestFile <- paste0(testFolder, "y_test.txt")
# Result folder
resultsFolder <- "./data/results/"
# Create result folder if it doesn't exist
if(!file.exists(resultsFolder)) { dir.create(resultsFolder) }

###############################################################
# Merges the training and the test sets to create one data set.
###############################################################
# Read all the files
subjectTrain <- read.table(subjectTrainFile, sep=" ")
xTrain <- read.table(xTrainFile)
yTrain <- read.table(yTrainFile)
subjectTest <- read.table(subjectTestFile)
xTest <- read.table(xTestFile)
yTest <- read.table(yTestFile)

# Merge the Train data
trainData <- cbind(subjectTrain, yTrain, xTrain)
# Merge the Test data
testData <- cbind(subjectTest, yTest, xTest)

# Merge all the data
testTrainData <- rbind(trainData, testData)

####################################################################
# Appropriately labels the data set with descriptive variable names.
####################################################################
# Read the features file
featuresFile <- paste0(originalDataFolder, "features.txt")
featuresData <- read.table(featuresFile, sep=" ")

# We just need the names of the features
features <- as.character(featuresData[, 2])

# Create the vector containing the column name
columnNames = c("Subject", "Activity", features)

# Assign the column names to the data.frame
names(testTrainData) <- columnNames

## 2 - Extracts only the measurements on the mean and standard deviation for each measurement. 
# Extract the column names for Mean and Standard Deviation
meanStdColumns <- columnNames[grepl(".*(mean\\(\\)|std\\(\\)).*", columnNames)]

# Concatenate with other column names to keep
selectedColumnNames = c("Subject", "Activity", meanStdColumns)

# Subset of the mergedData only with Mean and Standard Deviation values
meanStdData <- testTrainData[, selectedColumnNames]

## 3 - Uses descriptive activity names to name the activities in the data set
# Read the activity_labels file
activitiesFile <- paste0(originalDataFolder, "activity_labels.txt")
activitiesData <- read.table(activitiesFile, sep=" ", col.names=c("id", "Activity"))

# Merge the data with Activity labels
meanStdActivitiesData <- merge(activitiesData, meanStdData, by.x="id", by.y="Activity", all=TRUE)
# Remove the id column that is not needed anymore
meanStdActivitiesData <- meanStdActivitiesData[, -1]
# Save the result file
write.table(meanStdActivitiesData, file=paste0(resultsFolder, "meanStdActivities.txt"), row.names=FALSE)

## 5 - From the data set in step 4, creates a second, independent tidy data set 
##     with the average of each variable for each activity and each subject.
# Reshape the data to be able to calculate the average for each variable, grouped by Activity and Subject
melted <- melt(meanStdActivitiesData, id.vars = c("Activity", "Subject"))
averages <- cast(Activity + Subject ~ variable, data = melted, fun = mean)
# Save the result file
write.table(averages, file=paste0(resultsFolder, "averages.txt"), row.names=FALSE)
