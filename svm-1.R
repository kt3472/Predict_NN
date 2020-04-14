# install.packages("e1071")

library(e1071)
source('FeatureSetTA.R')

# Yahoo 사이트로부터 삼성전자 주가 데이터를 읽어온다
p <- getData('005930')

# 기술적 분석 Feature 데이터 세트를 생성한다
ds <- FeatureSetTA(p)
trainData <- as.data.frame(ds$train)
testData <- as.data.frame(ds$test)

trainData$class <- as.factor(trainData$class)
levels(trainData$class) <- c("Down", "Up")

testData$class <- as.factor(testData$class)
levels(testData$class) <- c("Down", "Up")

# SVM 을 생성한다
sv <- svm(class ~ ., data = trainData, kernel="radial", cost=1, gamma=0.1)

# 테스트 데이터 세트를 이용하여 성능을 확인한다
pred <- predict(sv, testData, type = "class")
cm <- table(pred, testData$class, dnn=list('predicted', 'actual'))
print(cm)
accuracy <- sum(diag(cm)) / sum(cm)
print(accuracy)

# 예측용 데이터를 이용하여 내일 주가의 방향을 예측해 본다.
pred <- predict(sv, ds$pred, type = "class")
print(pred)

# Cross Validation 오차가 최소가 되도록 C와 Gamma를 조정함
myGamma <- c(0.1, 0.5, 1)
myCost <- c(1, 50, 100)
tuned <- tune(svm, class ~ ., data=trainData, kernel="radial", ranges=list(gamma=myGamma, cost=myCost))

summary(tuned)
