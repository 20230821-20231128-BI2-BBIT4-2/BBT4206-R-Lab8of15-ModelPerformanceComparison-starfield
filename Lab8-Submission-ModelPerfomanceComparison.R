# *****************************************************************************
# Lab 8 Submission.: Model Performance Comparison ----


# If renv::restore() did not install the "languageserver" package (required to
# use R for VS Code), then it can be installed manually as follows (restart R
# after executing the command):

if (require("languageserver")) {
  require("languageserver")
} else {
  install.packages("languageserver", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

# Introduction ----
# The performance of the trained models can be compared visually. This is done
# to help you to identify and choose the top performing models.

# STEP 1. Install and Load the Required Packages ----
## mlbench ----
if (require("mlbench")) {
  require("mlbench")
} else {
  install.packages("mlbench", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## caret ----
if (require("caret")) {
  require("caret")
} else {
  install.packages("caret", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## kernlab ----
if (require("kernlab")) {
  require("kernlab")
} else {
  install.packages("kernlab", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

## randomForest ----
if (require("randomForest")) {
  require("randomForest")
} else {
  install.packages("randomForest", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}

# STEP 2. Load the Dataset ----
library(readr)
IRIS <- read_csv("data/IRIS.csv")
View(IRIS)

# STEP 3. The Resamples Function ----

# Analogy: We cannot compare apples with oranges; we compare apples with apples.

# The "resamples()"  function checks that the models are comparable and that
# they used the same training scheme ("train_control" configuration).
# To do this, after the models are trained, they are added to a list and we
# pass this list of models as an argument to the resamples() function in R.

## 3.a. Train the Models ----
# We train the following models, all of which are using 10-fold repeated cross
# validation with 3 repeats:
#   LDA
#   CART
#   KNN
#   SVM
#   Random Forest

train_control <- trainControl(method = "repeatedcv", number = 10, repeats = 3)

### LDA ----
set.seed(7)
IRIS_model_lda <- train(species ~ ., data = IRIS,
                            method = "lda", trControl = train_control)

### CART ----
set.seed(7)
IRIS_model_cart <- train(species ~ ., data = IRIS,
                             method = "rpart", trControl = train_control)

### KNN ----
set.seed(7)
IRIS_model_knn <- train(species ~ ., data = IRIS,
                            method = "knn", trControl = train_control)

### SVM ----
set.seed(7)
IRIS_model_svm <- train(species ~ ., data = IRIS,
                            method = "svmRadial", trControl = train_control)

### Random Forest ----
set.seed(7)
IRIS_model_rf <- train(species ~ ., data = IRIS,
                           method = "rf", trControl = train_control)

## 3.b. Call the `resamples` Function ----
# We then create a list of the model results and pass the list as an argument
# to the `resamples` function.

results <- resamples(list(LDA = IRIS_model_lda, CART = IRIS_model_cart,
                          KNN = IRIS_model_knn, SVM = IRIS_model_svm,
                          RF = IRIS_model_rf))

# STEP 4. Display the Results ----
## 1. Table Summary ----
# This is the simplest comparison. It creates a table with one model per row
# and its corresponding evaluation metrics displayed per column.

summary(results)

## 2. Box and Whisker Plot ----
# This is useful for visually observing the spread of the estimated accuracies
# for different algorithms and how they relate.

scales <- list(x = list(relation = "free"), y = list(relation = "free"))
bwplot(results, scales = scales)

## 3. Dot Plots ----
# They show both the mean estimated accuracy as well as the 95% confidence
# interval (e.g. the range in which 95% of observed scores fell).

scales <- list(x = list(relation = "free"), y = list(relation = "free"))
dotplot(results, scales = scales)

## 4. Scatter Plot Matrix ----
# This is useful when considering whether the predictions from two
# different algorithms are correlated. If weakly correlated, then they are good
# candidates for being combined in an ensemble prediction.

splom(results)

## 5. Pairwise xyPlots ----
# You can zoom in on one pairwise comparison of the accuracy of trial-folds for
# two models using an xyplot.

# xyplot plots to compare models
xyplot(results, models = c("LDA", "SVM"))

# or
# xyplot plots to compare models
xyplot(results, models = c("SVM", "CART"))

## 6. Statistical Significance Tests ----
# This is used to calculate the significance of the differences between the
# metric distributions of the various models.

### Upper Diagonal ----
# The upper diagonal of the table shows the estimated difference between the
# distributions. If we think that LDA is the most accurate model from looking
# at the previous graphs, we can get an estimate of how much better it is than
# specific other models in terms of absolute accuracy.

### Lower Diagonal ----
# The lower diagonal contains p-values of the null hypothesis.
# The null hypothesis is a claim that "the distributions are the same".
# A lower p-value is better (more significant).

diffs <- diff(results)

summary(diffs)



