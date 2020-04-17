library(e1071)
source('FeatureSetTA(2).R')
printf <- function(...) cat(sprintf(...))

# 기술적 지표로 구성된 Feature들을 더 추가하여 정확도가 향상되는지 확인한다.
# Features (16 개) : spread, atr, smi, adx, boll, macd, obv, cci, rsi, candle(OHLC), 
# volatility, voldiff (갭변동성과 장중 변동성 차이), volume( 5일 평균 거래 대금)
# Yahoo 사이트로부터 삼성전자 주가 데이터를 읽어온다
p <- getData('005930')

# 기술적 분석 Feature 데이터 세트를 생성한다
ds <- FeatureSetTA2(p)

# SVM 을 생성한다
sv <- svm(class ~ ., data = ds$train, kernel="radial", cost=100, gamma=0.1)

# 테스트 데이터 세트를 이용하여 성능을 확인한다
pred <- predict(sv, ds$test, type = "class")
cm <- table(pred, ds$test$class, dnn=list('predicted', 'actual'))
printf("\n* Confusion Matrix\n")
print(cm)

accuracy <- sum(diag(cm)) / sum(cm)
printf("\n* 정확도 = %.4f\n\n", accuracy)




