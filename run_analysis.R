require("dplyr")

# Function run_analysis can be used to create a tidy summarised data set from
# the Samsung data if it is available in the working directory. The created
# data frame is written to a file named 'act_subj_mean.txt' and it is also returned 
# from this function.
run_analysis <- function() {
    if (!"UCI HAR Dataset" %in% list.files())
        stop("Dataset directory 'HCI HAR Dataset' does not exist.")
    
    # 1. Merge the training and test data sets
    
    # Use this type to parse numbers in the file because default numeric type produced an error
    setClass('eNumeric')
    setAs("character","eNumeric", function(from) as.numeric(from))
    
    x_test <- read.delim2("UCI HAR Dataset/test/X_test.txt", 
                          header = FALSE, sep = "", colClasses = rep("eNumeric", 561))
    y_test <- read.csv("UCI HAR Dataset/test/y_test.txt", header = FALSE)
    subject_test <- read.csv("UCI HAR Dataset/test/subject_test.txt", header = FALSE)
    # Add activity and subject columns
    x_test <- cbind(x_test, y_test, subject_test)
    names(x_test) <- c(1:561, "Activity", "Subject")

    x_train <- read.delim2("UCI HAR Dataset/train/X_train.txt",
                           header = FALSE, sep = "", colClasses = rep("eNumeric", 561))
    y_train <- read.csv("UCI HAR Dataset/train/y_train.txt", header = FALSE)
    subject_train <- read.csv("UCI HAR Dataset/train/subject_train.txt", header = FALSE)
    x_train <- cbind(x_train, y_train, subject_train)
    names(x_train) <- c(1:561, "Activity", "Subject")
    
    # Merge rows of test and training data
    x_merged <- rbind(x_test, x_train)
    
    # 2. Extract only the measurements on the mean and standard deviation for each measurement
    vars <- read.delim2("UCI HAR Dataset/features.txt", header = FALSE, sep = "")
    names(vars) <- c("varNum", "varName")
    # Pick only the columns that have mean and std in their names
    meanStdCols <- filter(vars, grepl('mean|std', varName) & !grepl('meanFreq', varName))
    x_sel <- select(x_merged, meanStdCols$varNum, Activity, Subject)
    
    # 3. Use descriptive activity names to name the activities in the data set
    x_sel$Activity <- factor(x_sel$Activity, levels=as.character(1:6),
                   labels=c('WALKING','WALKING_UPSTAIRS','WALKING_DOWNSTAIRS', 'SITTING', 'STANDING', 'LAYING'))
    
    # 4. Label the data set with descriptive variable names
    names(x_sel) <- c(as.character(meanStdCols$varName), "Activity", "Subject")
    
    # 5. Create a tidy data set with the average of each variable per each activity and each subject
    x_out <- x_sel %>% 
        group_by(Activity, Subject) %>% 
        summarise_each(funs(mean))
    
    # Write final result to file
    write.table(x_out, file = "act_subj_mean.txt", row.names = FALSE)
    
    # Return result
    x_out
}