runAnalysis <- function(){
  subject_test <- read.table("test/subject_test.txt")
  x_test <- read.table("test/X_test.txt")
  y_test <- read.table("test/y_test.txt")
  subject_train <- read.table("train/subject_train.txt")
  x_train <- read.table("train/X_train.txt")
  y_train <- read.table("train/y_train.txt")
  
  subject_all <- rbind(subject_test, subject_train)
  x_all <- rbind(x_test, x_train)
  y_all <- rbind(y_test, y_train)
  
  sxy_all <- cbind(subject_all, x_all, y_all)
  
  features <- read.table("features.txt")
  
  colnames(sxy_all) <- c("subject", as.character(features[,2]), "activityId")
  
  grepNames <- function(nameVector) {
    namedCols <- lapply(nameVector, function(s) {
      grepl(s, names(sxy_all))
    })
    Reduce(function(i, j) {i | j}, namedCols)
  }
  
  sxy_selected <- sxy_all[,grepNames(c("subject", "activity", "mean", "Mean", "std"))]
  
  activities <- read.table('activity_labels.txt')
  
  colnames(activities) <- c("activityId", "activity")
  
  sxy_selected <- merge(sxy_selected, activities, by.x = "activityId", by.y = "activityId")
  
  sxy_split <- split(sxy_selected, as.factor(sxy_selected$subject))
  
  # getting the means
  
  subjectMeans <- lapply(seq_along(sxy_split), function(subIdx){
    sub <- sxy_split[[subIdx]]
    activitySplit <- split(sub, as.factor(sub$activity))
    acts <- lapply(seq_along(activitySplit), function(actIdx) {
      act <- activitySplit[[actIdx]]
      m <- colMeans(act[!names(act) %in% c("activityId", "subject", "activity")])
      unlist(list("subject" = sub$subject[subIdx], "activity" = as.character(act$activity[actIdx]), m))
    })
    acts
  })
  
  unlisted <- unlist(subjectMeans, recursive = FALSE)
  
  write.table(unlisted, "tidySet.txt", row.names = FALSE)
}