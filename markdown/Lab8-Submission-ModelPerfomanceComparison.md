Business Intelligence Lab Submission Markdown
================
Starfield
07/11/2023\>

<table style="width:97%;">
<colgroup>
<col style="width: 48%" />
<col style="width: 48%" />
</colgroup>
<tbody>
<tr class="odd">
<td><strong>Student ID Numbers and Names of Group Members</strong></td>
<td><p>1. 135232 - Sadiki Hamisi</p>
<p>2. 134782 - Yasmin Choma</p>
<p>3. 134783 - Moses mbugua</p>
<p>4. 122998 - Glenn Oloo</p></td>
</tr>
<tr class="even">
<td><strong>GitHub Classroom Group Name</strong></td>
<td>Starfield</td>
</tr>
<tr class="odd">
<td><strong>Course Code</strong></td>
<td>BBT4206</td>
</tr>
<tr class="even">
<td><strong>Course Name</strong></td>
<td>Business Intelligence II</td>
</tr>
<tr class="odd">
<td><strong>Program</strong></td>
<td>Bachelor of Business Information Technology</td>
</tr>
<tr class="even">
<td><strong>Semester Duration</strong></td>
<td>21<sup>st</sup> August 2023 to 28<sup>th</sup> November 2023</td>
</tr>
</tbody>
</table>

**Note:** the following “*KnitR*” options have been set as the
defaults:  
`knitr::opts_chunk$set(echo = TRUE, warning = FALSE, eval = TRUE, collapse = FALSE, tidy.opts = list(width.cutoff = 80), tidy = TRUE)`.

More KnitR options are documented here
<https://bookdown.org/yihui/rmarkdown-cookbook/chunk-options.html> and
here <https://yihui.org/knitr/options/>.

**Note:** the following “*R Markdown*” options have been set as the
defaults:

Installing and loading of required packages

``` code
# Language server
if (require("languageserver")) {
  require("languageserver")
} else {
  install.packages("languageserver", dependencies = TRUE,
                   repos = "https://cloud.r-project.org")
}
# mlbench
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
```

Loading the dataset

``` code

library(readr)
IRIS <- read_csv("data/IRIS.csv")
View(IRIS)
```

Training the models

``` code

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
```

Calling the re-sampled functions

``` code

results <- resamples(list(LDA = IRIS_model_lda, CART = IRIS_model_cart,
                          KNN = IRIS_model_knn, SVM = IRIS_model_svm,
                          RF = IRIS_model_rf))
```

Displaying the results

``` code

summary(results)
```

Visualization of the results

``` code

# Box and Whisker Plot ----

scales <- list(x = list(relation = "free"), y = list(relation = "free"))
bwplot(results, scales = scales)

# Dot Plots ----

scales <- list(x = list(relation = "free"), y = list(relation = "free"))
dotplot(results, scales = scales)

# Scatter Plot Matrix ----

splom(results)

# Pairwise xyPlots ----

# xyplot plots to compare models
xyplot(results, models = c("LDA", "SVM"))

# or
# xyplot plots to compare models
xyplot(results, models = c("SVM", "CART"))
```

Statistical Significance Tests (lower and upper diagonal)

``` code

diffs <- diff(results)

summary(diffs)
```
