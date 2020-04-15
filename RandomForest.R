# install.packages("randomForest")

require(randomForest)
source('FeatureSetTA.R')
printf <- function(...) cat(sprintf(...))

# Yahoo 사이트로부터 삼성전자 주가 데이터를 읽어온다
p <- getData('005930')

# 기술적 분석 Feature 데이터 세트를 생성한다
ds <- FeatureSetTA(p)

# class를 factor 형으로 변환한다
ds$train$class <- as.factor(ds$train$class)
levels(ds$train$class) <- c("Down", "Up")
ds$test$class <- as.factor(ds$test$class)
levels(ds$test$class) <- c("Down", "Up")

# 랜덤포레스트를 구축한다
rf <- randomForest(class ~ ., data = ds$train, ntree=50)

# Error rate을 관찰한다. (훈련 데이터로 측정한 Error 임)
plot(rf, main="Error")
err <- as.data.frame(rf$err.rate)
print(head(err))
err$mean <- apply(err, 1, mean)
minErrTree <- which(err$mean == min(err$mean))[1]
printf("* Error 가 최소인 트리의 개수 = %d\n", minErrTree)

# 테스트 데이터 세트를 이용하여 성능을 확인한다
pr <- predict(rf, ds$test)
cm <- table(pr, ds$test$class)
print(cm)
accuracy <- sum(diag(cm)) / sum(cm)
printf("\n* 정확도 = %.4f\n", accuracy)

# 분류기준으로 많이 사용된 기술적 분석 지표를 확인한다.
varImpPlot(rf, sort = TRUE, pch = 15, col='red', main="Importance")



