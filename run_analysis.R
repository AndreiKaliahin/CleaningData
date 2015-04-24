# This file should be placed in "UCI HAR Dataset" directory.
# Assuming that above directory is set as working directory. To check your current working directory use function getwd()
# To set new working directory use function setwd(). More about setwd() function you can read in help-file which could 
# be opened by writting "?getwd" without quotes in the console.

# Function run_analysis() aimed to merge and clean data about "wearable computing experiments" for futher analysis.

# The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. 
# Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) 
# wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, 
# authors captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. 
# The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, 
# where 70% of the volunteers was selected for generating the training data and 30% the test data. 

# The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in 
# fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). 
# The sensor acceleration signal, which has gravitational and body motion components,
# was separated using a Butterworth low-pass filter into body acceleration and gravity. 
# The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. 
# From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

run_analysis <- function(){

        #Loading neccessary libraries
        library(dplyr)
        library(stringr)
        
        ##Read source csv files and store them into variables
        
        #Activity labels are the same for train and test experiments. There are 6 types of activity.
        activity_labels<-read.table("activity_labels.txt")
        
        #Features are the same for train and test experiments. Features table contain names of calculations which were executed on dataset.
        features<-read.table("features.txt")
        
        #Reading main test dataset and storing into variable
        x_test<-read.table("test/X_test.txt")
        #Reading activity_id for test dataset and storing into variable
        activity_id_test<-read.table("test/y_test.txt")
        #Reading subjects for test dataset and storing into variable
        subj_test<-read.table("test/subject_test.txt")
        
        #Reading main train dataset and storing into variable
        x_train<-read.table("train/X_train.txt")
        #Reading activity_id for train dataset and storing into variable
        activity_id_train<-read.table("train/y_train.txt")
        #Reading subjects for train dataset and storing into variable
        subj_train<-read.table("train/subject_train.txt")
        
        ##Merging test and train datasets. Using cbind() function to be sure that my dataset wouldn't be reordered 
        #Merging main test and train datasets
        x<-rbind(x_test,x_train)
        #Merging activity_id test and train datasets
        activity_id<-rbind(activity_id_test, activity_id_train)
        #Merging subjects test and train datasets
        subject<-rbind(subj_test, subj_train)
        
        ##After merging data, remove all unnecessary source data variables
        rm(x_test, x_train, activity_id_test, activity_id_train, subj_test, subj_train)
        
        ##Extract only features which are contains mean()\Mean or std functions
        requested_features<-features[str_detect(features[,2],"[Mm]ean|[Ss]td"),]
        
        ##As soon as we will use this features as column names - removing brackets and replacing "-" to "_".
        ##Needed to make column names better readable
        requested_features[,2]<-str_replace_all(requested_features[,2],"\\(|\\)","")
        requested_features[,2]<-str_replace_all(requested_features[,2],"-|,","_")
        
        ##Extracting data from main dataset which contains data conserning mean()\Mean or std functions accordingly
        requested_x<-x[,requested_features[,1]]
        ##Rename main dataset columns from V1,V2 ... to readable and meaningful names
        names(requested_x)<-requested_features[,2]
        
        ##Creating new variable which contains every single activity_id with corresponding meaningful name.
        activity<-left_join(activity_id, activity_labels)
        
        ##After merging data, remove all unnecessary source data variables
        rm(x, activity_id, activity_labels, features)
        
        ##Rename Subject and Activity data frames
        names(subject)<-"Subject"
        names(activity)<-c("Act_id","Activity")
        
        ##Creating result table which merges Subject, Activity and Main datasets.
        result<-cbind(Activity = activity$Activity, subject, requested_x)
        
        ##Creating independent tidy dataset with conversion to .table
        tidy<-tbl_df(result)
        
        ##Using pipeline firstly grouping data by subject and Activity
        ##Afterwards using summarise_each_() function applying mean() function for all variables
        tidy<-tidy%>%group_by(Subject,Activity)%>%summarise_each_(funs(mean),names(tidy))
        
        ##As soon as we made average calculations rename data columns which were changed by adding _Avg suffix
        names(tidy)[3:length(names(tidy))]<-paste(names(tidy)[3:length(names(tidy))],"Avg", sep = "_")
        
        #Return tidy, summarized dataset
        tidy
}