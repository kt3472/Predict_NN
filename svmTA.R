library(e1071)
source('11-2.FeatureSetTA(2).R')
printf <- function(...) cat(sprintf(...))

# ����� ��ǥ�� ������ Feature���� �� �߰��Ͽ� ��Ȯ���� ���Ǵ��� Ȯ���Ѵ�.
# Features (16 ��) : spread, atr, smi, adx, boll, macd, obv, cci, rsi, candle(OHLC), 
# volatility, voldiff (���������� ���� ������ ����), volume( 5�� ��� �ŷ� ���)
# Yahoo ����Ʈ�κ��� �Ｚ���� �ְ� �����͸� �о�´�
p <- getData('005930')

# ����� �м� Feature ������ ��Ʈ�� �����Ѵ�
ds <- FeatureSetTA2(p)

# SVM �� �����Ѵ�
sv <- svm(class ~ ., data = ds$train, kernel="radial", cost=100, gamma=0.1)

# �׽�Ʈ ������ ��Ʈ�� �̿��Ͽ� ������ Ȯ���Ѵ�
pred <- predict(sv, ds$test, type = "class")
cm <- table(pred, ds$test$class, dnn=list('predicted', 'actual'))
printf("\n* Confusion Matrix\n")
print(cm)

accuracy <- sum(diag(cm)) / sum(cm)
printf("\n* ��Ȯ�� = %.4f\n\n", accuracy)



