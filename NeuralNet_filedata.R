require(neuralnet)
printf <- function(...) cat(sprintf(...))
FindClass <- function(x) { which(x == max(x)) }

# 샘플 데이터를 읽어온다
ds <- read.csv("data/sample3Class.csv")

ds$c1 <- ifelse(ds$class == 1, 1, 0)
ds$c2 <- ifelse(ds$class == 2, 1, 0)
ds$c3 <- ifelse(ds$class == 3, 1, 0)
ds$class <- NULL

# 훈련 데이터와 시험 데이터로 나눈다
# 시험 데이터 개수 (10%)
n <- as.integer(nrow(ds) * 0.1)

# 훈련 데이터 세트
trainD <- as.data.frame(ds[1:(nrow(ds)-n),])

# 시험 데이터 세트
testD <- as.data.frame(ds[(nrow(ds)-n+1):nrow(ds),])

formula <- as.formula("c1 + c2 + c3 ~ a + b + c + d")

# 인공신경망으로 훈련 데이터를 학습한다. Hidden layer = 1개, Hidden Layer의 Neuron 수 = 6개
# 알고리즘 : traditional Backpropagation
# 활성 함수 : Sigmoid
# 학습률 : 0.005
nn <- neuralnet(formula, data=trainD, hidden = 6,
                learningrate=0.005, act.fct="logistic", algorithm="backprop",
                err.fct="sse", linear.output=F)

# 훈련 오류 확인
err <- nn$result.matrix[1]
printf("\n* 훈련 오차 = %.4f\n", err)

# 인공신경망 시각화
plot(nn)

# 학습 결과를 이용하여 시험 데이터를 시험한다
nnPredict <- as.data.frame(compute(nn, testD[, 1:4])$net.result)

# 결과을 육안으로 확인한다
print(head(nnPredict))

# nnPredict에서 활성화 정도를 class로 변환한다
nnPredict$class <- apply(nnPredict, 1, FindClass)

# 결과을 육안으로 확인한다
print(head(nnPredict))

# test 데이터도 class로 변환한다
testD$class <- apply(testD[, 5:7], 1, FindClass)

# 결과을 육안으로 확인한다
print(head(testD))

# 테스트 데이터의 class와 예측된 class를 비교한다
cm <- table(testD$class, nnPredict$class)
accuracy <- sum(diag(cm)) / sum(cm)
printf("\n* Confusion Matrix\n")
print(cm)
printf("\n* 예측 정확도 = %.4f\n", accuracy)
