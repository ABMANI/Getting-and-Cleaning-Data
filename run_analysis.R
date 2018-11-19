
setwd("C:/Users/61710499/Desktop/Coursera - Getting and Cleaning Data/Project/UCI HAR Dataset/UCI HAR Dataset/train")

#################################################################
#Step 0 - Read Data
#################################################################
X_train<-read.table("C:/Users/61710499/Desktop/Coursera - Getting and Cleaning Data/Project/UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt")
X_test<-read.table("C:/Users/61710499/Desktop/Coursera - Getting and Cleaning Data/Project/UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt")
y_train<-read.table("C:/Users/61710499/Desktop/Coursera - Getting and Cleaning Data/Project/UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt")
y_test<-read.table("C:/Users/61710499/Desktop/Coursera - Getting and Cleaning Data/Project/UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt")
train_subj<-read.table("C:/Users/61710499/Desktop/Coursera - Getting and Cleaning Data/Project/UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt")
test_subj<-read.table("C:/Users/61710499/Desktop/Coursera - Getting and Cleaning Data/Project/UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt")
features<-read.table("C:/Users/61710499/Desktop/Coursera - Getting and Cleaning Data/Project/UCI HAR Dataset/UCI HAR Dataset/features.txt")
activities<-read.table("C:/Users/61710499/Desktop/Coursera - Getting and Cleaning Data/Project/UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt")

#################################################################
#Step 1 - Merges the training and the test sets to create one data set
#################################################################
X<-rbind(X_train,X_test)
y<-rbind(y_train,y_test)
subj<-rbind(train_subj,test_subj)
colnames(X)<-features$V2
colnames(y)<-"Activities"
colnames(subj)<-"Subject"
Dat<-cbind(subj,X,y)

#################################################################
#Step 2 - Extracts only the measurements on the mean and standard deviation for each measurement
#################################################################
Dat<-Dat[,grep("Subject|mean|std|Activities",colnames(Dat))]

##############################################################################
# Step 3 - Use descriptive activity names to name the activities in the data
#          set
##############################################################################
Dat$Activities<-factor(Dat$Activities,level=activities[,1],labels=activities[,2])

##############################################################################
# Step 4 - Appropriately labels the data set with descriptive variable names
##############################################################################
Dat_cols<-colnames(Dat)

Dat_cols<-gsub("[\\(\\)-]","",Dat_cols)

Dat_cols<-gsub("^f","FrequencyDomain",Dat_cols)
Dat_cols <- gsub("^t", "timeDomain", Dat_cols)
Dat_cols <- gsub("Acc", "Accelerometer", Dat_cols)
Dat_cols <- gsub("Gyro", "Gyroscope", Dat_cols)
Dat_cols <- gsub("Mag", "Magnitude", Dat_cols)
Dat_cols <- gsub("Freq", "Frequency", Dat_cols)
Dat_cols <- gsub("mean", "Mean", Dat_cols)
Dat_cols <- gsub("std", "StandardDeviation", Dat_cols)

colnames(Dat)<-Dat_cols
##############################################################################
# Step 5 - From the data set in step 4, creates a second, independent tidy data set 
#          with the average of each variable for each activity and each subject
##############################################################################
Dat_Tidy <- aggregate(Dat, by=list(activity = Dat$Activities, subject=Dat$Subject), mean)

write.table(Dat_Tidy, "tidy_data.txt", row.names = FALSE, quote = FALSE)

