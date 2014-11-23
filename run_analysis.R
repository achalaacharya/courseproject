########Set Working Directory
setwd("/home/minty/Coursera/Getting and Cleaning Data/Project")

#  Unnzip the files and saved them to the Working Directory
##################### PART ONE : Merges the training and the test sets to create one data set.
###### Read in Data
## Features and Activity Type
features     <- read.table('./features.txt',header=FALSE); 
activityType <- read.table('./activity_labels.txt',header=FALSE); 
## Training  Data
subjectTrain <- read.table('.train/subject_train.txt',header=FALSE); 
xTrain       <- read.table('.train/X_train.txt',header=FALSE); 
yTrain       <- read.table('.train/y_train.txt',header=FALSE); 

## Test Data
subjectTest <- read.table('.test/subject_test.txt',header=FALSE); #imports subject_test.txt
xTest       <- read.table('.test/X_test.txt',header=FALSE); #imports x_test.txt
yTest       <- read.table('.test/y_test.txt',header=FALSE); #imports y_test.txt

############ Combine the datasets
###First create column names for the test and training data
colnames(activityType)  <- c('activityId','activityType')
colnames(subjectTrain)  <- "subjectId"
colnames(xTrain)        <- features[,2]
colnames(yTrain)        <- "activityId"
colnames(subjectTest)   <- "subjectId"
colnames(xTest)         <- features[,2] 
colnames(yTest)         <- "activityId"
############ columnbind test and train data sets speartely
trainingData <- cbind(yTrain,subjectTrain,xTrain)
testData <-     cbind(yTest,subjectTest,xTest)
########### rowbind the two datasets together
Data <- rbind(trainingData,testData)

############## PART TWO: Extracts only the measurements on the mean and standard deviation for each measurement.
columns <- colnames(Data)
MeanSD <- (grepl("activity..",columns) | grepl("subject..",columns) | grepl("-mean..",columns) & !grepl("-meanFreq..",columns) & !grepl("mean..-",columns) | grepl("-std..",columns) & !grepl("-std()..-",columns))
Data <- Data[MeanSD==TRUE]
####################### PART THREE Uses descriptive activity names to name the activities in the data set
Data <-  merge(Data,activityType, by='activityId', all.x=TRUE)
columns <- colnames(Data)

#############PART FOUR Appropriately labels the data set with descriptive variable names
for (i in 1:length(columns)) 
{
    columns[i] = gsub("\\()","",columns[i])
    columns[i] = gsub("-std$","StdDev",columns[i])
    columns[i] = gsub("-mean","Mean",columns[i])
    columns[i] = gsub("^(t)","time",columns[i])
    columns[i] = gsub("^(f)","freq",columns[i])
    columns[i] = gsub("([Gg]ravity)","Gravity",columns[i])
    columns[i] = gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",columns[i])
    columns[i] = gsub("[Gg]yro","Gyro",columns[i])
    columns[i] = gsub("AccMag","AccMagnitude",columns[i])
    columns[i] = gsub("([Bb]odyaccjerkmag)","BodyAccJerkMagnitude",columns[i])
    columns[i] = gsub("JerkMag","JerkMagnitude",columns[i])
    columns[i] = gsub("GyroMag","GyroMagnitude",columns[i])
}
colnames(Data) <- columns

############### PART FIVE:From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
DataActivityType <- Data[,names(Data) != 'activityType']
tidyData    <- aggregate(DataActivityType[,names(DataActivityType) != c('activityId','subjectId')],by=list(activityId=DataActivityType$activityId,subjectId = DataActivityType$subjectId),mean);
tidyData    <- merge(tidyData,activityType,by='activityId',all.x=TRUE)
library(dplyr)
tidyData <- select(tidyData, activityId,activityType,subjectId, timeBodyAccMagnitudeMean:freqBodyGyroJerkMagnitudeStdDev)
tidyData <- arrange(tidyData, subjectId, activityId)
write.table(tidyData, './tidyData.txt',row.names=FALSE,sep='\t')
