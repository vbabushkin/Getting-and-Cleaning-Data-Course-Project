trainLabels<- read.table("./UCI HAR Dataset/train/y_train.txt", sep="\t")
testLabels<- read.table("./UCI HAR Dataset/test/y_test.txt", sep="\t")
trainSubjects<- read.table("./UCI HAR Dataset/train/subject_train.txt", sep="\t")
testSubjects<- read.table("./UCI HAR Dataset/test/subject_test.txt", sep="\t")

features<- read.table("./UCI HAR Dataset/features.txt", sep=" ",col.names=c("id", "name"), fill=FALSE, strip.white=TRUE)
columnNames<-features$name

trainData<-read.table("./UCI HAR Dataset/train/X_train.txt", col.names=columnNames)
testData<- read.table("./UCI HAR Dataset/test/X_test.txt", col.names=columnNames)

newLabelSet<-rbind(trainLabels,testLabels)
newSubjectSet<-rbind(trainSubjects,testSubjects)

#merged dataset
newDataSet<-rbind(trainData,testData)

#replacing activity id with labels
activityLabels<-read.table("./UCI HAR Dataset/activity_labels.txt",col.names=c("id", "name"))
df <- data.frame(activity = newLabelSet$V1)
ac <- data.frame(activity.code = activityLabels$id, activity.label =activityLabels$name)  
df$newLabel <- as.character(ac[match(df$activity, ac$activity.code), 'activity.label'])
df$newLabel <- as.factor(df$newLabel)


#select only measurements corresponding to mean and std
selectedHeaderNames<-names(newDataSet)[(grepl("mean", names(newDataSet))| grepl("std", names(newDataSet)))& !grepl("meanFreq", names(newDataSet))]

newDataSet<-newDataSet[,selectedHeaderNames]

#add subjects and modified labels to dataset
newDataSet<-cbind(newDataSet,df$newLabel)
newDataSet<-cbind(newSubjectSet$V1,newDataSet)
names(newDataSet)[1] = "Subjects"
names(newDataSet)[length(names(newDataSet))] = "Labels"

#order by subjects
newDataSet<-newDataSet[order(newDataSet$Subjects), ]

#save as txt
write.table(newDataSet, file = "newDataSet.txt", sep = "\t", col.names = colnames(newDataSet),row.names = FALSE)

#uncomment to test the output
#test<-read.table("newDataSet.txt", sep="\t",header = TRUE)