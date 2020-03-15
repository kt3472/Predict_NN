require(neuralnet)
source('1.CollectData.R')
printf <- function(...) cat(sprintf(...))
normalizeMinMax <- function(x) { (x - min(x)) / (max(x) - min(x)) }

# Yahoo ����Ʈ�κ��� �Ｚ���� �ְ� �����͸� �о�´�
p <- getData('005930')

# ����� �м� Feature ������ ��Ʈ�� �����Ѵ�
rsi <- RSI(p$open, n=3)
ema <- p$open - EMA(p$open, n=5) # EMA cross signal
macd <- MACD(p$open)$signal
bband <- BBands(p$open, n=20, sd=2)$pctB
pchg <- p$close - p$open
ds <- data.frame(rsi, ema, macd, bband, pchg)
rownames(ds) <- index(p)
colnames(ds) <- c("rsi", "ema", "macd", "bband", "pchg")
ds <- na.omit(ds)

# 0 ~ 1 ������ ������ normalization
ds <- as.data.frame(apply(ds, 2, normalizeMinMax))

# �Ʒ� �����Ϳ� ���� �����ͷ� ������
# ���� ������ ���� (10%)
n <- as.integer(nrow(ds) * 0.1)

# �Ʒ� ������ ��Ʈ
trainD <- as.data.frame(ds[1:(nrow(ds)-n),])

# ���� ������ ��Ʈ
testD <- as.data.frame(ds[(nrow(ds)-n+1):nrow(ds),])

formula <- as.formula("pchg ~ rsi + ema + macd + bband")

# �ΰ��Ű������ �Ʒ� �����͸� �н��Ѵ�. Hidden layer = 2��, Hidden Layer�� Neuron �� = 6��
# �˰����� : traditional Backpropagation
# Ȱ�� �Լ� : Sigmoid
# �н��� : 0.005
nn <- neuralnet(formula, data=trainD, hidden = c(8,8,8),
                learningrate=0.005, act.fct="logistic", algorithm="backprop",
                err.fct="sse", linear.output=F)

# �Ʒ� ���� Ȯ��
err <- nn$result.matrix[1]
printf("\n* �Ʒ� ���� = %.4f\n", err)

# �ΰ��Ű�� �ð�ȭ
plot(nn)

# �н� ����� �̿��Ͽ� ���� �����͸� �����Ѵ�
nnPredict <- compute(nn, testD[-5])$net.result

# �׽�Ʈ �������� ���ϴ� ��°� (pchg), ������ ����� (predict) ���Ѵ�. �񱳸� ���� scale() ��ȯ�Ͽ���.
pred <- as.data.frame(cbind(testD$pchg, nnPredict))
colnames(pred) <- c("pchg", "predict")
pred$npchg <- scale(pred$pchg)
pred$npredict <- scale(pred$predict)

# ��Ȯ�� ������ ���� ��� ����� class�� ǥ���� ����.
# npchg > 0 --> �ְ��� ���� ���̰�, �ƴϸ� �϶��� ����
pred$cpchg <- ifelse(pred$npchg > 0, 1, 0)
pred$cpredict <- ifelse(pred$npredict > 0, 1, 0)
printf("\n* ���� ��� Ȯ��\n")
print(tail(pred))

# ����ϴ� �����, ������ ����� ��Ʈ�� �׷��� �������� ���� ����.
plot(pred$npchg, type='l', col='blue', main="�Ķ��� = ��� ���, ������ = ���� ���")
lines(pred$npredict, col='red')

# ������ ��Ȯ���� �����Ѵ�
cm <- table(pred$cpchg, pred$cpredict)
printf("\n* Confusion Matrix\n")
print(cm)
accuracy <- sum(diag(cm)) / sum(cm)
printf("\n\n* ���� ��Ȯ�� = %.4f\n", accuracy)