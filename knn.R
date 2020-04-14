library(class)
source('FeatureSetTA.R')

# Yahoo 사이트로부터 삼성전자 주가 데이터를 읽어온다
#p <- getData('005930')

# 기술적 분석 Feature 데이터 세트를 생성한다
ds <- FeatureSetTA(p)

# 훈련용 데이터, 테스트용 데이터를 생성한다
train <- ds$train[, -10]        # Class 제외
test <- ds$test[, -10]          # Class 제외
class <- factor(as.vector(ds$train[, 10]))

# KNN 분류기로 train 데이터를 학습하고 test 데이의 class를 추정한다
# k 는 100으로 설정한다 (임의로 설정)
# knn() 함수는 내부에서 거리가 같은 지점 (tied point)에 대한 처리에 랜점 요소가 들어가기
# 때문에 tie가 존재하는 경우 실행할 때마다 결과가 달라질 수 있음.
# 동일 결과를 얻으려면 set.seed() 다음에 knn()을 수행함.
testClass <- knn(train, test, class, k=100)

# test set에 추정된 class를 표시한다
ds$test$predict <- testClass

# 추정이 잘 되었는지 육안으로 확인한다
head(ds$test)
tail(ds$test)

# 정확도를 계산한다
cm <- table(ds$test$class, testClass)
print(cm)
accuracy <- sum(diag(cm)) / sum(cm)
print(accuracy)

# k 값을 변화시키면서 accuracy가 가장 높은 k 를 찾아본다.
nk = 3
accuracy <- rep(0, nk)
for (k in 1:nk) {
   testClass <- knn(train, test, class, k=k)
   cm <- table(ds$test$class, testClass)
   accuracy[k] <- sum(diag(cm)) / length(testClass)
}

# accuracy가 가장 높은 k 값을 찾는다. max가 여러개 있을 수 있음. 첫 번째 것을 사용함.
ko <- which(accuracy == max(accuracy))[1]
printf("\n* 최적 k = %d\n", ko)
printf("* 정확도 = %.2f\n", accuracy[ko])

# accuracy를 그래프로 그려본다
plot(accuracy, type='l', col='blue', main="k 변화에 따른 정확도의 변화", xlab="k")
abline(v = ko, col='red')

# prediction용 데이터를 예측해 본다
prediction <- knn(train, ds$pred, class, k=ko)

if (prediction == 1) {
   printf("\n* 내일 주가는 하락할 것으로 예상됨. 정확도 = %.2f\n", accuracy[ko])
} else {
   printf("\n* 내일 주가는 상승할 것으로 예상됨. 정확도 = %.2f\n", accuracy[ko])
}


