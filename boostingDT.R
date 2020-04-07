library(adabag)
library(rpart)
source('3-2.FeatureSetTA.R')

# Yahoo 사이트로부터 삼성전자 주가 데이터를 읽어온다
p <- getData('005930')

# 기술적 분석 Feature 데이터 세트를 생성한다
ds <- FeatureSetTA(p)

# class를 factor 형으로 변환한다
ds$train$class <- as.factor(ds$train$class)
levels(ds$train$class) <- c("Dwon", "Up")
ds$test$class <- as.factor(ds$test$class)
levels(ds$test$class) <- c("Dwon", "Up")

# Boosting
control = rpart.control(cp = 0.007)
ada <- boosting(class~., data = ds$train, mfinal=100, boos=TRUE, coeflearn='Breiman', control)
#errorevol(ada, ds$train)

# 테스트 데이터 세트를 이용하여 성능을 확인한다
cm <- predict(ada, ds$test)$confusion
print(cm)
accuracy <- sum(diag(cm)) / sum(cm)
printf("\n* 정확도 = %.4f\n", accuracy)

# 분류기준으로 많이 사용된 기술적 분석 지표를 확인한다.
imp <- sort(ada$importance, decreasing=TRUE)
print(imp)
barplot(imp, col='green', xlab=colnames(imp))
