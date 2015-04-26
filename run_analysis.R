
library(data.table)
library(reshape2)


# Load the names of activity into acitivityNames
activityNames <- read.table("activity_labels.txt")[,2]

# Load names of columns into features
features <- read.table("features.txt")[,2]

# Extract only the measurements on the mean and standard deviation for each measurement.
extractFeatures <- grepl("mean|std", features)

# Load the X_test & y_test data.
xTest <- read.table("test/X_test.txt")
yTest <- read.table("test/y_test.txt")
subjectTest <- read.table("test/subject_test.txt")

names(xTest) = features

# Extract only the measurements on the mean and standard deviation for each measurement.
xTest = xTest[,extractFeatures]

# Load the activity names
yTest[,2] = activityNames[yTest[,1]]
names(yTest) = c("Activity_ID", "Activity_Label")
names(subjectTest) = "subject"

# Merge data
testData <- cbind(as.data.table(subjectTest), yTest, xTest)

# Load the X_train & y_train data.
xTrain <- read.table("train/X_train.txt")
yTrain <- read.table("train/y_train.txt")

subjectTrain <- read.table("train/subject_train.txt")

names(xTrain) = features

# Extract only the measurements on the mean and standard deviation for each measurement.
xTrain = xTrain[,extractFeatures]

# Load the activity names
yTrain[,2] = activityNames[yTrain[,1]]
names(yTrain) = c("Activity_ID", "Activity_Label")
names(subjectTrain) = "subject"

# Merge data
trainData <- cbind(as.data.table(subjectTrain), yTrain, xTrain)

# Merge test and train data
mergedData = rbind(testData, trainData)

# Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
colNames1  = colnames(mergedData)[1:3]
colNames2  = colnames(mergedData)[4:82]
newData      = melt(mergedData, id.vars = colNames1, measure.vars = colNames2)


tidyData   = dcast(newData, subject + Activity_Label ~ variable, mean)

write.table(tidyData, file = "./tidyData.txt")
