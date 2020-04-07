library(e1071)
require(foreach)
source('3-2.FeatureSetTA.R')

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

# SVM에 대해 Bagging을 수행한다
# 훈련 데이터 세트를 5개로 나누어 50번 반복 수행함
div <- 5
iterations <- 50

bagged <- foreach(m=1:iterations, .combine = cbind) %do% {
   pos <- sample(nrow(trainData), size=floor((nrow(trainData) / div)))
   train_pos <- 1:nrow(trainData) %in% pos
   base <- svm(class ~ ., data = trainData[train_pos,], kernel="radial", cost=1, gamma=0.5)
   predict(base, testData)
}

# Baggind 결과 확인
print(bagged[1:10, 1:10])

# Test 데이터를 사용하여 정확도를 측정한다
meanPredict <- apply(bagged[, 1:iterations], 1, function(x) {
   s <- (sum(x) / iterations)
   round(s, 0)
   })

svmPredict <- as.data.frame(cbind(testData$class, meanPredict), row.names=F)
cm <- table(svmPredict, dnn=list('predicted', 'actual'))
print(cm)
accuracy <- sum(diag(cm)) / sum(cm)
printf("\n* 정확도 = %.6f\n", accuracy)


