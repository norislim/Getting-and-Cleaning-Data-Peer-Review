
training_set <- read.table(file = "./train/X_train.txt")
training_labels <- read.table(file = "./train/y_train.txt")
subject_train <- read.table(file = "./train/subject_train.txt")

test_set <- read.table(file = "./test/X_test.txt")
test_label <- read.table(file = "./test/y_test.txt")
subject_test <- read.table(file = "./test/subject_test.txt")

features <- read.table(file = "features.txt")
activity_labels <- read.table(file = "activity_labels.txt")

# Merges the training and the test sets to create one data set.
df <- rbind(cbind(subject_test, test_set, test_label), cbind(subject_train, training_set, training_labels))
colnames(df[2:562]) <- features[,2]
colnames(df[1]) <- "subject"
colnames(df[563]) <- "activity"

# Extracts only the measurements on the mean and standard deviation for each measurement. 
indices <- grep(pattern = "mean|std", colnames(df))
new_df <- df[,indices]

# Uses descriptive activity names to name the activities in the data set
activity <- df[,563]

labels <- c()
for(i in activity){
  x <- activity_labels[i,2]
  labels <- c(labels, x)
}
new_df <- cbind(subject = df[1], new_df)
new_df <- cbind(new_df, activity = activity)
new_df <- cbind(new_df, activity_labels = labels)

# Appropriately labels the data set with descriptive variable names. 
colnames_df <- colnames(new_df)[2:80]
colnames_df <- gsub(pattern = "[()]|[-]", replacement = "", x = colnames_df)
colnames_df <- gsub(pattern = "^f", replacement = "FrequencyDomain", x = colnames_df)
colnames_df <- gsub(pattern = "^t", replacement = "TimeDomain", x = colnames_df)
colnames_df <- gsub(pattern = "mean", replacement = "Mean", x = colnames_df)
colnames_df <- gsub(pattern = "std", replacement = "StandardDeviation", x = colnames_df)
colnames_df <- gsub(pattern = "BodyBody", replacement = "Body", x = colnames_df)
colnames(new_df)[2:80] <- colnames_df

# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
x <- new_df %>% group_by(subject, activity_labels) %>% summarise_each(mean)

write.table(x, file = "./UCI HAR Dataset/tidydata.txt", row.names = FALSE, col.names = TRUE)


