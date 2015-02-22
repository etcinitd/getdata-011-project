# Getdata-011 Course Project

This repo contains a run_analysis.R file that has a function with the same name. Upon execution, run_analysis function creates a tidy summarised data set from the Samsung data if it is available in the working directory. The created data frame shows the average of each measured variable per each activity and each subject. After successful exection, result is written to a file named 'act_subj_mean.txt' and is also returned from the function.

## Code book
### Activity
One of the following labels, representing the activity that subject has been performing:
* WALKING
* WALKING_UPSTAIRS
* WALKING_DOWNSTAIRS
* SITTING
* STANDING
* LAYING

### Subject
A number, from 1 to 30 inclusive, representing a unique human subject that has been participating in the sampling process.
