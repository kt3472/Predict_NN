library(rpart)
library(rpart.plot)
source('3-2.FeatureSetTA.R')

# Yahoo 사이트로부터 삼성전자 주가 데이터를 읽어온다
#p <- getData('005930')

# 기술적 분석 Feature 데이터 세트를 생성한다
ds <- FeatureSetTA(p)
ds$train$class <- ifelse(ds$train$class == 1, "Down", "Up")
ds$test$class <- ifelse(ds$test$class == 1, "Down", "Up")

# Decision Tree를 생성한다. 처음에는 복잡도 (cp)를 작게 설정하여 Tree를 크게 만든다.
#dt <- rpart(class ~ spread + atr + smi + adx + aroon + boll + macd + obv + martn, data = ds$train, cp=0.001)
dt <- rpart(class ~ atr + smi + boll + obv + martn, data = ds$train, cp=0.001)

# Tree를 그려본다.
prp(dt, type = 2, extra = 8)

# Cross validation 오차가 최소가 되는 지점의 복잡도 (cp)를 찾는다.
# rpart 패키지는 자체로 CV 기능을 가지고 있으며, default로 10-fold CV를 수행한다.
# k-fold의 값은 rpart.control(xval = 10) 에 default로 설정되어 있음.
printcp(dt)
plotcp(dt, upper = "splits", col = "red")

# CV 오차가 최소가 되는 cp를 선택하여 가지치기 (Pruning) 한다.
pdt <- prune(dt, cp = 0.0074697)

# Pruning 된 Tree를 그려 본다.
prp(pdt, type = 2, extra = 8)

# 테스트 데이터 세트를 이용하여 성능을 확인한다
pred <- predict(pdt, ds$test, type = "class")
cm <- table(pred, ds$test$class, dnn=list('predicted', 'actual'))
print(cm)
accuracy <- sum(diag(cm)) / sum(cm)
print(accuracy)

# 예측용 데이터를 이용하여 내일 주가의 방향을 예측해 본다.
pred <- predict(pdt, ds$pred, type = "prob")
print(pred)


