library(e1071)
source('FeatureSetTA.R')
printf <- function(...) cat(sprintf(...))

# 기술적 분석 Feature들을 조합하여 정확도를 측정해 본다.
# ex : 
# 총 11개의 Feature들로 구성된 데이터 세트에서 k개의 Feature들을 조합하여 
# 데이터 세트를 구성한다. k=5개를 선택하는 조합의 개수는 462개 임.
# 
# 1번 조합 : ATR, SMI, ADX, Bollinger, MACD --> 57.38%
# 2번 조합 : ATR, SMI, ADX, Bollinger, OBV --> 54.25% 등
# 
# k = 6, 7, 8 ... 11 인 경우의 모든 조합으로 정확도를 계산해 보고, 의미있는
# Feature 조합이 있는지 평가해 본다. (종목도 바꿔가면서 평가해 보아야 함.)
# -------------------------------------------------------------------------
p <- getData('005930')

k = 8
c <- as.data.frame(t(combn(11, k)))
c$accuracy <- NA

for (i in 1:nrow(c)) {
   com <- rep(0, 11)
   r <- as.numeric(c[i,])
   com[r] <- 1

   # 기술적 분석 Feature 데이터 세트를 생성한다
   ds <- FeatureSetTA2(p, com)
   
   # SVM 을 생성한다
   sv <- svm(class ~ ., data = ds$train, kernel="radial", cost=100, gamma=0.1)
   
   # 테스트 데이터 세트를 이용하여 성능을 확인한다
   pred <- predict(sv, ds$test, type = "class")
   cm <- table(pred, ds$test$class, dnn=list('predicted', 'actual'))
   accuracy <- sum(diag(cm)) / sum(cm)
   c[i,]$accuracy <- accuracy
   printf("%d : 정확도 = %.4f\n", i, accuracy)
}

# Feature 선택에 따른 정확도의 분산을 육안으로 확인한다
title <- sprintf("k = %d, 평균 = %.2f, 표준편차 = %.2f %s", k, mean(c$accuracy)*100, sd(c$accuracy)*100, "%")
plot(density(c$accuracy), col='red', main=title)
abline(v=0.5, col='blue')

