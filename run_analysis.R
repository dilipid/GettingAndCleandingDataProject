library(plyr)

filename <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"


if(!file.exists("./data")) {
  dir.create("./data")
}

local_zipfile <- "./data/uci_har_dataset.zip"
if(!file.exists(local_zipfile)) {
  download.file(filename, destfile = local_zipfile, method = "curl")
}

unzip(zipfile = local_zipfile, exdir = "./data")

# merge the training and the test sets to create one data set.

# reading the training dataset

x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

# reading testing dataset

x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

# merge the two datasets to create one dataset
x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
subject_data <- rbind(subject_train, subject_test)

# reading features vector

features <- read.table("./data/UCI HAR Dataset/features.txt")

mean_and_std_features <- grep("-(mean|std)\\(\\)", features[, 2])

x_data <- x_data[, mean_and_std_features]

# correct the column names
names(x_data) <- features(mean_and_std_features, 2)

# reading activity labels

activityLabels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")

# uses descriptive activity names to name the activities in the data set

y_data[, 1] <- activityLabels[y_data[, 1], 2]

names(y_data) <- "activity"

# Appropriately labels the data set with descriptive variable names.

names(subject_data) <- "subject"

# bind all the data in a single data set

all_data <- cbind(x_data, y_data, subject_data)

# From the data set in step 4, creates a second, independent tidy data set with the 
# average of each variable for each activity and each subject.

averages_data <- ddply(all_data, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(averages_data, "tidy_data.txt", row.name=FALSE)