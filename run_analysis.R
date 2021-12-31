library(dplyr)
setwd("C:/Users/lalbarran/Desktop/Coursera/Getting and Cleaning Data R")


#download and unzip data
filename <- "Coursera_DS3_Final.zip"
URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(URL, filename, method="curl")

unzip(filename) 



#reading datasets and naming columns

# features <- read.table("UCI HAR Dataset/features.txt")
# activities <- read.table("UCI HAR Dataset/activity_labels.txt")
# subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
# x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
# y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
# subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
# x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
# y_train <- read.table("UCI HAR Dataset/train/y_train.txt")

features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")


#merge
X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
subject <- rbind(subject_train, subject_test)
merged <- cbind(subject, Y, X)

#mean and std from datasets
tidydata <- merged %>% select(subject, code, contains("mean"), contains("std"))
head(tidydata)

#naming codes from tidydata with names in activities dataset
tidydata$code <- activities[tidydata$code, 2]


#renaming
tidydata <- tidydata %>% rename(activities = code)
names(tidydata)<-gsub("Acc", "Accelerometer", names(tidydata))
names(tidydata)<-gsub("Gyro", "Gyroscope", names(tidydata))
names(tidydata)<-gsub("BodyBody", "Body", names(tidydata))
names(tidydata)<-gsub("Mag", "Magnitude", names(tidydata))
names(tidydata)<-gsub("^t", "Time", names(tidydata))
names(tidydata)<-gsub("^f", "Frequency", names(tidydata))
names(tidydata)<-gsub("tBody", "TimeBody", names(tidydata))
names(tidydata)<-gsub("-mean()", "Mean", names(tidydata), ignore.case = TRUE)
names(tidydata)<-gsub("-std()", "STD", names(tidydata), ignore.case = TRUE)
names(tidydata)<-gsub("-freq()", "Frequency", names(tidydata), ignore.case = TRUE)
names(tidydata)<-gsub("angle", "Angle", names(tidydata))
names(tidydata)<-gsub("gravity", "Gravity", names(tidydata))


#final table - average of each variable for each activity and each subject
final <- tidydata %>%
  group_by(subject, activities) %>%
  summarise_all(funs(mean))


str(final)

#writing table
write.table(final, "final_data.txt", row.name=FALSE)









