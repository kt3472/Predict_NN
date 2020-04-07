library(rpart)
library(rpart.plot)
source('3-2.FeatureSetTA.R')

# Yahoo ����Ʈ�κ��� �Ｚ���� �ְ� �����͸� �о�´�
#p <- getData('005930')

# ����� �м� Feature ������ ��Ʈ�� �����Ѵ�
ds <- FeatureSetTA(p)
ds$train$class <- ifelse(ds$train$class == 1, "Down", "Up")
ds$test$class <- ifelse(ds$test$class == 1, "Down", "Up")

# Decision Tree�� �����Ѵ�. ó������ ���⵵ (cp)�� �۰� �����Ͽ� Tree�� ũ�� �����.
#dt <- rpart(class ~ spread + atr + smi + adx + aroon + boll + macd + obv + martn, data = ds$train, cp=0.001)
dt <- rpart(class ~ atr + smi + boll + obv + martn, data = ds$train, cp=0.001)

# Tree�� �׷�����.
prp(dt, type = 2, extra = 8)

# Cross validation ������ �ּҰ� �Ǵ� ������ ���⵵ (cp)�� ã�´�.
# rpart ��Ű���� ��ü�� CV ����� ������ ������, default�� 10-fold CV�� �����Ѵ�.
# k-fold�� ���� rpart.control(xval = 10) �� default�� �����Ǿ� ����.
printcp(dt)
plotcp(dt, upper = "splits", col = "red")

# CV ������ �ּҰ� �Ǵ� cp�� �����Ͽ� ����ġ�� (Pruning) �Ѵ�.
pdt <- prune(dt, cp = 0.0074697)

# Pruning �� Tree�� �׷� ����.
prp(pdt, type = 2, extra = 8)

# �׽�Ʈ ������ ��Ʈ�� �̿��Ͽ� ������ Ȯ���Ѵ�
pred <- predict(pdt, ds$test, type = "class")
cm <- table(pred, ds$test$class, dnn=list('predicted', 'actual'))
print(cm)
accuracy <- sum(diag(cm)) / sum(cm)
print(accuracy)

# ������ �����͸� �̿��Ͽ� ���� �ְ��� ������ ������ ����.
pred <- predict(pdt, ds$pred, type = "prob")
print(pred)

