require(neuralnet)
source('1.CollectData.R')
printf <- function(...) cat(sprintf(...))
normalizeMinMax <- function(x) { (x - min(x)) / (max(x) - min(x)) }

# Yahoo 사이트로부터 삼성전자 주가 데이터를 읽어온다
p <- getData('005930')

# 기술적 분석 Feature 데이터 세트를 생성한다
rsi <- RSI(p$open, n=3)
ema <- p$open - EMA(p$open, n=5) # EMA cross signal
macd <- MACD(p$open)$signal
bband <- BBands(p$open, n=20, sd=2)$pctB
pchg <- p$close - p$open
ds <- data.frame(rsi, ema, macd, bband, pchg)
rownames(ds) <- index(p)
colnames(ds) <- c("rsi", "ema", "macd", "bband", "pchg")
ds <- na.omit(ds)

# 0 ~ 1 사이의 값으로 normalization
ds <- as.data.frame(apply(ds, 2, normalizeMinMax))

# 훈련 데이터와 시험 데이터로 나눈다
# 시험 데이터 개수 (10%)
n <- as.integer(nrow(ds) * 0.1)

# 훈련 데이터 세트
trainD <- as.data.frame(ds[1:(nrow(ds)-n),])

# 시험 데이터 세트
testD <- as.data.frame(ds[(nrow(ds)-n+1):nrow(ds),])

formula <- as.formula("pchg ~ rsi + ema + macd + bband")

# 인공신경망으로 훈련 데이터를 학습한다. Hidden layer = 2개, Hidden Layer의 Neuron 수 = 6개
# 알고리즘 : traditional Backpropagation
# 활성 함수 : Sigmoid
# 학습률 : 0.005
nn <- neuralnet(formula, data=trainD, hidden = c(8,8,8),
                learningrate=0.005, act.fct="logistic", algorithm="backprop",
                err.fct="sse", linear.output=F)

# 훈련 오류 확인
err <- nn$result.matrix[1]
printf("\n* 훈련 오차 = %.4f\n", err)

# 인공신경망 시각화
plot(nn)

# 학습 결과를 이용하여 시험 데이터를 시험한다
nnPredict <- compute(nn, testD[-5])$net.result

# 테스트 데이터의 원하는 출력과 (pchg), 예측된 출력을 (predict) 비교한다. 비교를 위해 scale() 변환하였음.
pred <- as.data.frame(cbind(testD$pchg, nnPredict))
colnames(pred) <- c("pchg", "predict")
pred$npchg <- scale(pred$pchg)
pred$npredict <- scale(pred$predict)

# 정확도 측정을 위해 출력 결과를 class로 표시해 본다.
# npchg > 0 --> 주가가 오른 것이고, 아니면 하락한 것임
pred$cpchg <- ifelse(pred$npchg > 0, 1, 0)
pred$cpredict <- ifelse(pred$npredict > 0, 1, 0)
printf("\n* 예측 결과 확인\n")
print(tail(pred))

# 희망하는 결과와, 예측된 결과를 차트로 그려서 육안으로 비교해 본다.
plot(pred$npchg, type='l', col='blue', main="파란색 = 희망 결과, 빨간색 = 예측 결과")
lines(pred$npredict, col='red')

# 예측의 정확도를 측정한다
cm <- table(pred$cpchg, pred$cpredict)
printf("\n* Confusion Matrix\n")
print(cm)
accuracy <- sum(diag(cm)) / sum(cm)
printf("\n\n* 예측 정확도 = %.4f\n", accuracy)
