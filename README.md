#ReadMe  
`This repo were created for Coursera peer assessment course "Getting and Cleaning data"`  

###ReadMe file describes how run_analysis() function works.
To run **run_analysis()** function source *`"run_analysis.R"`* file.
This file should be placed in "UCI HAR Dataset" (Samsung's tests home) directory.
Assuming that above directory is set as working directory. To check your current working directory use function getwd()
To set new working directory use function setwd(). More about setwd() function you can read in help-file which could 
be opened by writting "?getwd" without quotes in the console.

 Function run_analysis() aimed to merge and clean data about "wearable computing experiments" for futher analysis.

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. 
Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) 
wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, 
authors captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. 
The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in 
fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). 
The sensor acceleration signal, which has gravitational and body motion components,
was separated using a Butterworth low-pass filter into body acceleration and gravity. 
The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

##### Libraries
Loading neccessary libraries in this case "dplyr" and "stringr"

Read source csv files and store them into variables.
##### Activity
Activity labels are the same for train and test experiments. There are 6 types of activity.
- 1-WALKING
- 2-WALKING_UPSTAIRS
- 3-WALKING_DOWNSTAIRS
- 4-SITTING
- 5-STANDING
- 6-LAYING 

##### Features
Features are the same for train and test experiments. Features table contain names of calculations which were executed on dataset.

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

The set of variables that were estimated from these signals are: 

+ mean(): Mean value
+ std(): Standard deviation
+ mad(): Median absolute deviation 
+ max(): Largest value in array
+ min(): Smallest value in array
+ sma(): Signal magnitude area
+ energy(): Energy measure. Sum of the squares divided by the number of values. 
+ iqr(): Interquartile range 
+ entropy(): Signal entropy
+ arCoeff(): Autorregresion coefficients with Burg order equal to 4
+ correlation(): correlation coefficient between two signals
+ maxInds(): index of the frequency component with largest magnitude
+ meanFreq(): Weighted average of the frequency components to obtain a mean frequency
+ skewness(): skewness of the frequency domain signal 
+ kurtosis(): kurtosis of the frequency domain signal 
+ bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
+ angle(): Angle between to vectors.

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

+ gravityMean
+ tBodyAccMean
+ tBodyAccJerkMean
+ tBodyGyroMean
+ tBodyGyroJerkMean

##### Reading test datasets
Reading main test dataset (X_test.txt) and storing into variable  
Reading activity_id for test dataset (y_test.txt) and storing into variable  
Reading subjects for test dataset (subject_test.txt) and storing into variable  

##### Reading train datasets
Reading main train dataset (X_train.txt) and storing into variable  
Reading activity_id for train dataset (y_train.txt) and storing into variable  
Reading subjects for train dataset (subject_train.txt) and storing into variable  

##### Merging test and train datasets. 
Using cbind() function to be sure that my dataset wouldn't be reordered:  
+ Merging main test and train datasets  
+ Merging activity_id test and train datasets  
+ Merging subjects test and train datasets  

##### Extracting requested in step 2 features
Uing str_detect() function filter out requested features which are contains mean()\Mean or std functions and then extract them.  

As soon as we will use this features as column names - removing brackets and replacing "-" to "_". This step needed to make column names better readable  

##### Extracting data from main dataset
Extracting data from main dataset which contains data conserning mean()\Mean or std functions accordingly  
Rename main dataset columns from V1,V2 ... to readable and meaningful names

##### Converting activity_id to Activity name
Using left_join() function were created new variable which contains every single activity_id with corresponding meaningful name.  
> activity<-left_join(activity_id, activity_labels)  

Rename Subject and Activity data frames


##### Result dataset
Creating result table which merges Subject, Activity and Main datasets, using cbind() function  

##### Tidy dataset
Creating independent tidy dataset with conversion to .table
 > tidy<-tbl_df(result)
 
Using pipeline firstly grouping data by subject and Activity  
Afterwards using summarise_each_() function applying mean() function for all variables
> tidy<-tidy%>%group_by(Subject,Activity)%>%summarise_each_(funs(mean),names(tidy))

As soon as we made average calculations rename data columns which were changed by adding _Avg suffix
> names(tidy)[3:length(names(tidy))]<-paste(names(tidy)[3:length(names(tidy))],"Avg", sep = "_")

After merging data, remove all unnecessary source data variables 

Return tidy, summarized dataset.

##### Tidy data
Tidy dataset should correspond below rules:  
1. Each variable forms a column.  
2. Each observation forms a row.  
3. Each type of observational unit forms a table.  

As soon as our dataset match all of above principles we can call result dataset as "tidy".
